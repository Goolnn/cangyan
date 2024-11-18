use crate::api::cyfile::Date;
use crate::api::tools::File;
use flutter_rust_bridge::frb;
use std::sync::Arc;
use std::sync::Mutex;

pub struct Summary {
    file: Arc<Mutex<File>>,
}

impl Summary {
    #[frb(sync)]
    pub fn new(file: Arc<Mutex<File>>) -> Self {
        Summary { file }
    }

    #[frb(sync)]
    pub fn cover(&self) -> anyhow::Result<Vec<u8>> {
        let file = self
            .file
            .lock()
            .map_err(|e| anyhow::anyhow!(e.to_string()))?;

        let cover = file.project.cover().to_owned();

        Ok(cover)
    }

    #[frb(sync)]
    pub fn page_count(&self) -> anyhow::Result<usize> {
        let file = self
            .file
            .lock()
            .map_err(|e| anyhow::anyhow!(e.to_string()))?;

        let page_count = file.project.pages().len();

        Ok(page_count)
    }

    #[frb(sync)]
    pub fn category(&self) -> anyhow::Result<String> {
        let file = self
            .file
            .lock()
            .map_err(|e| anyhow::anyhow!(e.to_string()))?;

        let category = file.project.category().to_owned();

        Ok(category)
    }

    #[frb(sync)]
    pub fn title(&self) -> anyhow::Result<String> {
        let file = self
            .file
            .lock()
            .map_err(|e| anyhow::anyhow!(e.to_string()))?;

        let title = file.project.title().to_owned();

        Ok(title)
    }

    #[frb(sync)]
    pub fn number(&self) -> anyhow::Result<(u32, u32)> {
        let file = self
            .file
            .lock()
            .map_err(|e| anyhow::anyhow!(e.to_string()))?;

        let number = file.project.number();

        Ok(number)
    }

    #[frb(sync)]
    pub fn comment(&self) -> anyhow::Result<String> {
        let file = self
            .file
            .lock()
            .map_err(|e| anyhow::anyhow!(e.to_string()))?;

        let comment = file.project.comment().to_owned();

        Ok(comment)
    }

    #[frb(sync)]
    pub fn created_date(&self) -> anyhow::Result<Date> {
        let file = self
            .file
            .lock()
            .map_err(|e| anyhow::anyhow!(e.to_string()))?;

        let created_date = Date::from(file.project.created_date());

        Ok(created_date)
    }

    #[frb(sync)]
    pub fn updated_date(&self) -> anyhow::Result<Date> {
        let file = self
            .file
            .lock()
            .map_err(|e| anyhow::anyhow!(e.to_string()))?;

        let updated_date = Date::from(file.project.updated_date());

        Ok(updated_date)
    }
}
