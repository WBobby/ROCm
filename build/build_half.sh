#!/bin/bash

set -ex
source "$(dirname "${BASH_SOURCE[0]}")/compute_helper.sh"

set_component_src half

build_half() {
    echo "Start build"

    if [ "${ENABLE_ADDRESS_SANITIZER}" == "true" ]; then
         set_asan_env_vars
         set_address_sanitizer_on
         ASAN_CMAKE_PARAMS="false"
    fi
    mkdir -p "$BUILD_DIR" && cd "$BUILD_DIR"

    cmake \
        -DCMAKE_INSTALL_PREFIX="$ROCM_PATH" \
        -DBUILD_FILE_REORG_BACKWARD_COMPATIBILITY=OFF \
        "$COMPONENT_SRC"

    cmake --build "$BUILD_DIR" -- -j${PROC}
    cmake --build "$BUILD_DIR" -- package
    cmake --build "$BUILD_DIR" -- install

    rm -rf _CPack_Packages/ && find -name '*.o' -delete
    mkdir -p $PACKAGE_DIR && cp ${BUILD_DIR}/*.${PKGTYPE} $PACKAGE_DIR

    show_build_cache_stats
}

clean_half() {
    echo "Cleaning half build directory: ${BUILD_DIR} ${PACKAGE_DIR}"
    rm -rf "$BUILD_DIR" "$PACKAGE_DIR"
    echo "Done!"
}

stage2_command_args "$@"

case $TARGET in
    build) build_half ;;
    outdir) print_output_directory ;;
    clean) clean_half ;;
    *) die "Invalid target $TARGET" ;;
esac
