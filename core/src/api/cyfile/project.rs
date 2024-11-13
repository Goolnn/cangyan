use crate::api::cyfile::Date;
use crate::api::cyfile::Page;
use cyfile::Credit;
use flutter_rust_bridge::frb;
use std::collections::HashMap;
use std::collections::HashSet;

#[frb]
pub struct Project {
    #[frb(non_final)]
    pub cover: Vec<u8>,

    #[frb(non_final)]
    pub category: String,
    #[frb(non_final)]
    pub title: String,

    #[frb(non_final)]
    pub number: (u32, u32),

    #[frb(non_final)]
    pub comment: String,

    #[frb(non_final)]
    pub created_date: Date,
    #[frb(non_final)]
    pub updated_date: Date,

    #[frb(non_final)]
    pub credits: HashMap<Credit, HashSet<String>>,

    #[frb(non_final)]
    pub pages: Vec<Page>,
}

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

            pages: value.pages().iter().map(Page::from).collect(),
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
            .with_pages(value.pages.iter().map(cyfile::Page::from).collect())
    }
}
