use rinf::DartSignal;
use serde::Deserialize;

#[derive(Deserialize, DartSignal)]
pub struct Dropped {
    pub paths: Vec<String>,
}
