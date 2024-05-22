#!/bin/bash

set -ex

source "$(dirname "${BASH_SOURCE[0]}")/compute_helper.sh"

set_component_src rocSOLVER

build_rocsolver() {
    echo "Start build"

    cd $COMPONENT_SRC

    if [ "${ENABLE_ADDRESS_SANITIZER}" == "true" ]; then
       set_asan_env_vars
       set_address_sanitizer_on
    fi

    mkdir -p "$BUILD_DIR" && cd "$BUILD_DIR"

    if [ "${ENABLE_ADDRESS_SANITIZER}" == "true" ]; then
       rebuild_lapack
    fi

    if [ -n "$GPU_ARCHS" ]; then
        GPU_TARGETS="$GPU_ARCHS"
    else
        GPU_TARGETS="gfx908:xnack-;gfx90a:xnack-;gfx90a:xnack+;gfx940;gfx941;gfx942;gfx1030;gfx1100;gfx1101"
    fi

    CXX="${ROCM_PATH}/bin/hipcc" \
    cmake \
        -DCPACK_SET_DESTDIR=OFF \
        ${LAUNCHER_FLAGS} \
        $(rocm_common_cmake_params) \
        -Drocblas_DIR="${ROCM_PATH}/rocblas/lib/cmake/rocblas" \
        -DAMDGPU_TARGETS=${GPU_TARGETS} \
        -DBUILD_CLIENTS_TESTS=ON \
        -DBUILD_ADDRESS_SANITIZER="${ADDRESS_SANITIZER}" \
        -DBUILD_CLIENTS_BENCHMARKS=ON \
        -DBUILD_CLIENTS_SAMPLES=ON \
        -DBUILD_TESTING=ON \
        -DBUILD_CLIENTS_EXTRA_TESTS=ON \
        "$COMPONENT_SRC"

    cmake --build "$BUILD_DIR" -- -j${PROC}
    cmake --build "$BUILD_DIR" -- install
    cmake --build "$BUILD_DIR" -- package

    rm -rf _CPack_Packages/ && find -name '*.o' -delete
    mkdir $PACKAGE_DIR && cp ${BUILD_DIR}/*.${PKGTYPE} $PACKAGE_DIR

    show_build_cache_stats
}

clean_rocsolver() {
    echo "Cleaning rocSOLVER build directory: ${BUILD_DIR} ${PACKAGE_DIR}"
    rm -rf "$BUILD_DIR" "$PACKAGE_DIR"
    echo "Done!"
}

stage2_command_args "$@"

case $TARGET in
    build) build_rocsolver ;;
    outdir) print_output_directory ;;
    clean) clean_rocsolver ;;
    *) die "Invalid target $TARGET" ;;
esac
