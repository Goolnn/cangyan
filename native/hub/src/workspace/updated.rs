use crate::workspace::overview::Overview;
use rinf::RustSignal;
use serde::Serialize;

#[derive(Serialize, RustSignal)]
pub enum Updated {
    Added(Vec<Overview>),
    Removed(Vec<String>),
}
