use crate::api::tools::File;
use crate::api::tools::Workspace;
use flutter_rust_bridge::frb;
use std::sync::Arc;
use std::sync::Mutex;

#[frb]
pub struct HomeState {
    workspace: Workspace,
}

impl HomeState {
    #[frb(sync)]
    pub fn new(workspace: Workspace) -> Self {
        HomeState { workspace }
    }

    pub fn load(&mut self) -> anyhow::Result<Vec<Arc<Mutex<File>>>> {
        self.workspace.load()
    }
}

// pub use crate::api::cyfile::File;
// pub use std::sync::Mutex;

// use crate::api::cyfile::Summary;
// use crate::api::states::CreateState;
// use flutter_rust_bridge::frb;
// use std::path::PathBuf;
// use std::sync::Arc;

// #[frb(opaque)]
// pub struct HomeState {
//     workspace: PathBuf,

//     files: Vec<Arc<Mutex<File>>>,
// }

// impl HomeState {
//     #[frb(sync)]
//     pub fn new(workspace: String) -> Self {
//         let workspace = PathBuf::from(workspace);
//         let files = Vec::new();

//         HomeState { workspace, files }
//     }

//     pub fn load(&mut self) -> anyhow::Result<Vec<Summary>> {
//         self.files.clear();

//         if let Ok(entries) = self.workspace.read_dir() {
//             for entry in entries.flatten() {
//                 if !entry.path().is_file() {
//                     continue;
//                 }

//                 let path = entry.path();
//                 let file = File::open(path);

//                 if let Ok(file) = file {
//                     self.files.push(Arc::new(Mutex::from(file)));
//                 }
//             }
//         }

//         Ok(self
//             .files
//             .iter()
//             .map(|file| Summary::new(file.clone()))
//             .collect())
//     }

//     #[frb(sync)]
//     pub fn delete(&self, index: usize) -> anyhow::Result<()> {
//         let file = self
//             .files
//             .get(index)
//             .ok_or_else(|| anyhow::anyhow!("file not found"))?
//             .lock()
//             .map_err(|e| anyhow::anyhow!(e.to_string()))?;

//         file.delete()?;

//         Ok(())
//     }

//     #[frb(sync)]
//     pub fn filepath(&self, index: usize) -> anyhow::Result<String> {
//         let file = self
//             .files
//             .get(index)
//             .ok_or_else(|| anyhow::anyhow!("file not found"))?
//             .lock()
//             .map_err(|e| anyhow::anyhow!(e.to_string()))?;

//         Ok(file.path.to_string_lossy().to_string())
//     }

//     #[frb(sync)]
//     pub fn create(&self) -> CreateState {
//         CreateState::from(self.workspace.clone())
//     }
// }
