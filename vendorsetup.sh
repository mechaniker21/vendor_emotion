for device in $(cat vendor/emotion/emotion.devices)
do
add_lunch_combo emotion_$device-userdebug
done
