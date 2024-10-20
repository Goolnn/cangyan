use cyfile::File;
use flutter_rust_bridge::frb;
use std::fs;
use std::path::PathBuf;

pub struct HomeState {
    workspace: PathBuf,

    files: Vec<File>,
}

impl HomeState {
    #[frb(sync)]
    pub fn new(workspace: String) -> Self {
        let workspace = PathBuf::from(workspace);

        let mut files = Vec::new();

        if let Ok(entries) = workspace.read_dir() {
            for entry in entries.flatten() {
                if !entry.path().is_file() {
                    continue;
                }

                let stream = match fs::File::open(entry.path()) {
                    Ok(stream) => stream,
                    _ => continue,
                };

                let file = match File::open(stream) {
                    Ok(file) => file,
                    _ => continue,
                };

                files.push(file);
            }
        }

        HomeState { workspace, files }
    }
}

pub struct Summary {
    pub cover: Option<Vec<u8>>,
    pub page_count: u32,

    pub title: String,

    pub created_date: (u16, u8, u8, u8, u8, u8),
    pub saved_date: (u16, u8, u8, u8, u8, u8),
}
