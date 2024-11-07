use crate::api::file::Date;
use crate::api::file::Page;
use cyfile::Credit;
use flutter_rust_bridge::frb;
use std::collections::HashMap;
use std::collections::HashSet;

#[frb(non_opaque)]
pub struct Project {
    pub cover: Vec<u8>,

    pub category: String,
    pub title: String,

    pub number: (u32, u32),

    pub comment: String,

    pub created_date: Date,
    pub updated_date: Date,

    pub credits: HashMap<Credit, HashSet<String>>,

    pub pages: Vec<Page>,
}

impl Project {}

impl From<&cyfile::Project> for Project {
    fn from(value: &cyfile::Project) -> Self {
        Self {
            cover: value.cover().to_owned(),

            category: value.category().to_string(),
            title: value.title().to_string(),

            number: value.number(),

            comment: value.comment().to_string(),

            created_date: Date::from(&value.created_date()),
            updated_date: Date::from(&value.updated_data()),

            credits: value.credits().to_owned(),

            pages: value.pages().iter().map(|page| Page::from(page)).collect(),
        }
    }
}

impl From<&Project> for cyfile::Project {
    fn from(value: &Project) -> Self {
        Self::new()
            .with_cover(value.cover.to_owned())
            .with_category(value.category.to_string())
            .with_title(value.title.to_string())
            .with_number(value.number)
            .with_comment(value.comment.to_string())
            .with_credits(value.credits.to_owned())
            .with_pages(
                value
                    .pages
                    .iter()
                    .map(|page| cyfile::Page::from(page))
                    .collect(),
            )
    }
}
