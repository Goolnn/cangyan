use crate::api::file::File;
use crate::api::file::Summary;
use flutter_rust_bridge::frb;
use std::sync::Arc;
use std::sync::Mutex;

#[frb(opaque)]
pub struct InfoState {
    file: Arc<Mutex<File>>,
}

impl InfoState {
    #[frb(sync)]
    pub fn new(file: Arc<Mutex<File>>) -> Self {
        InfoState { file }
    }
}

#[frb]
impl From<&Summary> for InfoState {
    fn from(value: &Summary) -> Self {
        Self {
            file: value.file.clone(),
        }
    }
}
