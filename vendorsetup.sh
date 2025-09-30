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

echo "-> Checking for Settings patches to apply..."
if ! grep -q "build_maintainer" "packages/apps/Settings/res/values/cm_strings.xml"; then
  (
      cd "packages/apps/Settings"
      git am -3 "$SCRIPTS_ROOT/patches/0001-Settings-Add-Maintainer-string-into-device-info.patch"
  )
fi

echo "-> Checking for Launcher3 patches to apply..."
if ! grep -q "FLAG_ACTIVITY_NEW_TASK" "packages/apps/Launcher3/src/com/android/launcher3/quickspace/QuickEventsController.java"; then
  (
    cd "packages/apps/Launcher3"
    git am -3 "$SCRIPTS_ROOT/patches/0001-Launcher3-Fix-QuickSpace-crash-by-adding-FLAG_ACTIVI.patch"
  )
fi

if ! grep -q "Grid size settings" "packages/apps/Launcher3/res/values/cr_strings.xml"; then
  (
    cd "packages/apps/Launcher3"
    git am -3 "$SCRIPTS_ROOT/patches/0001-Launcher3-Allow-changing-app-drawer-and-home-screen-.patch"
  )
fi

echo "-> Checking for SystemUI patches to apply..."
if ! grep -q "bottom|start" "frameworks/base/packages/SystemUI/res/layout/status_bar_wifi_group_inner.xml"; then
  (
    cd "frameworks/base"
    git am -3 "$SCRIPTS_ROOT/patches/0001-WifiStandard-Move-standard-icon-to-the-left-side.patch"
  )
fi
