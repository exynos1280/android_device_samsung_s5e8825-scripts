SCRIPTS_ROOT=$(realpath device/samsung/s5e8825-scripts)

if ! grep -q "smscPduToPhoneNumber" "frameworks/opt/telephony/src/java/com/android/internal/telephony/RadioResponse.java"; then
  echo "Applying Samsung SMSC patches to Telephony..."

  (
      cd "frameworks/opt/telephony"
      git am -3 "$SCRIPTS_ROOT/patches/telephony/0001-telephony-Fix-various-Samsung-SMSC-formatting-issues.patch"
  )
  echo "Telephony patches applied successfully."
fi

if ! grep -q "setCurrentUsbFunctions mass_storage" "hardware/samsung/aidl/usb/gadget/UsbGadget.cpp"; then
  echo "Applying Samsung mass storage patch..."

  (
    cd "hardware/samsung"
    git am -3 "$SCRIPTS_ROOT/patches/hardware_samsung/0001-aidl-usb-gadget-Link-mass_storage.0-when-MTP-or-ADB-.patch"
    git am -3 "$SCRIPTS_ROOT/patches/hardware_samsung/0002-aidl-usb-gadget-Don-t-bail-out-on-mass_storage-link-.patch"
  )
fi

if [ -f "vendor/google/pixel/Android.bp" ] && grep -q "SystemUIClocks-BigNum" "vendor/google/pixel/Android.bp"; then
  echo "Removing SystemUIClock modules from vendor/google/pixel..."

  perl -0pe 's/android_app_import \{[^}]*name: "SystemUIClocks-[^}]*\}[^}]*\}//gms; s/\n{3,}/\n\n/g' "vendor/google/pixel/Android.bp" > "vendor/google/pixel/Android.bp.tmp" && mv "vendor/google/pixel/Android.bp.tmp" "vendor/google/pixel/Android.bp"

  echo "SystemUIClock modules removed."
fi

echo "-> Checking for Settings patches to apply..."
if ! grep -q "build_maintainer" "packages/apps/Settings/res/values/cm_strings.xml"; then
  (
    cd "packages/apps/Settings"
    git am -3 "$SCRIPTS_ROOT/patches/Settings/0001-Settings-Add-Maintainer-string-into-device-info.patch"
  )
fi

if ! grep -q "lso check system setting for 4G icon preference" "packages/apps/Settings/src/com/android/settings/network/telephony/NetworkSelectSettings.java"; then
  (
    cd "packages/apps/Settings"
    git am -3 "$SCRIPTS_ROOT/patches/Settings/0001-Settings-Apply-forced-4G-icon-consistently.patch"
  )
fi

echo "-> Checking for Launcher3 patches to apply..."
if ! grep -q "Grid size settings" "packages/apps/Launcher3/res/values/cr_strings.xml"; then
  (
    cd "packages/apps/Launcher3"
    git am -3 "$SCRIPTS_ROOT/patches/Launcher3/0001-Launcher3-Allow-changing-app-drawer-and-home-screen-.patch"
  )
fi

if ! grep -q "Try multiple wallpaper picker packages" "packages/apps/Launcher3/src/com/android/launcher3/views/OptionsPopupView.java"; then
  (
    cd "packages/apps/Launcher3"
    git am -3 "$SCRIPTS_ROOT/patches/Launcher3/0001-Launcher3-Support-multiple-wallpaper-pickers.patch"
  )
fi

echo "-> Checking for SystemUI patches to apply..."
if ! grep -q "convertLteToFourg" "frameworks/base/packages/SystemUI/src/com/android/systemui/qs/tiles/dialog/InternetDetailsContentController.java"; then
  (
    cd "frameworks/base"
    git am -3 "$SCRIPTS_ROOT/patches/SystemUI/0001-SystemUI-Apply-forced-4G-to-Quick-Settings-tile-too.patch"
  )
fi

echo "-> Checking for vendor/google patches to apply..."
if grep -q "GoogleSans-" "vendor/google/pixel/pixel-vendor.mk"; then
  (
    cd "vendor/google/pixel"
    git am -3 "$SCRIPTS_ROOT/patches/vendor_google/0001-pixel-Remove-Google-Sans-UI-fonts.patch"
  )
fi
