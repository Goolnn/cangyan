mod import;
mod overview;
mod updated;
mod watch;

#[cfg(target_os = "windows")]
mod inner {
    use directories::UserDirs;
    use std::path::PathBuf;

    pub fn workspace() -> Option<PathBuf> {
        let dirs = UserDirs::new()?;
        let path = dirs.document_dir()?;
        let buf = path.join("Cangyan");

        if !buf.exists() {
            std::fs::create_dir_all(&buf).ok()?;
        }

        Some(buf)
    }
}

#[cfg(target_os = "android")]
mod inner {
    use jni::JavaVM;
    use jni::objects::GlobalRef;
    use jni::objects::JString;
    use jni::objects::JValue;
    use jni::sys::JNI_VERSION_1_6;
    use jni::sys::jint;
    use std::ffi::c_void;
    use std::path::PathBuf;
    use std::sync::OnceLock;

    fn android_context() -> Option<(&'static JavaVM, &'static GlobalRef)> {
        static VM: OnceLock<JavaVM> = OnceLock::new();
        static CONTEXT: OnceLock<GlobalRef> = OnceLock::new();

        #[unsafe(no_mangle)]
        extern "system" fn JNI_OnLoad(vm: JavaVM, _: *mut c_void) -> jint {
            if let Ok(mut env) = vm.get_env()
                && let Ok(activity) = env.find_class("android/app/ActivityThread")
                && let Ok(value) = env.call_static_method(
                    activity,
                    "currentActivityThread",
                    "()Landroid/app/ActivityThread;",
                    &[],
                )
                && let Ok(thread) = value.l()
                && let Ok(value) =
                    env.call_method(thread, "getApplication", "()Landroid/app/Application;", &[])
                && let Ok(application) = value.l()
                && let Ok(context) = env.new_global_ref(application)
            {
                let _ = VM.set(vm);
                let _ = CONTEXT.set(context);
            }

            JNI_VERSION_1_6
        }

        let vm = VM.get()?;
        let context = CONTEXT.get()?;

        Some((vm, context))
    }

    pub fn workspace() -> Option<PathBuf> {
        let (vm, _) = android_context()?;

        let mut env = vm.attach_current_thread().ok()?;

        let environment = env.find_class("android/os/Environment").ok()?;

        let directory = env
            .get_static_field(&environment, "DIRECTORY_DOCUMENTS", "Ljava/lang/String;")
            .ok()?
            .l()
            .ok()?;

        let file = env
            .call_static_method(
                &environment,
                "getExternalStoragePublicDirectory",
                "(Ljava/lang/String;)Ljava/io/File;",
                &[JValue::Object(&directory)],
            )
            .ok()?
            .l()
            .ok()?;

        let path = env
            .call_method(file, "getAbsolutePath", "()Ljava/lang/String;", &[])
            .ok()?
            .l()
            .ok()?;

        let buf = PathBuf::from(env.get_string(&JString::from(path)).ok()?.to_str().ok()?)
            .join("Cangyan");

        if !buf.exists() {
            std::fs::create_dir_all(&buf).ok()?;
        }

        Some(buf)
    }
}

use crate::workspace::overview::Overviews;
use crate::workspace::watch::Watch;
use messages::actor::Actor;
use messages::prelude::Address;
use notify::Config;
use notify::RecommendedWatcher;
use notify::RecursiveMode;
use notify::Watcher;
use rinf::DartSignal;
use rinf::RustSignal;
use rinf::debug_print;
use std::path::PathBuf;
use tokio::sync::mpsc;
use tokio::task::JoinSet;

#[derive(Debug)]
pub struct Workspace {
    path: PathBuf,

    projects: Vec<cyfile::Project>,

    _owned_tasks: JoinSet<()>,
}

impl Actor for Workspace {}

impl Workspace {
    pub fn new(addr: Address<Self>) -> Option<Self> {
        let path = inner::workspace()?;

        let files = std::fs::read_dir(&path)
            .ok()?
            .filter_map(|path| {
                let path = path.ok()?.path();

                if path.is_file() { Some(path) } else { None }
            })
            .collect::<Vec<PathBuf>>();

        let projects = files
            .into_iter()
            .filter_map(|path| {
                if let Ok(file) = std::fs::File::open(&path) {
                    cyfile::File::open(file)
                        .map(|mut project| {
                            if let Some(name) = path.file_stem() {
                                project.set_title(name.to_string_lossy().to_string());
                            }

                            project
                        })
                        .ok()
                } else {
                    None
                }
            })
            .collect();

        let mut owned_tasks = JoinSet::new();

        {
            let mut addr = addr.clone();

            owned_tasks.spawn(async move {
                let receiver = import::Move::get_dart_signal_receiver();

                while let Some(pack) = receiver.recv().await {
                    let message = pack.message;

                    let _ = addr.notify(message).await;
                }
            });
        }

        {
            let mut addr = addr.clone();

            owned_tasks.spawn(async move {
                let receiver = import::Copy::get_dart_signal_receiver();

                while let Some(pack) = receiver.recv().await {
                    let message = pack.message;

                    let _ = addr.notify(message).await;
                }
            });
        }

        {
            let path = path.clone();

            let mut addr = addr.clone();

            owned_tasks.spawn(async move {
                let (tx, mut rx) = mpsc::unbounded_channel();

                if let Ok(mut watcher) = RecommendedWatcher::new(
                    move |res| {
                        let tx = tx.clone();

                        if let Err(err) = tx.send(res) {
                            debug_print!("Failed to send watch event: {:?}", err);
                        }
                    },
                    Config::default(),
                ) && let Ok(_) = watcher.watch(&path, RecursiveMode::NonRecursive)
                {
                    while let Some(event) = rx.recv().await {
                        match event {
                            Ok(event) => match event.kind {
                                notify::EventKind::Remove(_) => {
                                    let paths = event
                                        .paths
                                        .into_iter()
                                        .map(|path| path.display().to_string())
                                        .collect();

                                    let _ = addr.notify(Watch::Remove(paths)).await;
                                }

                                notify::EventKind::Create(_) => {}

                                // notify::EventKind::Any => todo!(),
                                // notify::EventKind::Access(access_kind) => todo!(),
                                // notify::EventKind::Modify(modify_kind) => todo!(),
                                // notify::EventKind::Other => todo!(),
                                _ => (),
                            },
                            Err(err) => rinf::debug_print!("{:?}", err),
                        }
                    }
                }
            });
        }

        Overviews::from(&projects).send_signal_to_dart();

        Some(Self {
            path,

            projects,

            _owned_tasks: owned_tasks,
        })
    }
}
