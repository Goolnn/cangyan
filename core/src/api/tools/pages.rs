use crate::api::tools::Editor;
use crate::api::tools::File;
use cyfile::Page;
use flutter_rust_bridge::frb;
use std::sync::Arc;
use std::sync::Mutex;

pub struct Pages {
    file: Arc<Mutex<File>>,
}

impl Pages {
    #[frb(sync)]
    pub fn new(file: Arc<Mutex<File>>) -> Self {
        Pages { file }
    }

    #[frb(sync)]
    pub fn insert_page_before(&self, index: usize, image: Vec<u8>) -> anyhow::Result<()> {
        let mut file = self
            .file
            .lock()
            .map_err(|e| anyhow::anyhow!(e.to_string()))?;

        file.project.pages_mut().insert(index, Page::new(image));

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

        file.project.pages_mut().remove(index);

        file.save()?;

        Ok(())
    }

    #[frb(sync)]
    pub fn move_page_to(&self, from: usize, to: usize) -> anyhow::Result<()> {
        let mut file = self
            .file
            .lock()
            .map_err(|e| anyhow::anyhow!(e.to_string()))?;

        let page = file.project.pages_mut().remove(from);

        file.project.pages_mut().insert(to, page);

        file.save()?;

        Ok(())
    }

    #[frb(sync)]
    pub fn images(&self) -> anyhow::Result<Vec<Vec<u8>>> {
        let file = self
            .file
            .lock()
            .map_err(|e| anyhow::anyhow!(e.to_string()))?;

        Ok(file
            .project
            .pages()
            .iter()
            .map(|page| page.data().to_vec())
            .collect())
    }

    #[frb(sync)]
    pub fn edit(&self, index: usize) -> Editor {
        Editor::new(Arc::clone(&self.file), index)
    }
}
