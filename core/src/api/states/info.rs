pub use cyfile::File;

use flutter_rust_bridge::frb;
use std::sync::Arc;

pub struct InfoState {
    file: Arc<File>,
}

impl InfoState {
    #[frb(sync)]
    pub fn new(file: Arc<File>) -> Self {
        InfoState { file }
    }
}
