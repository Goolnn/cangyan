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

    pub fn import(&mut self, title: String, data: Vec<u8>) -> anyhow::Result<Summary> {
        Ok(Summary::new(self.workspace.import(title, data)?))
    }

    #[frb(sync)]
    pub fn check(&self, title: String) -> bool {
        self.workspace.check(title)
    }
}
