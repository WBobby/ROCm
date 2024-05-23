#!/bin/bash

source "$(dirname "${BASH_SOURCE}")/compute_utils.sh"

printUsage() {
    echo
    echo "Usage: ${BASH_SOURCE##*/} [options ...]"
    echo
    echo "Options:"
    echo "  -c,  --clean              Clean output and delete all intermediate work"
    echo "  -s,  --static             Build static lib (.a).  build instead of dynamic/shared(.so) "
    echo "  -p,  --package <type>     Specify packaging format"
    echo "  -r,  --release            Make a release build instead of a debug build"
    echo "  -a,  --address_sanitizer  Enable address sanitizer"
    echo "  -o,  --outdir <pkg_type>  Print path of output directory containing packages of
    type referred to by pkg_type"
    echo "  -h,  --help               Prints this help"
    echo
    echo "Possible values for <type>:"
    echo "  deb -> Debian format (default)"
    echo "  rpm -> RPM format"
    echo

    return 0
}

API_NAME="rocprofiler"
PROJ_NAME="$API_NAME"
LIB_NAME="lib${API_NAME}"
TARGET="build"
MAKETARGET="deb"
PACKAGE_ROOT="$(getPackageRoot)"
PACKAGE_LIB="$(getLibPath)"
PACKAGE_INCLUDE="$(getIncludePath)"
BUILD_DIR="$(getBuildPath $API_NAME)"
PACKAGE_DEB="$(getPackageRoot)/deb/$API_NAME"
PACKAGE_RPM="$(getPackageRoot)/rpm/$API_NAME"
PACKAGE_PREFIX="$ROCM_INSTALL_PATH"
BUILD_TYPE="Debug"
MAKE_OPTS="$DASH_JAY -C $BUILD_DIR"
SHARED_LIBS="ON"
CLEAN_OR_OUT=0
MAKETARGET="deb"
PKGTYPE="deb"
GPU_LIST="gfx900,gfx906,gfx908,gfx90a,gfx940,gfx941,gfx942,gfx1030,gfx1100,gfx1101,gfx1102"

VALID_STR=$(getopt -o hcraso:p: --long help,clean,release,static,address_sanitizer,outdir:,package: -- "$@")
eval set -- "$VALID_STR"

while true; do
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
        BUILD_TYPE="RelWithDebInfo"
        shift
        ;;
    -a | --address_sanitizer)
        set_asan_env_vars
        set_address_sanitizer_on
        shift
        ;;
    -s | --static)
        SHARED_LIBS="OFF"
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
    rm -rf "$BUILD_DIR"
    rm -rf "$PACKAGE_DEB"
    rm -rf "$PACKAGE_RPM"
    rm -rf "$PACKAGE_ROOT/${PROJ_NAME}"
    rm -rf "$PACKAGE_ROOT/libexec/${PROJ_NAME}"
    rm -rf "$PACKAGE_INCLUDE/${PROJ_NAME}"
    rm -rf "$PACKAGE_LIB/${LIB_NAME}"*
    rm -rf "$PACKAGE_LIB/${PROJ_NAME}"
}

build_rocprofiler() {
    echo "Building $PROJ_NAME"

    sed -i 's/set(CPACK_GENERATOR "DEB" "RPM" "TGZ")/set(CPACK_GENERATOR "DEB" "TGZ")/' "${ROCPROFILER_ROOT}/CMakeLists.txt"

    PACKAGE_CMAKE="$(getCmakePath)"
    if [ ! -d "$BUILD_DIR" ]; then
        mkdir -p "$BUILD_DIR"
        pushd "$BUILD_DIR"
        print_lib_type $SHARED_LIBS

        cmake \
            $(rocm_cmake_params) \
            -DCMAKE_MODULE_PATH="$ROCPROFILER_ROOT/cmake_modules;$PACKAGE_CMAKE/hip" \
            $(rocm_common_cmake_params) \
            -DBUILD_SHARED_LIBS=$SHARED_LIBS \
            -DENABLE_LDCONFIG=OFF \
            -DUSE_PROF_API=1 \
            -DGPU_TARGETS="$GPU_LIST" \
            -DPROF_API_HEADER_PATH="$WORK_ROOT/roctracer/inc/ext" \
            -DHIP_HIPCC_FLAGS=$HIP_HIPCC_FLAGS";--offload-arch=$GPU_LIST" \
            -DCPACK_OBJCOPY_EXECUTABLE="${ROCM_INSTALL_PATH}/llvm/bin/llvm-objcopy" \
            -DCPACK_READELF_EXECUTABLE="${ROCM_INSTALL_PATH}/llvm/bin/llvm-readelf" \
            -DCPACK_STRIP_EXECUTABLE="${ROCM_INSTALL_PATH}/llvm/bin/llvm-strip" \
            -DCPACK_OBJDUMP_EXECUTABLE="${ROCM_INSTALL_PATH}/llvm/bin/llvm-objdump" \
            "$ROCPROFILER_ROOT"

        popd
    fi
    cmake --build "$BUILD_DIR" -- $MAKE_OPTS
    cmake --build "$BUILD_DIR" -- $MAKE_OPTS mytest
    cmake --build "$BUILD_DIR" -- $MAKE_OPTS install
    cmake --build "$BUILD_DIR" -- $MAKE_OPTS package

    copy_if DEB "${CPACKGEN:-"DEB;RPM"}" "$PACKAGE_DEB" "$BUILD_DIR/${API_NAME}"*.deb
    copy_if RPM "${CPACKGEN:-"DEB;RPM"}" "$PACKAGE_RPM" "$BUILD_DIR/${API_NAME}"*.rpm
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
build) build_rocprofiler ;;
outdir) print_output_directory ;;
*) die "Invalid target $TARGET" ;;
esac

echo "Operation complete"
