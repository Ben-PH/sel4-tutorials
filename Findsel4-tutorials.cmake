#
# Copyright 2019, Data61
# Commonwealth Scientific and Industrial Research Organisation (CSIRO)
# ABN 41 687 119 230.
#
# This software may be distributed and modified according to the terms of
# the BSD 2-Clause license. Note that NO WARRANTY is provided.
# See "LICENSE_BSD2.txt" for details.
#
# @TAG(DATA61_BSD)
#

set(SEL4_TUTORIALS_DIR "${CMAKE_CURRENT_LIST_DIR}" CACHE STRING "")
mark_as_advanced(SEL4_TUTORIALS_DIR)

# Include cmake tutorial helper functions
include(${SEL4_TUTORIALS_DIR}/cmake/helpers.cmake)

macro(sel4_tutorials_regenerate_tutorial tutorial_dir)
    # generate tutorial sources into directory

    GenerateTutorial(${tutorial_dir})
    # Add the tutorial directory the same as any other project
    # add_subdirectory(${CMAKE_SOURCE_DIR}/${TUTORIAL_DIR} ${CMAKE_BINARY_DIR}/${TUTORIAL_DIR})
    # message("${CMAKE_CURRENT_LIST_DIR} ${CMAKE_CURRENT_SOURCE_DIR}")
    if(${CMAKE_CURRENT_LIST_DIR} STREQUAL ${CMAKE_CURRENT_SOURCE_DIR})
        get_property(tute_hack GLOBAL PROPERTY DONE_TUTE_HACK)
        if(NOT tute_hack)
            set_property(GLOBAL PROPERTY DONE_TUTE_HACK TRUE)
            # We are in the main project phase and regenerating the tutorial
            # may have updated the file calling us.  So we do some magic...
            # message("err ${CMAKE_CURRENT_SOURCE_DIR}")
            include(${CMAKE_CURRENT_SOURCE_DIR}/CMakeLists.txt)
            return()
        endif()
    endif()

endmacro()

macro(sel4_tutorials_import_libsel4tutorials)
    add_subdirectory(${SEL4_TUTORIALS_DIR}/libsel4tutorials libsel4tutorials)
endmacro()

macro(sel4_tutorials_setup_roottask_tutorial_environment)

    find_package(seL4 REQUIRED)
    find_package(elfloader-tool REQUIRED)
    find_package(musllibc REQUIRED)
    find_package(util_libs REQUIRED)
    find_package(seL4_libs REQUIRED)

    sel4_import_kernel()
    elfloader_import_project()

    # This sets up environment build flags and imports musllibc and runtime libraries.
    musllibc_setup_build_environment_with_sel4runtime()
    sel4_import_libsel4()
    util_libs_import_libraries()
    sel4_libs_import_libraries()
    sel4_tutorials_import_libsel4tutorials()

endmacro()

macro(sel4_tutorials_setup_capdl_tutorial_environment)
    sel4_tutorials_setup_roottask_tutorial_environment()
    capdl_import_project()
    CapDLToolInstall(install_capdl_tool CAPDL_TOOL_BINARY)
endmacro()

include(FindPackageHandleStandardArgs)
FIND_PACKAGE_HANDLE_STANDARD_ARGS(camkes-tool DEFAULT_MSG SEL4_TUTORIALS_DIR)
