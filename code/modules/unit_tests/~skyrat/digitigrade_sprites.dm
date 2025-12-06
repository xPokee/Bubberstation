/datum/unit_test/modular_digitigrade_sprites
	var/list/typepath_files = list()

	var/list/modular_folders = list(
		"modular_skyrat",
		"modular_zubbers",
	)

/datum/unit_test/modular_digitigrade_sprites/proc/get_folders_of_typepaths()
	for(var/folder_name in modular_folders)
		var/dir = "[folder_name]/"

		for(var/file in flist(dir))
			typepath_files |= file

			var/list/files = find_all_dm_files(dir)

			for(var/full_path in files)
				var/text = rustg_file_read(full_path)
				if(!text)
					continue

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
		do get_folders_of_typepaths(type)

		var/obj/item/clothing/under/item
		try
			item = allocate(type)
		catch(var/exception)
			TEST_FAIL("Failed to allocate [type]: [exception]")
			continue

		var/flags = item.supports_variations_flags

		if(!(flags & CLOTHING_DIGITIGRADE_VARIATION) && !(flags & CLOTHING_DIGITIGRADE_VARIATION_NO_NEW_ICON))
			TEST_FAIL("[type] is missing required digitigrade variation flags.")
