MODPATH=${0%/*}

# log
LOGFILE=$MODPATH/debug.log
exec 2>$LOGFILE
set -x

# var
API=`getprop ro.build.version.sdk`
if [ ! -d $MODPATH/vendor ]\
|| [ -L $MODPATH/vendor ]; then
  MODSYSTEM=/system
fi
MOD=/data/adb/modules/nomount
NM=$MOD/bin/nm
NOMOUNT=false
[ ! -f $MOD/disable ] && [ -x $NM ] && $NM v >/dev/null 2>&1 && NOMOUNT=true
AML=/data/adb/modules/aml
AUD=`cat $MODPATH/audio.txt`

# NoMount
if $NOMOUNT; then
  if [ ! -d $AML ] || [ -f $AML/disable ]; then
    FILES=`find $MODPATH/system $MODPATH/vendor -type f -name $AUD`
    for FILE in $FILES; do
      DES=`echo $FILE | sed -e "s|$MODPATH||g" -e 's|/system/odm|/odm|g' -e 's|/system/my_product|/my_product|g'`
      RDES=`realpath $DES`
      if [ -f $RDES ]; then
        $NM del $RDES 2>/dev/null || true
        $NM add $RDES $FILE
      fi
    done
  fi
fi

# property
resetprop -n ro.audio.ignore_effects false
resetprop -n ro.build.product P855A01
resetprop -n ro.product.model "ZTE A2020G Pro"
resetprop -n ro.dts.licensepath /vendor/etc/dts/
resetprop -n ro.dts.cfgpath /vendor/etc/dts/
resetprop -n ro.vendor.dts.licensepath /vendor/etc/dts/
resetprop -n ro.vendor.dts.cfgpath /vendor/etc/dts/
resetprop -n ro.vendor.feature.zte_feature_dts_ultra_enable true
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
 android.hardware.audio@4.0-service-mediatek\
 android.hardware.audio.service

# wait
until [ "`getprop sys.boot_completed`" == 1 ]; do
  sleep 10
done

# list
PKGS=`cat $MODPATH/package.txt`
for PKG in $PKGS; do
  magisk --denylist rm $PKG 2>/dev/null
  magisk --sulist add $PKG 2>/dev/null
done
if magisk magiskhide sulist; then
  for PKG in $PKGS; do
    magisk magiskhide add $PKG
  done
else
  for PKG in $PKGS; do
    magisk magiskhide rm $PKG
  done
fi

# allow
PKG=com.dts.dtsxultra
if appops get $PKG > /dev/null 2>&1; then
  pm grant --all-permissions $PKG
  if [ "$API" -ge 33 ]; then
    appops set $PKG ACCESS_RESTRICTED_SETTINGS allow
  fi
  if [ "$API" -ge 30 ]; then
    appops set $PKG AUTO_REVOKE_PERMISSIONS_IF_UNUSED ignore
  fi
  PKGOPS=`appops get $PKG`
  UID=`grep "^$PKG " /data/system/packages.list | awk '{print $2}'`
  if [ "$UID" ] && [ "$UID" -gt 9999 ]; then
    UIDOPS=`appops get --uid "$UID"`
  fi
fi

# function
stop_log() {
SIZE=`du $LOGFILE | sed "s|$LOGFILE||g"`
if [ "$LOG" != stopped ] && [ "$SIZE" -gt 50 ]; then
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
[ "$PID" != "$NEXTPID" ] && killall $PROC
check_audioserver
}

# check
PROC=com.dts.dtsxultra
killall $PROC
check_audioserver










