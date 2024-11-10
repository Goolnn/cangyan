use crate::api::file::File;
use flutter_rust_bridge::frb;
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

    pub fn load(&mut self) -> anyhow::Result<Vec<Arc<Mutex<File>>>> {
        self.files.clear();

        if let Ok(entries) = self.workspace.read_dir() {
            for entry in entries.flatten() {
                if !entry.path().is_file() {
                    continue;
                }

                let path = entry.path();
                let file = File::open(path)?;

                self.files.push(Arc::new(Mutex::from(file)));
            }
        }

        Ok(self.files.clone())
    }
}
