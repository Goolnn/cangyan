pub use crate::api::tools::File;
pub use std::sync::Mutex;

use crate::api::tools::Summary;
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

    pub fn load(&mut self) -> anyhow::Result<Vec<Summary>> {
        let mut summaries = Vec::new();

        self.files.clear();

        if let Ok(entries) = self.path.read_dir() {
            for entry in entries.flatten() {
                if !entry.path().is_file() {
                    continue;
                }

                let path = entry.path();
                let file = cyfile::File::open(path.as_path());

                if let Ok(mut project) = file {
                    project.set_title(path.file_stem().unwrap().to_string_lossy().to_string());

                    let file = Arc::new(Mutex::new(File { project, path }));
                    let summary = Summary::new(Arc::clone(&file));

                    self.files.push(file);

                    summaries.push(summary);
                } else {
                    std::fs::remove_file(path)?;
                }
            }
        }

        Ok(summaries)
    }

    pub fn create(&self, title: String, images: Vec<Vec<u8>>) -> anyhow::Result<Summary> {
        let path = self.path.join(format!("{}.cy", title));

        let pages = images.into_iter().map(cyfile::Page::new).collect();
        let project = Project::new().with_pages(pages);

        cyfile::File::export(
            &project,
            ExportArguments::new(path.as_path()).with_version((0, 1)),
        )?;

        let file = Arc::new(Mutex::new(File { project, path }));
        let summary = Summary::new(file);

        Ok(summary)
    }

    pub fn include(&self, title: String, data: Vec<u8>) -> anyhow::Result<Summary> {
        let path = self.path.join(format!("{}.cy", title));

        std::fs::write(path.as_path(), data)?;

        let project = cyfile::File::open(path.as_path())?.with_title(title);
        let file = Arc::new(Mutex::new(File { project, path }));
        let summary = Summary::new(file);

        Ok(summary)
    }

    #[frb(sync)]
    pub fn check(&self, title: String) -> bool {
        let path = self.path.join(format!("{}.cy", title));

        path.exists()
    }
}
