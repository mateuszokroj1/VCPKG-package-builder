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

	file(DOWNLOAD "https://api.github.com/repos/${owner}/${repo_name}/actions/artifacts" ${CMAKE_CURRENT_LIST_DIR}/index_json)
	file(STRINGS ${CMAKE_CURRENT_LIST_DIR}/index_json json_content)
	message("${json_content}")

endfunction()