use crate::workspace::Workspace;
use crate::workspace::overview::Overviews;
use messages::prelude::Context;
use messages::prelude::Notifiable;
use rinf::DartSignal;
use rinf::RustSignal;
use serde::Deserialize;
use std::path::PathBuf;

#[derive(Deserialize, DartSignal)]
pub struct Move(pub Vec<String>);

#[derive(Deserialize, DartSignal)]
pub struct Copy(pub Vec<String>);

#[async_trait::async_trait]
impl Notifiable<Move> for Workspace {
    async fn notify(&mut self, msg: Move, _: &Context<Self>) {
        let paths = msg.0;

        let projects = paths
            .into_iter()
            .filter_map(|path| {
                let path = PathBuf::from(path);

                if (path.exists() && path.is_file() && cyfile::check(&path))
                    && let Ok(file) = std::fs::File::open(&path)
                    && let Ok(project) = cyfile::File::open(file)
                    && let Some(name) = path.file_name()
                    && let Ok(_) = std::fs::copy(&path, self.path.join(name))
                    && let Ok(_) = std::fs::remove_file(&path)
                {
                    Some(project)
                } else {
                    None
                }
            })
            .collect::<Vec<cyfile::Project>>();

        Overviews::from(&projects).send_signal_to_dart();

        self.projects.extend(projects);
    }
}

#[async_trait::async_trait]
impl Notifiable<Copy> for Workspace {
    async fn notify(&mut self, msg: Copy, _: &Context<Self>) {
        let paths = msg.0;

        let projects = paths
            .into_iter()
            .filter_map(|path| {
                let path = PathBuf::from(path);

                if (path.exists() && path.is_file() && cyfile::check(&path))
                    && let Ok(file) = std::fs::File::open(&path)
                    && let Ok(project) = cyfile::File::open(file)
                    && let Some(name) = path.file_name()
                    && let Ok(_) = std::fs::copy(&path, self.path.join(name))
                {
                    Some(project)
                } else {
                    None
                }
            })
            .collect::<Vec<cyfile::Project>>();

        Overviews::from(&projects).send_signal_to_dart();

        self.projects.extend(projects);
    }
}
