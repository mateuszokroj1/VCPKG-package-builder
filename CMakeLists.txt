cmake_minimum_required(VERSION 3.20)

include(DownloadPackageFromGitHub.cmake)

Download_VCPKG_Package("mateuszokroj1" "VCPKG-package-builder" "abcd", "${CMAKE_SOURCE_DIR}/.3rd")