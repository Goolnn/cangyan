use cyfile::ExportArguments;
use cyfile::File;
use cyfile::Page;
use cyfile::Project;
use flutter_rust_bridge::frb;
use std::path::Path;
use std::path::PathBuf;

#[frb(opaque)]
pub struct CreateState {
    workspace: PathBuf,
}

impl CreateState {
    #[frb(sync)]
    pub fn create(&self, title: String, images: Vec<Vec<u8>>) -> anyhow::Result<()> {
        let mut path = self.workspace.clone();

        path.push(format!("{}.cy", title));

        if path.exists() {
            anyhow::bail!("title name already exists");
        }

        let project = Project::new()
            .with_title(title)
            .with_pages(images.into_iter().map(Page::new).collect());

        File::export(&project, ExportArguments::new(path).with_version((0, 1)))
    }
}

impl<P> From<P> for CreateState
where
    P: AsRef<Path>,
{
    fn from(value: P) -> Self {
        CreateState {
            workspace: value.as_ref().to_path_buf(),
        }
    }
}
