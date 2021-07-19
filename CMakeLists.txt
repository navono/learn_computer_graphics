cmake_minimum_required(VERSION 3.19)

set(TARGET learn_computer_graphics)
project(${TARGET} VERSION 0.0.1 LANGUAGES CXX)

#set(CMAKE_CXX_STANDARD 20)


# Options: Things you can set via commandline options to cmake (e.g. -DENABLE_LTO=[ON|OFF])
option(ENABLE_WARNINGS_SETTINGS "Allow target_set_warnings to add flags and defines.
                                 Set this to OFF if you want to provide your own warning parameters." ON)
option(ENABLE_LTO "Enable link time optimization" ON)
option(ENABLE_DOCTESTS "Include tests in the library. Setting this to OFF will remove all doctest related code.
                        Tests in tests/*.cpp will still be enabled." ON)

option(${PROJECT_NAME}_ENABLE_CONAN "Enable the Conan package manager for this project." ON)

# Include stuff. No change needed.
set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} "${CMAKE_SOURCE_DIR}/cmake/")
include(ConfigSafeGuards)
include(Colors)
include(CTest)
include(Doctest)
include(Documentation)
include(LTO)
include(Misc)
include(Warnings)

include(${CMAKE_BINARY_DIR}/conanbuildinfo.cmake)
conan_basic_setup()
#set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} ${CONAN_CXX_FLAGS}")

# Check for LTO support.
find_lto(CXX)

# --------------------------------------------------------------------------------
#                         Locate files (change as needed).
# --------------------------------------------------------------------------------
# All .cpp files in src/
set(SOURCES
        src/main.cpp
        include/logger.h)

# All .cpp files in tests/
set(TESTFILES
        tests/main.cpp
        )

add_executable(${TARGET} ${SOURCES} ${MY_VERSIONINFO_RC})


# Lib needs its header files, and users of the library must also see these (PUBLIC). (No change needed)
target_include_directories(${TARGET} PUBLIC ${PROJECT_SOURCE_DIR}/include)

# There's also (probably) doctests within the library, so we need to see this as well.
target_link_libraries(${TARGET} PUBLIC doctest)

# Set the compile options you want (change as needed).
target_set_warnings(${TARGET} ENABLE ALL AS_ERROR ALL DISABLE Annoying)
# target_compile_options(${LIBRARY_NAME} ... )  # For setting manually.

# Link the executable to library (if it uses it).
target_link_libraries(${TARGET} PRIVATE ${LIBRARY_NAME} PRIVATE ${CONAN_LIBS})

# Set warnings (if needed).
target_set_warnings(${TARGET} ENABLE ALL AS_ERROR ALL DISABLE Annoying)

# enable link-time-optimization if available for non-debug configurations
target_enable_lto(${TARGET} optimized)

if (MSVC)
    # disable warning as error
    target_compile_options(${TARGET} PRIVATE "/WX-" )
else()
    # lots of warnings and all warnings as errors
    target_compile_options(${TARGET} PRIVATE "-Wall -Wextra -pedantic -Werror")
endif()

# Set the properties you require, e.g. what C++ standard to use. Here applied to library and main (change as needed).
set_target_properties(
        ${TARGET}
            PROPERTIES
            CXX_STANDARD 20
            CXX_STANDARD_REQUIRED YES
            CXX_EXTENSIONS NO
            PDB_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/pdb"
)

# Set up tests (see tests/CMakeLists.txt).
add_subdirectory(tests)