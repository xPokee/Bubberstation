/datum/unit_test/modular_digitigrade_sprites

/datum/unit_test/modular_digitigrade_sprites/proc/get_folder_of_typepath(typepath)
	log_test("DEBUG: Starting folder search for [typepath]")

	var/list/modular_folders = list(
		"modular_skyrat",
		"modular_zubbers",
	)

	var/typepath_as_string = "[typepath]"

	for(var/folder_name in modular_folders)
		var/dir = "[folder_name]/"
		log_test("DEBUG: Checking folder [dir]")

		for(var/file in flist(dir))
			var/list/files = find_all_dm_files(dir)

			for(var/full_path in files)
				var/text = rustg_file_read(full_path)
				if(!text)
					continue

				if(findtext(text, typepath_as_string))
					return folder_name

	return null

/datum/unit_test/modular_digitigrade_sprites/proc/find_all_dm_files(dir)
	var/list/results = list()
	for(var/entry in flist(dir))
		var/path = "[dir][entry]"
		if(copytext(entry, -2) == "dm")
			results += path
		else if(copytext(entry, -1) == "/")
			results += find_all_dm_files(path)
	return results

/datum/unit_test/modular_digitigrade_sprites/Run()
	for(var/type in subtypesof(/obj/item/clothing/under))
		var/folder = get_folder_of_typepath(type)
		if(!(folder == "modular_zubbers" || folder == "modular_skyrat"))
			continue

		var/obj/item/clothing/under/item
		try
			item = allocate(type)
		catch(var/exception)
			TEST_FAIL("Failed to allocate [type]: [exception]")
			continue

		if(!("supports_variations_flags" in item.vars))
			TEST_FAIL("[type] has no supports_variations_flags variable.")
			continue

		var/flags = item.supports_variations_flags

		if(!(flags & CLOTHING_DIGITIGRADE_VARIATION) && !(flags & CLOTHING_DIGITIGRADE_VARIATION_NO_NEW_ICON))
			TEST_FAIL("[type] is missing required digitigrade variation flags.")
