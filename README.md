# Amiga IDE Boot Rom

ROM based scsi.device to allow autoboot from IDE on Kickstart 1.3.

To create the ROM image you will need a scsi.device version 43.45 and the patch provided here.

Apply the patch to create the ROM image:
    `gpatch scsi.device scsi.device_43.45(A1200).gpatch boot.rom RECURSIVE`

The patch also includes the Kickstart 1.3 patch from http://aminet.net/package/util/boot/kick13scsipatch.
The ROM vector should be set to $80 but that can be easily changed, see bootrom_header.asm.


http://aminet.net/package/util/misc/gpatch
http://aminet.net/package/driver/media/SCSI4345p

