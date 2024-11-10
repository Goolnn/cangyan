use crate::api::cyfile::Text;
use flutter_rust_bridge::frb;

#[frb(non_opaque)]
#[derive(Clone)]
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

impl From<&Note> for cyfile::Note {
    fn from(value: &Note) -> Self {
        let texts = value.texts.iter().map(|text| text.into()).collect();

        let mut note = cyfile::Note::new()
            .with_coordinate(value.x, value.y)
            .with_choice(value.choice);

        *note.texts_mut() = texts;

        note
    }
}
