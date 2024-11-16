use crate::api::cyfile::Project;
use flutter_rust_bridge::frb;
use std::path::PathBuf;

#[frb(opaque)]
pub struct Workspace {
    path: PathBuf,
}

impl Workspace {
    #[frb(sync)]
    pub fn new(path: String) -> Self {
        let path = PathBuf::from(path);

        Workspace { path }
    }

    pub fn load(&self) -> anyhow::Result<Vec<File>> {
        let mut files = Vec::new();

        if let Ok(entries) = self.path.read_dir() {
            for entry in entries.flatten() {
                if !entry.path().is_file() {
                    continue;
                }

                let path = entry.path();
                let file = cyfile::File::open(path.as_path());

                if let Ok(file) = file {
                    let project = Project::from(&file);

                    files.push(File { project, path });
                } else {
                    std::fs::remove_file(path)?;
                }
            }
        }

        Ok(files)
    }
}

#[frb]
pub struct File {
    #[frb(non_final)]
    pub project: Project,
    #[frb(ignore)]
    pub path: PathBuf,
}
