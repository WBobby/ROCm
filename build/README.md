# Overview for ROCm.mk
This Makefile builds the various projects that makes up ROCm in the correct order.
It is expected to be run in an environment with the tooling set up. An easy way
to do this is to use Docker.
# Targets
- all (default)
- rocm-dev (a subset of all)
- clean
- list_components
- help
- T_foo
- C_foo


# Makefile Variables
- BUILDSIGS enable experimintal component builds
- PEVAL set to 1 to enable some Makefile debugging code.
- ENABLE\_ADDRESS\_SANITIZER set to "true" to enable address sanitizer builds
- RELEASE\_FLAG set to "" to avoid passing "-r" to builds, effect is package defined.
- NOBUILD="foo bar" to avoid adding foo and bar into the dependencies of top level targets. They still may be
  built if they are needed as dependencies of other top level targets.
- toplevel 

# Makefile assumptions

## Global requirements

### upload\_packages.sh foo
This should do an "upload" of the target "foo" to an artifact storage if applicable.

### download\_package "foo"
This should download a prebuilt package "foo" if available, otherwise return failure.
This is a spped optimization which allows reuse of previously built packages.

### repack "foo"
Obsolute before it was every used. Should repack "foo" to match current build.

## Requirements for package "foo"

### program build\_foo.sh
- Should take option "-c" to clean
- Should take option "-a" to do an address sanitizer build. This option may be a NOP but should exist
- Should take option "-r" to do a normal "RelWithDeb" build

#### Future work?
- should take an option "-P steps" to say which phases should be built. "c" for clean,
  "m" for make, "i" for install, "p" for package, "u" for upload.

## For package "foo" we define some targets
- T\_foo - The main build target, calls "build\_foo.sh -r"
- C\_foo - Clean target, calls "build_foo.sh -c"
- U\_foo - Upload target, calls "upload_packages.sh foo"
