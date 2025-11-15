mod first;
mod second;

use first::FirstActor;
use messages::prelude::Context;
use second::SecondActor;
use tokio::spawn;

pub async fn create_actors() {
    let first_context = Context::new();
    let first_addr = first_context.address();
    let second_context = Context::new();

    let first_actor = FirstActor::new(first_addr.clone());
    spawn(first_context.run(first_actor));

    let second_actor = SecondActor::new(first_addr);
    spawn(second_context.run(second_actor));
}
