use cangyan::api::config::Config;

fn main() -> anyhow::Result<()> {
    let config = Config::empty();

    println!("{}", config.to_string()?);

    Ok(())
}
