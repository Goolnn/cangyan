use crate::api::file::Source;
use flutter_rust_bridge::frb;
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

    pub fn load(&mut self) -> anyhow::Result<()> {
        self.sources.clear();

        if let Ok(entries) = self.workspace.read_dir() {
            for entry in entries.flatten() {
                if !entry.path().is_file() {
                    continue;
                }

                let path = entry.path();
                let source = Source::open(path)?;

                self.sources.push(Arc::new(Mutex::from(source)));
            }
        }

        Ok(())
    }
}
