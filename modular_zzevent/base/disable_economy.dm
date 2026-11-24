/datum/controller/subsystem/economy
	ss_flags = SS_NO_FIRE

/datum/controller/subsystem/economy/inflation_value()
	return 0

// Makes it so people don't need IDs
/obj/machinery/vending/Initialize(mapload)
	. = ..()

	onstation = FALSE
