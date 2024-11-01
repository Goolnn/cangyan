use cyfile::File;
use flutter_rust_bridge::frb;
use std::path::PathBuf;

#[frb(ignore)]
pub struct Source {
    pub file: File,
    pub path: PathBuf,
}
