# Backup the original value of the requested library suffixes
set(_CMAKE_FIND_LIBRARY_SUFFIXES ${CMAKE_FIND_LIBRARY_SUFFIXES})
# Static libraries end with .a on Unix and .lib on Windows
set(CMAKE_FIND_LIBRARY_SUFFIXES .a .lib)

find_path(zstd_INCLUDE_DIR zstd.h)
find_library(zstd_LIBRARY zstd)

# Reset the library suffixes to the original value
set(CMAKE_FIND_LIBRARY_SUFFIXES ${_CMAKE_FIND_LIBRARY_SUFFIXES})
# Unset the temporary to not pollute the global namespace
unset(_CMAKE_FIND_LIBRARY_SUFFIXES)

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(StaticZSTD DEFAULT_MSG zstd_LIBRARY
    zstd_INCLUDE_DIR)


# We found the static ZSTD library and then we set this target which
# LLVM CMake uses to find the "shared" library. Then ZSTD gets linked
# statically with LFortran and everything works. This is dependent
# on LLVM's CMake. If it changes, we also have to change the handling
# here.

add_library(zstd::libzstd_shared INTERFACE IMPORTED)
set_property(TARGET zstd::libzstd_shared PROPERTY INTERFACE_INCLUDE_DIRECTORIES
    ${zstd_INCLUDE_DIR})
set_property(TARGET zstd::libzstd_shared PROPERTY INTERFACE_LINK_LIBRARIES
    ${zstd_LIBRARY})
