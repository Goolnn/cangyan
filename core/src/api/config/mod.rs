use serde::Deserialize;
use serde::Serialize;

#[derive(Debug, Default, Serialize, Deserialize)]
pub struct Config {
    pub workspace: Option<String>,

    pub preview_features: bool,
}
