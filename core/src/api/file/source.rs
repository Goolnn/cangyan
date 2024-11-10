use crate::api::file::File;
use flutter_rust_bridge::frb;
use std::sync::Arc;
use std::sync::Mutex;

#[frb(opaque)]
pub struct Source {
    file: Arc<Mutex<File>>,
}

impl Source {
    #[frb(ignore)]
    pub fn new(file: Arc<Mutex<File>>) -> Self {
        Source { file }
    }
}
