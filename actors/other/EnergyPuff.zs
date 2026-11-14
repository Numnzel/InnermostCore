class EnergyPuff : BulletPuff {

	default {

		+PUFFONACTORS;
	}

	states {

		spawn:
		melee:
			APBX BCD 3 bright;
			stop;
	}
}