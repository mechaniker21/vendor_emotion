PRODUCT_BRAND ?= emotion

SUPERUSER_EMBEDDED := true

ifneq ($(TARGET_SCREEN_WIDTH) $(TARGET_SCREEN_HEIGHT),$(space))
# determine the smaller dimension
TARGET_BOOTANIMATION_SIZE := $(shell \
  if [ "$(TARGET_SCREEN_WIDTH)" -lt "$(TARGET_SCREEN_HEIGHT)" ]; then \
    echo $(TARGET_SCREEN_WIDTH); \
  else \
    echo $(TARGET_SCREEN_HEIGHT); \
  fi )

# get a sorted list of the sizes
bootanimation_sizes := $(subst .zip,, $(shell ls vendor/emotion/prebuilt/bootanimation))
bootanimation_sizes := $(shell echo -e $(subst $(space),'\n',$(bootanimation_sizes)) | sort -rn)

# find the appropriate size and set
define check_and_set_bootanimation
$(eval TARGET_BOOTANIMATION_NAME := $(shell \
  if [ -z "$(TARGET_BOOTANIMATION_NAME)" ]; then \
    if [ "$(1)" -le "$(TARGET_BOOTANIMATION_SIZE)" ]; then \
      echo $(1); \
      exit 0; \
    fi;
  fi;
  echo $(TARGET_BOOTANIMATION_NAME); ))
endef
$(foreach size,$(bootanimation_sizes), $(call check_and_set_bootanimation,$(size)))

ifeq ($(TARGET_BOOTANIMATION_HALF_RES),true)
PRODUCT_BOOTANIMATION := vendor/emotion/prebuilt/bootanimation/halfres/$(TARGET_BOOTANIMATION_NAME).zip
else
PRODUCT_BOOTANIMATION := vendor/emotion/prebuilt/bootanimation/$(TARGET_BOOTANIMATION_NAME).zip
endif
endif

# Common dictionaries
PRODUCT_PACKAGE_OVERLAYS += vendor/emotion/overlay/dictionaries
PRODUCT_BUILD_PROP_OVERRIDES += BUILD_UTC_DATE=0

ifeq ($(PRODUCT_GMS_CLIENTID_BASE),)
PRODUCT_PROPERTY_OVERRIDES += \
    ro.com.google.clientidbase=android-google
else
PRODUCT_PROPERTY_OVERRIDES += \
    ro.com.google.clientidbase=$(PRODUCT_GMS_CLIENTID_BASE)
endif

PRODUCT_PROPERTY_OVERRIDES += \
    keyguard.no_require_sim=true \
    ro.url.legal=http://www.google.com/intl/%s/mobile/android/basic/phone-legal.html \
    ro.url.legal.android_privacy=http://www.google.com/intl/%s/mobile/android/basic/privacy.html \
    ro.com.android.wifi-watchlist=GoogleGuest \
    ro.setupwizard.enterprise_mode=1 \
    ro.com.android.dateformat=MM-dd-yyyy \
    ro.com.android.dataroaming=false

#SELinux
PRODUCT_PROPERTY_OVERRIDES += \
    ro.build.selinux=1

# Default notification/alarm sounds
PRODUCT_PROPERTY_OVERRIDES += \
    ro.config.notification_sound=Argon.ogg \
    ro.config.alarm_alert=Hassium.ogg

ifneq ($(TARGET_BUILD_VARIANT),user)
# Thank you, please drive thru!
PRODUCT_PROPERTY_OVERRIDES += persist.sys.dun.override=0
endif

ifneq ($(TARGET_BUILD_VARIANT),eng)
# Enable ADB authentication
ADDITIONAL_DEFAULT_PROPERTIES += ro.adb.secure=1
endif

# Backup Tool
PRODUCT_COPY_FILES += \
    vendor/emotion/prebuilt/bin/backuptool.sh:install/bin/backuptool.sh \
    vendor/emotion/prebuilt/bin/backuptool.functions:install/bin/backuptool.functions \
    vendor/emotion/prebuilt/bin/blacklist:system/addon.d/blacklist
# Backup Services whitelist
PRODUCT_COPY_FILES += \
    vendor/emotion/configs/permissions/backup.xml:system/etc/sysconfig/backup.xml

# Signature compatibility validation
PRODUCT_COPY_FILES += \
    vendor/emotion/prebuilt/common/bin/otasigcheck.sh:install/bin/otasigcheck.sh

# init.d support
PRODUCT_COPY_FILES += \
    vendor/emotion/prebuilt/common/etc/init.d/00start:system/etc/init.d/00start \
    vendor/emotion/prebuilt/common/etc/init.d/01sysctl:system/etc/init.d/01sysctl \
    vendor/emotion/prebuilt/common/etc/sysctl.conf:system/etc/sysctl.conf \
    vendor/emotion/prebuilt/common/bin/sysinit:system/bin/sysinit

# userinit support
ifneq ($(TARGET_BUILD_VARIANT),user)
PRODUCT_COPY_FILES += \
    vendor/emotion/prebuilt/common/etc/init.d/90userinit:system/etc/init.d/90userinit
endif

# EMOTION-specific init file
PRODUCT_COPY_FILES += \
    vendor/emotion/prebuilt/common/etc/init.local.rc:root/init.emotion.rc \

# Installer
PRODUCT_COPY_FILES += \
    vendor/emotion/prebuilt/common/bin/persist.sh:install/bin/persist.sh \
    vendor/emotion/prebuilt/common/etc/persist.conf:system/etc/persist.conf

PRODUCT_COPY_FILES += \
    vendor/emotion/prebuilt/common/lib/libmicrobes_jni.so:system/lib/libmicrobes_jni.so \
    vendor/emotion/prebuilt/common/etc/resolv.conf:system/etc/resolv.conf

# Copy over added mimetype supported in libcore.net.MimeUtils
PRODUCT_COPY_FILES += \
    vendor/emotion/prebuilt/common/lib/content-types.properties:system/lib/content-types.properties

# Enable SIP+VoIP on all targets
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.software.sip.voip.xml:system/etc/permissions/android.software.sip.voip.xml

# Enable wireless Xbox 360 controller support
PRODUCT_COPY_FILES += \
    frameworks/base/data/keyboards/Vendor_045e_Product_028e.kl:system/usr/keylayout/Vendor_045e_Product_0719.kl

PRODUCT_COPY_FILES += \
    vendor/emotion/configs/permissions/com.emotion.android.xml:system/etc/permissions/com.emotion.android.xml

# Include CM audio files
include vendor/emotion/configs/cm_audio.mk

# Theme engine
include vendor/emotion/configs/themes_common.mk

ifneq ($(TARGET_DISABLE_CMSDK), true)
# CMSDK
include vendor/emotion/configs/cmsdk_common.mk
endif

# Required EMOTION packages
PRODUCT_PACKAGES += \
    BluetoothExt \
    CMAudioService \
    CMParts \
    Development \
    KernelAdiutor \
    Savoca-kcal \
    AdAway \
    LatinIME \
    LatinImeDictionaryPack \
    Stk \
    OmniSwitch \
    EmotionControl

#Build EmotionOTA only if EMOTION_VERSION_MAINTENANCE isn't Unofficial
ifneq ($(EMOTION_VERSION_MAINTENANCE),Unofficial)
PRODUCT_PACKAGES += \
    EmotionOTA
endif

# Optional EMOTION packages
PRODUCT_PACKAGES += \
    libemoji \
    LiveWallpapersPicker \
    PhotoTable \
    Terminal \
    masquerade

# Include librsjni explicitly to workaround GMS issue
PRODUCT_PACKAGES += \
    librsjni

# Custom CM packages
PRODUCT_PACKAGES += \
    AudioFX \
    CMAudioService \
    CMFileManager \
    CMParts \
    CMSettingsProvider \
    CMWallpapers \
    Eleven \
    ExactCalculator \
    Launcher3 \
    LockClock \
    Screencast \
    SoundRecorder \
    Trebuchet \
    WallpaperPicker \
    WeatherManagerService \
    WeatherProvider

# Exchange support
PRODUCT_PACKAGES += \
    Exchange2

# Extra tools in CM
PRODUCT_PACKAGES += \
    7z \
    bash \
    bzip2 \
    curl \
    fsck.ntfs \
    gdbserver \
    htop \
    lib7z \
    libsepol \
    micro_bench \
    mke2fs \
    mkfs.ntfs \
    mount.ntfs \
    nano \
    oprofiled \
    pigz \
    powertop \
    sqlite3 \
    strace \
    tune2fs \
    unrar \
    unzip \
    vim \
    wget \
    zip

# Custom off-mode charger
ifneq ($(WITH_CM_CHARGER),false)
PRODUCT_PACKAGES += \
    charger_res_images \
    cm_charger_res_images \
    font_log.png \
    libhealthd.cm
endif

# ExFAT support
WITH_EXFAT ?= true
ifeq ($(WITH_EXFAT),true)
TARGET_USES_EXFAT := true
PRODUCT_PACKAGES += \
    mount.exfat \
    fsck.exfat \
    mkfs.exfat
endif

# Openssh
PRODUCT_PACKAGES += \
    scp \
    sftp \
    ssh \
    sshd \
    sshd_config \
    ssh-keygen \
    start-ssh

# rsync
PRODUCT_PACKAGES += \
    rsync

# Stagefright FFMPEG plugin
PRODUCT_PACKAGES += \
    libffmpeg_extractor \
    libffmpeg_omx \
    media_codecs_ffmpeg.xml

PRODUCT_PROPERTY_OVERRIDES += \
    media.sf.omx-plugin=libffmpeg_omx.so \
    media.sf.extractor-plugin=libffmpeg_extractor.so

# Storage manager
PRODUCT_PROPERTY_OVERRIDES += \
    ro.storage_manager.enabled=true

# Telephony
PRODUCT_PACKAGES += \
    telephony-ext

PRODUCT_BOOT_JARS += \
    telephony-ext

# These packages are excluded from user builds
ifneq ($(TARGET_BUILD_VARIANT),user)
PRODUCT_PACKAGES += \
    procmem \
    procrank \
    su
endif

PRODUCT_PROPERTY_OVERRIDES += \
    persist.sys.root_access=3

# Common overlay
DEVICE_PACKAGE_OVERLAYS += vendor/emotion/overlay/common

PRODUCT_VERSION_MAJOR = 14
PRODUCT_VERSION_MINOR = 0
PRODUCT_VERSION_MAINTENANCE = 0

# Version information used on all builds
PRODUCT_BUILD_PROP_OVERRIDES += BUILD_VERSION_TAGS=release-keys USER=android-build BUILD_UTC_DATE=$(shell date +"%s")

# Call EMOTION Stuff
$(call inherit-product, vendor/emotion/configs/emotion_common.mk)

-include $(WORKSPACE)/build_env/image-auto-bits.mk
-include vendor/emotion/configs/partner_gms.mk

-include $(WORKSPACE)/build_env/image-auto-bits.mk
