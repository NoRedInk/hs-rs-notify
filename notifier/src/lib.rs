extern crate notify;

use notify::{watcher, RecursiveMode, Watcher};
use std::sync::mpsc::channel;
use std::time::Duration;
use std::os::raw::c_int;
#[no_mangle]
pub extern "C" fn watch_for_changes(cb: extern "C" fn() -> c_int) {
    // Create a channel to receive the events.
    let (tx, rx) = channel();

    // Create a watcher object, delivering debounced events.
    // The notification back-end is selected based on the platform.
    let mut watcher = watcher(tx, Duration::from_secs(10)).unwrap();

    // Add a path to be watched. All files and directories at that path and
    // below will be monitored for changes.
    watcher
        .watch("/Users/stoeffel/nri/", RecursiveMode::Recursive)
        .unwrap();

    loop {
        match rx.recv() {
            Ok(_) => {
                cb();
            }
            Err(e) => println!("watch error: {:?}", e),
        };
    }
}
