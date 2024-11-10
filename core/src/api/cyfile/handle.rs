use crate::api::cyfile::File;
use crate::api::cyfile::Summary;
use std::sync::Arc;
use std::sync::Mutex;

pub struct Handle {
    file: Arc<Mutex<File>>,
}

impl Handle {
    pub fn new(file: Arc<Mutex<File>>) -> Self {
        Handle { file }
    }
}

impl From<&Summary> for Handle {
    fn from(value: &Summary) -> Self {
        Handle {
            file: value.file.clone(),
        }
    }
}
