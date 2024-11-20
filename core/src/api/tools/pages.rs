use crate::api::tools::File;
use flutter_rust_bridge::frb;
use std::sync::Arc;
use std::sync::Mutex;

pub struct Pages {
    file: Arc<Mutex<File>>,
}

impl Pages {
    #[frb(sync)]
    pub fn new(file: Arc<Mutex<File>>) -> Self {
        Pages { file }
    }
}
