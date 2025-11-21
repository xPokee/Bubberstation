/datum/preference/toggle/has_custom_tongue
	category = PREFERENCE_CATEGORY_NON_CONTEXTUAL
	savefile_key = "has_custom_tongue"
	savefile_identifier = PREFERENCE_CHARACTER
	default_value = FALSE
	can_randomize = FALSE

/datum/preference/toggle/has_custom_tongue/apply_to_human(mob/living/carbon/human/target, value)
	return

/datum/preference/text/custom_tongue
	category = PREFERENCE_CATEGORY_NON_CONTEXTUAL
	savefile_key = "custom_tongue"
	savefile_identifier = PREFERENCE_CHARACTER
	can_randomize = FALSE
	maximum_value_length = 64 // We may want to lower this for sanity.

/datum/preference/text/custom_tongue/serialize(input_text)
	var/regex/unwanted_regex = regex(@"[^a-z]") // Prevent people from inputting slop into my text fields. No, you CAN'T have an eggplant emoji for when you whisper.
	if(unwanted_regex.Find(input_text))
		return null // No fun allowed.
	return htmlrendertext(input_text)

/datum/preference/text/custom_tongue/is_accessible(datum/preferences/user_preferences)
	if(!..())
		return FALSE
	return user_preferences.read_preference(/datum/preference/toggle/has_custom_tongue)

/datum/preference/text/custom_tongue/apply_to_human(mob/living/carbon/human/target, value)
	var/obj/item/organ/tongue/mob_tongue = target.get_organ_slot(ORGAN_SLOT_TONGUE)
	if(!mob_tongue)
		return

	var/say_pref = target.client?.prefs.read_preference(/datum/preference/text/custom_tongue/say)
	var/exclaim_pref = target.client?.prefs.read_preference(/datum/preference/text/custom_tongue/exclaim)
	var/whisper_pref = target.client?.prefs.read_preference(/datum/preference/text/custom_tongue/whisper)
	var/yell_pref = target.client?.prefs.read_preference(/datum/preference/text/custom_tongue/yell)
	var/ask_pref = target.client?.prefs.read_preference(/datum/preference/text/custom_tongue/ask)

	mob_tongue.set_say_modifiers(target,
		say = say_pref ? LOWER_TEXT(say_pref) : initial(mob_tongue.verb_say),
		exclaim = exclaim_pref ? LOWER_TEXT(exclaim_pref) : initial(mob_tongue.verb_exclaim),
		whisper = whisper_pref ? LOWER_TEXT(whisper_pref) : initial(mob_tongue.verb_whisper),
		yell = yell_pref ? LOWER_TEXT(yell_pref) : initial(mob_tongue.verb_yell),
		ask = ask_pref ? LOWER_TEXT(ask_pref) : initial(mob_tongue.verb_ask),
	)

/datum/preference/text/custom_tongue/ask
	savefile_key = "custom_tongue_ask"

/datum/preference/text/custom_tongue/exclaim
	savefile_key = "custom_tongue_exclaim"

/datum/preference/text/custom_tongue/whisper
	savefile_key = "custom_tongue_whisper"

/datum/preference/text/custom_tongue/yell
	savefile_key = "custom_tongue_yell"

/datum/preference/text/custom_tongue/say
	savefile_key = "custom_tongue_say"
