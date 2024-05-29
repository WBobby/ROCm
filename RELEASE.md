# ROCm 6.1.1 release notes

<!-- Disable lints since this is an auto-generated file.    -->
<!-- markdownlint-disable blanks-around-headers             -->
<!-- markdownlint-disable no-duplicate-header               -->
<!-- markdownlint-disable no-blanks-blockquote              -->
<!-- markdownlint-disable ul-indent                         -->
<!-- markdownlint-disable no-trailing-spaces                -->

<!-- spellcheck-disable -->

ROCm™ 6.1.1 introduces minor fixes and improvements to some tools and libraries.

## OS support

ROCm 6.1.1 has been tested against a pre-release version of Ubuntu 22.04.5 (kernel: 5.15 [GA], 6.8 [HWE]).

## AMD SMI

AMD SMI for ROCm 6.1.1

### Additions

- Added deferred error correctable counts to `amd-smi metric -ecc -ecc-blocks`.

### Changes

- Updated the output of `amd-smi metric --ecc-blocks` to show counters available from blocks.
- Updated the output of `amd-smi metric --clock` to reflect each engine.
- Updated the output of `amd-smi topology --json` to align with output reported by host and guest systems.

### Fixes

- Fixed `amd-smi metric --clock`'s clock lock and deep sleep status.
- Fixed an issue that would cause an error when resetting non-AMD GPUs.
- Fixed `amd-smi metric --pcie` and `amdsmi_get_pcie_info()` when using RDNA3 (Navi 32 and Navi 31) hardware to prevent "UNKNOWN" reports.
- Fixed the output results of `amd-smi process` when getting processes running on a device.

### Removals

- Removed the `amdsmi_get_gpu_process_info` API from the Python library. It was removed from the C library in an earlier release.

### Known issues

- `amd-smi bad-pages` can result in a `ValueError: Null pointer access` error when using some PMU firmware versions.

```{note}
See the [detailed changelog](https://github.com/ROCm/amdsmi/blob/docs/6.1.1/CHANGELOG.md) with code samples for more information.
```

## HIPCC

HIPCC for ROCm 6.1.1

### Changes

- **Upcoming:** a future release will enable use of compiled binaries `hipcc.bin` and `hipconfig.bin` by default. No action is needed by users. You can continue calling high-level Perl scripts `hipcc` and `hipconfig`. `hipcc.bin` and `hipconfig.bin` will be invoked by the high-level Perl scripts. To revert to the previous behavior and invoke `hipcc.pl` and `hipconfig.pl`, set the `HIP_USE_PERL_SCRIPTS` environment variable to `1`.
- **Upcoming:** a subsequent release will remove high-level Perl scripts `hipcc` and `hipconfig`. This release will remove the `HIP_USE_PERL_SCRIPTS` environment variable. It will rename `hipcc.bin` and `hipconfig.bin` to `hipcc` and `hipconfig` respectively. No action is needed by the users. To revert to the previous behavior, invoke `hipcc.pl` and `hipconfig.pl` explicitly.
- **Upcoming:** a subsequent release will remove `hipcc.pl` and `hipconfig.pl`.

## ROCm SMI

ROCm SMI for ROCm 6.1.1

### Additions

* Added the capability to unlock mutex when a process is dead. Added related debug output.
* Added the `Partition ID` field to the `rocm-smi` CLI.
* Added `NODE`, `GUID`, and `GFX Version` fields to the CLI.
* Documentation now includes C++ and Python tutorials, API guides, and reference material.

### Changes

* Some `rocm-smi` fields now display `N/A` instead of `unknown/unsupported` for consistency.
* Changed stacked ID formatting in the `rocm-smi` CLI to make it easier to spot identifiers.

### Fixes

* Fixed HIP and ROCm SMI mismatch on GPU bus assignments.
* Fixed memory leaks caused by not closing directories and creating maps nodes instead of using `.at()`.
* Fixed initializing calls which reuse `rocmsmi.initializeRsmi()` bindings in the `rocmsmi` Python API.
* Fixed an issue causing `rsmi_dev_activity_metric_get` gfx/memory to not update with GPU activity.

### Known issues

- ROCm SMI reports GPU utilization incorrectly for RDNA3 GPUs in some situations. See the issue on [GitHub](https://github.com/ROCm/ROCm/issues/3112).

```{note}
See the [detailed ROCm SMI changelog](https://github.com/ROCm/rocm_smi_lib/blob/docs/6.1.1/CHANGELOG.md) with code samples for more information.
```

## Library changes in ROCm 6.1.1

| Library     | Version                                                                    |
| ----------- | -------------------------------------------------------------------------- |
| AMDMIGraphX | [2.9](https://github.com/ROCm/AMDMIGraphX/releases/tag/rocm-6.1.1)         |
| hipBLAS     | [2.1.0](https://github.com/ROCm/hipBLAS/releases/tag/rocm-6.1.1)           |
| hipBLASLt   | [0.7.0](https://github.com/ROCm/hipBLASLt/releases/tag/rocm-6.1.1)         |
| hipCUB      | [3.1.0](https://github.com/ROCm/hipCUB/releases/tag/rocm-6.1.1)            |
| hipFFT      | [1.0.14](https://github.com/ROCm/hipFFT/releases/tag/rocm-6.1.1)           |
| hipRAND     | [2.10.17](https://github.com/ROCm/hipRAND/releases/tag/rocm-6.1.1)         |
| hipSOLVER   | 2.1.0 ⇒ [2.1.1](https://github.com/ROCm/hipSOLVER/releases/tag/rocm-6.1.1) |
| hipSPARSE   | [3.0.1](https://github.com/ROCm/hipSPARSE/releases/tag/rocm-6.1.1)         |
| hipSPARSELt | [0.2.0](https://github.com/ROCm/hipSPARSELt/releases/tag/rocm-6.1.1)       |
| hipTensor   | [1.2.0](https://github.com/ROCm/hipTensor/releases/tag/rocm-6.1.1)         |
| MIOpen      | [3.1.0](https://github.com/ROCm/MIOpen/releases/tag/rocm-6.1.1)            |
| MIVisionX   | [2.5.0](https://github.com/ROCm/MIVisionX/releases/tag/rocm-6.1.1)         |
| rccl        | [2.18.6](https://github.com/ROCm/rccl/releases/tag/rocm-6.1.1)             |
| rocALUTION  | [3.1.1](https://github.com/ROCm/rocALUTION/releases/tag/rocm-6.1.1)        |
| rocBLAS     | [4.1.0](https://github.com/ROCm/rocBLAS/releases/tag/rocm-6.1.1)           |
| rocDecode   | [0.5.0](https://github.com/ROCm/rocDecode/releases/tag/rocm-6.1.1)         |
| rocFFT      | 1.0.26 ⇒ [1.0.27](https://github.com/ROCm/rocFFT/releases/tag/rocm-6.1.1)  |
| rocm-cmake  | [0.12.0](https://github.com/ROCm/rocm-cmake/releases/tag/rocm-6.1.1)       |
| rocPRIM     | [3.1.0](https://github.com/ROCm/rocPRIM/releases/tag/rocm-6.1.1)           |
| rocRAND     | [3.0.1](https://github.com/ROCm/rocRAND/releases/tag/rocm-6.1.1)           |
| rocSOLVER   | [3.25.0](https://github.com/ROCm/rocSOLVER/releases/tag/rocm-6.1.1)        |
| rocSPARSE   | [3.1.2](https://github.com/ROCm/rocSPARSE/releases/tag/rocm-6.1.1)         |
| rocThrust   | [3.0.1](https://github.com/ROCm/rocThrust/releases/tag/rocm-6.1.1)         |
| rocWMMA     | [1.4.0](https://github.com/ROCm/rocWMMA/releases/tag/rocm-6.1.1)           |
| rpp         | [1.5.0](https://github.com/ROCm/rpp/releases/tag/rocm-6.1.1)               |
| Tensile     | [4.40.0](https://github.com/ROCm/Tensile/releases/tag/rocm-6.1.1)          |

### hipBLASLt 0.7.0

hipBLASLt 0.7.0 for ROCm 6.1.1

#### Additions

- Added `hipblasltExtSoftmax` extension API.
- Added `hipblasltExtLayerNorm` extension API.
- Added `hipblasltExtAMax` extension API.
- Added `GemmTuning` extension parameter to set split-k by user.
- Added support for mixed precision datatype: fp16/fp8 in with fp16 outk.

#### Deprecations

- **Upcoming**: `algoGetHeuristic()` ext API for GroupGemm will be deprecated in a future release of hipBLASLt.

### hipSOLVER 2.1.1

hipSOLVER 2.1.1 for ROCm 6.1.1

#### Changes

- By default, `BUILD_WITH_SPARSE` is now set to OFF on Microsoft Windows.

#### Fixes

- Fixed benchmark client build when `BUILD_WITH_SPARSE` is OFF.

### rocFFT 1.0.27

rocFFT 1.0.27 for ROCm 6.1.1

#### Additions

- Enable multi-GPU testing on systems without direct GPU-interconnects.

#### Fixes

- Fixed kernel launch failure on execute of very large odd-length real-complex transforms.
