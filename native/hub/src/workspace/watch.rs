use crate::workspace::Workspace;
use crate::workspace::updated::Updated;
use messages::prelude::Address;
use messages::prelude::Context;
use messages::prelude::Notifiable;
use notify::Config;
use notify::RecommendedWatcher;
use notify::RecursiveMode;
use notify::Watcher;
use rinf::RustSignal;
use std::path::Path;
use tokio::sync::mpsc;

pub enum Watch {
    Remove(Vec<String>),
}

pub async fn watch_task<P>(mut addr: Address<Workspace>, path: P)
where
    P: AsRef<Path>,
{
    let (tx, mut rx) = mpsc::unbounded_channel();

    if let Ok(mut watcher) = RecommendedWatcher::new(
        move |res| {
            let tx = tx.clone();

            if let Err(err) = tx.send(res) {
                rinf::debug_print!("Failed to send watch event: {:?}", err);
            }
        },
        Config::default(),
    ) && let Ok(_) = watcher.watch(path.as_ref(), RecursiveMode::NonRecursive)
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
}

#[async_trait::async_trait]
impl Notifiable<Watch> for Workspace {
    async fn notify(&mut self, msg: Watch, _: &Context<Self>) {
        match msg {
            Watch::Remove(paths) => {
                rinf::debug_print!("{:?}", paths);

                Updated::Removed(paths).send_signal_to_dart();
            }
        }
    }
}
