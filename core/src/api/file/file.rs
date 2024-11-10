use crate::api::file::Project;
use cyfile::ExportArguments;
use flutter_rust_bridge::frb;
use std::path::Path;
use std::path::PathBuf;

#[frb(ignore)]
pub struct File {
    pub project: Project,
    pub path: PathBuf,
}

impl File {
    pub fn open(path: impl AsRef<Path>) -> anyhow::Result<Self> {
        let mut project = Project::from(&cyfile::File::open(path.as_ref())?);
        let path = path.as_ref().to_path_buf();

        if project.title.is_empty() {
            let file_name = path.file_stem();

            if let Some(title) = file_name {
                project.title = title.to_string_lossy().to_string();
            }
        }

        Ok(Self { project, path })
    }

    pub fn create(path: impl AsRef<Path>, project: Project) -> anyhow::Result<Self> {
        cyfile::File::export(
            &cyfile::Project::from(&project),
            ExportArguments::new(path.as_ref()).with_version((0, 1)),
        )?;

        let path = path.as_ref().to_path_buf();

        Ok(Self { project, path })
    }
}
