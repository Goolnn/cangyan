use rinf::DartSignal;
use serde::Deserialize;

#[derive(Deserialize, DartSignal)]
pub struct Edit {
    pub path: String,
    pub page: u32,
}

pub struct Notes();

pub struct Note {}
