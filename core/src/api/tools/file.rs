use crate::api::cyfile::Project;
use cyfile::ExportArguments;
use flutter_rust_bridge::frb;
use std::path::PathBuf;

#[frb(non_opaque)]
pub struct File {
    #[frb(non_final)]
    pub project: Project,
    #[frb(ignore)]
    pub path: PathBuf,
}

impl File {
    #[frb(sync)]
    pub fn rename(&mut self, title: String) -> anyhow::Result<()> {
        let file_name = format!("{}.cy", title);

        let source = self.path.clone();
        let target = self.path.with_file_name(file_name.clone());

        std::fs::rename(source, target)?;

        self.path.set_file_name(file_name);

        self.project.title = title;

        Ok(())
    }

    #[frb(ignore)]
    pub fn save(&self) -> anyhow::Result<()> {
        cyfile::File::export(
            &cyfile::Project::from(&self.project),
            ExportArguments::new(&self.path).with_version((0, 1)),
        )?;

        Ok(())
    }
}
