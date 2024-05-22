#!/bin/bash

set -x


UNTAR_COMPONENT_NAME=$1


copy_pkg_files_to_rocm() {
    local comp_folder=$1
    local comp_pkg_name=$2

    cd "${OUT_DIR}/${PKGTYPE}/${comp_folder}"|| exit 2
    if [ "${PKGTYPE}" = 'deb' ]; then
        dpkg-deb -x ${comp_pkg_name}_*.deb pkg/
    else
        mkdir pkg && pushd pkg/ || exit 2
        if [[ "${comp_pkg_name}" != *-dev* ]]; then
            rpm2cpio ../${comp_pkg_name}-*.rpm | cpio -idmv
        else
            rpm2cpio ../${comp_pkg_name}el-*.rpm | cpio -idmv
        fi
        popd || exit 2
    fi
    ls ./pkg -alt
    ${SUDO} cp -r ./pkg${ROCM_PATH}/* "${ROCM_PATH}" || exit 2
    rm -rf pkg/
}

get_os_name() {
    local os_name
    os_name=$(grep -oP '^NAME="\K.*(?=")' < /etc/os-release)
    echo "${os_name,,}"
}

set_pkg_type() {
    local os_name
    os_name=$(grep -oP '^NAME="\K.*(?=")' < /etc/os-release)
    [ "${os_name,,}" = ubuntu ] && echo "deb" || echo "rpm"
}

setup_rocm_compilers_hash_file() {
    local clang_version
    clang_version="$("${ROCM_PATH}/llvm/bin/clang" --version | head -n 1)"
    printf '%s: %s\n' 'clang version' "${clang_version}" | tee "${OUT_DIR}/rocm_compilers_hash_file"
}

PKGTYPE=$(set_pkg_type)

case $UNTAR_COMPONENT_NAME in
    (lightning)
        if [ "${CCACHE_ENABLED}" == "true" ] ; then
            setup_rocm_compilers_hash_file
        fi

        mkdir -p ${ROCM_PATH}/bin
        printf '%s\n' > ${ROCM_PATH}/bin/target.lst gfx900 gfx906 gfx908 gfx803 gfx1030

        if [ -e "${ROCM_PATH}/lib/llvm/bin/rocm.cfg" ]; then
            sed -i '/-frtlib-add-rpath/d' ${ROCM_PATH}/lib/llvm/bin/rocm.cfg
        elif [ -e "${ROCM_PATH}/llvm/bin/rocm.cfg" ]; then
            sed -i '/-frtlib-add-rpath/d' ${ROCM_PATH}/llvm/bin/rocm.cfg
        fi
        ;;
    (hipify_clang)
        copy_pkg_files_to_rocm hipify hipify-clang
        ;;
    (hip_on_rocclr)
        rm -f ${ROCM_PATH}/bin/hipcc.bat
        ;;
    (openmp_extras)
        copy_pkg_files_to_rocm openmp-extras openmp-extras-runtime
        copy_pkg_files_to_rocm openmp-extras openmp-extras-dev
        ;;
    (rocblas)
        copy_pkg_files_to_rocm rocblas rocblas-dev
        ;;
    (*)
        echo "post processing is not required for ${UNTAR_COMPONENT_NAME}"
        ;;
esac

