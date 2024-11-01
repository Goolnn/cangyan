use cyfile::File;
use flutter_rust_bridge::frb;
use std::sync::Arc;
use std::sync::Mutex;

#[frb(opaque)]
pub struct Pages {
    file: Arc<Mutex<File>>,
}

impl Pages {
    #[frb(ignore)]
    pub fn new(file: Arc<Mutex<File>>) -> Self {
        Pages { file }
    }
}
