use crate::api::cyfile::Date;
use crate::api::tools::File;
use crate::api::tools::Pages;
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
    pub fn set_cover(&self, cover: Vec<u8>) -> anyhow::Result<()> {
        let mut file = self
            .file
            .lock()
            .map_err(|e| anyhow::anyhow!(e.to_string()))?;

        file.project.set_cover(cover);

        file.save()?;

        Ok(())
    }

    #[frb(sync)]
    pub fn set_category(&self, category: String) -> anyhow::Result<()> {
        let mut file = self
            .file
            .lock()
            .map_err(|e| anyhow::anyhow!(e.to_string()))?;

        file.project.set_category(category);

        file.save()?;

        Ok(())
    }

    #[frb(sync)]
    pub fn set_title(&self, title: String) -> anyhow::Result<()> {
        let mut file = self
            .file
            .lock()
            .map_err(|e| anyhow::anyhow!(e.to_string()))?;

        file.project.set_title(title.clone());

        file.rename(title)?;
        file.save()?;

        Ok(())
    }

    #[frb(sync)]
    pub fn set_number(&self, number: (u32, u32)) -> anyhow::Result<()> {
        let mut file = self
            .file
            .lock()
            .map_err(|e| anyhow::anyhow!(e.to_string()))?;

        file.project.set_number(number);

        file.save()?;

        Ok(())
    }

    #[frb(sync)]
    pub fn set_comment(&self, comment: String) -> anyhow::Result<()> {
        let mut file = self
            .file
            .lock()
            .map_err(|e| anyhow::anyhow!(e.to_string()))?;

        file.project.set_comment(comment);

        file.save()?;

        Ok(())
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
    pub fn progress(&self) -> anyhow::Result<f64> {
        let file = self
            .file
            .lock()
            .map_err(|e| anyhow::anyhow!(e.to_string()))?;

        let project = &file.project;

        let mut total = 0.0;
        let mut done = 0.0;

        for page in project.pages() {
            for note in page.notes() {
                if note.choice() != 0 {
                    done += 1.0;
                }

                total += 1.0;
            }
        }

        let progress = if total == 0.0 { 0.0 } else { done / total };

        Ok(progress)
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

    #[frb(sync)]
    pub fn pages(&self) -> Pages {
        Pages::new(Arc::clone(&self.file))
    }

    #[frb(sync)]
    pub fn filepath(&self) -> anyhow::Result<String> {
        let file = self
            .file
            .lock()
            .map_err(|e| anyhow::anyhow!(e.to_string()))?;

        let filepath = file.path.to_string_lossy().to_string();

        Ok(filepath)
    }

    #[frb(sync)]
    pub fn delete(&self) -> anyhow::Result<()> {
        let file = self
            .file
            .lock()
            .map_err(|e| anyhow::anyhow!(e.to_string()))?;

        file.delete()
    }
}
