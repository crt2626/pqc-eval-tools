# Install script for directory: /home/cuserp1/work/test/pqc-eval-tools/liboqs/src

# Set the install prefix
if(NOT DEFINED CMAKE_INSTALL_PREFIX)
  set(CMAKE_INSTALL_PREFIX "/home/cuserp1/work/test/pqc-eval-tools/liboqs/arm-liboqs-linux")
endif()
string(REGEX REPLACE "/$" "" CMAKE_INSTALL_PREFIX "${CMAKE_INSTALL_PREFIX}")

# Set the install configuration name.
if(NOT DEFINED CMAKE_INSTALL_CONFIG_NAME)
  if(BUILD_TYPE)
    string(REGEX REPLACE "^[^A-Za-z0-9_]+" ""
           CMAKE_INSTALL_CONFIG_NAME "${BUILD_TYPE}")
  else()
    set(CMAKE_INSTALL_CONFIG_NAME "")
  endif()
  message(STATUS "Install configuration: \"${CMAKE_INSTALL_CONFIG_NAME}\"")
endif()

# Set the component getting installed.
if(NOT CMAKE_INSTALL_COMPONENT)
  if(COMPONENT)
    message(STATUS "Install component: \"${COMPONENT}\"")
    set(CMAKE_INSTALL_COMPONENT "${COMPONENT}")
  else()
    set(CMAKE_INSTALL_COMPONENT)
  endif()
endif()

# Install shared libraries without execute permission?
if(NOT DEFINED CMAKE_INSTALL_SO_NO_EXE)
  set(CMAKE_INSTALL_SO_NO_EXE "1")
endif()

# Is this installation the result of a crosscompile?
if(NOT DEFINED CMAKE_CROSSCOMPILING)
  set(CMAKE_CROSSCOMPILING "FALSE")
endif()

# Set default install directory permissions.
if(NOT DEFINED CMAKE_OBJDUMP)
  set(CMAKE_OBJDUMP "/usr/bin/objdump")
endif()

if("x${CMAKE_INSTALL_COMPONENT}x" STREQUAL "xUnspecifiedx" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/lib/cmake/liboqs" TYPE FILE FILES
    "/home/cuserp1/work/test/pqc-eval-tools/liboqs/arm-liboqs-linux/src/liboqsConfig.cmake"
    "/home/cuserp1/work/test/pqc-eval-tools/liboqs/arm-liboqs-linux/src/liboqsConfigVersion.cmake"
    )
endif()

if("x${CMAKE_INSTALL_COMPONENT}x" STREQUAL "xUnspecifiedx" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/lib" TYPE STATIC_LIBRARY FILES "/home/cuserp1/work/test/pqc-eval-tools/liboqs/arm-liboqs-linux/lib/liboqs.a")
endif()

if("x${CMAKE_INSTALL_COMPONENT}x" STREQUAL "xUnspecifiedx" OR NOT CMAKE_INSTALL_COMPONENT)
  if(EXISTS "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/cmake/liboqs/liboqsTargets.cmake")
    file(DIFFERENT EXPORT_FILE_CHANGED FILES
         "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/cmake/liboqs/liboqsTargets.cmake"
         "/home/cuserp1/work/test/pqc-eval-tools/liboqs/arm-liboqs-linux/src/CMakeFiles/Export/lib/cmake/liboqs/liboqsTargets.cmake")
    if(EXPORT_FILE_CHANGED)
      file(GLOB OLD_CONFIG_FILES "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/cmake/liboqs/liboqsTargets-*.cmake")
      if(OLD_CONFIG_FILES)
        message(STATUS "Old export file \"$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/cmake/liboqs/liboqsTargets.cmake\" will be replaced.  Removing files [${OLD_CONFIG_FILES}].")
        file(REMOVE ${OLD_CONFIG_FILES})
      endif()
    endif()
  endif()
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/lib/cmake/liboqs" TYPE FILE FILES "/home/cuserp1/work/test/pqc-eval-tools/liboqs/arm-liboqs-linux/src/CMakeFiles/Export/lib/cmake/liboqs/liboqsTargets.cmake")
  if("${CMAKE_INSTALL_CONFIG_NAME}" MATCHES "^()$")
    file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/lib/cmake/liboqs" TYPE FILE FILES "/home/cuserp1/work/test/pqc-eval-tools/liboqs/arm-liboqs-linux/src/CMakeFiles/Export/lib/cmake/liboqs/liboqsTargets-noconfig.cmake")
  endif()
endif()

if("x${CMAKE_INSTALL_COMPONENT}x" STREQUAL "xUnspecifiedx" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/include/oqs" TYPE FILE FILES
    "/home/cuserp1/work/test/pqc-eval-tools/liboqs/src/oqs.h"
    "/home/cuserp1/work/test/pqc-eval-tools/liboqs/src/common/common.h"
    "/home/cuserp1/work/test/pqc-eval-tools/liboqs/src/common/rand/rand.h"
    "/home/cuserp1/work/test/pqc-eval-tools/liboqs/src/common/aes/aes.h"
    "/home/cuserp1/work/test/pqc-eval-tools/liboqs/src/common/sha2/sha2.h"
    "/home/cuserp1/work/test/pqc-eval-tools/liboqs/src/common/sha3/sha3.h"
    "/home/cuserp1/work/test/pqc-eval-tools/liboqs/src/common/sha3/sha3x4.h"
    "/home/cuserp1/work/test/pqc-eval-tools/liboqs/src/kem/kem.h"
    "/home/cuserp1/work/test/pqc-eval-tools/liboqs/src/sig/sig.h"
    "/home/cuserp1/work/test/pqc-eval-tools/liboqs/src/kem/bike/kem_bike.h"
    "/home/cuserp1/work/test/pqc-eval-tools/liboqs/src/kem/frodokem/kem_frodokem.h"
    "/home/cuserp1/work/test/pqc-eval-tools/liboqs/src/kem/ntruprime/kem_ntruprime.h"
    "/home/cuserp1/work/test/pqc-eval-tools/liboqs/src/kem/classic_mceliece/kem_classic_mceliece.h"
    "/home/cuserp1/work/test/pqc-eval-tools/liboqs/src/kem/hqc/kem_hqc.h"
    "/home/cuserp1/work/test/pqc-eval-tools/liboqs/src/kem/kyber/kem_kyber.h"
    "/home/cuserp1/work/test/pqc-eval-tools/liboqs/src/sig/dilithium/sig_dilithium.h"
    "/home/cuserp1/work/test/pqc-eval-tools/liboqs/src/sig/falcon/sig_falcon.h"
    "/home/cuserp1/work/test/pqc-eval-tools/liboqs/src/sig/sphincs/sig_sphincs.h"
    "/home/cuserp1/work/test/pqc-eval-tools/liboqs/arm-liboqs-linux/include/oqs/oqsconfig.h"
    )
endif()

if(NOT CMAKE_INSTALL_LOCAL_ONLY)
  # Include the install script for each subdirectory.
  include("/home/cuserp1/work/test/pqc-eval-tools/liboqs/arm-liboqs-linux/src/common/cmake_install.cmake")
  include("/home/cuserp1/work/test/pqc-eval-tools/liboqs/arm-liboqs-linux/src/kem/bike/cmake_install.cmake")
  include("/home/cuserp1/work/test/pqc-eval-tools/liboqs/arm-liboqs-linux/src/kem/frodokem/cmake_install.cmake")
  include("/home/cuserp1/work/test/pqc-eval-tools/liboqs/arm-liboqs-linux/src/kem/ntruprime/cmake_install.cmake")
  include("/home/cuserp1/work/test/pqc-eval-tools/liboqs/arm-liboqs-linux/src/kem/classic_mceliece/cmake_install.cmake")
  include("/home/cuserp1/work/test/pqc-eval-tools/liboqs/arm-liboqs-linux/src/kem/hqc/cmake_install.cmake")
  include("/home/cuserp1/work/test/pqc-eval-tools/liboqs/arm-liboqs-linux/src/kem/kyber/cmake_install.cmake")
  include("/home/cuserp1/work/test/pqc-eval-tools/liboqs/arm-liboqs-linux/src/sig/dilithium/cmake_install.cmake")
  include("/home/cuserp1/work/test/pqc-eval-tools/liboqs/arm-liboqs-linux/src/sig/falcon/cmake_install.cmake")
  include("/home/cuserp1/work/test/pqc-eval-tools/liboqs/arm-liboqs-linux/src/sig/sphincs/cmake_install.cmake")

endif()

