#sync rom
repo init --depth=1 --no-repo-verify -u https://github.com/ArrowOS/android_manifest.git -b arrow-13.0 -g default,-mips,-darwin,-notdefault
git clone https://github.com/strongreasons/local_manifest --depth 1 -b main .repo/local_manifests
repo sync -c --no-clone-bundle --no-tags --optimized-fetch --prune --force-sync -j8

# build rom
source $CIRRUS_WORKING_DIR/script/config
timeStart

source build/envsetup.sh
export TZ=Asia/Shanghai
export KBUILD_BUILD_USER=$KBUILD_BUILD_USER
export KBUILD_BUILD_HOST=$KBUILD_BUILD_HOST
export BUILD_USERNAME=$KBUILD_BUILD_USER
export BUILD_HOSTNAME=$KBUILD_BUILD_HOST
lunch arrow_X00TD-userdebug
mkfifo reading
tee "${BUILDLOG}" < reading &
build_message "Building Started"
progress &
m bacon > reading

retVal=$?
timeEnd
statusBuild
