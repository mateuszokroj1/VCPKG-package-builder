function(Download_VCPKG_Package owner repo_name version_id)
	if(owner MATCHES "^[A-z0-9_\\.-]+$")
		message("Owner name is correct.")
	else()
		message(FATAL_ERROR "Owner name is not correct.")
	endif()

	if(repo_name MATCHES "^[A-z0-9_\\.-]+$")
		message("Repository name is correct.")
	else()
		message(FATAL_ERROR "Repository name is not correct.")
	endif()

	if(version_id MATCHES "^[A-z0-9_-]+$")
		message("Version Id is correct.")
	else()
		message(FATAL_ERROR "Version Id is not correct.")
	endif()

	message(STATUS "Connecting to GitHub API...")

	if(CMAKE_SYSTEM_NAME equal "Windows")
		set(target_platform "Windows")
	elseif(CMAKE_SYSTEM_NAME equal "Darwin")
		set(target_platform "MacOS")
	else()
		set(target_platform "Linux")
	endif()

	file(DOWNLOAD "https://api.github.com/repos/${owner}/${repo_name}/actions/artifacts/${version-id}-${target_platform}" ${CMAKE_CURRENT_LIST_DIR}/index_json)
	file(STRINGS ${CMAKE_CURRENT_LIST_DIR}/index_json json_content)
	
	string(LENGTH json_content json_length)

	if(json_length LESS 1)
		message(FATAL_ERROR "GitHub API returned empty response. Maybe artifact not exist.")
	endif()

endfunction()