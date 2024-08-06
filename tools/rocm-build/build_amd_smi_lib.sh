#!/bin/bash

source "$(dirname "${BASH_SOURCE}")/compute_utils.sh"

printUsage() {
    echo
    echo "Usage: $(basename "${BASH_SOURCE}") [-c|-r|-h] [makeopts]"
    echo
    echo "Options:"
    echo "  -c,  --clean              Removes all amd_smi build artifacts"
    echo "  -r,  --release            Build non-debug version amd_smi (default is debug)"
    echo "  -a,  --address_sanitizer  Enable address sanitizer"
    echo "  -s,  --static             Component/Build does not support static builds just accepting this param & ignore. No effect of the param on this build"
    echo "  -w,  --wheel              Creates python wheel package of amd-smi. 
                                      It needs to be used along with -r option"
    echo "  -o,  --outdir <pkg_type>  Print path of output directory containing packages of type referred to by pkg_type"
    echo "  -p,  --package <type>     Specify packaging format"
    echo "  -h,  --help               Prints this help"
    echo "Possible values for <type>:"
    echo "  deb -> Debian format (default)"
    echo "  rpm -> RPM format"
    echo

    return 0
}

# AMD_SMI
PACKAGE_ROOT="$(getPackageRoot)"
TARGET="build"

PACKAGE_LIB=$(getLibPath)
PACKAGE_INCLUDE="$(getIncludePath)"

# AMDSMI
AMDSMI_BUILD_DIR=$(getBuildPath amdsmi)
AMDSMI_PACKAGE_DEB_DIR="$(getPackageRoot)/deb/amdsmi"
AMDSMI_PACKAGE_RPM_DIR="$(getPackageRoot)/rpm/amdsmi"
ROCM_WHEEL_DIR="${AMDSMI_BUILD_DIR}/_wheel"
AMDSMI_BUILD_TYPE="debug"
BUILD_TYPE="Debug"

# BUILD ARGUMENTS
MAKETARGET="deb"
MAKEARG="$DASH_JAY O=$AMDSMI_BUILD_DIR"
AMDSMI_MAKE_OPTS="$DASH_JAY O=$AMDSMI_BUILD_DIR -C $AMDSMI_BUILD_DIR"
AMDSMI_PKG_NAME="amd-smi-lib"
SHARED_LIBS="ON"
CLEAN_OR_OUT=0;
PKGTYPE="deb"

#parse the arguments
VALID_STR=`getopt -o hcraswo:p: --long help,clean,release,static,wheel,address_sanitizer,outdir:,package: -- "$@"`
eval set -- "$VALID_STR"

while true ;
do
    case "$1" in
        (-h | --help)
                printUsage ; exit 0;;
        (-c | --clean)
                TARGET="clean" ; ((CLEAN_OR_OUT|=1)) ; shift ;;
        (-r | --release)
                BUILD_TYPE="RelWithDebInfo" ; shift ;;
        (-a | --address_sanitizer)
                set_asan_env_vars
                set_address_sanitizer_on
                # TODO - support standard option of passing cmake environment vars - CFLAGS,CXXFLAGS etc., to enable address sanitizer
                ADDRESS_SANITIZER=true ; shift ;;
        (-s | --static)
                echo "-s parameter accepted but ignored" ; shift ;;
        (-w | --wheel)
                WHEEL_PACKAGE=true ; shift ;;
        (-o | --outdir)
                TARGET="outdir"; PKGTYPE=$2 ; OUT_DIR_SPECIFIED=1 ; ((CLEAN_OR_OUT|=2)) ; shift 2 ;;
        (-p | --package)
                MAKETARGET="$2" ; shift 2;;
        --)     shift; break;; # end delimiter
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

clean_amdsmi() {
    rm -rf "$ROCM_WHEEL_DIR"
    rm -rf "$AMDSMI_BUILD_DIR"
    rm -rf "$AMDSMI_PACKAGE_DEB_DIR"
    rm -rf "$AMDSMI_PACKAGE_RPM_DIR"
    rm -rf "$PACKAGE_ROOT/amd_smi"
    rm -rf "$PACKAGE_INCLUDE/amd_smi"
    rm -f $PACKAGE_LIB/libamd_smi.*
    return 0
}

build_amdsmi() {
    echo "Building AMDSMI"
    echo "AMDSMI_BUILD_DIR: ${AMDSMI_BUILD_DIR}"
    if [ ! -d "$AMDSMI_BUILD_DIR" ]; then
        mkdir -p $AMDSMI_BUILD_DIR
        pushd $AMDSMI_BUILD_DIR
        print_lib_type $SHARED_LIBS
        cmake \
            -DBUILD_SHARED_LIBS=$SHARED_LIBS \
            $(rocm_common_cmake_params) \
            $(rocm_cmake_params) \
            -DENABLE_LDCONFIG=OFF \
            -DAMD_SMI_PACKAGE="${AMDSMI_PKG_NAME}" \
            -DCPACK_PACKAGE_VERSION_MAJOR="1" \
            -DCPACK_PACKAGE_VERSION_MINOR="$ROCM_LIBPATCH_VERSION" \
            -DCPACK_PACKAGE_VERSION_PATCH="0" \
            -DADDRESS_SANITIZER="$ADDRESS_SANITIZER" \
            -DBUILD_TESTS=ON \
            "$AMD_SMI_LIB_ROOT"
        popd
    fi

    echo "Making amd_smi package:"
    cmake --build "$AMDSMI_BUILD_DIR" -- $AMDSMI_MAKE_OPTS
    cmake --build "$AMDSMI_BUILD_DIR" -- $AMDSMI_MAKE_OPTS install
    cmake --build "$AMDSMI_BUILD_DIR" -- $AMDSMI_MAKE_OPTS package

    copy_if DEB "${CPACKGEN:-"DEB;RPM"}" "$AMDSMI_PACKAGE_DEB_DIR" $AMDSMI_BUILD_DIR/*.deb
    copy_if RPM "${CPACKGEN:-"DEB;RPM"}" "$AMDSMI_PACKAGE_RPM_DIR" $AMDSMI_BUILD_DIR/*.rpm
}

create_wheel_package() {
    echo "Creating amd smi wheel package"
    # Copy the setup.py generator to build folder
    mkdir -p $ROCM_WHEEL_DIR
    cp -f $SCRIPT_ROOT/generate_setup_py.py $ROCM_WHEEL_DIR
    cp -f $SCRIPT_ROOT/repackage_wheel.sh $ROCM_WHEEL_DIR
    cd $ROCM_WHEEL_DIR
    # Currently only supports python3.6
    ./repackage_wheel.sh $AMDSMI_BUILD_DIR/*.rpm python3.6
    copy_if WHL "WHL" "$AMDSMI_PACKAGE_RPM_DIR" "$ROCM_WHEEL_DIR"/dist/*.whl
}

print_output_directory() {
    case ${PKGTYPE} in
        ("deb")
            echo ${AMDSMI_PACKAGE_DEB_DIR};;
        ("rpm")
            echo ${AMDSMI_PACKAGE_RPM_DIR};;
        (*)
            echo "Invalid package type \"${PKGTYPE}\" provided for -o" >&2; exit 1;;
    esac
    exit
}

verifyEnvSetup

case $TARGET in
    (clean) clean_amdsmi ;;
    (build) build_amdsmi ;;
    (outdir) print_output_directory ;;
    (*) die "Invalid target $TARGET" ;;
esac

if [[ $WHEEL_PACKAGE == true ]]; then
    echo "Wheel Package build started !!!!"
    create_wheel_package
fi

echo "Operation complete"
exit 0
