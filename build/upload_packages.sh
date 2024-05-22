#!/bin/bash

set -x


BUILD_COMPONENT="$1"
PACKAGEEXT=${PACKAGEEXT:-$2}

COMP_DIR=$(./${INFRA_REPO}/build/build_${BUILD_COMPONENT}.sh -o ${PACKAGEEXT})

TARGET_ARTI_URL=${TARGET_ARTI_URL:-$3}


[ -z "$JFROG_TOKEN" ] && echo "JFrog token is not set, skip uploading..." && exit 0
[ -z "$TARGET_ARTI_URL" ] && echo "Target URL is not set, skip uploading..." && exit 0
[ -z "$COMP_DIR" ] && echo "No packages in ${BUILD_COMPONENT}" && exit 0
[ ! -d "$COMP_DIR" ] && echo "NO ${COMP_DIR} folder..." && exit 0

PKG_NAME_LIST=( "${COMP_DIR}"/* )

for pkg in "${PKG_NAME_LIST[@]}"; do
    if [[ "${ENABLE_ADDRESS_SANITIZER}" != "true" ]] || [[ "${pkg##*/}" =~ "-asan" ]]; then
        echo "Uploading $pkg ..."
        if ! curl -f -H "X-JFrog-Art-Api:${JFROG_TOKEN}" \
                -X PUT "${TARGET_ARTI_URL}/$(basename ${pkg})" \
                -T "${COMP_DIR}/$(basename ${pkg})"; then
            echo "Unable to upload $pkg ..." >&2 && exit 1
        fi
        echo "$pkg uploaded..."
    fi
done

