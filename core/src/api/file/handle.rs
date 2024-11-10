use crate::api::file::File;
use crate::api::file::Source;
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

impl From<&Source> for Handle {
    fn from(value: &Source) -> Self {
        Handle {
            file: value.file.clone(),
        }
    }
}
