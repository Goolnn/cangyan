use crate::api::cyfile::File;
use crate::api::cyfile::Page;
use crate::api::cyfile::Summary;
use crate::api::states::EditState;
use cyfile::Credit;
use flutter_rust_bridge::frb;
use std::collections::HashMap;
use std::collections::HashSet;
use std::sync::Arc;
use std::sync::Mutex;

#[frb(opaque)]
pub struct InfoState {
    file: Arc<Mutex<File>>,
}

impl InfoState {
    #[frb(sync)]
    pub fn new(file: Arc<Mutex<File>>) -> Self {
        InfoState { file }
    }

    #[frb(sync)]
    pub fn summary(&self) -> Summary {
        Summary::new(self.file.clone())
    }

    #[frb(sync)]
    pub fn set_cover(&self, cover: Vec<u8>) -> anyhow::Result<()> {
        let mut file = self
            .file
            .lock()
            .map_err(|e| anyhow::anyhow!(e.to_string()))?;

        file.project.cover = cover;

        file.save()?;

        Ok(())
    }

    #[frb(sync)]
    pub fn set_category(&self, category: String) -> anyhow::Result<()> {
        let mut file = self
            .file
            .lock()
            .map_err(|e| anyhow::anyhow!(e.to_string()))?;

        file.project.category = category;

        file.save()?;

        Ok(())
    }

    #[frb(sync)]
    pub fn set_title(&self, title: String) -> anyhow::Result<()> {
        let mut file = self
            .file
            .lock()
            .map_err(|e| anyhow::anyhow!(e.to_string()))?;

        file.project.title = title;

        file.save()?;

        Ok(())
    }

    #[frb(sync)]
    pub fn set_number(&self, number: (u32, u32)) -> anyhow::Result<()> {
        let mut file = self
            .file
            .lock()
            .map_err(|e| anyhow::anyhow!(e.to_string()))?;

        file.project.number = number;

        file.save()?;

        Ok(())
    }

    #[frb(sync)]
    pub fn set_comment(&self, comment: String) -> anyhow::Result<()> {
        let mut file = self
            .file
            .lock()
            .map_err(|e| anyhow::anyhow!(e.to_string()))?;

        file.project.comment = comment;

        file.save()?;

        Ok(())
    }

    #[frb(sync)]
    pub fn set_credits(&self, credits: HashMap<Credit, HashSet<String>>) -> anyhow::Result<()> {
        let mut file = self
            .file
            .lock()
            .map_err(|e| anyhow::anyhow!(e.to_string()))?;

        file.project.credits = credits;

        file.save()?;

        Ok(())
    }

    #[frb(sync)]
    pub fn append_page(&self, image: Vec<u8>) -> anyhow::Result<()> {
        let mut file = self
            .file
            .lock()
            .map_err(|e| anyhow::anyhow!(e.to_string()))?;

        let page = cyfile::Page::new(image);

        file.project.pages.push(Page::from(&page));

        file.save()?;

        Ok(())
    }

    #[frb(sync)]
    pub fn insert_page_before(&self, index: usize, image: Vec<u8>) -> anyhow::Result<()> {
        let mut file = self
            .file
            .lock()
            .map_err(|e| anyhow::anyhow!(e.to_string()))?;

        let page = cyfile::Page::new(image);

        file.project.pages.insert(index, Page::from(&page));

        file.save()?;

        Ok(())
    }

    #[frb(sync)]
    pub fn insert_page_after(&self, index: usize, image: Vec<u8>) -> anyhow::Result<()> {
        self.insert_page_before(index + 1, image)
    }

    #[frb(sync)]
    pub fn remove_page(&self, index: usize) -> anyhow::Result<()> {
        let mut file = self
            .file
            .lock()
            .map_err(|e| anyhow::anyhow!(e.to_string()))?;

        file.project.pages.remove(index);

        file.save()?;

        Ok(())
    }

    #[frb(sync)]
    pub fn open_page(&self, index: usize) -> EditState {
        EditState::new(self.file.clone(), index)
    }
}

#[frb(sync)]
impl From<&Summary> for InfoState {
    fn from(summary: &Summary) -> Self {
        Self {
            file: summary.file.clone(),
        }
    }
}
