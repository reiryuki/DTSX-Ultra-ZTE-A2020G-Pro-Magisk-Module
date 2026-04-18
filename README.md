# DTSX Ultra ZTE A2020G Pro Magisk Module

## DISCLAIMER
- DTS app and blobs are owned by DTS™.
- The MIT license specified here is for the Magisk Module only, not for DTS app and blobs.

## Descriptions
- Equalizer sound effect ported from ZTE A2020G Pro (P855A01) and integrated as a Magisk Module for all supported and rooted devices with Magisk
- Post process type sound effect
- Changes/spoofs ro.build.product to P855A01 and ro.product.model to ZTE A2020G Pro which may break some system apps and features functionality

## Sources
- https://dumps.tadiphone.dev/dumps/zte/p855a01 msmnile-user-11-RKQ1.201221.002-20211215.223102-release-keys
- DtsUltra.apk: https://dumps.tadiphone.dev/dumps/zte/p855a01 msmnile-user-9-PKQ1.190328.001-68-release-keys
- offline_hptuning.db in DtsUltra.apk & dts-eagle.lic: https://github.com/C457/proprietary_vendor_zte_pine/tree/c22a26a9074dbf3f0bb6fbc43e7203531145d78e
- libdtsaudio.so: https://github.com/TadiT7/nubia_nx619j_dump/tree/76a9813a81f1973fcbff9dd21d53b6e9040a45f8
- libmagiskpolicy.so: Kitsune Mask R6687BB53

## Changelog

v5.8
- Does not disable raw playback (You can use Audio Compatibility Patch Reborn Magisk Module instead)

v5.7
- Fix wrong target in latest KernelSU
- Hide built-in DtsAudio.apk

v5.6-R
- Fix wrong file permissions in some ROMs

v5.6
- Tidy up aml.sh
- Exclude audioeffectshaptic.xml
- Abort installation if fail to mount mirror system

v5.5
- Improve /odm and /my_product support detection

v5.4
- Fix script bug at installation for libsqlite.so detections

v5.3
- Add Action button to clear apps caches
- Fix architecture detection in some weird ROMs
- Fix bug in uninstall.sh

v5.2
- Removes conflicted module
- Detects vndk libsqlite.so in apex

v5.1
- Update some blobs from msmnile-user-11-RKQ1.201221.002-20211215.223102-release-keys

v5.0
- Fix missing libsqlite.so in SDK 35

## Screenshots
- https://t.me/ryukimodsscreenshots/30

## Requirements
- arm64-v8a or armeabi-v7a architecture
- Android 6 (SDK 23) and up
- HIDL audio service
- Magisk or Kitsune Mask or KernelSU or Apatch installed

## Installation Guide & Download Link
- If you are using KernelSU, you need to disable Unmount Modules by Default in KernelSU app settings and install https://github.com/KernelSU-Modules-Repo/meta-overlayfs first
- Install this module via Magisk app or Kitsune Mask app or KernelSU app or Apatch app or Recovery if Magisk or Kitsune Mask installed
- Install AML Magisk Module https://t.me/ryukinotes/34 only if using any other else audio mod module
- Reboot
- If you are using KernelSU, you need to allow superuser list manually all package name listed in package.txt (and your home launcher app also) (enable show system apps) and reboot afterwards
- If you are using SUList, you need to allow list manually your home launcher app (enable show system apps) and reboot afterwards

## Optionals
- https://t.me/ryukinotes/65
- Global: https://t.me/ryukinotes/35
- Stream: https://t.me/ryukinotes/52

## Troubleshootings
- https://t.me/ryukinotes/65
- Global: https://t.me/ryukinotes/34

## Support & Bug Report
- https://t.me/ryukinotes/54
- If you don't do above, issues will be closed immediately

## Known Issue
- Probably still bug microphone in game apps in some devices

## Credits and Contributors
- @HuskyDG
- https://t.me/viperatmos
- https://t.me/androidryukimodsdiscussions
- You can contribute ideas about this Magisk Module here: https://t.me/androidappsportdevelopment

## Sponsors
- https://t.me/ryukinotes/25


