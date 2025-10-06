SCRIPTS_ROOT=$(realpath device/samsung/s5e8825-scripts)

if ! grep -q "smscPduToPhoneNumber" "frameworks/opt/telephony/src/java/com/android/internal/telephony/RadioResponse.java"; then
  echo "Applying Samsung SMSC patches to Telephony..."

  (
      cd "frameworks/opt/telephony"
      git am -3 "$SCRIPTS_ROOT/patches/telephony/0001-telephony-Fix-various-Samsung-SMSC-formatting-issues.patch"
  )
  echo "Telephony patches applied successfully."
fi
