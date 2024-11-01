use super::Source;
use crate::api::cyfile::Date;
use cyfile::Credit;
use flutter_rust_bridge::frb;
use std::collections::HashMap;
use std::collections::HashSet;
use std::sync::Arc;
use std::sync::Mutex;

#[frb(opaque)]
pub struct Summary {
    source: Arc<Mutex<Source>>,
}

impl Summary {
    #[frb(ignore)]
    pub fn new(source: Arc<Mutex<Source>>) -> Self {
        Summary { source }
    }

    #[frb(sync)]
    pub fn set_cover(&mut self, cover: Vec<u8>) -> anyhow::Result<()> {
        let mut source = self
            .source
            .lock()
            .map_err(|e| anyhow::anyhow!(e.to_string()))?;

        source.file.project_mut().set_cover(cover);

        source.save()?;

        Ok(())
    }

    #[frb(sync)]
    pub fn set_category(&mut self, category: String) -> anyhow::Result<()> {
        let mut source = self
            .source
            .lock()
            .map_err(|e| anyhow::anyhow!(e.to_string()))?;

        source.file.project_mut().set_category(category);

        source.save()?;

        Ok(())
    }

    #[frb(sync)]
    pub fn set_title(&mut self, title: String) -> anyhow::Result<()> {
        let mut source = self
            .source
            .lock()
            .map_err(|e| anyhow::anyhow!(e.to_string()))?;

        source.file.project_mut().set_title(title);

        source.save()?;

        Ok(())
    }

    #[frb(sync)]
    pub fn set_number(&mut self, number: (u32, u32)) -> anyhow::Result<()> {
        let mut source = self
            .source
            .lock()
            .map_err(|e| anyhow::anyhow!(e.to_string()))?;

        source.file.project_mut().set_number(number);

        source.save()?;

        Ok(())
    }

    #[frb(sync)]
    pub fn set_credits(&mut self, credits: HashMap<Credit, HashSet<String>>) -> anyhow::Result<()> {
        let mut source = self
            .source
            .lock()
            .map_err(|e| anyhow::anyhow!(e.to_string()))?;

        *source.file.project_mut().credits_mut() = credits;

        source.save()?;

        Ok(())
    }

    #[frb(sync)]
    pub fn cover(&self) -> anyhow::Result<Option<Vec<u8>>> {
        let source = self
            .source
            .lock()
            .map_err(|e| anyhow::anyhow!(e.to_string()))?;

        let project = source.file.project();
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
        let source = self
            .source
            .lock()
            .map_err(|e| anyhow::anyhow!(e.to_string()))?;

        Ok(source.file.project().category().to_string())
    }

    #[frb(sync)]
    pub fn title(&self) -> anyhow::Result<String> {
        let source = self
            .source
            .lock()
            .map_err(|e| anyhow::anyhow!(e.to_string()))?;

        Ok(source.file.project().title().to_string())
    }

    #[frb(sync)]
    pub fn number(&self) -> anyhow::Result<(u32, u32)> {
        let source = self
            .source
            .lock()
            .map_err(|e| anyhow::anyhow!(e.to_string()))?;

        Ok(source.file.project().number())
    }

    #[frb(sync)]
    pub fn credits(&self) -> anyhow::Result<HashMap<Credit, HashSet<String>>> {
        let source = self
            .source
            .lock()
            .map_err(|e| anyhow::anyhow!(e.to_string()))?;

        Ok(source.file.project().credits().clone())
    }

    #[frb(sync)]
    pub fn created_date(&self) -> anyhow::Result<Date> {
        let source = self
            .source
            .lock()
            .map_err(|e| anyhow::anyhow!(e.to_string()))?;

        Ok(Date::from(source.file.project().created_date()))
    }

    #[frb(sync)]
    pub fn saved_date(&self) -> anyhow::Result<Date> {
        let source = self
            .source
            .lock()
            .map_err(|e| anyhow::anyhow!(e.to_string()))?;

        Ok(Date::from(source.file.project().saved_date()))
    }

    #[frb(sync)]
    pub fn page_count(&self) -> anyhow::Result<u32> {
        let source = self
            .source
            .lock()
            .map_err(|e| anyhow::anyhow!(e.to_string()))?;

        Ok(source.file.project().pages().len() as u32)
    }
}
