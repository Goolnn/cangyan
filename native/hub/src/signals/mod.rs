mod dropped;

pub use dropped::Dropped;

use rinf::RustSignal;
use serde::Serialize;

#[derive(Serialize, RustSignal)]
pub struct Arguments(pub Vec<String>);
