use crate::api::cyfile::File;
use crate::api::cyfile::Note;
use crate::api::cyfile::Page;
use crate::api::cyfile::Text;
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
    pub fn move_note_to(&self, note_index: usize, x: f64, y: f64) -> anyhow::Result<()> {
        let mut file = self
            .file
            .lock()
            .map_err(|e| anyhow::anyhow!(e.to_string()))?;

        let page = file
            .project
            .pages
            .get_mut(self.page_index)
            .ok_or_else(|| anyhow::anyhow!("page index out of bounds: {}", self.page_index))?;

        let note = page
            .notes
            .get_mut(note_index)
            .ok_or_else(|| anyhow::anyhow!("note index out of bounds: {}", note_index))?;

        note.x = x;
        note.y = y;

        file.save()?;

        Ok(())
    }

    #[frb(sync)]
    pub fn modify_note_content(&self, note_index: usize, content: String) -> anyhow::Result<()> {
        let mut file = self
            .file
            .lock()
            .map_err(|e| anyhow::anyhow!(e.to_string()))?;

        let page = file
            .project
            .pages
            .get_mut(self.page_index)
            .ok_or_else(|| anyhow::anyhow!("page index out of bounds: {}", self.page_index))?;

        let note = page
            .notes
            .get_mut(note_index)
            .ok_or_else(|| anyhow::anyhow!("note index out of bounds: {}", note_index))?;

        note.texts[0].content = content;

        file.save()?;

        Ok(())
    }

    #[frb(sync)]
    pub fn modify_note_comment(&self, note_index: usize, comment: String) -> anyhow::Result<()> {
        let mut file = self
            .file
            .lock()
            .map_err(|e| anyhow::anyhow!(e.to_string()))?;

        let page = file
            .project
            .pages
            .get_mut(self.page_index)
            .ok_or_else(|| anyhow::anyhow!("page index out of bounds: {}", self.page_index))?;

        let note = page
            .notes
            .get_mut(note_index)
            .ok_or_else(|| anyhow::anyhow!("note index out of bounds: {}", note_index))?;

        note.texts[0].comment = comment;

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
            texts: vec![Text {
                content: String::new(),
                comment: String::new(),
            }],
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
