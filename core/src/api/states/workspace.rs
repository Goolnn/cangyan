use flutter_rust_bridge::frb;
use std::path::PathBuf;

#[frb(opaque)]
pub struct Workspace {
    path: PathBuf,
}

impl Workspace {
    #[frb(sync)]
    pub fn new(path: String) -> Self {
        let path = PathBuf::from(path);

        Workspace { path }
    }
}
