/// This is honestly my first attempt at a multiline macro/define. Basically, instead of writing or even copypasting code for each limb, we just shove it into this
/// I really hope you, as the future reader, will understand how this works
/// If not, God be with you
#define PROTEAN_LIMB_DEFINE(path, vital) \
##path {\
	max_damage = 100; \
	icon_greyscale = 'modular_zubbers/code/modules/customization/bodyparts/icons/protean_parts_greyscale.dmi'; \
	vital = ##vital;
}

/obj/item/bodypart/head/protean

/obj/item/bodypart/chest/protean

/obj/item/bodypart/arm/left/protean

/obj/item/bodypart/arm/right/protean

/obj/item/bodypart/leg/left/protean

/obj/item/bodypart/leg/right/protean
