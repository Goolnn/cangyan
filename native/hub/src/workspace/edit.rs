use crate::workspace::Workspace;
use crate::workspace::open::Note;
use crate::workspace::open::Notes;
use messages::prelude::Address;
use messages::prelude::Context;
use messages::prelude::Notifiable;
use rinf::DartSignal;
use rinf::RustSignal;
use rinf::SignalPiece;
use serde::Deserialize;

#[derive(Deserialize, DartSignal)]
pub enum Edit {
    Project {
        path: String,

        edit: ProjectEdit,
    },

    Note {
        path: String,

        page_index: u32,
        note_index: u32,

        edit: NoteEdit,
    },
}

#[derive(Deserialize, SignalPiece)]
pub enum ProjectEdit {
    Save,
}

#[derive(Deserialize, SignalPiece)]
pub enum NoteEdit {
    Move { x: f64, y: f64 },
}

#[async_trait::async_trait]
impl Notifiable<Edit> for Workspace {
    async fn notify(&mut self, msg: Edit, _: &Context<Self>) {
        match msg {
            Edit::Project { path, edit } => {
                if let Some(project) = self.projects.get_mut(&path) {
                    match edit {
                        ProjectEdit::Save => {
                            let _ = cyfile::File::export(
                                project,
                                cyfile::ExportArguments::new(&path).with_version((0, 1)),
                            );
                        }
                    }
                }
            }

            Edit::Note {
                path,

                page_index,
                note_index,

                edit,
            } => {
                if let Some(project) = self.projects.get_mut(&path)
                    && let Some(page) = project.pages_mut().get_mut(page_index as usize)
                    && let Some(note) = page.notes_mut().get_mut(note_index as usize)
                {
                    match edit {
                        NoteEdit::Move { x, y } => {
                            note.set_x(x);
                            note.set_y(y);
                        }
                    }
                }

                if let Some(project) = self.projects.get(&path)
                    && let Some(notes) = project
                        .pages()
                        .get(page_index as usize)
                        .map(|page| page.notes().iter().map(Note::from).collect())
                {
                    Notes(notes).send_signal_to_dart();
                }
            }
        }
    }
}

pub async fn edit_task(mut addr: Address<Workspace>) {
    let receiver = Edit::get_dart_signal_receiver();

    while let Some(pack) = receiver.recv().await {
        let message = pack.message;

        let _ = addr.notify(message).await;
    }
}
