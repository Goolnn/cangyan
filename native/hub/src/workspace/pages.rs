use crate::workspace::Workspace;
use messages::prelude::Address;
use messages::prelude::Context;
use messages::prelude::Notifiable;
use rinf::DartSignal;
use rinf::RustSignal;
use serde::Deserialize;
use serde::Serialize;

#[derive(Deserialize, DartSignal)]
pub struct Open {
    pub path: String,
}

pub async fn open_task(mut addr: Address<Workspace>) {
    let receiver = Open::get_dart_signal_receiver();

    while let Some(pack) = receiver.recv().await {
        let message = pack.message;

        let _ = addr.notify(message).await;
    }
}

#[async_trait::async_trait]
impl Notifiable<Open> for Workspace {
    async fn notify(&mut self, msg: Open, _: &Context<Self>) {
        let path = msg.path;

        Pages(self.projects.get(&path).map(|project| {
            project
                .pages()
                .iter()
                .map(|page| page.data().to_vec())
                .collect()
        }))
        .send_signal_to_dart();
    }
}

#[derive(Serialize, RustSignal)]
pub struct Pages(pub Option<Vec<Vec<u8>>>);
