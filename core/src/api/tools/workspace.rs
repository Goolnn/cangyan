pub use std::sync::Mutex;

use crate::api::tools::File;
use cyfile::ExportArguments;
use cyfile::Project;
use flutter_rust_bridge::frb;
use std::path::PathBuf;
use std::sync::Arc;

#[frb(opaque)]
pub struct Workspace {
    path: PathBuf,

    files: Vec<Arc<Mutex<File>>>,
}

impl Workspace {
    #[frb(sync)]
    pub fn new(path: String) -> Self {
        let path = PathBuf::from(path);
        let files = Vec::new();

        Workspace { path, files }
    }

    #[frb(ignore)]
    pub fn load(&mut self) -> anyhow::Result<Vec<Arc<Mutex<File>>>> {
        self.files.clear();

        if let Ok(entries) = self.path.read_dir() {
            for entry in entries.flatten() {
                if !entry.path().is_file() {
                    continue;
                }

                let path = entry.path();
                let file = cyfile::File::open(path.as_path());

                if let Ok(project) = file {
                    let file = Arc::new(Mutex::new(File { project, path }));

                    self.files.push(file);
                } else {
                    std::fs::remove_file(path)?;
                }
            }
        }

        Ok(self.files.clone())
    }

    #[frb(ignore)]
    pub fn create(&self, title: String, images: Vec<Vec<u8>>) -> anyhow::Result<File> {
        let path = self.path.join(format!("{}.cy", title));

        let pages = images.into_iter().map(cyfile::Page::new).collect();
        let project = Project::new().with_pages(pages);

        cyfile::File::export(
            &project,
            ExportArguments::new(path.as_path()).with_version((0, 1)),
        )?;

        let file = File { project, path };

        Ok(file)
    }

    #[frb(ignore)]
    pub fn import(&self, title: String, data: Vec<u8>) -> anyhow::Result<()> {
        let path = self.path.join(format!("{}.cy", title));

        std::fs::write(path, data)?;

        Ok(())
    }

    #[frb(ignore)]
    pub fn check(&self, title: String) -> anyhow::Result<bool> {
        let path = self.path.join(format!("{}.cy", title));

        Ok(path.exists())
    }
}
