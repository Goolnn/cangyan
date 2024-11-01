use crate::api::cyfile::Text;
use flutter_rust_bridge::frb;

#[frb(non_opaque)]
pub struct Note {
    pub x: f64,
    pub y: f64,

    pub choice: u32,

    pub texts: Vec<Text>,
}

impl From<&cyfile::Note> for Note {
    fn from(value: &cyfile::Note) -> Self {
        Self {
            x: value.x(),
            y: value.y(),

            choice: value.choice(),

            texts: value.texts().iter().map(|text| text.into()).collect(),
        }
    }
}
