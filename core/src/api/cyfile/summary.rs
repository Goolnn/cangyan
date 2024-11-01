use crate::api::cyfile::Date;
use cyfile::File;
use flutter_rust_bridge::frb;
use std::sync::Arc;
use std::sync::Mutex;

#[frb(opaque)]
pub struct Summary {
    file: Arc<Mutex<File>>,
}

impl Summary {
    #[frb(ignore)]
    pub fn new(file: Arc<Mutex<File>>) -> Self {
        Summary { file }
    }

    #[frb(sync)]
    pub fn cover(&self) -> anyhow::Result<Option<Vec<u8>>> {
        let file = self
            .file
            .lock()
            .map_err(|e| anyhow::anyhow!(e.to_string()))?;

        let project = file.project();
        let cover = project.cover();

        if cover.is_empty() {
            if project.pages().is_empty() {
                Ok(None)
            } else {
                Ok(Some(project.pages()[0].data().to_owned()))
            }
        } else {
            Ok(Some(cover.to_owned()))
        }
    }

    #[frb(sync)]
    pub fn category(&self) -> anyhow::Result<String> {
        let file = self
            .file
            .lock()
            .map_err(|e| anyhow::anyhow!(e.to_string()))?;

        Ok(file.project().category().to_string())
    }

    #[frb(sync)]
    pub fn title(&self) -> anyhow::Result<String> {
        let file = self
            .file
            .lock()
            .map_err(|e| anyhow::anyhow!(e.to_string()))?;

        Ok(file.project().title().to_string())
    }

    #[frb(sync)]
    pub fn number(&self) -> anyhow::Result<(u32, u32)> {
        let file = self
            .file
            .lock()
            .map_err(|e| anyhow::anyhow!(e.to_string()))?;

        Ok(file.project().number())
    }

    #[frb(sync)]
    pub fn created_date(&self) -> anyhow::Result<Date> {
        let file = self
            .file
            .lock()
            .map_err(|e| anyhow::anyhow!(e.to_string()))?;

        Ok(Date::from(file.project().created_date()))
    }

    #[frb(sync)]
    pub fn saved_date(&self) -> anyhow::Result<Date> {
        let file = self
            .file
            .lock()
            .map_err(|e| anyhow::anyhow!(e.to_string()))?;

        Ok(Date::from(file.project().saved_date()))
    }

    #[frb(sync)]
    pub fn page_count(&self) -> anyhow::Result<u32> {
        let file = self
            .file
            .lock()
            .map_err(|e| anyhow::anyhow!(e.to_string()))?;

        Ok(file.project().pages().len() as u32)
    }
}
