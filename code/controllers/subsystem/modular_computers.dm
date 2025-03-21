///The maximum amount of logs that can be generated before they start overwriting each other.
#define MAX_LOG_COUNT 300

SUBSYSTEM_DEF(modular_computers)
	name = "Modular Computers"

	wait = 1 MINUTES
	runlevels = RUNLEVEL_GAME

	///List of all logs generated by ModPCs through the round.
	///Stops at MAX_LOG_COUNT and must be purged to keep logging.
	var/list/modpc_logs = list()

	///List of all programs available to download from the NTNet store.
	var/list/available_station_software = list()
	///List of all programs that can be downloaded from an emagged NTNet store.
	var/list/available_antag_software = list()
	///List of all chat channels created by Chat Client.
	var/list/chat_channels = list()

	///Boolean on whether the IDS warning system is enabled
	var/intrusion_detection_enabled = TRUE
	///Boolean to show a message warning if there's an active intrusion for Wirecarp users.
	var/intrusion_detection_alarm = FALSE
	var/next_picture_id = 0

	///Lazylist of coupons used by the Coupon Master PDA app. e.g. "COUPONCODE25" = coupon_code
	var/list/discount_coupons
	///When will the next coupon drop?
	var/next_discount = 0

/datum/controller/subsystem/modular_computers/Initialize()
	build_software_lists()
	initialized = TRUE
	return SS_INIT_SUCCESS

/datum/controller/subsystem/modular_computers/fire(resumed = FALSE)
	if(discount_coupons && world.time >= next_discount)
		announce_coupon()

///Generate new coupon codes that can be redeemed with the Coupon Master App
/datum/controller/subsystem/modular_computers/proc/announce_coupon()
	//If there's no way to announce the coupon, we may as well skip it.
	var/obj/machinery/announcement_system/announcement_system = get_announcement_system()
	if(!announcement_system)
		return

	var/static/list/discounts = list("0.10" = 7, "0.15" = 16, "0.20" = 20, "0.25" = 16, "0.50" = 8, "0.66" = 1)
	var/static/list/flash_discounts = list("0.30" = 3, "0.40" = 8, "0.50" = 8, "0.66" = 2, "0.75" = 1)
	///Eliminates non-alphanumeric characters, as well as the word "Single-Pack" or "Pack" or "Crate" from the coupon code
	var/static/regex/strip_pack_name = regex("\[^a-zA-Z0-9]|(Single-)?Pack|Crate", "g")

	var/datum/supply_pack/discounted_pack = pick(GLOB.discountable_packs[pick_weight(GLOB.pack_discount_odds)])
	var/pack_name = initial(discounted_pack.name)
	var/chosen_discount
	var/expires_in = 0
	if(prob(75))
		chosen_discount = text2num(pick_weight(discounts))
		if(prob(20))
			expires_in = rand(8,10) MINUTES
	else
		chosen_discount = text2num(pick_weight(flash_discounts))
		expires_in = rand(2, 4) MINUTES
	var/coupon_code = "[uppertext(strip_pack_name.Replace(pack_name, ""))][chosen_discount*100]"

	var/list/targets = list()
	for (var/messenger_ref in GLOB.pda_messengers)
		var/datum/computer_file/program/messenger/messenger = GLOB.pda_messengers[messenger_ref]
		if(locate(/datum/computer_file/program/coupon) in messenger?.computer.stored_files)
			targets += messenger

	///Don't go any further if the same coupon code has been done alrady or if there's no recipient for the 'promo'.
	if((coupon_code in discount_coupons) || !length(targets))
		return

	var/datum/coupon_code/coupon = new(chosen_discount, discounted_pack, expires_in)

	discount_coupons[coupon_code] = coupon

	///pda message code here
	var/static/list/promo_messages = list(
		"A new discount has dropped for %GOODY: %DISCOUNT.",
		"Check this new offer out: %GOODY, now %DISCOUNT off.",
		"Now on sales: %GOODY, at %DISCOUNT discount!",
		"This item is now on sale (%DISCOUNT off): %GOODY.",
		"Would you look at that! A %DISCOUNT discount on %GOODY!",
		"Exclusive offer for %GOODY. Only %DISCOUNT! Get it now:",
		"%GOODY is now %DISCOUNT off.",
		"*RING* A new discount has dropped: %GOODY, %DISCOUNT off.",
		"%GOODY - %DISCOUNT off."
	)
	var/static/list/code_messages = list(
		"Here's the code",
		"Use this code to redeem it",
		"Open the app to redeem it",
		"Code",
		"Redeem it now",
		"Buy it now",
	)

	var/chosen_promo_message = replacetext(replacetext(pick(promo_messages), "%GOODY", pack_name), "%DISCOUNT", "[chosen_discount*100]%")
	var/datum/signal/subspace/messaging/tablet_message/signal = new(announcement_system, list(
		"fakename" = "Coupon Master",
		"fakejob" = "Goodies Promotion",
		"message" = "[chosen_promo_message] [pick(code_messages)]: [coupon_code][expires_in ? " (EXPIRES IN [uppertext(DisplayTimeText(expires_in))])" : ""].",
		"targets" = targets,
		"automated" = TRUE,
	))

	signal.send_to_receivers()

	next_discount = world.time + rand(3, 5) MINUTES


///Finds all downloadable programs and adds them to their respective downloadable list.
/datum/controller/subsystem/modular_computers/proc/build_software_lists()
	for(var/datum/computer_file/program/prog as anything in subtypesof(/datum/computer_file/program))
		// Has no TGUI file so is not meant to be a downloadable thing.
		if(!initial(prog.tgui_id) || !initial(prog.filename))
			continue
		prog = new prog

		if(prog.program_flags & PROGRAM_ON_NTNET_STORE)
			available_station_software.Add(prog)
		if(prog.program_flags & PROGRAM_ON_SYNDINET_STORE)
			available_antag_software.Add(prog)

///Attempts to find a new file through searching the available stores with its name.
/datum/controller/subsystem/modular_computers/proc/find_ntnet_file_by_name(filename)
	for(var/datum/computer_file/program/programs as anything in available_station_software + available_antag_software)
		if(filename == programs.filename)
			return programs
	return null

///Attempts to find a chatorom using the ID of the channel.
/datum/controller/subsystem/modular_computers/proc/get_chat_channel_by_id(id)
	for(var/datum/ntnet_conversation/chan as anything in chat_channels)
		if(chan.id == id)
			return chan
	return null

/**
 * Records a message into the station logging system for the network
 * Arguments:
 * * log_string - The message being logged
 */
/datum/controller/subsystem/modular_computers/proc/add_log(log_string)
	var/list/log_text = list()
	log_text += "\[[station_time_timestamp()]\]"
	log_text += "*SYSTEM* - "
	log_text += log_string
	log_string = log_text.Join()

	modpc_logs.Add(log_string)

	// We have too many logs, remove the oldest entries until we get into the limit
	if(modpc_logs.len > MAX_LOG_COUNT)
		modpc_logs = modpc_logs.Copy(modpc_logs.len - MAX_LOG_COUNT, 0)

/**
 * Removes all station logs and leaves it with an alert that it's been wiped.
 */
/datum/controller/subsystem/modular_computers/proc/purge_logs()
	modpc_logs = list()
	add_log("-!- LOGS DELETED BY SYSTEM OPERATOR -!-")

/**
 * Returns a name which a /datum/picture can be assigned to.
 * Use this function to get asset names and to avoid cache duplicates/overwriting.
 */
/datum/controller/subsystem/modular_computers/proc/get_next_picture_name()
	var/next_uid = next_picture_id
	next_picture_id++
	return "ntos_picture_[next_uid].png"

#undef MAX_LOG_COUNT
