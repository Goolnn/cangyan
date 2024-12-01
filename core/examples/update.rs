use cangyan::api::update::Platform;
use cangyan::api::update::Update;

const VERSION: &str = "0.1.0";

#[tokio::main]
async fn main() -> anyhow::Result<()> {
    let release = Update::fetch().await?;

    println!("{:#?}", release);
    println!();

    if release.check_update(VERSION)? {
        println!("发现新版本: {}", release.version);
        println!();

        if let Some(asset) = release.asset_of(Platform::Android) {
            println!("资源名称：{}", asset.name);
            println!("资源平台：{:?}", Platform::Android);
            println!("资源大小：{:.2} MiB", asset.size as f64 / 1024.0 / 1024.0);
            println!("下载地址：{}", asset.url);
        }
    } else {
        println!("已是最新版本");
    }

    Ok(())
}
