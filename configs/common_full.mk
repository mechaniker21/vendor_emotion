# Inherit common EMOTION stuff
$(call inherit-product, vendor/emotion/configs/common.mk)

PRODUCT_SIZE := full

# Bring in all video files
$(call inherit-product, frameworks/base/data/videos/VideoPackage2.mk)

# Include CM audio files
include vendor/emotion/configs/cm_audio.mk

# Include EMOTION LatinIME dictionaries
PRODUCT_PACKAGE_OVERLAYS += vendor/emotion/overlay/dictionaries

# Optional EMOTION packages
PRODUCT_PACKAGES += \
    CMSettingsProvider \
    Galaxy4 \
    HoloSpiralWallpaper \
    LiveWallpapers \
    LiveWallpapersPicker \
    MagicSmokeWallpapers \
    NoiseField \
    PhaseBeam \
    PhotoPhase \
    PhotoTable \
    Screencast \
    SoundRecorder

PRODUCT_PACKAGES += \
    VideoEditor \
    libvideoeditor_jni \
    libvideoeditor_core \
    libvideoeditor_osal \
    libvideoeditor_videofilters \
    libvideoeditorplayer

# Extra tools in EMOTION
PRODUCT_PACKAGES += \
    7z \
    lib7z \
    bash \
    bzip2 \
    curl \
    powertop \
    unrar \
    unzip \
    vim \
    wget \
    zip