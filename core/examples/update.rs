use cangyan::api::update::Update;

const VERSION: &str = "0.1.0";

#[tokio::main]
async fn main() -> anyhow::Result<()> {
    let release = Update::fetch().await?;

    println!("{:#?}", release);

    if release.check_update(VERSION)? {
        println!("发现新版本: {}", release.version);
    } else {
        println!("已是最新版本");
    }

    Ok(())
}
