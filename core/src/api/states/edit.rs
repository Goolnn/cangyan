use crate::api::cyfile::File;
use crate::api::cyfile::Page;
use std::sync::Arc;
use std::sync::Mutex;

pub struct EditState {
    file: Arc<Mutex<File>>,

    page_index: usize,
}

impl EditState {
    pub fn new(file: Arc<Mutex<File>>, page_index: usize) -> Self {
        EditState { file, page_index }
    }

    pub fn set_page(&self, page: Page) -> anyhow::Result<()> {
        let mut file = self
            .file
            .lock()
            .map_err(|e| anyhow::anyhow!(e.to_string()))?;

        file.project.pages[self.page_index] = page;

        file.save()?;

        Ok(())
    }

    pub fn page(&self) -> anyhow::Result<Option<Page>> {
        let file = self
            .file
            .lock()
            .map_err(|e| anyhow::anyhow!(e.to_string()))?;

        Ok(file.project.pages.get(self.page_index).cloned())
    }
}
