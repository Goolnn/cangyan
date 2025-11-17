mod workspace;

use crate::workspace::Overviews;
use crate::workspace::Workspace;
use rinf::RustSignal;

rinf::write_interface!();

#[tokio::main(flavor = "current_thread")]
async fn main() {
    if let Some(workspace) = Workspace::new() {
        Overviews::from(workspace.projects()).send_signal_to_dart();
    }

    rinf::dart_shutdown().await;
}
