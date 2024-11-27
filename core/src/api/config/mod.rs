use flutter_rust_bridge::frb;
use serde::Deserialize;
use serde::Serialize;

#[derive(Debug, Default, Serialize, Deserialize)]
pub struct Config {
    pub workspace: Option<String>,

    pub preview_features: bool,
}

impl Config {
    #[frb(sync)]
    pub fn new(value: String) -> anyhow::Result<Self> {
        let config: Config = serde_yaml::from_str(&value)?;

        Ok(config)
    }

    #[frb(sync)]
    pub fn to_string(&self) -> anyhow::Result<String> {
        let yaml = serde_yaml::to_string(&self)?;

        Ok(yaml)
    }
}
