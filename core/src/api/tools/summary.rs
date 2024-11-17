use cyfile::File;
use flutter_rust_bridge::frb;
use std::sync::Arc;
use std::sync::Mutex;

pub struct Summary {
    file: Arc<Mutex<File>>,
}

impl Summary {
    #[frb(sync)]
    pub fn new(file: Arc<Mutex<File>>) -> Self {
        Summary { file }
    }
}
