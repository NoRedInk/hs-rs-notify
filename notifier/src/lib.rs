extern crate notify;
use std::ffi::CStr;
use std::os::raw::c_char;
use notify::{watcher, RecursiveMode, Watcher};
use std::sync::mpsc::channel;
use std::time::Duration;
use std::os::raw::c_int;
#[no_mangle]
pub extern "C" fn watch_for_changes(path_ptr: *const c_char, cb: extern "C" fn() -> c_int) {
    unsafe {
        let (tx, rx) = channel();
        let mut watcher = watcher(tx, Duration::from_secs(1)).unwrap();
        let path = CStr::from_ptr(path_ptr).to_str().expect("Invalid path");
        watcher.watch(path, RecursiveMode::Recursive).unwrap();

        loop {
            match rx.recv() {
                Ok(_) => {
                    cb();
                }
                Err(e) => println!("watch error: {:?}", e),
            };
        }
    }
}
