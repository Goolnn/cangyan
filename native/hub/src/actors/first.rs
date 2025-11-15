use crate::signals::BigBool;
use crate::signals::SmallNumber;
use crate::signals::SmallText;
use async_trait::async_trait;
use messages::prelude::Actor;
use messages::prelude::Address;
use messages::prelude::Context;
use messages::prelude::Handler;
use messages::prelude::Notifiable;
use rinf::DartSignal;
use rinf::RustSignal;
use rinf::debug_print;
use std::time::Duration;
use tokio::task::JoinSet;
use tokio::time::interval;

pub struct FirstActor {
    _owned_tasks: JoinSet<()>,
}

impl Actor for FirstActor {}

impl FirstActor {
    pub fn new(self_addr: Address<Self>) -> Self {
        let mut _owned_tasks = JoinSet::new();

        _owned_tasks.spawn(Self::listen_to_dart(self_addr.clone()));
        _owned_tasks.spawn(Self::listen_to_timer(self_addr));

        FirstActor { _owned_tasks }
    }
}

#[async_trait]
impl Notifiable<SmallText> for FirstActor {
    async fn notify(&mut self, msg: SmallText, _: &Context<Self>) {
        debug_print!("{}", msg.text);

        SmallNumber { number: 7 }.send_signal_to_dart();
    }
}

#[async_trait]
impl Handler<BigBool> for FirstActor {
    type Result = bool;

    async fn handle(&mut self, msg: BigBool, _: &Context<Self>) -> bool {
        msg.send_signal_to_dart();

        false
    }
}

impl FirstActor {
    async fn listen_to_dart(mut self_addr: Address<Self>) {
        let receiver = SmallText::get_dart_signal_receiver();

        while let Some(signal_pack) = receiver.recv().await {
            let _ = self_addr.notify(signal_pack.message).await;
        }
    }

    async fn listen_to_timer(mut self_addr: Address<Self>) {
        let mut time_interval = interval(Duration::from_secs(3));

        let text = "From an owned task".to_owned();

        loop {
            time_interval.tick().await;
            let _ = self_addr.notify(SmallText { text: text.clone() }).await;
        }
    }
}
