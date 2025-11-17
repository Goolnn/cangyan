mod workspace;

use crate::workspace::Workspace;
use messages::prelude::Context;

rinf::write_interface!();

#[tokio::main(flavor = "current_thread")]
async fn main() {
    let context = Context::new();
    let addr = context.address();

    if let Some(workspace) = Workspace::new(addr) {
        tokio::spawn(context.run(workspace));
    }

    rinf::dart_shutdown().await;
}
