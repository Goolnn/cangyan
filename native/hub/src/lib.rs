mod actors;
mod signals;
mod workspace;

use crate::workspace::Workspace;
use actors::create_actors;
use rinf::dart_shutdown;
use rinf::debug_print;
use rinf::write_interface;
use tokio::spawn;

write_interface!();

#[tokio::main(flavor = "current_thread")]
async fn main() {
    spawn(create_actors());

    if let Some(workspace) = Workspace::new() {
        debug_print!("Workspace path: {}", workspace.path().display());
    }

    dart_shutdown().await;
}
