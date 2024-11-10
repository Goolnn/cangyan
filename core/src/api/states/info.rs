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

    #[frb(sync)]
    pub fn summary(&self) -> Summary {
        Summary::new(self.file.clone())
    }
}

#[frb(sync)]
impl From<&Summary> for InfoState {
    fn from(summary: &Summary) -> Self {
        Self {
            file: summary.file.clone(),
        }
    }
}
