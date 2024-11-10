use crate::api::file::Date;
use crate::api::file::File;
use flutter_rust_bridge::frb;
use std::sync::Arc;
use std::sync::Mutex;

#[frb(opaque)]
pub struct Source {
    file: Arc<Mutex<File>>,
}

impl Source {
    #[frb(ignore)]
    pub fn new(file: Arc<Mutex<File>>) -> Self {
        Source { file }
    }

    pub fn cover(&self) -> anyhow::Result<Vec<u8>> {
        let file = self
            .file
            .lock()
            .map_err(|e| anyhow::anyhow!(e.to_string()))?;

        Ok(file.project.cover.clone())
    }

    pub fn page_count(&self) -> anyhow::Result<usize> {
        let file = self
            .file
            .lock()
            .map_err(|e| anyhow::anyhow!(e.to_string()))?;

        Ok(file.project.pages.len())
    }

    pub fn category(&self) -> anyhow::Result<String> {
        let file = self
            .file
            .lock()
            .map_err(|e| anyhow::anyhow!(e.to_string()))?;

        Ok(file.project.category.clone())
    }

    pub fn title(&self) -> anyhow::Result<String> {
        let file = self
            .file
            .lock()
            .map_err(|e| anyhow::anyhow!(e.to_string()))?;

        Ok(file.project.title.clone())
    }

    pub fn number(&self) -> anyhow::Result<(u32, u32)> {
        let file = self
            .file
            .lock()
            .map_err(|e| anyhow::anyhow!(e.to_string()))?;

        Ok(file.project.number)
    }

    pub fn comment(&self) -> anyhow::Result<String> {
        let file = self
            .file
            .lock()
            .map_err(|e| anyhow::anyhow!(e.to_string()))?;

        Ok(file.project.comment.clone())
    }

    pub fn created_date(&self) -> anyhow::Result<Date> {
        let file = self
            .file
            .lock()
            .map_err(|e| anyhow::anyhow!(e.to_string()))?;

        Ok(file.project.created_date)
    }

    pub fn updated_date(&self) -> anyhow::Result<Date> {
        let file = self
            .file
            .lock()
            .map_err(|e| anyhow::anyhow!(e.to_string()))?;

        Ok(file.project.updated_date)
    }
}
