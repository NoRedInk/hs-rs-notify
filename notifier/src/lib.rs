extern crate notify;

use notify::{watcher, RecursiveMode, Watcher};
use std::sync::mpsc::channel;
use std::time::Duration;

#[no_mangle]
pub extern "C" fn print_string(cb: extern "C" fn() -> ()) {
    println!("hello from rust");

    // Create a channel to receive the events.
    let (tx, rx) = channel();

    // Create a watcher object, delivering debounced events.
    // The notification back-end is selected based on the platform.
    let mut watcher = watcher(tx, Duration::from_secs(10)).unwrap();

    // Add a path to be watched. All files and directories at that path and
    // below will be monitored for changes.
    watcher
        .watch("/Users/jasper/Desktop", RecursiveMode::Recursive)
        .unwrap();

    match rx.recv() {
        Ok(_event) => cb(),
        Err(e) => println!("watch error: {:?}", e),
    };
}
