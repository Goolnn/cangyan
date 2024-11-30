use crate::frb_generated::StreamSink;
use flutter_rust_bridge::frb;
use futures_util::StreamExt;
use reqwest::Client;
use serde::Deserialize;

const OWNER: &str = "Goolnn";
const REPO: &str = "cangyan";
const TOKEN: &str = include_str!("token");

const USER_AGENT: &str = "Cangyan";

#[frb(opaque)]
pub struct Update {}

#[derive(Deserialize, Debug)]
pub struct Release {
    #[serde(rename = "tag_name")]
    pub version: String,

    #[serde(rename = "published_at")]
    pub published: String,

    pub prerelease: bool,

    pub assets: Vec<Asset>,
}

#[derive(Deserialize, Debug, Clone)]
pub struct Asset {
    pub name: String,
    #[serde(rename = "size")]
    pub size: u32,
    #[serde(rename = "browser_download_url")]
    pub url: String,
}

pub enum Platform {
    Windows,
    Android,
}

impl Update {
    pub async fn fetch() -> anyhow::Result<Release> {
        let url = format!(
            "https://api.github.com/repos/{}/{}/releases/latest",
            OWNER, REPO
        );

        let client = Client::new();
        let response = client
            .get(&url)
            .header("User-Agent", USER_AGENT)
            .header("Authorization", format!("Bearer {}", TOKEN))
            .send()
            .await?;

        let status = response.status();

        if status.is_success() {
            Ok(response.json::<Release>().await?)
        } else {
            anyhow::bail!("Failed to fetch the latest release");
        }
    }
}

impl Release {
    #[frb(sync)]
    pub fn check_update(&self, version: &str) -> anyhow::Result<bool> {
        let local_version = semver::Version::parse(&version[1..])?;
        let latest_version = semver::Version::parse(&self.version[1..])?;

        Ok(latest_version > local_version)
    }

    #[frb(sync)]
    pub fn asset_of(&self, platform: Platform) -> Option<Asset> {
        let platform = match platform {
            Platform::Windows => "windows",
            Platform::Android => "android",
        };

        self.assets
            .iter()
            .find(|asset| asset.name.contains(platform))
            .cloned()
    }
}

impl Asset {
    pub async fn download(&self, stream: StreamSink<Vec<u8>>) -> anyhow::Result<()> {
        let client = Client::new();
        let response = client.get(self.url.to_owned()).send().await?;
        let status = response.status();

        if status.is_success() {
            let mut body = response.bytes_stream();

            while let Some(chunk) = body.next().await {
                stream
                    .add(chunk?.to_vec())
                    .map_err(|e| anyhow::anyhow!(e.to_string()))?;
            }

            Ok(())
        } else {
            anyhow::bail!("Failed to download the asset");
        }
    }
}
