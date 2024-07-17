/obj/item/organ/internal/stomach/protean
	name = "refactory module"
	desc = "A miniature metal processing unit and nanite factory."
	icon = 'modular_zubbers/icons/mob/species/protean/protean.dmi'
	icon_state = "refactory"
	organ_traits = list(TRAIT_NOHUNGER)

	/// How much max metal can we hold at any given time (In sheets)
	var/metal_max = PROTEAN_STOMACH_FULL
	/// How much metal are we holding currently (In sheets)
	var/metal = PROTEAN_STOMACH_FULL

/obj/item/organ/internal/stomach/protean/Initialize(mapload)
	. = ..()
	metal = rand(PROTEAN_STOMACH_FULL/2, PROTEAN_STOMACH_FULL)

/obj/item/organ/internal/stomach/protean/on_life(seconds_per_tick, times_fired)
	. = ..()
	metal -= ((PROTEAN_STOMACH_FULL / 4000) * seconds_per_tick)
	handle_hunger_slowdown(owner)

/// Reused here to check if our stomach is faltering
/obj/item/organ/internal/stomach/protean/handle_hunger_slowdown(mob/living/carbon/human/human)
	if(!istype(owner.dna.species, /datum/species/protean))
		return
	if(metal > PROTEAN_STOMACH_FALTERING)
		return
	// Insert integrity faltering code here once that's done

#undef PROTEAN_STOMACH_FULL
#undef PROTEAN_STOMACH_FALTERING
