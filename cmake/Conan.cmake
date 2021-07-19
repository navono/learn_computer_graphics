# Download automatically, you can also just copy the conan.cmake file
if(NOT EXISTS "${CMAKE_BINARY_DIR}/conan.cmake")
  message(STATUS "Downloading conan.cmake from https://github.com/conan-io/cmake-conan")
  file(DOWNLOAD "https://raw.githubusercontent.com/conan-io/cmake-conan/master/conan.cmake"
          "${CMAKE_BINARY_DIR}/conan.cmake")
endif()

include(${CMAKE_BINARY_DIR}/conan.cmake)

# because Coverage need CMAKE_BUILD_TYPE, but conflict with conan's build_type options, so simple change it during CMAKE_BUILD_TYPE is Coverage
if (${CMAKE_BUILD_TYPE} STREQUAL Coverage)
  # make conan pass
  set(CMAKE_BUILD_TYPE Debug)
  conan_cmake_run(
          REQUIRES
          ${CONAN_EXTRA_REQUIRES}
          OPTIONS
          ${CONAN_EXTRA_OPTIONS}
          BASIC_SETUP
          CMAKE_TARGETS
          BUILD
          missing
  )
  # make coverage pass
  set(CMAKE_BUILD_TYPE Coverage)
else()
  conan_cmake_run(
          REQUIRES
          ${CONAN_EXTRA_REQUIRES}
          OPTIONS
          ${CONAN_EXTRA_OPTIONS}
          BASIC_SETUP
          CMAKE_TARGETS
          BUILD
          missing
  )
endif ()



