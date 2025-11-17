use rinf::RustSignal;
use rinf::SignalPiece;
use serde::Serialize;
use std::collections::HashMap;

#[derive(Serialize, RustSignal)]
pub struct Overviews(pub HashMap<String, Overview>);

#[derive(Serialize, SignalPiece)]
pub struct Overview {
    cover: Vec<u8>,

    title: String,

    comment: String,

    created_date: Date,
    updated_date: Date,

    page_count: u32,
}

#[derive(Serialize, SignalPiece)]
pub struct Date {
    year: u16,
    month: u8,
    day: u8,

    hour: u8,
    minute: u8,
    second: u8,
}

impl From<&HashMap<String, cyfile::Project>> for Overviews {
    fn from(value: &HashMap<String, cyfile::Project>) -> Self {
        Self(
            value
                .iter()
                .map(|(key, project)| (key.clone(), Overview::from(project)))
                .collect(),
        )
    }
}

impl From<&cyfile::Project> for Overview {
    fn from(value: &cyfile::Project) -> Self {
        Self {
            cover: value.cover().to_vec(),

            title: value.title().to_string(),

            comment: value.comment().to_string(),

            created_date: value.created_date().into(),
            updated_date: value.updated_date().into(),

            page_count: value.pages().len() as u32,
        }
    }
}

impl From<cyfile::Date> for Date {
    fn from(value: cyfile::Date) -> Self {
        Self {
            year: value.year(),
            month: value.month(),
            day: value.day(),

            hour: value.hour(),
            minute: value.minute(),
            second: value.second(),
        }
    }
}
