use crate::workspace::Workspace;
use crate::workspace::updated::Updated;
use messages::prelude::Context;
use messages::prelude::Notifiable;
use rinf::RustSignal;

pub enum Watch {
    Remove(Vec<String>),
}

#[async_trait::async_trait]
impl Notifiable<Watch> for Workspace {
    async fn notify(&mut self, msg: Watch, _: &Context<Self>) {
        match msg {
            Watch::Remove(paths) => {
                Updated::Removed(paths).send_signal_to_dart();
            }
        }
    }
}
