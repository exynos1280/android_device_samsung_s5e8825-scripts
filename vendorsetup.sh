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
