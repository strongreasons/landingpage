#sync rom
repo init --depth=1 --no-repo-verify -u https://github.com/Komodo-OS/manifest -b 12.1 -g default,-mips,-darwin,-notdefault
git clone https://github.com/strongreasons/local_manifest --depth 1 -b komodo .repo/local_manifests
repo sync -c --no-clone-bundle --no-tags --optimized-fetch --prune --force-sync -j8

# build rom
source $CIRRUS_WORKING_DIR/script/config
timeStart

source build/envsetup.sh
export TZ=Asia/Jakarta
export KBUILD_BUILD_USER=$KBUILD_BUILD_USER
export KBUILD_BUILD_HOST=$KBUILD_BUILD_HOST
export BUILD_USERNAME=$KBUILD_BUILD_USER
export BUILD_HOSTNAME=$KBUILD_BUILD_HOST
lunch komodo_X00TD-userdebug
mkfifo reading
tee "${BUILDLOG}" < reading &
build_message "Building Started"
progress &
mka komodo -j8  > reading

retVal=$?
timeEnd
statusBuild
