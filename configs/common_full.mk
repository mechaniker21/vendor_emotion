# Inherit common EMOTION stuff
$(call inherit-product, vendor/emotion/configs/common.mk)

PRODUCT_SIZE := full

# Include CM audio files
include vendor/emotion/configs/cm_audio.mk

# Optional EMOTION packages
PRODUCT_PACKAGES += \
    Galaxy4 \
    HoloSpiralWallpaper \
    LiveWallpapers \
    LiveWallpapersPicker \
    MagicSmokeWallpapers \
    NoiseField \
    PhaseBeam \
    PhotoTable \
    SoundRecorder \
    PhotoPhase \
    Screencast

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

# Themes
PRODUCT_PACKAGES += \
    HexoLibre
