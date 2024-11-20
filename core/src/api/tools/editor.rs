use crate::api::cyfile::Note;
use crate::api::tools::File;
use flutter_rust_bridge::frb;
use std::sync::Arc;
use std::sync::Mutex;

pub struct Editor {
    file: Arc<Mutex<File>>,

    index: usize,
}

impl Editor {
    #[frb(sync)]
    pub fn new(file: Arc<Mutex<File>>, index: usize) -> Self {
        Editor { file, index }
    }

    pub fn notes(&self) -> anyhow::Result<Vec<Note>> {
        let file = self
            .file
            .lock()
            .map_err(|e| anyhow::anyhow!(e.to_string()))?;

        let page = &file.project.pages()[self.index];
        let notes = page.notes().iter().map(Note::from).collect();

        Ok(notes)
    }
}
