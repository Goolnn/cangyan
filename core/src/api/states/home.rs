use flutter_rust_bridge::frb;

pub struct HomeState {}

impl HomeState {
    #[frb(sync)]
    pub fn new() -> Self {
        HomeState {}
    }
}
