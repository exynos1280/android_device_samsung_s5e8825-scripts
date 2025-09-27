SCRIPTS_ROOT="$(realpath device/samsung/s5e8825-scripts)"

if ! grep -q "smscPduToPhoneNumber" "frameworks/opt/telephony/src/java/com/android/internal/telephony/RadioResponse.java"; then
  echo "Applying Samsung SMSC patches to Telephony..."

  (
      cd "frameworks/opt/telephony"
      git fetch https://github.com/exynos1280/platform_frameworks_opt_telephony android-15.0.0_r26
      git cherry-pick 28fe40db08282f5a9cacccbacd1447fa6998c03c
  )
  echo "Telephony patches applied successfully."
fi

if ! grep -q "build_maintainer" "packages/apps/Settings/res/values/cm_strings.xml"; then
  echo "Applying Settings maintainer patch..."

  (
      cd "packages/apps/Settings"
      git am -3 "$SCRIPTS_ROOT/patches/0001-Settings-Add-Maintainer-string-into-device-info.patch"
  )
  echo "Settings maintainer patch applied successfully."
fi

if ! grep -q "FLAG_ACTIVITY_NEW_TASK" "packages/apps/Launcher3/src/com/android/launcher3/quickspace/QuickEventsController.java"; then
  echo "Applying Launcher3 Quickspace crash fix..."

  (
    cd "packages/apps/Launcher3"
    git am -3 "$SCRIPTS_ROOT/patches/0001-Launcher3-Fix-QuickSpace-crash-by-adding-FLAG_ACTIVI.patch"
  )
  echo "Launcher3 Quickspace crash fix applied successfully."
fi
