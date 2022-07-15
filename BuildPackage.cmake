function(Build_VCPKG_Package vcpkg_libraries)
	list(LENGTH vcpkg_libraries list_length)

	if(list_length EQUAL 0)
		message(FATAL_ERROR "Variable must be a non-empty list.")
	endif()

	find_program(Git NAMES git)

	set(vcpkg_dir ${CMAKE_CURRENT_BINARY_DIR}/vcpkg)

	if(IS_DIRECTORY vcpkg_dir)
		file(REMOVE_RECURSE vcpkg_dir)
	endif()

	message(STATUS "Downloading VCPKG...")

	execute_process(
		WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
		COMMAND Git clone "https://github.com/microsoft/vcpkg.git"
	)

	if(WIN32)
		if(${CMAKE_CXX_COMPILER_ID} STREQUAL MSVC)
			set(VCPKG_START ${vcpkg_dir}/bootstrap-vcpkg.bat)
		else()
			message(FATAL_ERROR "Compiler must be a MSVC on Win32 platform.\nCurrently is '${CMAKE_CXX_COMPILER_ID}'.")
		endif()
	else()
		set(VCPKG_START ${vcpkg_dir}/bootstrap-vcpkg.sh)
	endif()

	message(STATUS "Installing VCPKG...")

	execute_process(COMMAND ${VCPKG_START})

	find_program(vcpkg_app NAMES vcpkg HINTS ${vcpkg_dir})

	foreach(package_name ${vcpkg_libraries})
		message(STATUS "vcpkg: Installing ${package_name}...")
		execute_process(
			COMMAND ${vcpkg_app} install ${package_name}
		)
	endforeach()
endfunction()