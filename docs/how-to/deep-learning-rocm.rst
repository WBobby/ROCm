.. meta::
   :description: How to install deep learning frameworks for ROCm
   :keywords: deep learning, frameworks, ROCm, install, PyTorch, TensorFlow, JAX, MAGMA, DeepSpeed, ML, AI

********************************************
Installing deep learning frameworks for ROCm
********************************************

ROCm provides a comprehensive ecosystem for deep learning development, including
:ref:`libraries <artificial-intelligence-apis>` for optimized deep learning operations and ROCm-aware versions of popular
deep learning frameworks and libraries such as PyTorch, TensorFlow, JAX, and MAGMA. ROCm works closely with these
frameworks to ensure that framework-specific optimizations take advantage of AMD accelerator and GPU architectures.

The following guides cover installation processes for ROCm-aware deep learning frameworks.

.. grid::

   .. grid-item::
      :columns: 3

      :doc:`PyTorch for ROCm <rocm-install-on-linux:how-to/3rd-party/pytorch-install>`

   .. grid-item::
      :columns: 3

      :doc:`TensorFlow for ROCm <rocm-install-on-linux:how-to/3rd-party/tensorflow-install>`

   .. grid-item::
      :columns: 3

   .. grid-item::
      :columns: 3

   .. grid-item::
      :columns: 3

      :doc:`JAX for ROCm <rocm-install-on-linux:how-to/3rd-party/jax-install>`

   .. grid-item::
      :columns: 3

      :doc:`MAGMA for ROCm <rocm-install-on-linux:how-to/3rd-party/magma-install>`

   .. grid-item::
      :columns: 3

   .. grid-item::
      :columns: 3

The following chart steps through typical installation workflows for installing deep learning frameworks for ROCm.

.. image:: ../data/how-to/framework_install_2024_05_23.png
   :alt: Flowchart for installing ROCm-aware machine learning frameworks
   :align: center

Find information on version compatibility and framework release notes in :doc:`Third-party support matrix
<rocm-install-on-linux:reference/3rd-party-support-matrix>`.

.. note::

   For guidance on installing ROCm itself, refer to :doc:`ROCm installation for Linux <rocm-install-on-linux:index>`.

Learn how to use your ROCm deep learning environment for training, fine-tuning, and inference through the following guides.

* :doc:`rocm-for-ai/index`
