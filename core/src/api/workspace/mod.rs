use std::path::PathBuf;

pub struct Workspace {
    path: PathBuf,
}

impl Workspace {
    pub fn new(path: String) -> Self {
        let path = PathBuf::from(path);

        Self { path }
    }
}

pub enum Error {}
