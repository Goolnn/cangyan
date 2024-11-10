use flutter_rust_bridge::frb;

#[frb(non_opaque)]
#[derive(Clone)]
pub struct Text {
    pub content: String,
    pub comment: String,
}

impl From<&cyfile::Text> for Text {
    fn from(value: &cyfile::Text) -> Self {
        Text {
            content: value.content().to_string(),
            comment: value.comment().to_string(),
        }
    }
}

impl From<&Text> for cyfile::Text {
    fn from(value: &Text) -> Self {
        cyfile::Text::new()
            .with_content(value.content.clone())
            .with_comment(value.comment.clone())
    }
}
