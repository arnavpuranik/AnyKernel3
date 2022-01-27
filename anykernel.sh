# AnyKernel3 Ramdisk Mod Script
# osm0sis @ xda-developers

## AnyKernel setup
# begin properties
properties() { '
kernel.string=neXus Kernel by Arnav
do.devicecheck=1
do.modules=0
do.systemless=1
do.cleanup=1
do.cleanuponabort=0
device.name1=whyred
device.name2=
device.name3=
device.name4=
device.name5=
supported.versions=
supported.patchlevels=
'; } # end properties

# shell variables
block=/dev/block/bootdevice/by-name/boot;
is_slot_device=0;
ramdisk_compression=auto;

## AnyKernel methods (DO NOT CHANGE)
# import patching functions/variables - see for reference
. tools/ak3-core.sh;

aroma_get_value() {
  [ -f /tmp/aroma/${1}.prop ] && cat /tmp/aroma/${1}.prop | head -n1 | cut -d'=' -f2 || echo ""
}

## AnyKernel boot install
split_boot;

# extract Image and dtb
xz -d ${home}/Image.xz || abort

# Read value by user selected from aroma prop files
cpu_overclock=$(aroma_get_value cpu_overclock)
wiredbtn_altmode=$(aroma_get_value wiredbtn_altmode)
fake_selenforce=$(aroma_get_value fake_selenforce)
newcam_blobs=$(aroma_get_value newcam_blobs)
qti_haptics=$(aroma_get_value qti_haptics)

# qti haptics
if [ "$qti_haptics" == "2" ]; then
    ui_print "Selecting QTI Haptics"
    xz -dc ${home}/kernel_dtbqti.xz > ${home}/kernel_dtb || abort
else
    ui_print "Selecting Non-QTI Haptics"
    xz -dc ${home}/kernel_dtb.xz > ${home}/kernel_dtb || abort
fi

# cpu overclock
if [ "$cpu_overclock" == "2" ]; then
    ui_print "Selecting OC Freqs"
    patch_cmdline "androidboot.cpuoverclock" "androidboot.cpuoverclock=1"
else
    ui_print "Selecting Non-OC Freqs"
    patch_cmdline "androidboot.cpuoverclock" ""
fi

# alternate wired button mode
if [ "$wiredbtn_altmode" == "2" ]; then
    ui_print "Selecting Alternate Wired Headphones Buttons"
    patch_cmdline "androidboot.wiredbtnaltmode" "androidboot.wiredbtnaltmode=1"
else
    ui_print "Selecting Normal Wired Headphones Buttons"
    patch_cmdline "androidboot.wiredbtnaltmode" ""
fi

# fake enforcing mode
if [ "$fake_selenforce" == "1" ]; then
    ui_print "Selecting Fake Enforcing Mode"
    patch_cmdline "androidboot.fakeselenforce" "androidboot.fakeselenforce=1"
else
    ui_print "Selecting No-Fake Enforcing Mode"
    patch_cmdline "androidboot.fakeselenforce" ""
fi

# new camera blobs
if [ "$newcam_blobs" == "2" ]; then
    ui_print "Selecting New Camera Blobs"
    $bin/bspatch ${home}/Image ${home}/Image ${home}/bspatch/newcam.patch || abort
fi

flash_boot;
## end boot install
