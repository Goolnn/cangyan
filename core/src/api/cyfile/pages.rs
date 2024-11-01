use cyfile::File;
use flutter_rust_bridge::frb;
use std::sync::Arc;
use std::sync::Mutex;

#[frb(opaque)]
pub struct Pages {
    file: Arc<Mutex<File>>,
}

impl Pages {
    #[frb(ignore)]
    pub fn new(file: Arc<Mutex<File>>) -> Self {
        Pages { file }
    }

    pub fn images(&self) -> anyhow::Result<Vec<Vec<u8>>> {
        let file = self
            .file
            .lock()
            .map_err(|e| anyhow::anyhow!(e.to_string()))?;

        let project = file.project();
        let pages = project.pages();

        let mut images = Vec::new();

        for page in pages {
            images.push(page.data().to_owned());
        }

        Ok(images)
    }
}
