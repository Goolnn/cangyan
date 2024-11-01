use flutter_rust_bridge::frb;

#[frb(non_opaque)]
pub struct Text {
    pub content: String,
    pub comment: String,
}

impl From<cyfile::Text> for Text {
    fn from(text: cyfile::Text) -> Self {
        Text {
            content: text.content().to_string(),
            comment: text.comment().to_string(),
        }
    }
}
