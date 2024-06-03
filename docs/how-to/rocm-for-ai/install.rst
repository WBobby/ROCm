.. meta::
   :description: How to use ROCm for AI
   :keywords: ROCm, AI, LLM, train, fine-tune, FSDP, DeepSpeed, LLaMA, tutorial

.. _rocm-for-ai-install:

***********************************************
Installing ROCm and machine learning frameworks
***********************************************

Before getting started, install ROCm and supported machine learning frameworks.

.. grid:: 1

   .. grid-item-card:: Pre-install

      Each release of ROCm supports specific hardware and software configurations. Before installing, consult the
      :doc:`System requirements <rocm-install-on-linux:reference/system-requirements>` and
      :doc:`Installation prerequisites <rocm-install-on-linux:how-to/prerequisites>` guides.

If you’re new to ROCm, refer to the :doc:`ROCm quick start install guide for Linux
<rocm-install-on-linux:tutorial/quick-start>`.

If you’re using a Radeon GPU for graphics-accelerated applications, refer to the
:doc:`Radeon installation instructions <radeon:docs/install/install-radeon>`.

ROCm supports two methods for installation. There is no difference in the final ROCm installation between these two
methods. You can also opt for :ref:`single-version or multi-version installation
<rocm-install-on-linux:installation-types>`.

*  :doc:`Using your Linux distribution's package manager <rocm-install-on-linux:how-to/native-install/index>`

*  :doc:`Using the AMDGPU installer <rocm-install-on-linux:how-to/amdgpu-install>`

.. grid:: 1

   .. grid-item-card:: Post-install

      Follow the :doc:`post-installation instructions <rocm-install-on-linux:how-to/native-install/post-install>` to
      configure your system linker, PATH, and verify the installation.

      If you encounter any issues during installation, refer to the
      :doc:`Installation troubleshooting <rocm-install-on-linux:how-to/native-install/install-faq>` guide.

Machine learning frameworks
===========================

ROCm supports popular machine learning frameworks and libraries including `PyTorch
<https://pytorch.org/blog/pytorch-for-amd-rocm-platform-now-available-as-python-package>`_, `TensorFlow
<https://tensorflow.org>`_, `JAX <https://jax.readthedocs.io/en/latest>`_, and `DeepSpeed
<https://cloudblogs.microsoft.com/opensource/2022/03/21/supporting-efficient-large-model-training-on-amd-instinct-gpus-with-deepspeed/>`_.

Review the framework installation documentation. For ease-of-use, it's recommended to use official ROCm prebuilt Docker
images with the framework pre-installed.

* :doc:`PyTorch for ROCm <rocm-install-on-linux:how-to/3rd-party/pytorch-install>`
* :doc:`TensorFlow for ROCm <rocm-install-on-linux:how-to/3rd-party/tensorflow-install>`
* :doc:`JAX for ROCm <rocm-install-on-linux:how-to/3rd-party/jax-install>`

The sections that follow in :doc:`Training a model <train-a-model>` are geared for a ROCm with PyTorch installation.
