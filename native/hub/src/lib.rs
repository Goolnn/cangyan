mod actors;
mod signals;
mod tasks;

use crate::actors::Workspace;
use interprocess::local_socket::GenericNamespaced;
use interprocess::local_socket::Stream;
use interprocess::local_socket::ToNsName;
use interprocess::local_socket::prelude::*;
use messages::prelude::Context;
use rinf::debug_print;
use single_instance::SingleInstance;
use std::io::BufReader;
use std::io::Write;

pub const SIG_NAME: &str = "com.goolnn.cangyan.sig";
pub const IPC_NAME: &str = "com.goolnn.cangyan.ipc";

rinf::write_interface!();

#[tokio::main(flavor = "current_thread")]
async fn main() -> anyhow::Result<()> {
    let instance = SingleInstance::new(SIG_NAME)?;

    if !instance.is_single() {
        let config = bincode::config::standard();

        let stream = Stream::connect(IPC_NAME.to_ns_name::<GenericNamespaced>()?)?;

        let mut buf = BufReader::new(stream);

        let args = std::env::args().skip(1).collect::<Vec<String>>();
        let data = bincode::encode_to_vec(&args, config)?;

        buf.get_mut().write_all(&data)?;

        std::process::exit(0);
    }

    let context = Context::new();
    let addr = context.address();
    let workspace = Workspace::default();

    tokio::spawn(context.run(workspace));

    tokio::spawn(tasks::dropped(addr.clone()));
    tokio::spawn(tasks::interprocess(addr.clone()));

    rinf::dart_shutdown().await;

    Ok(())
}
