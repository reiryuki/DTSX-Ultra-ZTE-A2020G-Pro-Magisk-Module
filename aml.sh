MODPATH=${0%/*}

# destination
MODAEC=`find $MODPATH/system -type f -name *audio*effects*.conf`
MODAEX=`find $MODPATH/system -type f -name *audio*effects*.xml`
MODAP=`find $MODPATH/system -type f -name *policy*.conf -o -name *policy*.xml`
MODAPX=`find $MODPATH/system -type f -name *policy*.xml`
MODMC=$MODPATH/system/vendor/etc/media_codecs.xml
LIBPATH="\/vendor\/lib\/soundfx"

# function
remove_conf() {
for RMVS in $RMV; do
  sed -i "s/$RMVS/removed/g" $MODAEC
done
sed -i 's/path \/vendor\/lib\/soundfx\/removed//g' $MODAEC
sed -i 's/path \/system\/lib\/soundfx\/removed//g' $MODAEC
sed -i 's/path \/vendor\/lib\/removed//g' $MODAEC
sed -i 's/path \/system\/lib\/removed//g' $MODAEC
sed -i 's/library removed//g' $MODAEC
sed -i 's/uuid removed//g' $MODAEC
sed -i "/^        removed {/ {;N s/        removed {\n        }//}" $MODAEC
}
remove_xml() {
for RMVS in $RMV; do
  sed -i "s/\"$RMVS\"/\"removed\"/g" $MODAEX
done
sed -i 's/<library name="removed" path="removed"\/>//g' $MODAEX
sed -i 's/<effect name="removed" library="removed" uuid="removed"\/>//g' $MODAEX
sed -i 's/<libsw library="removed" uuid="removed"\/>//g' $MODAEX
sed -i 's/<libhw library="removed" uuid="removed"\/>//g' $MODAEX
sed -i 's/<apply effect="removed"\/>//g' $MODAEX
}

# setup audio effects conf
if [ "$MODAEC" ]; then
  sed -i "/^        ring_helper {/ {;N s/        ring_helper {\n        }//}" $MODAEC
  sed -i "/^        alarm_helper {/ {;N s/        alarm_helper {\n        }//}" $MODAEC
  sed -i "/^        music_helper {/ {;N s/        music_helper {\n        }//}" $MODAEC
  sed -i "/^        voice_helper {/ {;N s/        voice_helper {\n        }//}" $MODAEC
  sed -i "/^        notification_helper {/ {;N s/        notification_helper {\n        }//}" $MODAEC
  sed -i "/^        ma_ring_helper {/ {;N s/        ma_ring_helper {\n        }//}" $MODAEC
  sed -i "/^        ma_alarm_helper {/ {;N s/        ma_alarm_helper {\n        }//}" $MODAEC
  sed -i "/^        ma_music_helper {/ {;N s/        ma_music_helper {\n        }//}" $MODAEC
  sed -i "/^        ma_voice_helper {/ {;N s/        ma_voice_helper {\n        }//}" $MODAEC
  sed -i "/^        ma_system_helper {/ {;N s/        ma_system_helper {\n        }//}" $MODAEC
  sed -i "/^        ma_notification_helper {/ {;N s/        ma_notification_helper {\n        }//}" $MODAEC
#  sed -i "/^        sa3d {/ {;N s/        sa3d {\n        }//}" $MODAEC
#  sed -i "/^        fens {/ {;N s/        fens {\n        }//}" $MODAEC
#  sed -i "/^        lmfv {/ {;N s/        lmfv {\n        }//}" $MODAEC
  sed -i "/^        dirac {/ {;N s/        dirac {\n        }//}" $MODAEC
#  sed -i "/^        dtsaudio {/ {;N s/        dtsaudio {\n        }//}" $MODAEC
  if ! grep -Eq '^output_session_processing {' $MODAEC; then
    sed -i -e '$a\
output_session_processing {\
    music {\
    }\
    ring {\
    }\
    alarm {\
    }\
    voice_call {\
    }\
    notification {\
    }\
}\' $MODAEC
  else
    if ! grep -Eq '^    notification {' $MODAEC; then
      sed -i "/^output_session_processing {/a\    notification {\n    }" $MODAEC
    fi
    if ! grep -Eq '^    voice_call {' $MODAEC; then
      sed -i "/^output_session_processing {/a\    voice_call {\n    }" $MODAEC
    fi
    if ! grep -Eq '^    alarm {' $MODAEC; then
      sed -i "/^output_session_processing {/a\    alarm {\n    }" $MODAEC
    fi
    if ! grep -Eq '^    ring {' $MODAEC; then
      sed -i "/^output_session_processing {/a\    ring {\n    }" $MODAEC
    fi
    if ! grep -Eq '^    music {' $MODAEC; then
      sed -i "/^output_session_processing {/a\    music {\n    }" $MODAEC
    fi
  fi
fi

# setup audio effects xml
if [ "$MODAEX" ]; then
  sed -i 's/<apply effect="ring_helper"\/>//g' $MODAEX
  sed -i 's/<apply effect="alarm_helper"\/>//g' $MODAEX
  sed -i 's/<apply effect="music_helper"\/>//g' $MODAEX
  sed -i 's/<apply effect="voice_helper"\/>//g' $MODAEX
  sed -i 's/<apply effect="notification_helper"\/>//g' $MODAEX
  sed -i 's/<apply effect="ma_ring_helper"\/>//g' $MODAEX
  sed -i 's/<apply effect="ma_alarm_helper"\/>//g' $MODAEX
  sed -i 's/<apply effect="ma_music_helper"\/>//g' $MODAEX
  sed -i 's/<apply effect="ma_voice_helper"\/>//g' $MODAEX
  sed -i 's/<apply effect="ma_system_helper"\/>//g' $MODAEX
  sed -i 's/<apply effect="ma_notification_helper"\/>//g' $MODAEX
#  sed -i 's/<apply effect="sa3d"\/>//g' $MODAEX
#  sed -i 's/<apply effect="fens"\/>//g' $MODAEX
#  sed -i 's/<apply effect="lmfv"\/>//g' $MODAEX
  sed -i 's/<apply effect="dirac"\/>//g' $MODAEX
#  sed -i 's/<apply effect="dtsaudio"\/>//g' $MODAEX
  if ! grep -Eq '<postprocess>' $MODAEX || grep -Eq '<!-- Audio post processor' $MODAEX; then
    sed -i '/<\/effects>/a\
    <postprocess>\
        <stream type="music">\
        <\/stream>\
        <stream type="ring">\
        <\/stream>\
        <stream type="alarm">\
        <\/stream>\
        <stream type="voice_call">\
        <\/stream>\
        <stream type="notification">\
        <\/stream>\
    <\/postprocess>' $MODAEX
  else
    if ! grep -Eq '<stream type="notification">' $MODAEX || grep -Eq '<!-- YunMang.Xiao@PSW.MM.Dolby' $MODAEX; then
      sed -i "/<postprocess>/a\        <stream type=\"notification\">\n        <\/stream>" $MODAEX
    fi
    if ! grep -Eq '<stream type="voice_call">' $MODAEX; then
      sed -i "/<postprocess>/a\        <stream type=\"voice_call\">\n        <\/stream>" $MODAEX
    fi
    if ! grep -Eq '<stream type="alarm">' $MODAEX || grep -Eq '<!-- YunMang.Xiao@PSW.MM.Dolby' $MODAEX; then
      sed -i "/<postprocess>/a\        <stream type=\"alarm\">\n        <\/stream>" $MODAEX
    fi
    if ! grep -Eq '<stream type="ring">' $MODAEX || grep -Eq '<!-- YunMang.Xiao@PSW.MM.Dolby' $MODAEX; then
      sed -i "/<postprocess>/a\        <stream type=\"ring\">\n        <\/stream>" $MODAEX
    fi
    if ! grep -Eq '<stream type="music">' $MODAEX || grep -Eq '<!-- YunMang.Xiao@PSW.MM.Dolby' $MODAEX; then
      sed -i "/<postprocess>/a\        <stream type=\"music\">\n        <\/stream>" $MODAEX
    fi
  fi
fi

# dirac
#2RMV="libdiraceffect.so dirac_gef 3799D6D1-22C5-43C3-B3EC-D664CF8D2F0D
#2      libdirac.so dirac_controller b437f4de-da28-449b-9673-667f8b9643fe
#2      dirac_music b437f4de-da28-449b-9673-667f8b964304
#2      dirac e069d9e0-8329-11df-9168-0002a5d5c51b"
#2if [ "$MODAEC" ]; then
#2  remove_conf
#2fi
#2if [ "$MODAEX" ]; then
#2  remove_xml
#2fi

# misoundfx
#3RMV="libmisoundfx.so misoundfx 5b8e36a5-144a-4c38-b1d7-0002a5d5c51b"
#3if [ "$MODAEC" ]; then
#3  remove_conf
#3fi
#3if [ "$MODAEX" ]; then
#3  remove_xml
#3fi

# conflict
RMV="libsamsungSoundbooster_plus_legacy.so libsamsungSoundbooster_plus.so
     soundbooster_plus
     50de45f0-5d4c-11e5-a837-0800200c9a66
     libaudiosaplus_sec_legacy.so libaudiosaplus_sec.so
     soundalive_sec soundalive
     cf65eb39-ce2f-48a8-a903-ceb818c06745
     05227ea0-50bb-11e3-ac69-0002a5d5c51b
     0b2dbc60-50bb-11e3-988b-0002a5d5c51b
     libmysound_legacy.so libmysound.so
     mysound dha
     263a88e0-50b1-11e2-bcfd-0800200c9a66
     37155c20-50bb-11e3-9fac-0002a5d5c51b
     3ef69260-50bb-11e3-931e-0002a5d5c51b
     libsamsungSoundbooster_tdm_legacy.so
     tdm
     beb1d058-916a-4adf-9cfe-54ee5ba8c4a5
     libvolumemonitor_energy.so
     volumemonitor
     16311c29-bb53-4415-b7af-ae653e812de8
     libmyspace.so
     myspace sa3d
     3462a6e0-655a-11e4-8b67-0002a5d5c51b
     1c91fca0-664a-11e4-b8c2-0002a5d5c51b
     c7a84e61-eebe-4fcc-bc53-efcb841b4625
     libLifevibes_lvverx.so
     lmfv fens
     3b75f00-93ce-11e0-9fb8-0002a5d5c51b
     d6dbf400-93ce-11e0-bcd7-0002a5d5c51b
     df0afc20-93ce-11e0-98de-0002a5d5c51b
     989d9460-413d-11e1-8b0d-0002a5d5c51b
     cbcc5980-476d-11e1-82ee-0002a5d5c51b
     libgearvr.so
     vr360audio vr3d
     e6388202-e7a4-4c72-b68a-332eeeba269b"
if [ "$MODAEC" ]; then
  remove_conf
fi
if [ "$MODAEX" ]; then
  remove_xml
fi

# store
LIB=libdtsaudio.so
LIBNAME=dtsaudio
NAME=dts_audio
UUID=146edfc0-7ed2-11e4-80eb-0002a5d5c51b
RMV="$LIB $LIBNAME $NAME $UUID"

# patch audio effects conf
if [ "$MODAEC" ]; then
  remove_conf
  sed -i "/^libraries {/a\  $LIBNAME {\n    path $LIBPATH\/$LIB\n  }" $MODAEC
  sed -i "/^effects {/a\  $NAME {\n    library $LIBNAME\n    uuid $UUID\n  }" $MODAEC
  sed -i "/^    music {/a\        $NAME {\n        }" $MODAEC
#r  sed -i "/^    ring {/a\        $NAME {\n        }" $MODAEC
#a  sed -i "/^    alarm {/a\        $NAME {\n        }" $MODAEC
#v  sed -i "/^    voice_call {/a\        $NAME {\n        }" $MODAEC
#n  sed -i "/^    notification {/a\        $NAME {\n        }" $MODAEC
fi

# patch audio effects xml
if [ "$MODAEX" ]; then
  remove_xml
  sed -i "/<libraries>/a\        <library name=\"$LIBNAME\" path=\"$LIB\"\/>" $MODAEX
  sed -i "/<effects>/a\        <effect name=\"$NAME\" library=\"$LIBNAME\" uuid=\"$UUID\"\/>" $MODAEX
  sed -i "/<stream type=\"music\">/a\            <apply effect=\"$NAME\"\/>" $MODAEX
#r  sed -i "/<stream type=\"ring\">/a\            <apply effect=\"$NAME\"\/>" $MODAEX
#a  sed -i "/<stream type=\"alarm\">/a\            <apply effect=\"$NAME\"\/>" $MODAEX
#v  sed -i "/<stream type=\"voice_call\">/a\            <apply effect=\"$NAME\"\/>" $MODAEX
#n  sed -i "/<stream type=\"notification\">/a\            <apply effect=\"$NAME\"\/>" $MODAEX
fi

# patch audio policy
#uif [ "$MODAP" ]; then
#u  sed -i 's/RAW/NONE/g' $MODAP
#u  sed -i 's/,raw//g' $MODAP
#ufi

# patch audio policy xml
if [ "$MODAPX" ]; then
  if ! grep -Eq 'format="AUDIO_FORMAT_DTS"' $MODAPX; then
    sed -i '/AUDIO_FORMAT_MP3/i\
                    <profile name="" format="AUDIO_FORMAT_DTS"\
                             samplingRates="32000,44100,48000"\
                             channelMasks="AUDIO_CHANNEL_OUT_MONO,AUDIO_CHANNEL_OUT_STEREO,AUDIO_CHANNEL_OUT_2POINT1,AUDIO_CHANNEL_OUT_QUAD,AUDIO_CHANNEL_OUT_PENTA,AUDIO_CHANNEL_OUT_5POINT1"/>' $MODAPX
  fi
  if ! grep -Eq 'format="AUDIO_FORMAT_DTS_HD"' $MODAPX; then
      sed -i '/AUDIO_FORMAT_MP3/i\
                    <profile name="" format="AUDIO_FORMAT_DTS_HD"\
                             samplingRates="32000,44100,48000,64000,88200,96000,128000,176400,192000"\
                             channelMasks="AUDIO_CHANNEL_OUT_MONO,AUDIO_CHANNEL_OUT_STEREO,AUDIO_CHANNEL_OUT_2POINT1,AUDIO_CHANNEL_OUT_QUAD,AUDIO_CHANNEL_OUT_PENTA,AUDIO_CHANNEL_OUT_5POINT1,AUDIO_CHANNEL_OUT_6POINT1,AUDIO_CHANNEL_OUT_7POINT1"/>' $MODAPX
  fi
fi

# patch media codecs
if [ -f $MODMC ]; then
  sed -i '/<MediaCodecs>/a\
    <Include href="media_codecs_dts_audio.xml"/>' $MODMC
fi




