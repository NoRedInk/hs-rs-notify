use std::os::raw::c_int;
#[no_mangle]
pub extern "C" fn print_string(cb: extern "C" fn() -> c_int) {
    println!("hello from rust");
    cb();
}
