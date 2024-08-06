#!/bin/bash

source "$(dirname "${BASH_SOURCE}")/compute_utils.sh"

printUsage() {
    echo
    echo "Usage: ${BASH_SOURCE##*/} [options ...]"
    echo
    echo "Options:"
    echo "  -c,  --clean              Clean output and delete all intermediate work"
    echo "  -p,  --package <type>     Specify packaging format"
    echo "  -r,  --release            Make a release build instead of a debug build"
    echo "  -a,  --address_sanitizer  Enable address sanitizer"
    echo "  -o,  --outdir <pkg_type>  Print path of output directory containing packages of
                                      type referred to by pkg_type"
    echo "  -s,  --static             Component/Build does not support static builds just accepting this param & ignore.
                                      No effect of the param on this build"
    echo "  -w,  --wheel              Creates python wheel package of aqlprofile.
                                      It needs to be used along with -r option"
    echo "  -h,  --help               Prints this help"
    echo
    echo "Possible values for <type>:"
    echo "  deb -> Debian format (default)"
    echo "  rpm -> RPM format"
    echo

    return 0
}

## Build environment variables
API_NAME="hsa-amd-aqlprofile"
PROJ_NAME="$API_NAME"
LIB_NAME="lib${API_NAME}64"

PACKAGE_PREFIX="$ROCM_INSTALL_PATH"
PACKAGE_ROOT="$(getPackageRoot)"
PACKAGE_LIB="$(getLibPath)"
PACKAGE_INCLUDE="$(getIncludePath)"
PACKAGE_DEB="$(getPackageRoot)/deb/$API_NAME"
PACKAGE_RPM="$(getPackageRoot)/rpm/$API_NAME"
BUILD_DIR="$(getBuildPath $API_NAME)"
ROCM_WHEEL_DIR="${BUILD_DIR}/_wheel"

TARGET="build"
BUILD_TYPE="Debug"
MAKETARGET="deb"
MAKE_OPTS="$DASH_JAY -C $BUILD_DIR"
SHARED_LIBS="ON"
CLEAN_OR_OUT=0
MAKETARGET="deb"
PKGTYPE="deb"

# Handling GPU Targets for HSACO and HIP Executables
GPU_LIST="gfx900;gfx906;gfx908;gfx90a;gfx940;gfx941;gfx942;gfx1030;gfx1100;gfx1101;gfx1102"

#parse the arguments
VALID_STR=$(getopt -o hcraswo:p: --long help,clean,release,static,wheel,address_sanitizer,clean,outdir:,package: -- "$@")
eval set -- "$VALID_STR"

while true; do
    #echo "parocessing $1"
    case "$1" in
    -h | --help)
        printUsage
        exit 0
        ;;
    -c | --clean)
        TARGET="clean"
        ((CLEAN_OR_OUT |= 1))
        shift
        ;;
    -r | --release)
        BUILD_TYPE="Release"
        shift
        ;;
    -a | --address_sanitizer)
        set_asan_env_vars
        set_address_sanitizer_on
        shift
        ;;
    -s | --static)
        echo "-s parameter accepted but ignored"
        shift
        ;;
    -w | --wheel)
        WHEEL_PACKAGE=true
        shift
        ;;
    -o | --outdir)
        TARGET="outdir"
        PKGTYPE=$2
        OUT_DIR_SPECIFIED=1
        ((CLEAN_OR_OUT |= 2))
        shift 2
        ;;
    -p | --package)
        MAKETARGET="$2"
        shift 2
        ;;
    --)
        shift
        break
        ;;
    *)
        echo " This should never come but just incase : UNEXPECTED ERROR Parm : [$1] " >&2
        exit 20
        ;;
    esac

done

RET_CONFLICT=1
check_conflicting_options $CLEAN_OR_OUT $PKGTYPE $MAKETARGET
if [ $RET_CONFLICT -ge 30 ]; then
    print_vars $API_NAME $TARGET $BUILD_TYPE $SHARED_LIBS $CLEAN_OR_OUT $PKGTYPE $MAKETARGET
    exit $RET_CONFLICT
fi

clean() {
    echo "Cleaning $PROJ_NAME"

    rm -rf "$ROCM_WHEEL_DIR"
    rm -rf "$BUILD_DIR"
    rm -rf "$PACKAGE_DEB"
    rm -rf "$PACKAGE_RPM"
    rm -rf "$PACKAGE_ROOT/${PROJ_NAME}"
    rm -rf "$PACKAGE_LIB/${LIB_NAME}"*
}

build() {
    echo "Building $PROJ_NAME"

    if [ ! -d "$BUILD_DIR" ]; then
        mkdir -p "$BUILD_DIR"
        pushd "$BUILD_DIR"
        print_lib_type $SHARED_LIBS
        export HIPCC_COMPILE_FLAGS_APPEND="--rocm-path=$ROCM_PATH --offload-arch=gfx900 --offload-arch=gfx906  --offload-arch=gfx908 \
                                                                  --offload-arch=gfx90a --offload-arch=gfx940  --offload-arch=gfx1030 \
                                                                  --offload-arch=gfx1100 --offload-arch=gfx1101 --offload-arch=gfx1102"

        cmake \
            $(rocm_cmake_params) \
            -DBUILD_SHARED_LIBS=$SHARED_LIBS \
            -DCMAKE_MODULE_PATH="$AQLPROFILE_ROOT/cmake_modules" \
            -DENABLE_LDCONFIG=OFF \
            $(rocm_common_cmake_params) \
            -DGPU_TARGETS="$GPU_LIST" \
            -DCPACK_OBJCOPY_EXECUTABLE="${PACKAGE_PREFIX}/llvm/bin/llvm-objcopy" \
            -DCPACK_READELF_EXECUTABLE="${PACKAGE_PREFIX}/llvm/bin/llvm-readelf" \
            -DCPACK_STRIP_EXECUTABLE="${PACKAGE_PREFIX}/llvm/bin/llvm-strip" \
            -DCPACK_OBJDUMP_EXECUTABLE="${PACKAGE_PREFIX}/llvm/bin/llvm-objdump" \
            "$AQLPROFILE_ROOT"

        popd
    fi
    cmake --build "$BUILD_DIR" -- $MAKE_OPTS
    cmake --build "$BUILD_DIR" -- $MAKE_OPTS test
    cmake --build "$BUILD_DIR" -- $MAKE_OPTS mytest
    cmake --build "$BUILD_DIR" -- $MAKE_OPTS install
    cmake --build "$BUILD_DIR" -- $MAKE_OPTS package

    copy_if DEB "${CPACKGEN:-"DEB;RPM"}" "$PACKAGE_DEB" $BUILD_DIR/${API_NAME}*.deb
    copy_if RPM "${CPACKGEN:-"DEB;RPM"}" "$PACKAGE_RPM" $BUILD_DIR/${API_NAME}*.rpm
}

create_wheel_package() {
    echo "Creating aqlprofile wheel package"
    mkdir -p $ROCM_WHEEL_DIR
    cp -f $SCRIPT_ROOT/generate_setup_py.py $ROCM_WHEEL_DIR
    cp -f $SCRIPT_ROOT/repackage_wheel.sh $ROCM_WHEEL_DIR
    cd $ROCM_WHEEL_DIR
    # Currently only supports python3.6
    ./repackage_wheel.sh $BUILD_DIR/${API_NAME}*.rpm python3.6
    # Copy the wheel created to RPM folder which will be uploaded to artifactory
    copy_if WHL "WHL" "$PACKAGE_RPM" "$ROCM_WHEEL_DIR"/dist/*.whl
}

print_output_directory() {
    case ${PKGTYPE} in
    "deb")
        echo ${PACKAGE_DEB}
        ;;
    "rpm")
        echo ${PACKAGE_RPM}
        ;;
    *)
        echo "Invalid package type \"${PKGTYPE}\" provided for -o" >&2
        exit 1
        ;;
    esac
    exit
}
verifyEnvSetup

case "$TARGET" in
clean) clean ;;
build) build ;;
outdir) print_output_directory ;;
*) die "Invalid target $TARGET" ;;
esac

if [[ $WHEEL_PACKAGE == true ]]; then
    echo "Wheel Package build started !!!!"
    create_wheel_package
fi

echo "Operation complete"
