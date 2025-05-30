#define ORBIE_MAXIMUM_HEALTH 300

/mob/living/basic/orbie
	name = "Orbie"
	desc = "An orb shaped hologram."
	icon = 'icons/mob/simple/pets.dmi'
	icon_state = "orbie"
	icon_living = "orbie"
	speed = 0
	maxHealth = 100
	status_flags = CANPUSH
	light_on = FALSE
	light_system = OVERLAY_LIGHT
	light_range = 6
	light_color = "#64bee1"
	health = 100
	habitable_atmos = null
	unsuitable_atmos_damage = 0
	can_buckle_to = FALSE
	density = FALSE
	pass_flags = PASSMOB
	move_force = 0
	move_resist = 0
	pull_force = 0
	minimum_survivable_temperature = TCMB
	maximum_survivable_temperature = INFINITY
	death_message = "fades out of existence!"
	ai_controller = /datum/ai_controller/basic_controller/orbie
	damage_coeff = list(BRUTE = 1, BURN = 1, TOX = 1, STAMINA = 0, OXY = 1)
	///are we happy or not?
	var/happy_state = FALSE
	///overlay for our neutral eyes
	var/static/mutable_appearance/eyes_overlay = mutable_appearance('icons/mob/simple/pets.dmi', "orbie_eye_overlay")
	///overlay for when our eyes are emitting light
	var/static/mutable_appearance/orbie_light_overlay = mutable_appearance('icons/mob/simple/pets.dmi', "orbie_light_overlay")
	///overlay for the flame propellar
	var/static/mutable_appearance/flame_overlay = mutable_appearance('icons/mob/simple/pets.dmi', "orbie_flame_overlay")
	///overlay for our happy eyes
	var/static/mutable_appearance/happy_eyes_overlay = mutable_appearance('icons/mob/simple/pets.dmi', "orbie_happy_eye_overlay")
	///commands we can give orbie
	var/static/list/pet_commands = list(
		/datum/pet_command/idle,
		/datum/pet_command/free,
		/datum/pet_command/move,
		/datum/pet_command/untargeted_ability/pet_lights,
		/datum/pet_command/use_ability/take_photo,
		/datum/pet_command/follow/orbie,
		/datum/pet_command/perform_trick_sequence,
	)

/mob/living/basic/orbie/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/holographic_nature)
	var/static/list/food_types = list(/obj/item/food/virtual_chocolate)
	AddComponent(/datum/component/obeys_commands, pet_commands)
	AddElement(/datum/element/basic_eating, food_types = food_types)
	ADD_TRAIT(src, TRAIT_SILICON_EMOTES_ALLOWED, INNATE_TRAIT)

	RegisterSignal(src, COMSIG_VIRTUAL_PET_LEVEL_UP, PROC_REF(on_level_up))
	RegisterSignal(src, COMSIG_ATOM_UPDATE_LIGHT_ON, PROC_REF(on_lights))
	ai_controller.set_blackboard_key(BB_BASIC_FOODS, typecacheof(food_types))
	update_appearance()

/mob/living/basic/orbie/early_melee_attack(atom/target, list/modifiers, ignore_cooldown)
	. = ..()
	if(!.)
		return FALSE
	if(src == target || happy_state || !istype(target))
		return TRUE

	toggle_happy_state()
	addtimer(CALLBACK(src, PROC_REF(toggle_happy_state)), 30 SECONDS)
	return FALSE

/mob/living/basic/orbie/proc/on_lights(datum/source)
	SIGNAL_HANDLER

	update_appearance()

/mob/living/basic/orbie/proc/toggle_happy_state()
	happy_state = !happy_state
	update_appearance()

/mob/living/basic/orbie/can_be_pulled(user, force)
	return FALSE

/mob/living/basic/orbie/proc/on_level_up(datum/source, new_level)
	SIGNAL_HANDLER

	if(maxHealth >= ORBIE_MAXIMUM_HEALTH)
		UnregisterSignal(src, COMSIG_VIRTUAL_PET_LEVEL_UP)
		return

	maxHealth += 100
	heal_overall_damage(maxHealth - health)


/mob/living/basic/orbie/update_overlays()
	. = ..()
	if(stat == DEAD)
		return
	. += flame_overlay
	if(happy_state)
		. += happy_eyes_overlay
	else if(light_on)
		. += orbie_light_overlay
	else
		. += eyes_overlay

/mob/living/basic/orbie/gib()
	death(TRUE)

#undef ORBIE_MAXIMUM_HEALTH
