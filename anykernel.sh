# AnyKernel3 Ramdisk Mod Script
# osm0sis @ xda-developers

## AnyKernel setup
# begin properties
properties() { '
kernel.string=KCUFKernel-V1
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

# Read value by user selected from aroma prop files
wiredbtn_altmode=$(aroma_get_value wiredbtn_altmode)
fake_selenforce=$(aroma_get_value fake_selenforce)

# alternate weired button mode
if [ "$wiredbtn_altmode" == "2" ]; then
    patch_cmdline "androidboot.wiredbtnaltmode" "androidboot.wiredbtnaltmode=1"
else
    patch_cmdline "androidboot.wiredbtnaltmode" ""
fi

# fake enforcing mode
if [ "$fake_selenforce" == "1" ]; then
    patch_cmdline "androidboot.fakeselenforce" "androidboot.fakeselenforce=1"
else
    patch_cmdline "androidboot.fakeselenforce" ""
fi

flash_boot;
## end boot install
