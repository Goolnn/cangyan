pub use cyfile::Credit;

use flutter_rust_bridge::frb;

#[frb(mirror(Credit))]
pub enum _Credit {
    Artists,
    Translators,
    Proofreaders,
    Retouchers,
    Typesetters,
    Supervisors,
}
