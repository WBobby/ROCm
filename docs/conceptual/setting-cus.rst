.. meta::
    :description: Setting the number of CUs
    :keywords: AMD, ROCm, cu, number of cus

.. _env-variables-reference:

*************************************************************
Setting the number of CUs
*************************************************************

When using GPUs to accelerate compute workloads, it sometimes becomes necessary
to configure the hardware's usage of Compute Units (CU). This is a more advanced
option, so please read this page before experimentation.

The GPU driver provides two environment variables to set the number of CUs used. The
first one is ``HSA_CU_MASK`` and the second one is ``ROC_GLOBAL_CU_MASK``. The main
difference is that ``ROC_GLOBAL_CU_MASK`` sets the CU mask on queues created by the HIP
or the OpenCL runtimes. While ``HSA_CU_MASK`` sets the mask on a lower level of queue
creation in the driver, this mask will also be set for queues being profiled.

The environment variables have the following syntax:

::

    ID = [0-9][0-9]*                         ex. base 10 numbers
    ID_list = (ID | ID-ID)[, (ID | ID-ID)]*  ex. 0,2-4,7
    GPU_list = ID_list                       ex. 0,2-4,7
    CU_list = 0x[0-F]* | ID_list             ex. 0x337F OR 0,2-4,7
    CU_Set = GPU_list : CU_list              ex. 0,2-4,7:0-15,32-47 OR 0,2-4,7:0x337F
    HSA_CU_MASK = CU_Set [; CU_Set]*         ex. 0,2-4,7:0-15,32-47; 3-9:0x337F

The GPU indices are taken post ``ROCR_VISIBLE_DEVICES`` reordering. For GPUs listed,
the listed or masked CUs will be enabled, the rest disabled. Unlisted GPUs will not
be affected, their CUs will all be enabled.

The parsing of the variable is stopped when a syntax error occurs. The erroneous set
and the ones following will be ignored. Repeating GPU or CU IDs are a syntax error.
Specifying a mask with no usable CUs (CU_list is 0x0) is a syntax error. For excluding
GPU devices use ``ROCR_VISIBLE_DEVICES``.

These environment variables only affect ROCm software, not graphics applications.

It's important to know that not all CU configurations are valid on all devices. For
instance, on devices where two CUs can be combined into a WGP (for kernels running in
WGP mode), it is not valid to disable only a single CU in a WGP. `This paper
<https://www.cs.unc.edu/~otternes/papers/rtsj2022.pdf>`_ can provide more information
about what to expect, when disabling CUs.
