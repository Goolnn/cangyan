use crate::actors::Workspace;
use crate::actors::workspace;
use messages::prelude::Address;
use notify::Config;
use notify::EventKind;
use notify::RecommendedWatcher;
use notify::RecursiveMode;
use notify::Watcher;
use notify::event::ModifyKind;
use notify::event::RenameMode;
use rinf::debug_print;
use std::path::Path;
use tokio::sync::mpsc;

pub async fn watch(mut addr: Address<Workspace>) -> anyhow::Result<()> {
    let (tx, mut rx) = mpsc::unbounded_channel();

    let mut watcher = RecommendedWatcher::new(
        move |res| {
            let tx = tx.clone();

            if let Err(err) = tx.send(res) {
                debug_print!("Failed to send watch event: {:?}", err);
            }
        },
        Config::default(),
    )?;

    watcher.watch(
        Path::new("C:\\Users\\Goolnn\\Documents\\cangyan"),
        RecursiveMode::Recursive,
    )?;

    while let Some(event) = rx.recv().await {
        let event = event?;

        match event.kind {
            EventKind::Create(_) => addr.notify(workspace::Watch::Create(event.paths)).await?,
            EventKind::Remove(_) => addr.notify(workspace::Watch::Remove(event.paths)).await?,
            EventKind::Modify(ModifyKind::Name(RenameMode::From)) => {
                addr.notify(workspace::Watch::Remove(event.paths)).await?;
            }
            EventKind::Modify(ModifyKind::Name(RenameMode::To)) => {
                addr.notify(workspace::Watch::Create(event.paths)).await?;
            }
            _ => debug_print!("{:?}", event),
        }
    }

    Ok(())
}
