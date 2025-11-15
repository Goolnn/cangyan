use rinf::DartSignal;
use rinf::RustSignal;
use rinf::SignalPiece;
use serde::Deserialize;
use serde::Serialize;

#[derive(Deserialize, DartSignal)]
pub struct SmallText {
    pub text: String,
}

#[derive(Serialize, RustSignal)]
pub struct SmallNumber {
    pub number: i32,
}

#[derive(Serialize, RustSignal)]
pub struct BigBool {
    pub member: bool,
    pub nested: SmallBool,
}

#[derive(Serialize, SignalPiece)]
pub struct SmallBool(pub bool);
