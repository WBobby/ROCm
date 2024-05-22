#!/bin/bash

source "$(dirname "${BASH_SOURCE}")/compute_utils.sh"

printUsage() {
    echo
    echo "Usage: $(basename "${BASH_SOURCE}") [options ...]"
    echo
    echo "Options:"
    echo "  -c,  --clean              Clean output and delete all intermediate work"
    echo "  -r,  --release            Build a release version of the package"
    echo "  -a,  --address_sanitizer  Enable address sanitizer"
    echo "  -s,  --static             Supports static CI by accepting this param & not bailing out. No effect of the param though"
    echo "  -o,  --outdir <pkg_type>  Print path of output directory containing packages of
    type referred to by pkg_type"
    echo "  -p,  --package <type>     Specify packaging format"
    echo "  -h,  --help             Prints this help"
    echo
    echo

    return 0
}

TARGET="build"
PACKAGE_ROOT="$(getPackageRoot)"
PACKAGE_DEB="$(getPackageRoot)/deb/rocm-cmake"
PACKAGE_RPM="$(getPackageRoot)/rpm/rocm-cmake"
ROCM_CMAKE_BUILD_DIR="$(getBuildPath rocm-cmake)"

ROCM_CMAKE_BUILD_DIR="$(getBuildPath rocm-cmake)"
ROCM_CMAKE_PACKAGE_DEB="$(getPackageRoot)/deb/rocm-cmake"
ROCM_CMAKE_PACKAGE_RPM="$(getPackageRoot)/rpm/rocm-cmake"
ROCM_CMAKE_BUILD_TYPE="debug"
BUILD_TYPE="Debug"
SHARED_LIBS="ON"
CLEAN_OR_OUT=0;
PKGTYPE="deb"
MAKETARGET="deb"

VALID_STR=`getopt -o hcraso:p: --long help,clean,release,static,address_sanitizer,outdir:,package: -- "$@"`
eval set -- "$VALID_STR"

while true ;
do
    case "$1" in
        (-h | --help)
                printUsage ; exit 0;;
        (-c | --clean)
                TARGET="clean" ; ((CLEAN_OR_OUT|=1)) ; shift ;;
        (-r | --release)
                BUILD_TYPE="Release" ; shift ;;
        (-a | --address_sanitizer)
                ack_and_ignore_asan ; shift ;;
        (-s | --static)
                SHARED_LIBS="OFF" ; shift ;;
        (-o | --outdir)
                TARGET="outdir"; PKGTYPE=$2 ; OUT_DIR_SPECIFIED=1 ; ((CLEAN_OR_OUT|=2)) ; shift 2 ;;
        (-p | --package)
                MAKETARGET="$2" ; shift 2;;
        --)     shift; break;;
        (*)
                echo " This should never come but just incase : UNEXPECTED ERROR Parm : [$1] ">&2 ; exit 20;;
    esac

done

RET_CONFLICT=1
check_conflicting_options $CLEAN_OR_OUT $PKGTYPE $MAKETARGET
if [ $RET_CONFLICT -ge 30 ]; then
   print_vars $API_NAME $TARGET $BUILD_TYPE $SHARED_LIBS $CLEAN_OR_OUT $PKGTYPE $MAKETARGET
   exit $RET_CONFLICT
fi


clean_rocm_cmake() {
    rm -rf $ROCM_CMAKE_BUILD_DIR
    rm -rf $ROCM_CMAKE_PACKAGE_DEB
    rm -rf $ROCM_CMAKE_PACKAGE_RPM
}

build_rocm_cmake() {
    echo "Building ROCm cmake"

    if [ ! -d "$ROCM_CMAKE_BUILD_DIR" ]; then
        mkdir -p "$ROCM_CMAKE_BUILD_DIR"
        pushd "$ROCM_CMAKE_BUILD_DIR"

        cmake \
            $(rocm_cmake_params) \
            -DCPACK_SET_DESTDIR="OFF" \
            -DROCM_DISABLE_LDCONFIG=ON \
            $ROCM_CMAKE_ROOT
        cmake --build . -- install
        cmake --build . -- package
        popd
    fi

    copy_if DEB "${CPACKGEN:-"DEB;RPM"}" "$ROCM_CMAKE_PACKAGE_DEB" $ROCM_CMAKE_BUILD_DIR/rocm-cmake*.deb
    copy_if RPM "${CPACKGEN:-"DEB;RPM"}" "$ROCM_CMAKE_PACKAGE_RPM" $ROCM_CMAKE_BUILD_DIR/rocm-cmake*.rpm
}

print_output_directory() {
    case ${PKGTYPE} in
        ("deb")
            echo ${ROCM_CMAKE_PACKAGE_DEB};;
        ("rpm")
            echo ${ROCM_CMAKE_PACKAGE_RPM};;
        (*)
            echo "Invalid package type \"${PKGTYPE}\" provided for -o" >&2; exit 1;;
    esac
    exit
}

case $TARGET in
    (clean) clean_rocm_cmake ;;
    (build) build_rocm_cmake ;;
    (outdir) print_output_directory ;;
    (*) die "Invalid target $TARGET" ;;
esac

echo "Operation complete"
