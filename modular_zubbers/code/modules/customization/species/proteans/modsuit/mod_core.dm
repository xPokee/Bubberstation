/obj/item/mod/core/protean
	name = "MOD protean core"
	icon_state = "mod-core-ethereal"
	desc = "You shouldn't see this thing on its own"

	/// We handle as many interactions as possible through the species datum
	/// The species handles cleanup on this
	var/datum/species/protean/linked_species

/obj/item/mod/core/protean/charge_source()
	return linked_species.owner.get_organ_slot(ORGAN_SLOT_STOMACH)

/obj/item/mod/core/protean/charge_amount()
	var/obj/item/organ/internal/stomach/protean/stomach = linked_species.owner.get_organ_slot(ORGAN_SLOT_STOMACH)
	if(!istype(stomach))
		return
	return stomach.metal

/obj/item/mod/core/protean/max_charge_amount()
	return PROTEAN_STOMACH_FULL

/// We don't charge in a standard way
/obj/item/mod/core/protean/add_charge(amount)
	return FALSE

/obj/item/mod/core/protean/subtract_charge(amount)
	return FALSE

/obj/item/mod/core/protean/check_charge(amount)
	return FALSE

/obj/item/mod/core/protean/get_charge_icon_state()
	return charge_source() ? "0" : "missing"
