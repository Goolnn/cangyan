use flutter_rust_bridge::frb;
use std::path::PathBuf;

pub struct File {
    path: PathBuf,
}

impl File {
    #[frb(ignore)]
    pub fn new(path: PathBuf) -> Self {
        Self { path }
    }
}
