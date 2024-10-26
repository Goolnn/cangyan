pub use cyfile::File;

use crate::frb_generated::RustAutoOpaque;
use flutter_rust_bridge::frb;
use std::sync::Arc;

#[frb(opaque)]
pub struct InfoState {
    file: RustAutoOpaque<Arc<File>>,
}

impl InfoState {
    #[frb(sync)]
    pub fn new(file: RustAutoOpaque<Arc<File>>) -> Self {
        InfoState { file }
    }

    #[frb(sync)]
    pub fn cover(&self) -> Option<Vec<u8>> {
        None
    }

    #[frb(sync)]
    pub fn page_count(&self) -> u32 {
        self.file.blocking_read().project().pages().len() as u32
    }

    #[frb(sync)]
    pub fn category(&self) -> String {
        String::new()
    }

    #[frb(sync)]
    pub fn title(&self) -> String {
        self.file.blocking_read().project().title().to_string()
    }

    #[frb(sync)]
    pub fn number(&self) -> (u32, u32) {
        (0, 0)
    }

    #[frb(sync)]
    pub fn created_date(&self) -> (u16, u8, u8, u8, u8, u8) {
        let date = self.file.blocking_read().project().created_date();

        (
            date.year(),
            date.month(),
            date.day(),
            date.hour(),
            date.minute(),
            date.second(),
        )
    }

    #[frb(sync)]
    pub fn saved_date(&self) -> (u16, u8, u8, u8, u8, u8) {
        let date = self.file.blocking_read().project().saved_date();

        (
            date.year(),
            date.month(),
            date.day(),
            date.hour(),
            date.minute(),
            date.second(),
        )
    }

    #[frb(sync)]
    pub fn pages(&self) -> Vec<Vec<u8>> {
        self.file
            .blocking_read()
            .project()
            .pages()
            .iter()
            .map(|page| page.data().to_owned())
            .collect()
    }
}
