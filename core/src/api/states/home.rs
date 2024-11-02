use crate::api::cyfile::Project;
use crate::api::cyfile::Source;
use cyfile::File;
use flutter_rust_bridge::frb;
use std::fs;
use std::path::PathBuf;
use std::sync::Arc;
use std::sync::Mutex;

#[frb(opaque)]
pub struct HomeState {
    workspace: PathBuf,

    sources: Vec<Arc<Mutex<Source>>>,
}

impl HomeState {
    #[frb(sync)]
    pub fn new(workspace: String) -> Self {
        let workspace = PathBuf::from(workspace);
        let sources = Vec::new();

        HomeState { workspace, sources }
    }

    pub fn load(&mut self) {
        self.sources.clear();

        if let Ok(entries) = self.workspace.read_dir() {
            for entry in entries.flatten() {
                if !entry.path().is_file() {
                    continue;
                }

                let stream = match fs::File::open(entry.path()) {
                    Ok(stream) => stream,
                    _ => continue,
                };

                let mut file = match File::open(stream) {
                    Ok(file) => file,
                    _ => continue,
                };

                if file.project().title().is_empty() {
                    let file_path = entry.path();
                    let file_name = file_path.file_stem();

                    if let Some(file_name) = file_name {
                        file.project_mut().set_title(file_name.to_string_lossy());
                    }
                }

                let path = entry.path();
                let source = Arc::new(Mutex::new(Source { file, path }));

                self.sources.push(source);
            }
        }
    }

    #[frb(sync)]
    pub fn projects(&self) -> Vec<Project> {
        self.sources
            .iter()
            .map(|source| Project::new(Arc::clone(source)))
            .collect()
    }
}
