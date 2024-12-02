mod file;
mod folder;

pub use file::File;
pub use folder::Folder;

use std::path::PathBuf;
use thiserror::Error;

pub struct Workspace {
    path: PathBuf,

    folders: Vec<Folder>,
    files: Vec<File>,
}

impl Workspace {
    pub fn new(path: String) -> anyhow::Result<Self> {
        let path = PathBuf::from(path);

        let mut folders = Vec::new();
        let mut files = Vec::new();

        if !path.is_dir() {
            return Err(Error::PathNotDirectory { path }.into());
        }

        for entry in path.read_dir()?.flatten() {
            let path = entry.path();

            if path.is_dir() {
                folders.push(Folder::new(path.to_path_buf()));
            }

            if path.is_file() {
                files.push(File::new(path.to_path_buf()));
            }
        }

        Ok(Self {
            path,

            folders,
            files,
        })
    }
}

#[derive(Error, Debug)]
pub enum Error {
    #[error("\"{}\" is not directory", path.display())]
    PathNotDirectory { path: PathBuf },
}
