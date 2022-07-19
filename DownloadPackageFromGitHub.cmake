function(Download_VCPKG_Package owner repo_name version_id destination_dir)
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

	if(CMAKE_SYSTEM_NAME STREQUAL "Windows")
		set(target_platform "Windows")
	elseif(CMAKE_SYSTEM_NAME STREQUAL "Darwin")
		set(target_platform "macOS")
	else()
		set(target_platform "Linux")
	endif()

	set(target_artifact_name "${version_id}-${target_platform}")
	message("Artifact name is: ${target_artifact_name}.")

	file(DOWNLOAD "https://api.github.com/repos/${owner}/${repo_name}/actions/artifacts" ${CMAKE_CURRENT_LIST_DIR}/index_json)
	file(READ ${CMAKE_CURRENT_LIST_DIR}/index_json json_content)
	
	if(NOT json_content)
		message(FATAL_ERROR "GitHub API returned empty response. Maybe artifact not exist.")
	endif()

	string(JSON artifacts_count GET ${json_content} "total_count")
	message("Found ${artifacts_count} items.")

	string(JSON artifacts_list GET ${json_content} "artifacts")
	
	message("${artifacts_list}")

	set(zip_url "")
	foreach(item_index RANGE ${artifacts_count})
		string(JSON current_name GET ${artifacts_list} ${item_index} "name")

		message("Name of ${item_index} is ${current_name}.")

		if(${current_name} STREQUAL ${target_artifact_name})
			string(JSON zip_url GET ${artifacts_list} ${item_index} "archive_download_url")
			break()
		endif()
	endforeach()
	
	string(LENGTH ${zip_url} url_length)
	if(${url_length} LESS 4)
		message(FATAL_ERROR "Cannot read Archive URL from GitHub API.")
	endif()

	message("${zip_url}")

	set(downloaded_archive_name "${target_artifact_name}.zip")
	file(DOWNLOAD ${zip_url} ${CMAKE_CURRENT_LIST_DIR}/${downloaded_archive_name})
endfunction()