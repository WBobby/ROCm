#!/bin/bash

source "$(dirname "${BASH_SOURCE}")/compute_utils.sh"

printUsage() {
    echo
    echo "Usage: $(basename "${BASH_SOURCE}") [options ...]"
    echo
    echo "Options:"
    echo "  -c,  --clean              Clean output and delete all intermediate work"
    echo "  -p,  --package <type>     Specify packaging format"
    echo "  -r,  --release            Make a release build instead of a debug build"
    echo "  -a,  --address_sanitizer  Enable address sanitizer"
    echo "  -o,  --outdir <pkg_type>  Print path of output directory containing packages of type referred to by pkg_type"
    echo "  -h,  --help               Prints this help"
    echo
    echo "Possible values for <type>:"
    echo "  deb -> Debian format (default)"
    echo "  rpm -> RPM format"
    echo

    return 0
}

PACKAGE_ROOT="$(getPackageRoot)"
PACKAGE_DEB="$(getPackageRoot)/deb/libhsakmt"
PACKAGE_RPM="$(getPackageRoot)/rpm/libhsakmt"
THUNK_BUILD_DIR="$(getBuildPath thunk)"
TARGET="build"
MAKETARGET="deb"
MAKEARG="$DASH_JAY O=$THUNK_BUILD_DIR"
PACKAGE_LIB="$(getLibPath)"
PACKAGE_INCLUDE="$(getIncludePath)"

ROCT_BUILD_DIR="$(getBuildPath roct)"
ROCT_PACKAGE_DEB="$(getPackageRoot)/deb/roct"
ROCT_PACKAGE_RPM="$(getPackageRoot)/rpm/roct"
ROCT_BUILD_TYPE="debug"
BUILD_TYPE="Debug"
ROCT_MAKE_OPTS="$DASH_JAY -C $ROCT_BUILD_DIR"
CLEAN_OR_OUT=0;

print_vars() {
echo " Var status thunk "
echo "TARGET= $TARGET"
echo "BUILD_TYPE = $BUILD_TYPE"
echo "MAKETARGE = $MAKETARGET"
echo "CLEAN_OR_OUT = $CLEAN_OR_OUT"
echo "PKGTYPE= $PKGTYPE"
}

check_conflicting_options() {

    if [ "$MAKETARGET" != "deb" ] && [ "$MAKETARGET" != "rpm" ] && [ "$MAKETARGET" != "tar" ]; then
       echo " Wrong Param Passed for Package Type.  Aborting .. "
       print_vars
       exit 30
    fi

    if [ $CLEAN_OR_OUT -ge 2 ]; then
       if [ "$PKGTYPE" != "deb" ] && [ "$PKGTYPE" != "rpm" ] && [ "$PKGTYPE" != "tar" ]; then
          echo " Wrong Param Passed for Package Type for the Outdir.  Aborting .. "
          print_vars
          exit 40
       fi
    fi

    if [ $CLEAN_OR_OUT -ge 3 ]; then
       echo " Clean & Out Both are sepcified.  Not accepted. Bailing .. "
       exit 50
    fi
}

VALID_STR=`getopt -o hcraso:p: --long help,clean,release,address_sanitizer,clean,outdir:,package: -- "$@"`
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
                set_address_sanitizer_on ; shift ;;
	(-s)
	       	shift ;; # Static build requested, NO-OP for this package. Required for static Jenkins builds
        (-o | --outdir)
                TARGET="outdir"; PKGTYPE=$2 ; OUT_DIR_SPECIFIED=1 ; ((CLEAN_OR_OUT|=2)) ; shift 2 ;;
        (-p | --package)
                MAKETARGET="$2" ; shift 2;;
        --)     shift; break;;
        (*)
                echo " This should never come but just incase : UNEXPECTED ERROR Parm : [$1] ">&2 ; exit 20;;
    esac

done

check_conflicting_options


clean_roct() {
    rm -rf "$ROCT_BUILD_DIR"
    rm -rf "$ROCT_PACKAGE_DEB"
    rm -rf "$ROCT_PACKAGE_RPM"
    rm -rf "$PACKAGE_ROOT/libhsakmt"
    rm -rf "$PACKAGE_INCLUDE/libhsakmt"
    rm -f $PACKAGE_LIB/libhsakmt.so*
    rm -f $PACKAGE_LIB/libhsakmt.a
    rm -f $PACKAGE_INCLUDE/hsakmt*.h $PACKAGE_INCLUDE/linux/kfd_ioctl.h
}

build_roct() {
    echo "Building ROCt"

    rm -f $ROCT_BUILD_DIR/hsakmt-roct*.deb
    rm -f $ROCT_BUILD_DIR/hsakmt-roct-dev/hsakmt-roct*.deb
    rm -f "$ROCT_PACKAGE_DEB"/*

    rm -f $ROCT_BUILD_DIR/hsakmt-roct*.rpm
    rm -f $ROCT_BUILD_DIR/hsakmt-roct-dev/hsakmt-roct*.rpm
    rm -f "$ROCT_PACKAGE_RPM"/*

    if [ "${DISTRO_ID}" = "centos-7" ]; then
        libdrm_cmake_var="-DHSAKMT_REQUIRES_LIBDRM=true"
    fi

    if [ ! -d "$ROCT_BUILD_DIR" ]; then
        mkdir -p "$ROCT_BUILD_DIR"
        pushd "$ROCT_BUILD_DIR"

        cmake \
            -DCMAKE_MODULE_PATH="$THUNK_ROOT/cmake_modules" \
            -DBUILD_SHARED_LIBS="OFF" \
	        $(rocm_cmake_params) \
	    $(rocm_common_cmake_params) \
            -DHSAKMT_INSTALL_PREFIX="$PACKAGE_ROOT" \
            -DHSAKMT_INSTALL_LIBDIR="$PACKAGE_LIB" \
            -DHSAKMT_PACKAGING_INSTALL_PREFIX="$ROCM_PATH" \
            -DENABLE_LDCONFIG=OFF \
            -DHSAKMT_WERROR=1 \
            -DADDRESS_SANITIZER="$ADDRESS_SANITIZER" \
            $libdrm_cmake_var \
            "$THUNK_ROOT"
        popd
    fi
    cmake --build "$ROCT_BUILD_DIR" -- $ROCT_MAKE_OPTS
    cmake --build "$ROCT_BUILD_DIR" -- $ROCT_MAKE_OPTS install
    cmake --build "$ROCT_BUILD_DIR" -- $ROCT_MAKE_OPTS package

    if [ -e "$THUNK_ROOT/hsakmt-dev.txt" ]; then
        cmake --build "$ROCT_BUILD_DIR" -- $ROCT_MAKE_OPTS install-dev
        cmake --build "$ROCT_BUILD_DIR" -- $ROCT_MAKE_OPTS package-dev
    fi

    mkdir -p "$PACKAGE_LIB"
    if [ -e "$ROCT_BUILD_DIR/libhsakmt.so" ]; then
        cp -R "$ROCT_BUILD_DIR/libhsakmt.so"* "$PACKAGE_LIB"
    fi
    if [ -e "$ROCT_BUILD_DIR/libhsakmt.a" ]; then
        cp -R "$ROCT_BUILD_DIR/libhsakmt.a" "$PACKAGE_LIB"
    fi

    mkdir -p "$ROCT_PACKAGE_DEB"
    if [[ "${CPACKGEN:-"DEB;RPM"}" =~ "DEB" ]] ; then
        cp -a $ROCT_BUILD_DIR/hsakmt*.deb "$ROCT_PACKAGE_DEB"
        if [ -e "$THUNK_ROOT/hsakmt-dev.txt" ]; then
            cp -a $ROCT_BUILD_DIR/hsakmt-roct-dev/hsakmt-roct*.deb "$ROCT_PACKAGE_DEB"
        fi
    fi

    mkdir -p "$ROCT_PACKAGE_RPM"
    if [[ "${CPACKGEN:-"DEB;RPM"}" =~ "RPM" ]] ; then
        cp -a $ROCT_BUILD_DIR/hsakmt*.rpm "$ROCT_PACKAGE_RPM"
        if [ -e "$THUNK_ROOT/hsakmt-dev.txt" ]; then
            cp -a $ROCT_BUILD_DIR/hsakmt-roct-dev/hsakmt-roct*.rpm "$ROCT_PACKAGE_RPM"
        fi
    fi
}

print_output_directory() {
    case ${PKGTYPE} in
        ("deb")
            echo ${ROCT_PACKAGE_DEB};;
        ("rpm")
            echo ${ROCT_PACKAGE_RPM};;
        (*)
            echo "Invalid package type \"${PKGTYPE}\" provided for -o" >&2; exit 1;;
    esac
    exit
}

verifyEnvSetup

case $TARGET in
    (clean) clean_roct ;;
    (build) build_roct ;;
    (outdir) print_output_directory ;;
    (*) die "Invalid target $TARGET" ;;
esac

echo "Operation complete"
