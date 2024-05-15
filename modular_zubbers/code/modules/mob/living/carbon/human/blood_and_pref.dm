/datum/preference/color/blood_pref
	category = PREFERENCE_CATEGORY_SECONDARY_FEATURES
	savefile_identifier = PREFERENCE_CHARACTER
	savefile_key = "blood_colour"


/datum/preference/color/blood_pref/apply_to_human(mob/living/carbon/human/target, value, datum/preferences/preferences)
	target.dna.blood_colour = value


/datum/dna/var/blood_colour = "#ff0000"



/obj/effect/decal/cleanable/blood/var/mob/living/carbon/from = null

/obj/effect/decal/cleanable/blood/Initialize(mapload)
	. = ..()
	color = from ? from.dna.blood_colour : "#FFFFFF"
