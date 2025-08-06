use messages::prelude::Address;
use rinf::DartSignal;

use crate::actors::Workspace;
use crate::signals::Dropped;

pub async fn dropped(mut addr: Address<Workspace>) -> anyhow::Result<()> {
    let receiver = Dropped::get_dart_signal_receiver();

    while let Some(pack) = receiver.recv().await {
        let paths = pack.message.paths;

        addr.notify(paths).await?;
    }

    Ok(())
}
