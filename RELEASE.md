<!-- Do not edit this file!                                 -->
<!-- This file is autogenerated with                        -->
<!--   tools/autotag/tag_script.py                          -->
<!-- Disable lints since this is an auto-generated file.    -->
<!-- markdownlint-disable blanks-around-headers             -->
<!-- markdownlint-disable no-duplicate-header               -->
<!-- markdownlint-disable no-blanks-blockquote              -->
<!-- markdownlint-disable ul-indent                         -->
<!-- markdownlint-disable no-trailing-spaces                -->
<!-- markdownlint-disable reference-links-images            -->
<!-- markdownlint-disable no-missing-space-atx              -->
<!-- spellcheck-disable                                     -->
# ROCm 6.3.1 release notes

The release notes provide a summary of notable changes since the previous ROCm release.

- [Release highlights](#release-highlights)

- [Operating system and hardware support changes](#operating-system-and-hardware-support-changes)

- [ROCm components versioning](#rocm-components)

- [Detailed component changes](#detailed-component-changes)

- [ROCm known issues](#rocm-known-issues)

- [ROCm resolved issues](#rocm-resolved-issues)

- [ROCm upcoming changes](#rocm-upcoming-changes)

```{note}
If you’re using Radeon™ PRO or Radeon GPUs in a workstation setting with a
display connected, continue to use ROCm 6.2.3. See the [Use ROCm on Radeon GPUs](https://rocm.docs.amd.com/projects/radeon/en/latest/index.html)
documentation to verify compatibility and system requirements.
```
## Release highlights

The following are notable new features and improvements in ROCm 6.3.1. For changes to individual components, see
[Detailed component changes](#detailed-component-changes).

### Per queue resiliency for Instinct MI300 accelerators

The AMDGPU driver now includes enhanced resiliency for misbehaving applications on AMD Instinct MI300 accelerators. This helps isolate the impact of misbehaving applications, ensuring other workloads running on the same accelerator are unaffected.

### ROCm Runfile Installer

ROCm 6.3.1 introduces the ROCm Runfile Installer, with initial support for Ubuntu 22.04. The ROCm Runfile Installer facilitates ROCm installation without using a native Linux package management system, with or without network or internet access. For more information, see the [ROCm Runfile Installer documentation](https://rocm.docs.amd.com/projects/install-on-linux/en/docs-6.3.1/install/rocm-runfile-installer.html).

### ROCm documentation updates

ROCm documentation continues to be updated to provide clearer and more comprehensive guidance for a wider variety of user needs and use cases.

* Added documentation on training a model with ROCm Megatron-LM. AMD offers a Docker image for MI300X accelerators
  containing essential components to get started, including ROCm libraries, PyTorch, and Megatron-LM utilities. See
  [Training a model using ROCm Megatron-LM](https://rocm.docs.amd.com/en/docs-6.3.1/how-to/rocm-for-ai/train-a-model.html)
  to get started.

  The new ROCm Megatron-LM training Docker accompanies the [ROCm vLLM inference
  Docker](https://rocm.docs.amd.com/en/docs-6.3.1/how-to/performance-validation/mi300x/vllm-benchmark.html)
  as a set of ready-to-use containerized solutions to get started with using ROCm
  for AI.

* Updated the [Instinct MI300X workload tuning
  guide](https://rocm.docs.amd.com/en/docs-6.3.1/how-to/tuning-guides/mi300x/workload.html) with more current optimization
  strategies. The updated sections include guidance on vLLM optimization, PyTorch TunableOp, and hipBLASLt tuning.

* HIP graph-safe libraries operate safely in HIP execution graphs. [HIP graphs](https://rocm.docs.amd.com/projects/HIP/en/docs-6.3.1/how-to/hip_runtime_api/hipgraph.html#how-to-hip-graph) are an alternative way of executing tasks on a GPU that can provide performance benefits over launching kernels using the standard method via streams. A topic that shows whether a [ROCm library is graph-safe](https://rocm.docs.amd.com/en/docs-6.3.1/reference/graph-safe-support.html) has been added.

* The [Device memory](https://rocm.docs.amd.com/projects/HIP/en/docs-6.3.1/how-to/hip_runtime_api/memory_management/device_memory.html) topic in the HIP memory management section has been updated.

* The HIP documentation has expanded with new resources for developers:
  * [Multi device management](https://rocm.docs.amd.com/projects/HIP/en/docs-6.3.1/how-to/hip_runtime_api/multi_device.html)
  * [OpenGL interoperability](https://rocm.docs.amd.com/projects/HIP/en/docs-6.3.1/how-to/hip_runtime_api/opengl_interop.html)

## Operating system and hardware support changes

ROCm 6.3.1 adds support for Debian 12 (kernel: 6.1). Debian is supported only on AMD Instinct accelerators. See the installation instructions at [Debian native installation](https://rocm.docs.amd.com/projects/install-on-linux/en/docs-6.3.1/install/native-install/debian.html).

ROCm 6.3.1 enables support for AMD Instinct MI325X accelerator. For more information, see [AMD Instinct™ MI325X Accelerators](https://www.amd.com/en/products/accelerators/instinct/mi300/mi325x.html).

See the [Compatibility
matrix](https://rocm.docs.amd.com/en/docs-6.3.1/compatibility/compatibility-matrix.html)
for more information about operating system and hardware compatibility.

## ROCm components

The following table lists the versions of ROCm components for ROCm 6.3.1, including any version
changes from 6.3.0 to 6.3.1. Click the component's updated version to go to a list of its changes.
Click {fab}`github` to go to the component's source code on GitHub.

<div class="pst-scrollable-table-container">
    <table id="rocm-rn-components" class="table">
        <thead>
            <tr>
                <th>Category</th>
                <th>Group</th>
                <th>Name</th>
                <th>Version</th>
                <th></th>
            </tr>
        </thead>
        <colgroup>
            <col span="1">
            <col span="1">
        </colgroup>
        <tbody class="rocm-components-libs rocm-components-ml">
            <tr>
                <th rowspan="9">Libraries</th>
                <th rowspan="9">Machine learning and computer vision</th>
                <td><a href="https://rocm.docs.amd.com/projects/composable_kernel/en/docs-6.3.1/index.html">Composable Kernel</a></td>
                <td>1.1.0</td>
                <td><a href="https://github.com/ROCm/composable_kernel"><i class="fab fa-github fa-lg"></i></a></td>
            </tr>
            <tr>
                <td><a href="https://rocm.docs.amd.com/projects/AMDMIGraphX/en/docs-6.3.1/index.html">MIGraphX</a></td>
                <td>2.11.0</td>
                <td><a href="https://github.com/ROCm/AMDMIGraphX"><i class="fab fa-github fa-lg"></i></a></td>
            </tr>
            <tr>
                <td><a href="https://rocm.docs.amd.com/projects/MIOpen/en/docs-6.3.1/index.html">MIOpen</a></td>
                <td>3.3.0</td>
                <td><a href="https://github.com/ROCm/MIOpen"><i class="fab fa-github fa-lg"></i></a></td>
            </tr>
            <tr>
                <td><a href="https://rocm.docs.amd.com/projects/MIVisionX/en/docs-6.3.1/index.html">MIVisionX</a></td>
                <td>3.1.0&nbsp;&Rightarrow;&nbsp;<a href="#mivisionx-3-1-0">3.1.0</a></td>
                <td><a href="https://github.com/ROCm/MIVisionX"><i class="fab fa-github fa-lg"></i></a></td>
            </tr>
            <tr>
                <td><a href="https://rocm.docs.amd.com/projects/rocAL/en/docs-6.3.1/index.html">rocAL</a></td>
                <td>2.1.0</td>
                <td><a href="https://github.com/ROCm/rocAL"><i class="fab fa-github fa-lg"></i></a></td>
            </tr>
            <tr>
                <td><a href="https://rocm.docs.amd.com/projects/rocDecode/en/docs-6.3.1/index.html">rocDecode</a></td>
                <td>0.8.0</td>
                <td><a href="https://github.com/ROCm/rocDecode"><i class="fab fa-github fa-lg"></i></a></td>
            </tr>
            <tr>
                <td><a href="https://rocm.docs.amd.com/projects/rocJPEG/en/docs-6.3.1/index.html">rocJPEG</a></td>
                <td>0.6.0</td>
                <td><a href="https://github.com/ROCm/rocJPEG"><i class="fab fa-github fa-lg"></i></a></td>
            </tr>
            <tr>
                <td><a href="https://rocm.docs.amd.com/projects/rocPyDecode/en/docs-6.3.1/index.html">rocPyDecode</a></td>
                <td>0.2.0</td>
                <td><a href="https://github.com/ROCm/rocPyDecode"><i class="fab fa-github fa-lg"></i></a></td>
            </tr>
            <tr>
                <td><a href="https://rocm.docs.amd.com/projects/rpp/en/docs-6.3.1/index.html">RPP</a></td>
                <td>1.9.1</td>
                <td><a href="https://github.com/ROCm/rpp"><i class="fab fa-github fa-lg"></i></a></td>
            </tr>
        </tbody>
        <tbody class="rocm-components-libs rocm-components-communication tbody-reverse-zebra">
            <tr>
                <th rowspan="1"></th>
                <th rowspan="1">Communication</th>
                <td><a href="https://rocm.docs.amd.com/projects/rccl/en/docs-6.3.1/index.html">RCCL</a></td>
                <td>2.21.5&nbsp;&Rightarrow;&nbsp;<a href="#rccl-2-21-5">2.21.5</a></td>
                <td><a href="https://github.com/ROCm/rccl"><i class="fab fa-github fa-lg"></i></a></td>
            </tr>
        </tbody>
        <tbody class="rocm-components-libs rocm-components-math">
            <tr>
                <th rowspan="16"></th>
                <th rowspan="16">Math</th>
                <td><a href="https://rocm.docs.amd.com/projects/hipBLAS/en/docs-6.3.1/index.html">hipBLAS</a></td>
                <td>2.3.0</td>
                <td><a href="https://github.com/ROCm/hipBLAS"><i class="fab fa-github fa-lg"></i></a></td>
            </tr>
            <tr>
                <td><a href="https://rocm.docs.amd.com/projects/hipBLASLt/en/docs-6.3.1/index.html">hipBLASLt</a></td>
                <td>0.10.0</td>
                <td><a href="https://github.com/ROCm/hipBLASLt"><i class="fab fa-github fa-lg"></i></a></td>
            </tr>
            <tr>
                <td><a href="https://rocm.docs.amd.com/projects/hipFFT/en/docs-6.3.1/index.html">hipFFT</a></td>
                <td>1.0.17</td>
                <td><a href="https://github.com/ROCm/hipFFT"><i class="fab fa-github fa-lg"></i></a></td>
            </tr>
            <tr>
                <td><a href="https://rocm.docs.amd.com/projects/hipfort/en/docs-6.3.1/index.html">hipfort</a></td>
                <td>0.5.0</td>
                <td><a href="https://github.com/ROCm/hipfort"><i class="fab fa-github fa-lg"></i></a></td>
            </tr>
            <tr>
                <td><a href="https://rocm.docs.amd.com/projects/hipRAND/en/docs-6.3.1/index.html">hipRAND</a></td>
                <td>2.11.1</td>
                <td><a href="https://github.com/ROCm/hipRAND"><i class="fab fa-github fa-lg"></i></a></td>
            </tr>
            <tr>
                <td><a href="https://rocm.docs.amd.com/projects/hipSOLVER/en/docs-6.3.1/index.html">hipSOLVER</a></td>
                <td>2.3.0</td>
                <td><a href="https://github.com/ROCm/hipSOLVER"><i class="fab fa-github fa-lg"></i></a></td>
            </tr>
            <tr>
                <td><a href="https://rocm.docs.amd.com/projects/hipSPARSE/en/docs-6.3.1/index.html">hipSPARSE</a></td>
                <td>3.1.2</td>
                <td><a href="https://github.com/ROCm/hipSPARSE"><i class="fab fa-github fa-lg"></i></a></td>
            </tr>
            <tr>
                <td><a href="https://rocm.docs.amd.com/projects/hipSPARSELt/en/docs-6.3.1/index.html">hipSPARSELt</a></td>
                <td>0.2.2</td>
                <td><a href="https://github.com/ROCm/hipSPARSELt"><i class="fab fa-github fa-lg"></i></a></td>
            </tr>
            <tr>
                <td><a href="https://rocm.docs.amd.com/projects/rocALUTION/en/docs-6.3.1/index.html">rocALUTION</a></td>
                <td>3.2.1</td>
                <td><a href="https://github.com/ROCm/rocALUTION"><i class="fab fa-github fa-lg"></i></a></td>
            </tr>
            <tr>
                <td><a href="https://rocm.docs.amd.com/projects/rocBLAS/en/docs-6.3.1/index.html">rocBLAS</a></td>
                <td>4.3.0</td>
                <td><a href="https://github.com/ROCm/rocBLAS"><i class="fab fa-github fa-lg"></i></a></td>
            </tr>
            <tr>
                <td><a href="https://rocm.docs.amd.com/projects/rocFFT/en/docs-6.3.1/index.html">rocFFT</a></td>
                <td>1.0.31</td>
                <td><a href="https://github.com/ROCm/rocFFT"><i class="fab fa-github fa-lg"></i></a></td>
            </tr>
            <tr>
                <td><a href="https://rocm.docs.amd.com/projects/rocRAND/en/docs-6.3.1/index.html">rocRAND</a></td>
                <td>3.2.0</td>
                <td><a href="https://github.com/ROCm/rocRAND"><i class="fab fa-github fa-lg"></i></a></td>
            </tr>
            <tr>
                <td><a href="https://rocm.docs.amd.com/projects/rocSOLVER/en/docs-6.3.1/index.html">rocSOLVER</a></td>
                <td>3.27.0</td>
                <td><a href="https://github.com/ROCm/rocSOLVER"><i class="fab fa-github fa-lg"></i></a></td>
            </tr>
            <tr>
                <td><a href="https://rocm.docs.amd.com/projects/rocSPARSE/en/docs-6.3.1/index.html">rocSPARSE</a></td>
                <td>3.3.0</td>
                <td><a href="https://github.com/ROCm/rocSPARSE"><i class="fab fa-github fa-lg"></i></a></td>
            </tr>
            <tr>
                <td><a href="https://rocm.docs.amd.com/projects/rocWMMA/en/docs-6.3.1/index.html">rocWMMA</a></td>
                <td>1.6.0</td>
                <td><a href="https://github.com/ROCm/rocWMMA"><i class="fab fa-github fa-lg"></i></a></td>
            </tr>
            <tr>
                <td><a href="https://rocm.docs.amd.com/projects/Tensile/en/docs-6.3.1/src/index.html">Tensile</a></td>
                <td>4.42.0</td>
                <td><a href="https://github.com/ROCm/Tensile"><i class="fab fa-github fa-lg"></i></a></td>
            </tr>
        </tbody>
        <tbody class="rocm-components-libs rocm-components-primitives">
            <tr>
                <th rowspan="4"></th>
                <th rowspan="4">Primitives</th>
                <td><a href="https://rocm.docs.amd.com/projects/hipCUB/en/docs-6.3.1/index.html">hipCUB</a></td>
                <td>3.3.0</td>
                <td><a href="https://github.com/ROCm/hipCUB"><i class="fab fa-github fa-lg"></i></a></td>
            </tr>
            <tr>
                <td><a href="https://rocm.docs.amd.com/projects/hipTensor/en/docs-6.3.1/index.html">hipTensor</a></td>
                <td>1.4.0</td>
                <td><a href="https://github.com/ROCm/hipTensor"><i class="fab fa-github fa-lg"></i></a></td>
            </tr>
            <tr>
                <td><a href="https://rocm.docs.amd.com/projects/rocPRIM/en/docs-6.3.1/index.html">rocPRIM</a></td>
                <td>3.3.0</td>
                <td><a href="https://github.com/ROCm/rocPRIM"><i class="fab fa-github fa-lg"></i></a></td>
            </tr>
            <tr>
                <td><a href="https://rocm.docs.amd.com/projects/rocThrust/en/docs-6.3.1/index.html">rocThrust</a></td>
                <td>3.3.0</td>
                <td><a href="https://github.com/ROCm/rocThrust"><i class="fab fa-github fa-lg"></i></a></td>
            </tr>
        </tbody>
        <tbody class="rocm-components-tools rocm-components-system">
            <tr>
                <th rowspan="7">Tools</th>
                <th rowspan="7">System management</th>
                <td><a href="https://rocm.docs.amd.com/projects/amdsmi/en/docs-6.3.1/index.html">AMD SMI</a></td>
                <td>24.7.1&nbsp;&Rightarrow;&nbsp;<a href="#amd-smi-24-7-1">24.7.1</a></td>
                <td><a href="https://github.com/ROCm/rocm-cmake"><i class="fab fa-github fa-lg"></i></a></td>
            </tr>
            <tr>
                <td><a href="https://rocm.docs.amd.com/projects/rdc/en/docs-6.3.1/index.html">ROCm Data Center Tool</a></td>
                <td>0.3.0</td>
                <td><a href="https://github.com/ROCm/rdc"><i class="fab fa-github fa-lg"></i></a></td>
            </tr>
            <tr>
                <td><a href="https://rocm.docs.amd.com/projects/rocminfo/en/docs-6.3.1/index.html">rocminfo</a></td>
                <td>1.0.0</td>
                <td><a href="https://github.com/ROCm/rocminfo"><i class="fab fa-github fa-lg"></i></a></td>
            </tr>
            <tr>
                <td><a href="https://rocm.docs.amd.com/projects/rocm_smi_lib/en/docs-6.3.1/index.html">ROCm SMI</a></td>
                <td>7.4.0</td>
                <td><a href="https://github.com/ROCm/rocm_smi_lib"><i class="fab fa-github fa-lg"></i></a></td>
            </tr>
            <tr>
                <td><a href="https://rocm.docs.amd.com/projects/ROCmValidationSuite/en/docs-6.3.1/index.html">ROCmValidationSuite</a></td>
                <td>1.1.0</td>
                <td><a href="https://github.com/ROCm/ROCmValidationSuite"><i class="fab fa-github fa-lg"></i></a></td>
            </tr>
        </tbody>
        <tbody class="rocm-components-tools rocm-components-perf tbody-reverse-zebra">
            <tr>
                <th rowspan="6"></th>
                <th rowspan="6">Performance</th>
                <td><a href="https://rocm.docs.amd.com/projects/rocm_bandwidth_test/en/docs-6.3.1/index.html">ROCm Bandwidth
                        Test</a></td>
                <td>1.4.0</td>
                <td><a href="https://github.com/ROCm/rocm_bandwidth_test/"><i
                            class="fab fa-github fa-lg"></i></a></td>
            </tr>
            <tr>
                <td><a href="https://rocm.docs.amd.com/projects/rocprofiler-compute/en/docs-6.3.1/index.html">ROCm Compute Profiler</a></td>
                <td>3.0.0&nbsp;&Rightarrow;&nbsp<a href="#rocm-compute-profiler-3-0-0">3.0.0</a></td>
                <td><a href="https://github.com/ROCm/rocprofiler-compute"><i
                            class="fab fa-github fa-lg"></i></a></td>
            </tr>
            <tr>
                <td><a href="https://rocm.docs.amd.com/projects/rocprofiler-systems/en/docs-6.3.1/index.html">ROCm Systems Profiler</a></td>
                <td>0.1.0&nbsp;&Rightarrow;&nbsp<a href="#rocm-systems-profiler-0-1-0">0.1.0</a></td>
                <td><a href="https://github.com/ROCm/rocprofiler-systems"><i
                            class="fab fa-github fa-lg"></i></a></td>
            </tr>
            <tr>
                <td><a href="https://rocm.docs.amd.com/projects/rocprofiler/en/docs-6.3.1/index.html">ROCProfiler</a></td>
                <td>2.0.0</td>
                <td><a href="https://github.com/ROCm/ROCProfiler/"><i
                            class="fab fa-github fa-lg"></i></a></td>
            </tr>
            <tr>
                <td><a href="https://rocm.docs.amd.com/projects/rocprofiler-sdk/en/docs-6.3.1/index.html">ROCprofiler-SDK</a></td>
                <td>0.5.0</td>
                <td><a href="https://github.com/ROCm/rocprofiler-sdk/"><i
                            class="fab fa-github fa-lg"></i></a></td>
            </tr>
            <tr >
                <td><a href="https://rocm.docs.amd.com/projects/roctracer/en/docs-6.3.1/index.html">ROCTracer</a></td>
                <td>4.1.0</td>
                <td><a href="https://github.com/ROCm/ROCTracer/"><i
                            class="fab fa-github fa-lg"></i></a></td>
            </tr>
        </tbody>
        <tbody class="rocm-components-tools rocm-components-dev tbody-reverse-zebra">
            <tr>
                <th rowspan="5"></th>
                <th rowspan="5">Development</th>
                <td><a href="https://rocm.docs.amd.com/projects/HIPIFY/en/docs-6.3.1/index.html">HIPIFY</a></td>
                <td>18.0.0&nbsp;&Rightarrow;&nbsp;<a href="#hipify-18-0-0">18.0.0</a></td>
                <td><a href="https://github.com/ROCm/HIPIFY/"><i
                            class="fab fa-github fa-lg"></i></a></td>
            </tr>
            <tr>
                <td><a href="https://rocm.docs.amd.com/projects/ROCdbgapi/en/docs-6.3.1/index.html">ROCdbgapi</a></td>
                <td>0.77.0</td>
                <td><a href="https://github.com/ROCm/ROCdbgapi/"><i
                            class="fab fa-github fa-lg"></i></a></td>
            </tr>
            <tr>
                <td><a href="https://rocm.docs.amd.com/projects/ROCmCMakeBuildTools/en/docs-6.3.1/index.html">ROCm CMake</a></td>
                <td>0.14.0</td>
                <td><a href="https://github.com/ROCm/rocm-cmake/"><i
                            class="fab fa-github fa-lg"></i></a></td>
            </tr>
            <tr>
                <td><a href="https://rocm.docs.amd.com/projects/ROCgdb/en/docs-6.3.1/index.html">ROCm Debugger (ROCgdb)</a>
                </td>
                <td>15.2</td>
                <td><a href="https://github.com/ROCm/ROCgdb/"><i
                            class="fab fa-github fa-lg"></i></a></td>
            </tr>
            <tr>
                <td><a href="https://rocm.docs.amd.com/projects/rocr_debug_agent/en/docs-6.3.1/index.html">ROCr Debug Agent</a>
                </td>
                <td>2.0.3</td>
                <td><a href="https://github.com/ROCm/rocr_debug_agent/"><i
                            class="fab fa-github fa-lg"></i></a></td>
            </tr>
        </tbody>
        <tbody class="rocm-components-compilers">
            <tr>
                <th rowspan="2" colspan="2">Compilers</th>
                <td><a href="https://rocm.docs.amd.com/projects/HIPCC/en/docs-6.3.1/index.html">HIPCC</a></td>
                <td>1.1.1</td>
                <td><a href="https://github.com/ROCm/llvm-project/"><i
                            class="fab fa-github fa-lg"></i></a></td>
            </tr>
            <tr>
                <td><a href="https://rocm.docs.amd.com/projects/llvm-project/en/docs-6.3.1/index.html">llvm-project</a></td>
                <td>18.0.0</td>
                <td><a href="https://github.com/ROCm/llvm-project/"><i
                            class="fab fa-github fa-lg"></i></a></td>
            </tr>
        </tbody>
        <tbody class="rocm-components-runtimes">
            <tr>
                <th rowspan="2" colspan="2">Runtimes</th>
                <td><a href="https://rocm.docs.amd.com/projects/HIP/en/docs-6.3.1/index.html">HIP</a></td>
                <td>6.3.0&nbsp;&Rightarrow;&nbsp;<a href="#hip-6-3-1">6.3.1</a></td>
                <td><a href="https://github.com/ROCm/HIP/"><i class="fab fa-github fa-lg"></i></a></td>
            </tr>
            <tr>
                <td><a href="https://rocm.docs.amd.com/projects/ROCR-Runtime/en/docs-6.3.1/index.html">ROCr Runtime</a></td>
                <td>1.14.0</td>
                <td><a href="https://github.com/ROCm/ROCR-Runtime/"><i class="fab fa-github fa-lg"></i></a></td>
            </tr>
        </tbody>
    </table>
</div>

## Detailed component changes

The following sections describe key changes to ROCm components.

### **AMD SMI** (24.7.1)

#### Changed

* `amd-smi monitor` displays `VCLOCK` and `DCLOCK` instead of `ENC_CLOCK` and `DEC_CLOCK`.

#### Resolved issues

* Fixed `amd-smi monitor`'s reporting of encode and decode information. `VCLOCK` and `DCLOCK` are
  now associated with both `ENC_UTIL` and `DEC_UTIL`.

```{note}
See the full [AMD SMI changelog](https://github.com/ROCm/amdsmi/blob/6.3.x/CHANGELOG.md) for more details and examples.
```

### **HIP** (6.3.1)

#### Added

* An activeQueues set that tracks only the queues that have a command submitted to them, which allows fast iteration in ``waitActiveStreams``.

#### Resolved issues

* A deadlock in a specific customer application by preventing hipLaunchKernel latency degradation with number of idle streams.

### **HIPIFY** (18.0.0)

#### Added

* Support for: 
  * NVIDIA CUDA 12.6.2
  * cuDNN 9.5.1
  * LLVM 19.1.3
  * Full `hipBLAS` 64-bit APIs
  * Full `rocBLAS` 64-bit APIs

#### Resolved issues

* Added missing support for device intrinsics and built-ins: `__all_sync`, `__any_sync`, `__ballot_sync`, `__activemask`, `__match_any_sync`, `__match_all_sync`, `__shfl_sync`, `__shfl_up_sync`, `__shfl_down_sync`, and `__shfl_xor_sync`.

### **MIVisionX** (3.1.0)

#### Changed

* AMD Clang is now the default CXX and C compiler.
* The dependency on rocDecode has been removed and automatic rocDecode installation is now disabled in the setup script.

#### Resolved issues

* Canny failure on Instinct MI300 has been fixed.
* Ubuntu 24.04 CTest failures have been fixed.

#### Known issues

* CentOS, Red Hat, and SLES requires the manual installation of `OpenCV` and `FFMPEG`. 
* Hardware decode requires that ROCm is installed with `--usecase=graphics`.

#### Upcoming changes

* Optimized audio augmentations support for VX_RPP.

### **RCCL** (2.21.5)

#### Changed

* Enhanced the user documentation.

#### Resolved Issues

* Corrected some user help strings in `install.sh`.

### **ROCm Compute Profiler** (3.0.0)

#### Resolved issues

* Fixed a minor issue for users upgrading to ROCm 6.3 from 6.2 post-rename from `omniperf`.
  See [ROCm Compute Profiler and ROCm Systems Profiler post-upgrade issues](#rocm-compute-profiler-and-rocm-systems-profiler-post-upgrade-issues).

### **ROCm Systems Profiler** (0.1.0)

#### Added

* Improvements to support OMPT target offload.

#### Resolved issues

* Fixed an issue with generated Perfetto files. See [issue #3767](https://github.com/ROCm/ROCm/issues/3767) for more information.

* Fixed an issue with merging multiple `.proto` files.

* Fixed an issue causing GPU resource data to be missing from traces of Instinct MI300A systems.

* Fixed a minor issue for users upgrading to ROCm 6.3 from 6.2 post-rename from `omnitrace`.
  See [ROCm Compute Profiler and ROCm Systems Profiler post-upgrade issues](#rocm-compute-profiler-and-rocm-systems-profiler-post-upgrade-issues).

## ROCm known issues

ROCm known issues are noted on {fab}`github` [GitHub](https://github.com/ROCm/ROCm/labels/Verified%20Issue). For known
issues related to individual components, review the [Detailed component changes](#detailed-component-changes).

### PCI Express Qualification Tool failure on Debian 12

The PCI Express Qualification Tool (PEQT) module present in the ROCm Validation Suite (RVS) might fail due to the segmentation issue in Debian 12 (bookworm). This will result in failure to determine the characteristics of the PCIe interconnect between the host platform and the GPU like support for Gen 3 atomic completers, DMA transfer statistics, link speed, and link width. The standard PCIe command `lspci` can be used as an alternative to view the characteristics of the PCIe bus interconnect with the GPU. This issue is under investigation and will be addressed in a future release. See [GitHub issue #4175](https://github.com/ROCm/ROCm/issues/4175).

## ROCm resolved issues

The following are previously known issues resolved in this release. For resolved issues related to
individual components, review the [Detailed component changes](#detailed-component-changes).

### Instinct MI300 series: backward weights convolution performance issue

Fixed a performance issue affecting certain tensor shapes during backward weights convolution when using FP16 or FP32 data types on Instinct MI300 series accelerators. See [GitHub issue #4080](https://github.com/ROCm/ROCm/issues/4080).

### ROCm Compute Profiler and ROCm Systems Profiler post-upgrade issues

Packaging metadata for ROCm Compute Profiler (`rocprofiler-compute`) and ROCm Systems Profiler
(`rocprofiler-systems`) has been updated to handle the renaming from Omniperf and Omnitrace,
respectively. This fixes minor issues when upgrading from ROCm 6.2 to 6.3. For more information, see the GitHub issues
[#4082](https://github.com/ROCm/ROCm/issues/4082) and
[#4083](https://github.com/ROCm/ROCm/issues/4083).

### Stale file due to OpenCL ICD loader deprecation

When upgrading from ROCm 6.2.x to ROCm 6.3.0, the issue of removal of the `rocm-icd-loader` package
leaving a stale file in the old `rocm-6.2.x` directory has been resolved. The stale files left during
the upgrade from ROCm 6.2.x to ROCm 6.3.0 will be removed when upgrading to ROCm 6.3.1. For more
information, see [GitHub issue #4084](https://github.com/ROCm/ROCm/issues/4084).

## ROCm upcoming changes

The following changes to the ROCm software stack are anticipated for future releases.

### AMDGPU wavefront size compiler macro deprecation

The `__AMDGCN_WAVEFRONT_SIZE__` macro will be deprecated in an upcoming
release. It is recommended to remove any use of this macro. For more information, see [AMDGPU
support](https://rocm.docs.amd.com/projects/llvm-project/en/docs-6.3.1/LLVM/clang/html/AMDGPUSupport.html).

### HIPCC Perl scripts deprecation

The HIPCC Perl scripts (`hipcc.pl` and `hipconfig.pl`) will be removed in an upcoming release.

