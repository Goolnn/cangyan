pub use cyfile::File;

use flutter_rust_bridge::frb;
use std::fs;
use std::path::PathBuf;
use std::sync::Arc;

pub struct HomeState {
    workspace: PathBuf,

    files: Vec<Arc<File>>,
}

impl HomeState {
    #[frb(sync)]
    pub fn new(workspace: String) -> Self {
        let workspace = PathBuf::from(workspace);
        let files = Vec::new();

        HomeState { workspace, files }
    }

    #[frb(sync)]
    pub fn summaries(&self) -> Vec<Summary> {
        self.files
            .iter()
            .map(|file| {
                let project = file.project();

                let cover = project.pages().first().map(|page| page.data().to_owned());
                let page_count = project.pages().len() as u32;

                let title = project.title().to_string();

                let created_date = {
                    let date = project.created_date();

                    (
                        date.year(),
                        date.month(),
                        date.day(),
                        date.hour(),
                        date.minute(),
                        date.second(),
                    )
                };

                let saved_date = {
                    let date = project.saved_date();

                    (
                        date.year(),
                        date.month(),
                        date.day(),
                        date.hour(),
                        date.minute(),
                        date.second(),
                    )
                };

                Summary {
                    cover,
                    page_count,

                    title,

                    created_date,
                    saved_date,
                }
            })
            .collect()
    }

    pub fn load(&mut self) {
        self.files.clear();

        if let Ok(entries) = self.workspace.read_dir() {
            for entry in entries.flatten() {
                if !entry.path().is_file() {
                    continue;
                }

                let stream = match fs::File::open(entry.path()) {
                    Ok(stream) => stream,
                    _ => continue,
                };

                let mut file = match File::open(stream) {
                    Ok(file) => file,
                    _ => continue,
                };

                if file.project().title().is_empty() {
                    let file_path = entry.path();
                    let file_name = file_path.file_stem();

                    if let Some(file_name) = file_name {
                        file.project_mut().set_title(file_name.to_string_lossy());
                    }
                }

                self.files.push(Arc::new(file));
            }
        }
    }
}

pub struct Summary {
    pub cover: Option<Vec<u8>>,
    pub page_count: u32,

    pub title: String,

    pub created_date: (u16, u8, u8, u8, u8, u8),
    pub saved_date: (u16, u8, u8, u8, u8, u8),
}
