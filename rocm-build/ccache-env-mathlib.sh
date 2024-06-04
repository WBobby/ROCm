#!/bin/bash

# set ccache environment variable for math libraries
if [ "${CCACHE_ENABLED}" == "true" ] && [ -f "${OUT_DIR}"/logs/lightning ]; then
    export LAUNCHER_FLAGS="-DCMAKE_CXX_COMPILER_LAUNCHER=/usr/local/bin/ccache -DCMAKE_C_COMPILER_LAUNCHER=/usr/local/bin/ccache"
    export CCACHE_IGNOREHEADERS=${ROCM_PATH}/include:${ROCM_PATH}/llvm/include:${ROCM_PATH}/lib/llvm/lib/clang/17/include:${ROCM_PATH}/lib/llvm/include
    export CCACHE_COMPILERCHECK=none
    export CCACHE_EXTRAFILES=${OUT_DIR}/rocm_compilers_hash_file
fi
