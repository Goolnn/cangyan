use crate::workspace::Workspace;
use crate::workspace::overview::Overview;
use crate::workspace::updated::Updated;
use messages::prelude::Context;
use messages::prelude::Notifiable;
use rinf::DartSignal;
use rinf::RustSignal;
use serde::Deserialize;
use std::collections::HashMap;
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
                let source_path = PathBuf::from(path);

                if (source_path.exists() && source_path.is_file() && cyfile::check(&source_path))
                    && let Ok(file) = std::fs::File::open(&source_path)
                    && let Ok(mut project) = cyfile::File::open(file)
                    && let Some(file_name) = source_path.file_name()
                    && let Some(project_name) = source_path
                        .file_stem()
                        .map(|name| name.to_string_lossy().to_string())
                    && let target_path = self.path.join(file_name)
                    && let Ok(_) = std::fs::copy(&source_path, &target_path)
                    && let Ok(_) = std::fs::remove_file(&source_path)
                {
                    project.set_title(project_name);

                    Some((target_path.to_string_lossy().to_string(), project))
                } else {
                    None
                }
            })
            .collect::<HashMap<String, cyfile::Project>>();

        Updated::Added(
            projects
                .iter()
                .map(|(path, project)| (path.clone(), Overview::from(project)))
                .collect(),
        )
        .send_signal_to_dart();

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
                let source_path = PathBuf::from(path);

                if (source_path.exists() && source_path.is_file() && cyfile::check(&source_path))
                    && let Ok(file) = std::fs::File::open(&source_path)
                    && let Ok(mut project) = cyfile::File::open(file)
                    && let Some(file_name) = source_path.file_name()
                    && let Some(project_name) = source_path
                        .file_stem()
                        .map(|name| name.to_string_lossy().to_string())
                    && let target_path = self.path.join(file_name)
                    && let Ok(_) = std::fs::copy(&source_path, &target_path)
                {
                    project.set_title(project_name);

                    Some((target_path.display().to_string(), project))
                } else {
                    None
                }
            })
            .collect::<HashMap<String, cyfile::Project>>();

        Updated::Added(
            projects
                .iter()
                .map(|(path, project)| (path.clone(), Overview::from(project)))
                .collect(),
        )
        .send_signal_to_dart();

        self.projects.extend(projects);
    }
}
