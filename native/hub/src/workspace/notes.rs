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
pub struct Edit {
    pub path: String,

    pub index: u32,
}

pub async fn edit_task(mut addr: Address<Workspace>) {
    let receiver = Edit::get_dart_signal_receiver();

    while let Some(pack) = receiver.recv().await {
        let message = pack.message;

        let _ = addr.notify(message).await;
    }
}

#[async_trait::async_trait]
impl Notifiable<Edit> for Workspace {
    async fn notify(&mut self, msg: Edit, _: &Context<Self>) {
        let path = msg.path;
        let index = msg.index as usize;

        if let Some(project) = self.projects.get(&path)
            && let Some(page) = project.pages().get(index)
        {
            Notes(page.notes().iter().map(Note::from).collect()).send_signal_to_dart();
        }
    }
}

#[derive(Serialize, RustSignal)]
pub struct Notes(Vec<Note>);

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
