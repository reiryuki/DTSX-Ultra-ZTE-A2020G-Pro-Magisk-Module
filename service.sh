(

MODPATH=${0%/*}

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

killall audioserver

sleep 60

PROP=`getprop ro.build.version.sdk`
PKG=com.dts.dtsxultra
pm grant $PKG android.permission.READ_EXTERNAL_STORAGE
pm grant $PKG android.permission.WRITE_EXTERNAL_STORAGE
pm grant $PKG android.permission.ACCESS_MEDIA_LOCATION
if [ "$PROP" -gt 29 ]; then
  appops set $PKG AUTO_REVOKE_PERMISSIONS_IF_UNUSED ignore
fi

) 2>/dev/null


