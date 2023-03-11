# qemu-device-sample

This project consist of two parts: the device and driver.

## Device emulation
The device ctcddev is emulated in qemu with version 5.0.0,
and the source file is `hw/misc/ctcdev.c`

use `-device ctc` command line arguments to add a ctcdev to guest


## Device Driver
the source files of driver is put in `linux-driver`

you can copy the linux-drivers to guest and comiple the source codes
in guest.

* make 
* insmode testdev-drv.ko
