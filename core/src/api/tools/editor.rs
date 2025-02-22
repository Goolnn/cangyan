use crate::api::cyfile::Note;
use crate::api::tools::File;
use cyfile::Text;
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

    #[frb(sync)]
    pub fn append_note(&self, x: f64, y: f64) -> anyhow::Result<()> {
        let mut file = self
            .file
            .lock()
            .map_err(|e| anyhow::anyhow!(e.to_string()))?;

        let page = &mut file.project.pages_mut()[self.index];

        page.notes_mut().push(
            cyfile::Note::new()
                .with_coordinate(x, y)
                .with_text(Text::new()),
        );

        file.save()?;

        Ok(())
    }

    #[frb(sync)]
    pub fn remove_note(&self, index: usize) -> anyhow::Result<()> {
        let mut file = self
            .file
            .lock()
            .map_err(|e| anyhow::anyhow!(e.to_string()))?;

        let page = &mut file.project.pages_mut()[self.index];

        page.notes_mut().remove(index);

        file.save()?;

        Ok(())
    }

    #[frb(sync)]
    pub fn update_note_position(&self, index: usize, x: f64, y: f64) -> anyhow::Result<()> {
        let mut file = self
            .file
            .lock()
            .map_err(|e| anyhow::anyhow!(e.to_string()))?;

        let page = &mut file.project.pages_mut()[self.index];
        let note = &mut page.notes_mut()[index];

        note.set_x(x);
        note.set_y(y);

        file.save()?;

        Ok(())
    }

    #[frb(sync)]
    pub fn update_note_content(&self, index: usize, content: String) -> anyhow::Result<()> {
        let mut file = self
            .file
            .lock()
            .map_err(|e| anyhow::anyhow!(e.to_string()))?;

        let page = &mut file.project.pages_mut()[self.index];
        let note = &mut page.notes_mut()[index];

        note.texts_mut()[0].set_content(content);

        file.save()?;

        Ok(())
    }

    #[frb(sync)]
    pub fn update_note_comment(&self, index: usize, comment: String) -> anyhow::Result<()> {
        let mut file = self
            .file
            .lock()
            .map_err(|e| anyhow::anyhow!(e.to_string()))?;

        let page = &mut file.project.pages_mut()[self.index];
        let note = &mut page.notes_mut()[index];

        note.texts_mut()[0].set_comment(comment);

        file.save()?;

        Ok(())
    }

    #[frb(sync)]
    pub fn set_note_number(&self, index: usize, number: usize) -> anyhow::Result<()> {
        let mut file = self
            .file
            .lock()
            .map_err(|e| anyhow::anyhow!(e.to_string()))?;

        let page = &mut file.project.pages_mut()[self.index];
        let note = page.notes_mut().remove(index);

        page.notes_mut().insert(number, note);

        file.save()?;

        Ok(())
    }

    #[frb(sync)]
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
