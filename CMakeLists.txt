cmake_minimum_required(VERSION 3.20)

include(BuildPackage.cmake)

if(NOT DEFINED libraries)
	message(FATAL_ERROR "You must firstly specify 'libraries' variable as list of package names.")
endif()

BUILD_VCPKG_PACKAGE("${libraries}")