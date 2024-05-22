# Traditional first make target
all:

# Use bash as a shell
# On Ubuntu sh is 'dash'
SHELL:=bash

# Allow RELEASE_FLAG to be overwritten
RELEASE_FLAG?=-r

# Set SANITIZER_FLAG for sanitizer
ASAN_DEP:=
ifeq (${ENABLE_ADDRESS_SANITIZER},true)
	ASAN_DEP=lightning
	SANITIZER_FLAG=-a
endif

export INFRA_REPO:=rocm-build

OUT_DIR:=$(shell . ${INFRA_REPO}/build/envsetup.sh >/dev/null 2>&1 ; echo $${OUT_DIR})
ROCM_INSTALL_PATH:=$(shell . ${INFRA_REPO}/build/envsetup.sh >/dev/null 2>&1 ; echo $${ROCM_INSTALL_PATH})

$(info OUT_DIR=${OUT_DIR})
$(info ROCM_INSTALL_PATH=${ROCM_INSTALL_PATH})

# -------------------------------------------------------------------------
# Internal stuff. Could be put in a different file to hide it.
# Internal macros, they need to be defined before being used.

# The internal "eval" allows parts of the Makefile to be generated.
# Whilst it is possible to dump the effective Makefile, it can be
# hard to see where parts come from. Set up the "peval" macro which
# optionally prints out the generated makefile snippet and evaluate it.
# Use "make PEVAL=1 all" to see the things being evaluated.
ifeq (,${PEVAL})
    define peval =
    $(eval $1)
    endef
else
    define peval =
    $(eval $(info $1)$1)
    endef
endif

# macro to add dependencies. Saves having to put all the OUT_DIR/logs in
# The outer strip is to work around a gnu make 4.1 and earlier bug
# It should not be needed.
define adddep =
$(strip $(call peval,components+= $(1) $(2))
$(foreach comp,$(strip $2),$(call peval,${OUT_DIR}/logs/${1}: ${OUT_DIR}/logs/${comp}))
)
endef
# End of internal stuff that is needed at the start of the file
# -------------------------------------------------------------------------

# Dependencies. These can be updated. Anything that is mentioned in
# either the args to the adddep macro will be added to components.  as
# an example there is no need for the adddep of lightning, as it
# depends on nothing and at least one other component includes it.

# Syntax. Up to the first comma everything is fixed. The "call" is a
# keyword to gnu make. The "adddep" is the name of the variable containing
# the macro.
# The second comma delimited argument is the target.
# The third comma delimited arg is the thing that the target depends on.
# It is a space seperated list with zero or more elements.

$(call adddep,rocm-core,${ASAN_DEP})
$(call adddep,rocprofiler-register,${ASAN_DEP})
$(call adddep,aqlprofile,${ASAN_DEP} hsa)
$(call adddep,rocprofiler,${ASAN_DEP} hsa roctracer aqlprofile opencl_on_rocclr hip_on_rocclr comgr dbgapi)
$(call adddep,roctracer,${ASAN_DEP} hsa hip_on_rocclr)
$(call adddep,thunk,${ASAN_DEP})
$(call adddep,hsa,${ASAN_DEP} thunk lightning devicelibs rocprofiler-register)
$(call adddep,rocm_smi_lib,${ASAN_DEP})
$(call adddep,amd_smi_lib,${ASAN_DEP})
$(call adddep,rdc,${ASAN_DEP} rocm_smi_lib hsa rocprofiler)
$(call adddep,rocminfo,${ASAN_DEP} hsa)
$(call adddep,lightning,)
$(call adddep,devicelibs,lightning)
$(call adddep,comgr,lightning devicelibs)
$(call adddep,hipcc,)
$(call adddep,rocclr,${ASAN_DEP} hsa comgr hipcc rocprofiler-register)
$(call adddep,opencl_on_rocclr,${ASAN_DEP} rocclr)
$(call adddep,hip_on_rocclr,${ASAN_DEP} rocclr rocprofiler-register)
$(call adddep,hipify_clang,hip_on_rocclr lightning)
$(call adddep,clang-ocl,lightning rocm-cmake)
$(call adddep,rocm_bandwidth_test,${ASAN_DEP} hsa)
$(call adddep,rocm-cmake,${ASAN_DEP})
$(call adddep,rocr_debug_agent,${ASAN_DEP} hip_on_rocclr hsa dbgapi)
$(call adddep,openmp_extras,thunk lightning devicelibs hsa)
$(call adddep,rocm-gdb,dbgapi)
$(call adddep,dbgapi,hsa comgr)

# rocm-dev points to all possible last finish components of Stage1 build.
rocm-dev-components :=rdc hipify_clang openmp_extras \
	rocm-core amd_smi_lib hipcc clang-ocl \
	rocm_bandwidth_test rocr_debug_agent rocm-gdb
$(call adddep,rocm-dev,$(filter-out ${NOBUILD},${rocm-dev-components}))

$(call adddep,amdmigraphx,miopen-hip rocm-dev)
$(call adddep,composable_kernel,rocm-dev)
$(call adddep,half,rocm-dev)
$(call adddep,hipblas,rocblas rocsolver rocm-dev)
$(call adddep,hipblaslt,hipblas rocm-dev)
$(call adddep,hipcub,rocprim rocm-dev)
$(call adddep,hipfft,rocfft rocrand hiprand rocm-dev)
$(call adddep,hipfort,rocblas hipblas rocsparse hipsparse rocfft hipfft rocrand hiprand rocsolver hipsolver rocm-dev)
$(call adddep,hiprand,rocrand rocm-dev)
$(call adddep,hipsolver,rocsolver hipsparse rocm-dev)
$(call adddep,hipsparse,rocsparse rocm-dev)
$(call adddep,hipsparselt,hipsparse rocm-dev)
$(call adddep,hiptensor,composable_kernel rocm-dev)
$(call adddep,miopen-deps,rocm-dev)
$(call adddep,miopen-hip,half composable_kernel miopen-deps rocblas rocm-dev)
$(call adddep,mivisionx,amdmigraphx miopen-hip rpp rocm-dev)
$(call adddep,rccl,rocm-dev)
$(call adddep,rocalution,rocblas rocsparse rocrand rocm-dev)
$(call adddep,rocblas,rocm-dev)
$(call adddep,rocdecode,rocm-dev)
$(call adddep,rocfft,rocrand hiprand rocm-dev)
$(call adddep,rocmvalidationsuite,rocblas rocm-dev)
$(call adddep,rocprim,rocm-dev)
$(call adddep,rocrand,rocm-dev)
$(call adddep,rocsolver,rocblas rocsparse rocm-dev)
$(call adddep,rocsparse,rocprim rocm-dev)
$(call adddep,rocthrust,rocprim rocm-dev)
$(call adddep,rocwmma,rocblas rocm-dev)
$(call adddep,rpp,half rocm-dev)


# -------------------------------------------------------------------------
# The rest of the file is internal
# Do not pass jobserver params if -n build
ifneq (,$(findstring n,${MAKEFLAGS}))
RMAKE:=
else
RMAKE := +
endif


# disable the builtin rules
.SUFFIXES:

# Linear
# include moredeps

# A macro to define a toplevel target, add it to the 'all' target
# Make it depend on the generated log. Generate the log of the build.

# See if the macro is already defined, if so don't touch it.
# As GNU make allows more than one makefile to be specified with "-f"
# one could put an alternative definition of "toplevel" in a different
# file or even the environment, and use the data in this file for other
# purposes. Uses might include generating output in "dot" format for
# showing the dependency graph, or having a wrapper script to run programs
# to generate code quality tools.
ifeq (${toplevel},)
# { Start of test to see if toplevel is defined
define toplevel =

# The "target" make, this builds the package if it is out of date
T_$1: ${OUT_DIR}/logs/$1 FRC
	:              $1 built

# The "upload" for $1, it uploads the packages for $1 to the central storage
U_$1: T_$1 FRC
	source $${INFRA_REPO}/build/envsetup.sh && $${INFRA_REPO}/build/upload_packages.sh "$1"
	:		$1 uploaded

# The "clean" for $1, it just marks the target as not existing so it will be built
# in the future.
C_$1: FRC
	rm -f ${OUT_DIR}/logs/$1 ${OUT_DIR}/logs/$1.repackaged

# parallel build {
${OUT_DIR}/logs/$1: | ${OUT_DIR}/logs
ifneq ($(wildcard ${OUT_DIR}/logs/$1.repackaged),)
	@echo  Skipping build of $1 as it has already been repackaged
	cat $$@.repackaged > $$@
	rm -f $$@.repackaged
else # } {
	@echo  $1 started due to $$? | sed "s:${OUT_DIR}/logs/::g"
# Build in a subshell so we get the time output
# Pass in jobserver info using the RMAKE variable
	${RMAKE}@( if set -x && source $${INFRA_REPO}/build/envsetup.sh && \
	rm -f $$@.errors $$@ $$@.repackaged && \
	$${INFRA_REPO}/build/build_$1.sh -c && source $${INFRA_REPO}/build/ccache-env-mathlib.sh && \
	time bash -x $${INFRA_REPO}/build/build_$1.sh $${RELEASE_FLAG} $${SANITIZER_FLAG} && $${INFRA_REPO}/build/post_inst_pkg.sh "$1" ; \
	then mv $$@.inprogress $$@ ; \
	else mv $$@.inprogress $$@.errors ; echo Error in $1 >&2 ; exit 1 ;\
	fi ) > $$@.inprogress 2>&1
endif # }

# end of toplevel macro
endef
# } End of test to see if toplevel is defined
endif

components:=$(sort $(components))

# Create all the T_xxxx and C_xxxx targets
$(call peval,$(foreach dep,$(strip ${components}),$(call toplevel,${dep})))

# Add all the T_xxxx targets to "all"  except those listed in NOBUILD
# Note this does not prohibit them from being built, it just means that
# a build of "all" will not force them to be built directly
# example command
#  make -f jenkins-utils/scripts/Stage1.mk -j60

##help all: Build everything
all: $(addprefix T_,$(filter-out ${NOBUILD},${components}))
	@echo All ROCm components built
# Do not document this target
upload: $(addprefix U_,${components})
	@echo All ROCm components built and uploaded

##help rocm-dev: Build a subset of ROCm
rocm-dev: T_rocm-dev
	@echo rocm-dev built

${OUT_DIR}/logs:
	sudo mkdir -p -m 775 "${ROCM_INSTALL_PATH}" && \
	sudo chown -R "$(shell id -u):$(shell id -g)" "${ROCM_INSTALL_PATH}"
	sudo chown -R "$(shell id -u):$(shell id -g)" "/home/$(shell id -un)"
	mkdir -p "${@}"
	mkdir -p ${HOME}/.ccache

##help clean: remove the output directory and recreate it
clean:
	[ -n "${OUT_DIR}" ] && rm -rf "${OUT_DIR}"
	mkdir -p ${OUT_DIR}/logs

.SECONDARY: ${components:%=${OUT_DIR}/logs/%}

.PHONY: all clean repack help list_components

##help list_components: output the list of components
##help : Hint make list_components | paste - - - | column -t
list_components:
	@echo "${components}" | sed 'y/ /\n/'

##help help:	show this text
help:
	@sed -n 's/^##help //p' ${MAKEFILE_LIST} | \
	    if type -t column > /dev/null ; then  column -s: -t ; else cat ; fi

FRC:
