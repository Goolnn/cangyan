mod workspace;

use crate::workspace::Files;
use crate::workspace::Workspace;
use rinf::RustSignal;

rinf::write_interface!();

#[tokio::main(flavor = "current_thread")]
async fn main() {
    if let Some(workspace) = Workspace::new() {
        Files(Some(
            workspace
                .files()
                .iter()
                .map(|file| file.display().to_string())
                .collect(),
        ))
        .send_signal_to_dart();
    } else {
        Files(None).send_signal_to_dart();
    }

    rinf::dart_shutdown().await;
}
