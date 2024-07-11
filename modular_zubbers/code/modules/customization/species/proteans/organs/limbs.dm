/// This is my first attempt at a multiline macro/define.
/// Basically, instead of writing or even copypasting code for each limb, we just shove it into this
/// I really hope you, as the future reader, will understand how this works
/// If not, God be with you

/// This one is simple, gives it the correct bodytypes, and the correct name
#define PROTEAN_BODYPART_DEFINE(path, health) \
##path {\
	max_damage = ##health; \
	limb_species = SPECIES_PROTEAN; \
	bodytype = parent_type::bodytype | BODYTYPE_NANO; \
}

/// Reworks the logic for dismembering, once your limb would get mangled it loses its integrity and falls off
#define PROTEAN_DELIMB_DEFINE(path) \
##path/try_dismember(wounding_type, wounding_dmg, wound_bonus, bare_wound_bonus) {\
	if(((get_damage() + wounding_dmg) >= max_damage)) {\
		dismember();\
	}\
}


// Core
PROTEAN_BODYPART_DEFINE(/obj/item/bodypart/head/mutant/protean, 120)
PROTEAN_DELIMB_DEFINE(/obj/item/bodypart/head/mutant/protean)

PROTEAN_BODYPART_DEFINE(/obj/item/bodypart/chest/mutant/protean, LIMB_MAX_HP_CORE)


// Limbs
PROTEAN_BODYPART_DEFINE(/obj/item/bodypart/arm/left/mutant/protean, 40)
PROTEAN_BODYPART_DEFINE(/obj/item/bodypart/arm/right/mutant/protean, 40)
PROTEAN_BODYPART_DEFINE(/obj/item/bodypart/leg/left/mutant/protean, 40)
PROTEAN_BODYPART_DEFINE(/obj/item/bodypart/leg/right/mutant/protean, 40)

PROTEAN_DELIMB_DEFINE(/obj/item/bodypart/arm/left/mutant/protean)
PROTEAN_DELIMB_DEFINE(/obj/item/bodypart/arm/right/mutant/protean)
PROTEAN_DELIMB_DEFINE(/obj/item/bodypart/leg/left/mutant/protean)
PROTEAN_DELIMB_DEFINE(/obj/item/bodypart/leg/right/mutant/protean)

#undef PROTEAN_BODYPART_DEFINE
#undef PROTEAN_DELIMB_DEFINE
