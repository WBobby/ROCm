#!/bin/bash

set -ex

source "$(dirname "${BASH_SOURCE[0]}")/compute_helper.sh"

set_component_src hipCUB

build_hipcub() {
    echo "Start build"

    cd $COMPONENT_SRC
    if [ "${ENABLE_ADDRESS_SANITIZER}" == "true" ]; then
         set_asan_env_vars
         set_address_sanitizer_on
         ASAN_CMAKE_PARAMS="false"
    fi

    mkdir -p "$BUILD_DIR" && cd "$BUILD_DIR"

    if [ -n "$GPU_ARCHS" ]; then
        GPU_TARGETS="$GPU_ARCHS"
    else
        GPU_TARGETS="gfx908:xnack-;gfx90a:xnack-;gfx90a:xnack+;gfx940;gfx941;gfx942;gfx1030;gfx1100;gfx1101"
    fi

    CXX=$(set_build_variables CXX)\
    cmake \
        ${LAUNCHER_FLAGS} \
        $(rocm_common_cmake_params) \
        -DCMAKE_MODULE_PATH="${ROCM_PATH}/lib/cmake/hip;${ROCM_PATH}/hip/cmake" \
        -Drocprim_DIR="${ROCM_PATH}/rocprim"  \
        -DBUILD_TEST=ON \
        -DAMDGPU_TARGETS=${GPU_TARGETS} \
        "$COMPONENT_SRC"

    cmake --build "$BUILD_DIR" -- -j${PROC}
    cmake --build "$BUILD_DIR" -- install
    cmake --build "$BUILD_DIR" -- package

    rm -rf _CPack_Packages/ && find -name '*.o' -delete
    mkdir -p $PACKAGE_DIR && cp ${BUILD_DIR}/*.${PKGTYPE} $PACKAGE_DIR

    show_build_cache_stats
}

clean_hipcub() {
    echo "Cleaning hipCUB build directory: ${BUILD_DIR} ${PACKAGE_DIR}"
    rm -rf "$BUILD_DIR" "$PACKAGE_DIR"
    echo "Done!"
}

stage2_command_args "$@"

case $TARGET in
    build) build_hipcub ;;
    outdir) print_output_directory ;;
    clean) clean_hipcub ;;
    *) die "Invalid target $TARGET" ;;
esac
