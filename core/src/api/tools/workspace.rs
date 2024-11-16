use crate::api::cyfile::Project;
use crate::api::tools::File;
use cyfile::ExportArguments;
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

    #[frb(sync)]
    pub fn create(&self, title: String, images: Vec<Vec<u8>>) -> anyhow::Result<File> {
        let path = self.path.join(format!("{}.cy", title));

        let pages = images.into_iter().map(cyfile::Page::new).collect();
        let project = cyfile::Project::new().with_pages(pages);

        cyfile::File::export(
            &project,
            ExportArguments::new(path.as_path()).with_version((0, 1)),
        )?;

        let project = Project::from(&project);
        let file = File { project, path };

        Ok(file)
    }

    #[frb(sync)]
    pub fn import(&self, title: String, data: Vec<u8>) -> anyhow::Result<()> {
        let path = self.path.join(format!("{}.cy", title));

        std::fs::write(path, data)?;

        Ok(())
    }

    #[frb(sync)]
    pub fn check(&self, title: String) -> anyhow::Result<bool> {
        let path = self.path.join(format!("{}.cy", title));

        Ok(path.exists())
    }
}
