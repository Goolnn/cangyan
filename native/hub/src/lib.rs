mod actors;
mod signals;

use actors::create_actors;
use rinf::dart_shutdown;
use rinf::write_interface;
use tokio::spawn;

write_interface!();

#[tokio::main(flavor = "current_thread")]
async fn main() {
    spawn(create_actors());

    dart_shutdown().await;
}
