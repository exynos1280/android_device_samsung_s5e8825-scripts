if [ -d "hardware/samsung/doze" ]; then
    rm -rf "hardware/samsung/doze"
fi

if [ -d "hardware/samsung/AdvancedDisplay" ]; then
    rm -rf "hardware/samsung/AdvancedDisplay"
fi

if [ -d "system/nfc" ] && ! grep "nfa_t4tnfcee_is_config" system/nfc/src/nfa/include/nfa_nfcee_int.h > /dev/null; then
  cd system/nfc
  git fetch https://github.com/LineageOS/android_system_nfc refs/changes/55/423355/1 && git cherry-pick FETCH_HEAD
  cd -
fi

if ! grep -q "smscPduToPhoneNumber" "frameworks/opt/telephony/src/java/com/android/internal/telephony/RadioResponse.java"; then
  echo "Applying Samsung SMSC patches to Telephony..."

  pushd "frameworks/opt/telephony" > /dev/null
  git fetch https://github.com/exynos1280/platform_frameworks_opt_telephony android-15.0.0_r26-td

  # 1. "ignore invalid SMSC" patch from PHH
  git cherry-pick 0fdaaba9c88cbc3d8c9c5288d6d2820fd6bd344e

  # 2. "actually parse it" patch from PHH
  git cherry-pick 9de26ca6b0fcbbb8bc27ca75a57697a7724f797d

  # 3. "Convert PDU to phone number" patch
  git cherry-pick 4bc77f13f09ca37c034adea8d4c401f2df5cb01d

  popd > /dev/null
  echo "Telephony patches applied successfully."
fi

if [ -f "hardware/lineage/interfaces/health/aidl/default/FastCharge.cpp" ]; then
  echo "Reverting IFastCharge HAL changes..."

  pushd "hardware/lineage/interfaces" > /dev/null
  git fetch https://github.com/exynos1280/android_hardware_lineage_interfaces edf551e9afacee35e43e021b96577067fd5d02f0

  git cherry-pick edf551e9afacee35e43e021b96577067fd5d02f0

  popd > /dev/null
fi

if ! grep -q "mass_storage" "hardware/samsung/aidl/usb/gadget/UsbGadget.cpp"; then
  echo "Applying DriveDroid mass_storage fix..."

  pushd "hardware/samsung" > /dev/null

  git fetch https://github.com/exynos1280/android_hardware_samsung lineage-22.2-usbgadgetfix

  git cherry-pick 904f4793f97ad745c59a1ef8c4cd6669192f27e8

  popd > /dev/null
fi
