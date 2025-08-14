use async_trait::async_trait;
use messages::actor::Actor;
use messages::prelude::Context;
use messages::prelude::Notifiable;
use rinf::debug_print;
use std::collections::HashSet;
use std::path::Path;
use std::path::PathBuf;

#[derive(Debug)]
pub struct Workspace {
    files: HashSet<PathBuf>,
}

pub enum Watch {
    Create(Vec<PathBuf>),
    Remove(Vec<PathBuf>),
}

impl Workspace {
    pub fn new() -> Self {
        let path = Path::new("C:\\Users\\Goolnn\\Documents\\cangyan");

        let files = std::fs::read_dir(path)
            .map(|dir| {
                dir.filter_map(|entry| {
                    entry.ok().and_then(|entry| {
                        let path = entry.path();

                        if path.is_file()
                            && path.is_absolute()
                            && path.extension().is_some_and(|ext| ext == "cy")
                        {
                            Some(path)
                        } else {
                            None
                        }
                    })
                })
            })
            .map_or_else(|_| HashSet::new(), |paths| paths.collect());

        debug_print!("{:?}", files);

        Self { files }
    }
}

impl Actor for Workspace {}

#[async_trait]
impl Notifiable<Vec<String>> for Workspace {
    async fn notify(&mut self, args: Vec<String>, _: &Context<Self>) {
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

        debug_print!("{:?}", self.files);
    }
}

#[async_trait]
impl Notifiable<Watch> for Workspace {
    async fn notify(&mut self, msg: Watch, _: &Context<Self>) {
        match msg {
            Watch::Create(paths) => {
                self.files.extend(paths.into_iter().filter_map(|path| {
                    if path.exists()
                        && path.is_file()
                        && path.is_absolute()
                        && path.extension().is_some_and(|ext| ext == "cy")
                    {
                        Some(path)
                    } else {
                        None
                    }
                }));
            }

            Watch::Remove(paths) => {
                self.files.retain(|path| !paths.contains(path));
            }
        }

        debug_print!("{:?}", self.files);
    }
}
