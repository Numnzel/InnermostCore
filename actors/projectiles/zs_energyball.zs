class Energyball : Doomimpball {

	Actor auraGFX;
	int rate;

	override void BeginPlay() {

		Super.BeginPlay();

		rate = 0;
		auraGFX = Spawn("EnergyballAura", pos);
		if (auraGFX) auraGFX.target = self;
	}

	override void Tick() {

		Super.Tick();

		if (++rate > 7) {

			int dmg = 2 * random(1, 6);
			ExtendedRadiusDamage(60.0, dmg);
			rate = 0;
		}
	}

	void ExtendedRadiusDamage(double radius, int damage) {

		BlockThingsIterator it = BlockThingsIterator.Create(self, radius);
		Actor other;

		while (it.Next()) {

			other = it.thing;

			if (!other || other == self || other == target || other.bFRIENDLY ||
				!other.bSHOOTABLE || !CheckSight(other) || Distance3D(other) > radius + other.radius)
				continue;

			other.DamageMobj(self, target, damage, 'Normal');

			vector3 position = (other.pos.x, other.pos.y, other.pos.z + (other.height / 2));
			Spawn("EnergyGFX", position);
		}
	}

	override int SpecialMissileHit(Actor victim) {

		if (victim && victim.bDONTRIP) return MHIT_DEFAULT;

		return MHIT_PASS; // Pass through actors
	}

	default {
		
		speed 8;
		radius 6;
		height 8;
	}
	
	states {
	
		spawn:
			BAL1 ABABABABABABAB 4 bright;
		death:
			TNT1 A 0 { if (auraGFX) auraGFX.Destroy(); }
			BAL1 CDE 6 bright;
			stop;
	}
}

class EnergyballAura : Actor {

	/*
	array<Actor> victims;

	override int SpecialMissileHit (Actor victim) {

		if (victim && target && target.target &&
			victim != target.target && victim.bSHOOTABLE && victims.Find(victim) == victims.Size() && CheckSight(victim, SF_IGNOREVISIBILITY|SF_IGNOREWATERBOUNDARY)) {

			victim.DamageMobj(self, target, 150, 'Energy');
			victims.Push(victim);
		}

		return MHIT_PASS;
	}
	*/

	default {

		radius 6;
		height 8;
		scale 3.0;
		renderStyle "Add";
		alpha 0.15;

		+NOINTERACTION;
	}

	states {

		spawn:
			APBX BBBCCCDDD 1 nodelay bright {

				if (target) SetOrigin(target.pos, true);
			}
			loop;
		death:
			TNT1 A 0;
			stop;
	}
}

class EnergyGFX : Actor {

	default {

		+NOGRAVITY;
		+NOINTERACTION;
	}

	states {

		spawn:
			APBX BCD 3 bright;
			stop;
	}
}
