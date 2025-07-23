if ! grep -q "smscPduToPhoneNumber" "frameworks/opt/telephony/src/java/com/android/internal/telephony/RadioResponse.java"; then
  echo "Applying Samsung SMSC patches to Telephony..."

  pushd "frameworks/opt/telephony" > /dev/null
  git fetch https://github.com/Flopster101/platform_frameworks_opt_telephony android-15.0.0_r26-td

  # 1. "ignore invalid SMSC" patch from PHH
  git cherry-pick 0fdaaba9c88cbc3d8c9c5288d6d2820fd6bd344e

  # 2. "actually parse it" patch from PHH
  git cherry-pick 9de26ca6b0fcbbb8bc27ca75a57697a7724f797d

  # 3. "Convert PDU to phone number" patch
  git cherry-pick 4bc77f13f09ca37c034adea8d4c401f2df5cb01d

  popd > /dev/null
  echo "Telephony patches applied successfully."
fi
