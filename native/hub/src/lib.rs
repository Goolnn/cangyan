mod workspace;

use crate::workspace::Workspace;

rinf::write_interface!();

#[tokio::main(flavor = "current_thread")]
async fn main() {
    let _workspace = Workspace::new();

    rinf::dart_shutdown().await;
}
