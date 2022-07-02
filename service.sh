MODPATH=${0%/*}
API=`getprop ro.build.version.sdk`
AML=/data/adb/modules/aml

# debug
exec 2>$MODPATH/debug.log
set -x

# property
resetprop ro.build.product P855A01
resetprop ro.product.model "ZTE A2020G Pro"
resetprop ro.dts.licensepath /vendor/etc/dts/
resetprop ro.dts.cfgpath /vendor/etc/dts/
resetprop ro.vendor.dts.licensepath /vendor/etc/dts/
resetprop ro.vendor.dts.cfgpath /vendor/etc/dts/
resetprop ro.feature.zte_feature_dts_ultra_enable true
resetprop ro.feature.zte_dts_tuning_path P855A02_P
resetprop ro.product.lge.globaleffect.dts false
resetprop ro.lge.globaleffect.dts false
resetprop ro.odm.config.dts_licensepath /vendor/etc/dts/
resetprop vendor.dts.audio.allow_offload true
#resetprop vendor.dts.audio.log_time true
#resetprop vendor.dts.audio.dump_input true
#resetprop vendor.dts.audio.disable_undoredo true
#resetprop vendor.dts.audio.print_eagle true
#resetprop vendor.dts.audio.dump_output true
#resetprop vendor.dts.audio.dump_eagle true
#resetprop vendor.dts.audio.dump_initial true
#resetprop vendor.dts.audio.set_bypass true
#resetprop vendor.dts.audio.dump_driver true

# wait
sleep 20

# aml fix
DIR=$AML/system/vendor/odm/etc
if [ -d $DIR ] && [ ! -f $AML/disable ]; then
  chcon -R u:object_r:vendor_configs_file:s0 $DIR
fi

# mount
NAME="*audio*effects*.conf -o -name *audio*effects*.xml"
#pNAME="*audio*effects*.conf -o -name *audio*effects*.xml -o -name *policy*.conf -o -name *policy*.xml"
if [ ! -d $AML ] || [ -f $AML/disable ]; then
  DIR=$MODPATH/system/vendor
else
  DIR=$AML/system/vendor
fi
FILE=`find $DIR/etc -maxdepth 1 -type f -name $NAME`
if [ `realpath /odm/etc` == /odm/etc ] && [ "$FILE" ]; then
  for i in $FILE; do
    j="/odm$(echo $i | sed "s|$DIR||")"
    if [ -f $j ]; then
      umount $j
      mount -o bind $i $j
    fi
  done
fi
if [ -d /my_product/etc ] && [ "$FILE" ]; then
  for i in $FILE; do
    j="/my_product$(echo $i | sed "s|$DIR||")"
    if [ -f $j ]; then
      umount $j
      mount -o bind $i $j
    fi
  done
fi

# restart
killall audioserver

# wait
sleep 40

# allow
PKG=com.dts.dtsxultra
if [ "$API" -ge 30 ]; then
  appops set $PKG AUTO_REVOKE_PERMISSIONS_IF_UNUSED ignore
fi


