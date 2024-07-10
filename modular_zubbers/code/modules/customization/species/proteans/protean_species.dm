

/datum/species/protean
	id = SPECIES_PROTEAN

	name = "Protean"
	blurb = "Sometimes very advanced civilizations will produce the ability to swap into manufactured, robotic bodies. And sometimes \
			<i>VERY</i> advanced civilizations have the option of 'nanoswarm' bodies. Effectively a single robot body comprised \
			of millions of tiny nanites working in concert to maintain cohesion."
	show_ssd = "totally quiescent"
	death_message = "rapidly loses cohesion, retreating into their hardened control module..."
	knockout_message = "collapses inwards, forming a disordered puddle of gray goo."
	remains_type = /obj/effect/decal/cleanable/ash

	inherent_traits = list(	TRAIT_NO_SLIP_WATER,
							TRAIT_NO_DNA_SCRAMBLE,
							TRAIT_HARDLY_WOUNDED,
							TRAIT_RDS_SUPPRESSED,
							TRAIT_MADNESS_IMMUNE,
							)

	inherent_biotypes = MOB_ROBOTIC | MOB_HUMANOID
