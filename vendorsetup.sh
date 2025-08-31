if ! grep -q "smscPduToPhoneNumber" "frameworks/opt/telephony/src/java/com/android/internal/telephony/RadioResponse.java"; then
  echo "Applying Samsung SMSC patches to Telephony..."

  (
      cd "frameworks/opt/telephony"
      git fetch https://github.com/exynos1280/platform_frameworks_opt_telephony android-15.0.0_r26
      git cherry-pick 28fe40db08282f5a9cacccbacd1447fa6998c03c
  )

  popd > /dev/null
  echo "Telephony patches applied successfully."
fi

if [ -d "hardware/samsung/doze" ]; then
    rm -rf "hardware/samsung/doze"
fi

if [ -d "hardware/samsung/AdvancedDisplay" ]; then
    rm -rf "hardware/samsung/AdvancedDisplay"
fi

if ! grep -q "mass_storage" "hardware/samsung/aidl/usb/gadget/UsbGadget.cpp"; then
  echo "Applying DriveDroid mass_storage fix..."

  pushd "hardware/samsung" > /dev/null

  git fetch https://github.com/exynos1280/android_hardware_samsung lineage-22.2-usbgadgetfix

  git cherry-pick 904f4793f97ad745c59a1ef8c4cd6669192f27e8

  popd > /dev/null
fi
