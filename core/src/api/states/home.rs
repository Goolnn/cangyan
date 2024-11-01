pub use cyfile::File;

use crate::api::cyfile::Summary;
use flutter_rust_bridge::frb;
use std::fs;
use std::path::PathBuf;
use std::sync::Arc;
use std::sync::Mutex;

#[frb(opaque)]
pub struct HomeState {
    workspace: PathBuf,

    files: Vec<Arc<Mutex<File>>>,
}

impl HomeState {
    #[frb(sync)]
    pub fn new(workspace: String) -> Self {
        let workspace = PathBuf::from(workspace);
        let files = Vec::new();

        HomeState { workspace, files }
    }

    pub fn load(&mut self) {
        self.files.clear();

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

                self.files.push(Arc::new(Mutex::new(file)));
            }
        }
    }

    #[frb(sync)]
    pub fn summaries(&self) -> Vec<Summary> {
        self.files
            .iter()
            .map(|file| Summary::new(Arc::clone(file)))
            .collect()
    }
}
