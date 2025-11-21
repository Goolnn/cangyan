use crate::workspace::Workspace;
use messages::prelude::Address;
use messages::prelude::Context;
use messages::prelude::Notifiable;
use rinf::DartSignal;
use rinf::RustSignal;
use rinf::SignalPiece;
use serde::Deserialize;
use serde::Serialize;

#[derive(Deserialize, DartSignal)]
pub enum Open {
    Pages { path: String },
    Notes { path: String, index: u32 },
}

#[async_trait::async_trait]
impl Notifiable<Open> for Workspace {
    async fn notify(&mut self, msg: Open, _: &Context<Self>) {
        match msg {
            Open::Pages { path } => {
                if let Some(pages) = self
                    .projects
                    .get(&path)
                    .map(|project| project.pages().iter().map(Page::from).collect())
                {
                    Pages(pages).send_signal_to_dart();
                }
            }

            Open::Notes { path, index } => {
                if let Some(project) = self.projects.get(&path)
                    && let Some(notes) = project
                        .pages()
                        .get(index as usize)
                        .map(|page| page.notes().iter().map(Note::from).collect())
                {
                    Notes(notes).send_signal_to_dart();
                }
            }
        }
    }
}

pub async fn open_task(mut addr: Address<Workspace>) {
    let receiver = Open::get_dart_signal_receiver();

    while let Some(pack) = receiver.recv().await {
        let message = pack.message;

        let _ = addr.notify(message).await;
    }
}

#[derive(Serialize, RustSignal)]
pub struct Pages(pub Vec<Page>);

#[derive(Serialize, SignalPiece)]
pub struct Page {
    pub data: Vec<u8>,

    pub note_count: u32,
}

impl From<&cyfile::Page> for Page {
    fn from(value: &cyfile::Page) -> Self {
        Self {
            data: value.data().to_vec(),

            note_count: value.notes().len() as u32,
        }
    }
}

#[derive(Serialize, RustSignal)]
pub struct Notes(pub Vec<Note>);

#[derive(Serialize, SignalPiece)]
pub struct Note {
    x: f64,
    y: f64,

    texts: Vec<Text>,
}

#[derive(Serialize, SignalPiece)]
pub struct Text {
    content: String,
    comment: String,
}

impl From<&cyfile::Note> for Note {
    fn from(value: &cyfile::Note) -> Self {
        Note {
            x: value.x(),
            y: value.y(),

            texts: value.texts().iter().map(Text::from).collect(),
        }
    }
}

impl From<&cyfile::Text> for Text {
    fn from(value: &cyfile::Text) -> Self {
        Self {
            content: value.content().to_string(),
            comment: value.comment().to_string(),
        }
    }
}
