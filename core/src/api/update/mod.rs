use flutter_rust_bridge::frb;
use reqwest::Client;
use serde::Deserialize;

const OWNER: &str = "Goolnn";
const REPO: &str = "cangyan";

const USER_AGENT: &str = "Cangyan";

#[frb(opaque)]
pub struct Update {}

#[derive(Deserialize, Debug)]
#[frb(non_opaque)]
pub struct Release {
    #[serde(rename = "tag_name")]
    pub version: String,

    #[serde(rename = "published_at")]
    pub published: String,

    pub prerelease: bool,

    pub assets: Vec<Asset>,
}

#[derive(Deserialize, Debug)]
#[frb(non_opaque)]
pub struct Asset {
    pub name: String,
    #[serde(rename = "size")]
    pub size: u32,
    #[serde(rename = "browser_download_url")]
    pub url: String,
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
