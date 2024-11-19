use crate::api::tools::Summary;
use crate::api::tools::Workspace;
use flutter_rust_bridge::frb;

#[frb]
pub struct HomeState {
    workspace: Workspace,
}

impl HomeState {
    #[frb(sync)]
    pub fn new(workspace: Workspace) -> Self {
        HomeState { workspace }
    }

    pub fn load(&mut self) -> anyhow::Result<Vec<Summary>> {
        Ok(self
            .workspace
            .load()?
            .into_iter()
            .map(Summary::new)
            .collect())
    }
}
