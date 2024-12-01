use std::path::PathBuf;
use thiserror::Error;

pub struct Workspace {
    path: PathBuf,
}

impl Workspace {
    pub fn new(path: String) -> anyhow::Result<Self> {
        let path = PathBuf::from(path);

        if !path.is_dir() {
            return Err(Error::PathNotDirectory { path }.into());
        }

        Ok(Self { path })
    }
}

#[derive(Error, Debug)]
pub enum Error {
    #[error("\"{}\" is not directory", path.display())]
    PathNotDirectory { path: PathBuf },
}
