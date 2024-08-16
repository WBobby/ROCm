#!/bin/bash

set -ex
source "$(dirname "${BASH_SOURCE[0]}")/compute_helper.sh"

set_component_src rocAL

build_rocal() {

    if [ "$DISTRO_ID" = "mariner-2.0" ] ; then
     echo "Not building rocal for ${DISTRO_ID}. Exiting..."
     return 0
    fi

    echo "Start build"

    # Enable ASAN
    if [ "${ENABLE_ADDRESS_SANITIZER}" == "true" ]; then
        set_asan_env_vars
        set_address_sanitizer_on
    fi

    mkdir -p $BUILD_DIR && cd $BUILD_DIR

    python3 ${COMPONENT_SRC}/rocAL-setup.py

    cmake -DAMDRPP_PATH=$ROCM_PATH ${COMPONENT_SRC}
    make -j${PROC}
    cmake --build . --target PyPackageInstall
    sudo make install
    sudo make package
    sudo chown -R $(id -u):$(id -g) ${BUILD_DIR}

    rm -rf _CPack_Packages/ && find -name '*.o' -delete
    mkdir -p $PACKAGE_DIR
    cp ${BUILD_DIR}/*.${PKGTYPE} $PACKAGE_DIR
    show_build_cache_stats
}

clean_rocal() {
    echo "Cleaning rocAL build directory: ${BUILD_DIR} ${PACKAGE_DIR}"
    rm -rf "$BUILD_DIR" "$PACKAGE_DIR"
    echo "Done!"
}

stage2_command_args "$@"

case $TARGET in
    build) build_rocal ;;
    outdir) print_output_directory ;;
    clean) clean_rocal ;;
    *) die "Invalid target $TARGET" ;;
esac
