cmake_minimum_required(VERSION 3.20)

include(BuildPackage.cmake)

if(NOT DEFINED vcpkg_libraries)
	message(FATAL_ERROR "You mus firstly specify 'vcpkg_libraries' variable as list of package names.")
endif()

BUILD_VCPKG_PACKAGE()