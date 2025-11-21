/datum/preference/toggle/has_custom_tongue
	category = PREFERENCE_CATEGORY_NON_CONTEXTUAL
	savefile_key = "has_custom_tongue"
	savefile_identifier = PREFERENCE_CHARACTER
	default_value = FALSE
	can_randomize = FALSE

/datum/preference/toggle/has_custom_tongue/apply_to_human(mob/living/carbon/human/target, value, datum/preferences/preferences)
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
	if (!..())
		return FALSE
	return user_preferences.read_preference(/datum/preference/toggle/has_custom_tongue)

/datum/preference/text/custom_tongue/apply_to_human(mob/living/carbon/human/target, value)
	return

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

/mob/living/carbon/human/proc/apply_custom_tongue_preferences()
	var/client/human_client = client
	if(!human_client)
		return FALSE

	if(!human_client.prefs.read_preference(/datum/preference/toggle/has_custom_tongue))
		return FALSE

	var/custom_ask = human_client.prefs.read_preference(/datum/preference/text/custom_tongue/ask)
	if (custom_ask)
		verb_ask = LOWER_TEXT(custom_ask)

	var/custom_exclaim = human_client.prefs.read_preference(/datum/preference/text/custom_tongue/exclaim)
	if (custom_exclaim)
		verb_exclaim = LOWER_TEXT(custom_exclaim)

	var/custom_whisper = human_client.prefs.read_preference(/datum/preference/text/custom_tongue/whisper)
	if (custom_whisper)
		verb_whisper = LOWER_TEXT(custom_whisper)

	var/custom_yell = human_client.prefs.read_preference(/datum/preference/text/custom_tongue/yell)
	if (custom_yell)
		verb_yell = LOWER_TEXT(custom_yell)

	var/custom_say = human_client.prefs.read_preference(/datum/preference/text/custom_tongue/say)
	if (custom_say)
		var/obj/item/organ/tongue/tongue_organ = get_organ_slot(ORGAN_SLOT_TONGUE)
		if(tongue_organ)
			tongue_organ.say_mod = LOWER_TEXT(custom_say)

	return TRUE

/mob/living/carbon/human/proc/reset_custom_tongue_to_default()
	verb_ask = initial(verb_ask)
	verb_exclaim = initial(verb_exclaim)
	verb_whisper = initial(verb_whisper)
	verb_yell = initial(verb_yell)

	var/obj/item/organ/tongue/tongue_organ = get_organ_slot(ORGAN_SLOT_TONGUE)
	if(tongue_organ)
		tongue_organ.say_mod = initial(tongue_organ.say_mod)

	return TRUE

/mob/living/carbon/human/proc/register_custom_tongue_signal()
	RegisterSignal(src, COMSIG_SET_SAY_MODIFIERS, PROC_REF(apply_custom_tongue_signal))
	apply_custom_tongue_preferences()
	return

/mob/living/carbon/human/proc/apply_custom_tongue_signal()
	SIGNAL_HANDLER
	apply_custom_tongue_preferences()
	return
