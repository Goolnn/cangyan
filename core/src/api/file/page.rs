use crate::api::file::Note;
use flutter_rust_bridge::frb;

#[frb(non_opaque)]
pub struct Page {
    pub data: Vec<u8>,

    pub notes: Vec<Note>,
}

impl From<&cyfile::Page> for Page {
    fn from(value: &cyfile::Page) -> Self {
        let data = value.data().to_owned();
        let notes = value.notes().iter().map(|note| note.into()).collect();

        Page { data, notes }
    }
}

impl From<&Page> for cyfile::Page {
    fn from(value: &Page) -> Self {
        let notes = value.notes.iter().map(|note| note.into()).collect();

        let mut page = cyfile::Page::new(value.data.clone());

        *page.notes_mut() = notes;

        page
    }
}
