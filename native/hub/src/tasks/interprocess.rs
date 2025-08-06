use crate::IPC_NAME;
use crate::actors::Workspace;
use interprocess::local_socket::GenericNamespaced;
use interprocess::local_socket::ListenerOptions;
use interprocess::local_socket::ToNsName;
use interprocess::local_socket::tokio::Stream;
use interprocess::local_socket::traits::tokio::Listener;
use messages::prelude::Address;
use tokio::io::AsyncReadExt;

pub async fn interprocess(mut addr: Address<Workspace>) -> anyhow::Result<()> {
    let args: Vec<String> = std::env::args().skip(1).collect();

    addr.notify(args).await?;

    let listener = ListenerOptions::new()
        .name(IPC_NAME.to_ns_name::<GenericNamespaced>()?)
        .create_tokio()?;

    loop {
        let stream = listener.accept().await?;

        tokio::spawn(connect(addr.clone(), stream));
    }
}

async fn connect(mut addr: Address<Workspace>, stream: Stream) -> anyhow::Result<()> {
    let config = bincode::config::standard();

    let mut buf = tokio::io::BufReader::new(stream);

    let mut data = Vec::new();

    buf.read_to_end(&mut data).await?;

    let args: Vec<String> = bincode::decode_from_slice(&data, config)?.0;

    addr.notify(args).await?;

    Ok(())
}
