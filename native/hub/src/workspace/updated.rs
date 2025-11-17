use crate::workspace::overview::Overview;
use rinf::RustSignal;
use serde::Serialize;
use std::collections::HashMap;

#[derive(Serialize, RustSignal)]
pub enum Updated {
    Added(HashMap<String, Overview>),
    Removed(Vec<String>),
}
