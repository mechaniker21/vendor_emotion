# Inherit common EMOTION stuff
$(call inherit-product, vendor/emotion/configs/common_full.mk)

# Default notification/alarm sounds
PRODUCT_PROPERTY_OVERRIDES += \
    ro.config.notification_sound=Argon.ogg \
    ro.config.alarm_alert=Scandium.ogg