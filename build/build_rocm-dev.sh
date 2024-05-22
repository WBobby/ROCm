#!/bin/bash

set -ex

source "$(dirname "${BASH_SOURCE[0]}")/compute_helper.sh"

stage2_command_args "$@"

case $TARGET in
    build) echo "end of rocm-dev build..." ;;
    outdir) ;;
    clean) echo "Cleaning rocm-dev is not required..." ;;
    *) die "Invalid target $TARGET" ;;
esac
