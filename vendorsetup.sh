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

if [ -d "hardware/samsung/hidl/livedisplay" ]; then
    rm -rf "hardware/samsung/hidl/livedisplay"
fi

if [ -d "hardware/samsung/aidl/touch" ]; then
    rm -rf "hardware/samsung/aidl/touch"
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

echo "Cleaning up Lineage sepolicy from slsi sepolicy"
if [ -d "device/samsung_slsi/sepolicy" ]; then
  pushd "device/samsung_slsi/sepolicy" > /dev/null

  find . -type f -iname '*lineage*.te' -print -exec rm -f -- {} +

  find . -type f -name 'file_contexts' -print0 | while IFS= read -r -d '' fc; do
    if grep -qE 'vendor\.lineage|hal_lineage' "$fc"; then
      sed -i '/vendor\.lineage/d; /hal_lineage/d' "$fc"
      awk 'NF{p=1; print; next} p{print ""; p=0}' "$fc" > "${fc}.tmp" && mv "${fc}.tmp" "$fc"
      echo "Cleaned $fc"
    fi
  done

  popd > /dev/null
  echo "Lineage sepolicy cleanup finished"
fi

