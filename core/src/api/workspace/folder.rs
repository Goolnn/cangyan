use flutter_rust_bridge::frb;
use std::path::PathBuf;

pub struct Folder {
    path: PathBuf,
}

impl Folder {
    #[frb(ignore)]
    pub fn new(path: PathBuf) -> Self {
        Self { path }
    }
}
