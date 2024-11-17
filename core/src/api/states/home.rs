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
