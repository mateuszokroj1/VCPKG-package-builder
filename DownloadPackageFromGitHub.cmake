function(Download_VCPKG_Package owner repo_name api_token version_id destination_dir)
	if(${owner} MATCHES "^[A-z0-9_\\.-]+$")
		message("Owner name is correct.")
	else()
		message(FATAL_ERROR "Owner name is not correct.")
	endif()

	if(${repo_name} MATCHES "^[A-z0-9_\\.-]+$")
		message("Repository name is correct.")
	else()
		message(FATAL_ERROR "Repository name is not correct.")
	endif()

	if(${api_token} MATCHES "^[A-z0-9_-]+$")
		message("API token is correct.")
	else()
		message(FATAL_ERROR "API token is not correct.")
	endif()

	if(${version_id} MATCHES "^[A-z0-9_-]+$")
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
	message("Searching for: ${target_artifact_name}.")

	file(DOWNLOAD
		"https://api.github.com/repos/${owner}/${repo_name}/actions/artifacts"
		${CMAKE_CURRENT_LIST_DIR}/index_json
		HTTPHEADER "Accept: application/vnd.github+json"
		HTTPHEADER "Authorization: token ${api_token}"
		SHOW_PROGRESS
		STATUS status_list)
	
	list(GET status_list 0 response_code)
	if(NOT(${response_code} EQUAL 0))
		message(FATAL_ERROR "Cannot read Artifacts index from GitHub API.")
	endif()
	
	file(READ ${CMAKE_CURRENT_LIST_DIR}/index_json json_content)
	
	string(LENGTH ${json_content} content_length)
	if(${content_length} LESS 4)
		message(FATAL_ERROR "Cannot read Artifacts index from GitHub API.")
	endif()

	string(JSON artifacts_count GET ${json_content} "total_count")
	message("Found ${artifacts_count} items.")

	string(JSON artifacts_list GET ${json_content} "artifacts")

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

	set(downloaded_archive_name "${target_artifact_name}.zip")
	message("File will be downloaded to:\n${CMAKE_CURRENT_LIST_DIR}/${downloaded_archive_name}")
	file(DOWNLOAD
		${zip_url}
		${CMAKE_CURRENT_LIST_DIR}/${downloaded_archive_name}
		HTTPHEADER "Accept: application/vnd.github+json"
		HTTPHEADER "Authorization: token ${api_token}"
		LOG download_log
		SHOW_PROGRESS
		STATUS response_code)

	list(GET status_list 0 response_code)
	if(NOT(${response_code} EQUAL 0))
		message(FATAL_ERROR "Cannot download archive from GitHub API.")
	endif()

	message("${download_log}")

	file(ARCHIVE_EXTRACT
		INPUT ${CMAKE_CURRENT_LIST_DIR}/${downloaded_archive_name}
		DESTINATION ${destination_dir}
	)

endfunction()