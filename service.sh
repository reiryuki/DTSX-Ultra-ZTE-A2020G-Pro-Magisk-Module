MODPATH=${0%/*}

# log
LOGFILE=$MODPATH/debug.log
exec 2>$LOGFILE
set -x

# var
API=`getprop ro.build.version.sdk`

# property
resetprop -n ro.audio.ignore_effects false
resetprop -n ro.build.product P855A01
resetprop -n ro.product.model "ZTE A2020G Pro"
resetprop -n ro.dts.licensepath /vendor/etc/dts/
resetprop -n ro.dts.cfgpath /vendor/etc/dts/
resetprop -n ro.vendor.dts.licensepath /vendor/etc/dts/
resetprop -n ro.vendor.dts.cfgpath /vendor/etc/dts/
resetprop -n ro.feature.zte_feature_dts_ultra_enable true
resetprop -n ro.feature.zte_dts_tuning_path P855A02_P
resetprop -n ro.product.lge.globaleffect.dts false
resetprop -n ro.lge.globaleffect.dts false
resetprop -n ro.odm.config.dts_licensepath /vendor/etc/dts/
resetprop -n vendor.dts.audio.allow_offload true
#resetprop -n vendor.dts.audio.log_time false
#resetprop -n vendor.dts.audio.dump_input false
#resetprop -n vendor.dts.audio.disable_undoredo false
#resetprop -n vendor.dts.audio.print_eagle false
#resetprop -n vendor.dts.audio.dump_output false
#resetprop -n vendor.dts.audio.dump_eagle false
#resetprop -n vendor.dts.audio.dump_initial false
#resetprop -n vendor.dts.audio.set_bypass false
#resetprop -n vendor.dts.audio.dump_driver false

# restart
if [ "$API" -ge 24 ]; then
  SERVER=audioserver
else
  SERVER=mediaserver
fi
killall $SERVER\
 android.hardware.audio@4.0-service-mediatek

# wait
sleep 20

# aml fix
AML=/data/adb/modules/aml
if [ -L $AML/system/vendor ]\
&& [ -d $AML/vendor ]; then
  DIR=$AML/vendor/odm/etc
else
  DIR=$AML/system/vendor/odm/etc
fi
if [ -d $DIR ] && [ ! -f $AML/disable ]; then
  chcon -R u:object_r:vendor_configs_file:s0 $DIR
fi
AUD=`grep AUD= $MODPATH/copy.sh | sed -e 's|AUD=||g' -e 's|"||g'`
if [ -L $AML/system/vendor ]\
&& [ -d $AML/vendor ]; then
  DIR=$AML/vendor
else
  DIR=$AML/system/vendor
fi
FILES=`find $DIR -type f -name $AUD`
if [ -d $AML ] && [ ! -f $AML/disable ]\
&& find $DIR -type f -name $AUD; then
  if ! grep '/odm' $AML/post-fs-data.sh && [ -d /odm ]\
  && [ "`realpath /odm/etc`" == /odm/etc ]; then
    for FILE in $FILES; do
      DES=/odm`echo $FILE | sed "s|$DIR||g"`
      if [ -f $DES ]; then
        umount $DES
        mount -o bind $FILE $DES
      fi
    done
  fi
  if ! grep '/my_product' $AML/post-fs-data.sh\
  && [ -d /my_product ]; then
    for FILE in $FILES; do
      DES=/my_product`echo $FILE | sed "s|$DIR||g"`
      if [ -f $DES ]; then
        umount $DES
        mount -o bind $FILE $DES
      fi
    done
  fi
fi

# wait
until [ "`getprop sys.boot_completed`" == "1" ]; do
  sleep 10
done

# allow
PKG=com.dts.dtsxultra
if [ "$API" -ge 33 ]; then
  pm grant $PKG android.permission.POST_NOTIFICATIONS
  appops set $PKG ACCESS_RESTRICTED_SETTINGS allow
fi
if [ "$API" -ge 30 ]; then
  appops set $PKG AUTO_REVOKE_PERMISSIONS_IF_UNUSED ignore
fi
PKGOPS=`appops get $PKG`
UID=`dumpsys package $PKG 2>/dev/null | grep -m 1 Id= | sed -e 's|    userId=||g' -e 's|    appId=||g'`
if [ "$UID" ] && [ "$UID" -gt 9999 ]; then
  UIDOPS=`appops get --uid "$UID"`
fi

# audio flinger
DMAF=`dumpsys media.audio_flinger`

# function
stop_log() {
SIZE=`du $LOGFILE | sed "s|$LOGFILE||g"`
if [ "$LOG" != stopped ] && [ "$SIZE" -gt 75 ]; then
  exec 2>/dev/null
  set +x
  LOG=stopped
fi
}
check_audioserver() {
if [ "$NEXTPID" ]; then
  PID=$NEXTPID
else
  PID=`pidof $SERVER`
fi
sleep 15
stop_log
NEXTPID=`pidof $SERVER`
if [ "`getprop init.svc.$SERVER`" != stopped ]; then
  [ "$PID" != "$NEXTPID" ] && killall $PROC
else
  start $SERVER
fi
check_audioserver
}

# check
PROC=com.dts.dtsxultra
killall $PROC
check_audioserver










