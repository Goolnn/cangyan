use crate::api::cyfile::File;
use crate::api::cyfile::Note;
use crate::api::cyfile::Page;
use flutter_rust_bridge::frb;
use std::sync::Arc;
use std::sync::Mutex;

#[frb(opaque)]
pub struct EditState {
    file: Arc<Mutex<File>>,

    page_index: usize,
}

impl EditState {
    #[frb(sync)]
    pub fn new(file: Arc<Mutex<File>>, page_index: usize) -> Self {
        EditState { file, page_index }
    }

    #[frb(sync)]
    pub fn set_page(&self, page: Page) -> anyhow::Result<()> {
        let mut file = self
            .file
            .lock()
            .map_err(|e| anyhow::anyhow!(e.to_string()))?;

        file.project.pages[self.page_index] = page;

        file.save()?;

        Ok(())
    }

    #[frb(sync)]
    pub fn append_note(&self, x: f64, y: f64) -> anyhow::Result<()> {
        let mut file = self
            .file
            .lock()
            .map_err(|e| anyhow::anyhow!(e.to_string()))?;

        let page = file
            .project
            .pages
            .get_mut(self.page_index)
            .ok_or_else(|| anyhow::anyhow!("page index out of bounds: {}", self.page_index))?;

        page.notes.push(Note {
            x,
            y,
            choice: 0,
            texts: Vec::new(),
        });

        file.save()?;

        Ok(())
    }

    #[frb(sync)]
    pub fn remove_note(&self, note_index: usize) -> anyhow::Result<()> {
        let mut file = self
            .file
            .lock()
            .map_err(|e| anyhow::anyhow!(e.to_string()))?;

        let page = file
            .project
            .pages
            .get_mut(self.page_index)
            .ok_or_else(|| anyhow::anyhow!("page index out of bounds: {}", self.page_index))?;

        page.notes.remove(note_index);

        file.save()?;

        Ok(())
    }

    #[frb(sync)]
    pub fn page(&self) -> anyhow::Result<Option<Page>> {
        let file = self
            .file
            .lock()
            .map_err(|e| anyhow::anyhow!(e.to_string()))?;

        Ok(file.project.pages.get(self.page_index).cloned())
    }
}
