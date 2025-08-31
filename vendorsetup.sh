if ! grep -q "smscPduToPhoneNumber" "frameworks/opt/telephony/src/java/com/android/internal/telephony/RadioResponse.java"; then
  echo "Applying Samsung SMSC patches to Telephony..."

  pushd "frameworks/opt/telephony" > /dev/null
  git fetch https://github.com/exynos1280/platform_frameworks_opt_telephony android-15.0.0_r26

  git cherry-pick 28fe40db08282f5a9cacccbacd1447fa6998c03c

  popd > /dev/null
  echo "Telephony patches applied successfully."
fi
