/obj/item/mod/control/pre_equipped/protean
	name = "hardsuit rig"
	desc = "The hardsuit rig unit of a Protean, allowing them to retract into it, or to deploy a suit that protects against various environments."
	theme = /datum/mod_theme/protean

/datum/mod_theme/protean
	name = "Protean"
	desc = ""

/obj/item/mod/control/pre_equipped/protean/Initialize(mapload, datum/mod_theme/new_theme, new_skin, obj/item/mod/core/new_core)
	. = ..()
	ADD_TRAIT(src, TRAIT_NODROP, QUIRK_TRAIT)
	actions_types += list()
