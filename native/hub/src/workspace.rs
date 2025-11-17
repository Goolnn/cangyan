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

use rinf::RustSignal;
use rinf::SignalPiece;
use serde::Serialize;
use std::path::Path;
use std::path::PathBuf;

#[derive(Debug)]
pub struct Workspace {
    path: PathBuf,

    projects: Vec<cyfile::Project>,
}

impl Workspace {
    pub fn new() -> Option<Self> {
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
                if let Ok(file) = std::fs::File::open(path) {
                    cyfile::File::open(file).ok()
                } else {
                    None
                }
            })
            .collect();

        Some(Self { path, projects })
    }

    pub fn path(&self) -> &Path {
        &self.path
    }

    pub fn projects(&self) -> &Vec<cyfile::Project> {
        &self.projects
    }
}

#[derive(Serialize, RustSignal)]
pub struct Overviews(pub Vec<Overview>);

#[derive(Serialize, SignalPiece)]
pub struct Overview {
    cover: Vec<u8>,

    title: String,

    comment: String,

    created_date: Date,
    updated_date: Date,

    page_count: u32,
}

#[derive(Serialize, SignalPiece)]
pub struct Date {
    year: u16,
    month: u8,
    day: u8,

    hour: u8,
    minute: u8,
    second: u8,
}

impl<'a, I> From<I> for Overviews
where
    I: IntoIterator<Item = &'a cyfile::Project>,
{
    fn from(iter: I) -> Self {
        Self(iter.into_iter().map(Overview::from).collect())
    }
}

impl From<&cyfile::Project> for Overview {
    fn from(value: &cyfile::Project) -> Self {
        Self {
            cover: value.cover().to_vec(),

            title: value.title().to_string(),

            comment: value.comment().to_string(),

            created_date: value.created_date().into(),
            updated_date: value.updated_date().into(),

            page_count: value.pages().len() as u32,
        }
    }
}

impl From<cyfile::Date> for Date {
    fn from(value: cyfile::Date) -> Self {
        Self {
            year: value.year(),
            month: value.month(),
            day: value.day(),

            hour: value.hour(),
            minute: value.minute(),
            second: value.second(),
        }
    }
}
