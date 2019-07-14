#!/bin/bash

# Check for root access
if [[ $EUID -ne 0 ]]; then
    echo "This script must be run as root"
    exec sudo "$0" "$@"
    exit 1
fi

# Define functions
function patchXcode {
    BASE_PATH=$1
    echo "[*] (Re-)patching Xcode"

    # TODO: Update templates with current BASE_PATH instead of /opt/iOSOpenDev

    echo "[*] Linking specifications if necessary..."
    if [ ! -L "/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/Library/Xcode/Specifications" ]; then
        ln -s "${BASE_PATH}/specifications/iPhoneOS/Specifications" "/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/Library/Xcode/"
        ln -s "${BASE_PATH}/specifications/iPhoneSimulator/Specifications" "/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneSimulator.platform/Developer/Library/Xcode/"
    fi

    echo "[*] Transferring SDKs..."
    cp -R "${BASE_PATH}/deps/sdks/" "/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/"

    echo "[*] Patching latest SDK..."
    /usr/libexec/PlistBuddy -c "Set DefaultProperties:AD_HOC_CODE_SIGNING_ALLOWED YES" /Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS.sdk/SDKSettings.plist
    /usr/libexec/PlistBuddy -c "Set DefaultProperties:CODE_SIGNING_REQUIRED NO" /Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS.sdk/SDKSettings.plist
    /usr/libexec/PlistBuddy -c "Set DefaultProperties:AD_HOC_CODE_SIGNING_ALLOWED YES" /Applications/Xcode.app/Contents/Developer/Platforms/iPhoneSimulator.platform/Developer/SDKs/iPhoneSimulator.sdk/SDKSettings.plist
    /usr/libexec/PlistBuddy -c "Set DefaultProperties:CODE_SIGNING_REQUIRED NO" /Applications/Xcode.app/Contents/Developer/Platforms/iPhoneSimulator.platform/Developer/SDKs/iPhoneSimulator.sdk/SDKSettings.plist

    echo "[*] Patching minimum SDK version..."
    /usr/libexec/PlistBuddy -c "Set MinimumSDKVersion 8.4" /Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Info.plist
    /usr/libexec/PlistBuddy -c "Set MinimumSDKVersion 8.4" /Applications/Xcode.app/Contents/Developer/Platforms/iPhoneSimulator.platform/Info.plist

    echo "[!] Done patching Xcode"
}

function patchSimulators {
    BASE_PATH=$1
    echo "[*] (Re-)patching iOS simulators for simject"

    cd "${BASE_PATH}/deps/simject"
    chmod +x installsubstrate.sh
    ./installsubstrate.sh subst 1>/dev/null 
    
    echo "[!] Patched iOS simulators"
}

function installSimject {
    BASE_PATH=$1
    echo "[*] Installing simject"

    cd "${BASE_PATH}/deps/simject"
    git submodule init 1>/dev/null && git submodule update 1>/dev/null 
    
    make setup 1>/dev/null
    cp "${BASE_PATH}/deps/simject/bin/resim" /usr/local/bin/
    
    echo "[!] Installed simject"
    echo "[*] Added binary: resim"
    echo "[*] Call to reload the currently running iOS Simulator with tweaks"
    echo "[*] It is automatically invoked by Xcode if you switch on the SIMJECT flag for a Logos-based project"
}


# Setup defaults
BASE_PATH="$( cd "$(dirname "$0")" ; pwd -P )"
THEOS_PATH="/opt/theos"
INSTALL_SIMJECT=1

PATCH_SIMJECT_ONLY=0
PATCH_XCODE_ONLY=0

# Parse args
for i in "$@"
do
case $i in
    --theos-path=*)
        THEOS_PATH="${i#*=}"
        shift
    ;;
    --no-simject)
        INSTALL_SIMJECT=0
        shift
    ;;
    --patch-simject)
        PATCH_SIMJECT_ONLY=1
        shift
    ;;
    --patch-xcode)
        PATCH_XCODE_ONLY=1
        shift
    ;;
    *)
        # unknown option, ignoring
    ;;
esac
done

# Work with args

if { [ "$PATCH_SIMJECT_ONLY" -ne 1 ] && [ "$PATCH_XCODE_ONLY" -ne 1 ] ; } then
    patchXcode $BASE_PATH

    # Do simject stuff second
    if [ "$INSTALL_SIMJECT" -ne 0 ]; then
        export THEOS=$THEOS_PATH
        
        installSimject $BASE_PATH
        patchSimulators $BASE_PATH
    fi
    
    echo "[!] Installation complete"
elif [ "$PATCH_SIMJECT_ONLY" == 1 ]; then
    patchSimulators $BASE_PATH
elif [ "$PATCH_XCODE_ONLY" == 1 ]; then
    patchXcode $BASE_PATH
else
    echo "[!] No action specified, exiting."
fi