use crate::signals::Arguments;
use async_trait::async_trait;
use messages::actor::Actor;
use messages::prelude::Context;
use messages::prelude::Notifiable;
use rinf::RustSignal;
use std::collections::HashSet;
use std::path::PathBuf;

#[derive(Debug, Default)]
pub struct Workspace {
    files: HashSet<PathBuf>,
}

impl Actor for Workspace {}

#[async_trait]
impl Notifiable<Vec<String>> for Workspace {
    async fn notify(&mut self, args: Vec<String>, _: &Context<Self>) {
        Arguments(args.clone()).send_signal_to_dart();

        let paths = args.iter().filter_map(|arg| {
            let path = PathBuf::from(arg.trim());

            if path.exists()
                && path.is_file()
                && path.is_absolute()
                && path.extension().is_some_and(|ext| ext == "cy")
            {
                Some(path)
            } else {
                None
            }
        });

        self.files.extend(paths);
    }
}
