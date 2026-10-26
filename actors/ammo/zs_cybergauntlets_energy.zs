class CGEnergy : ammo {
	
	int lastAmount;
	int timerIdle; // Timer for checking idle time
	int timerRate; // Timer for managing the generation/substraction rate
	int timerWalk; // Timer for checking walked time

	override void AttachToOwner(Actor newOwner) {

		super.AttachToOwner(newOwner);

		lastAmount = amount;
		timerIdle = 0;
		timerRate = 0;
		timerWalk = 0;
	}

	override bool TryPickup(in out Actor toucher) {

		Ammo ammoType = Ammo(toucher.FindInventory(GetParentAmmo())); // Get ammo type
		bool picked = super.TryPickup(toucher);

		if (!picked) timerIdle = 0; // Reset idle timer on overgeneration

		return picked;
	}
	
	override void DoEffect() {

		super.DoEffect();

		if (!owner) return;

		if (amount != lastAmount) {

			// Restart timer
			timerIdle = 0;
			lastAmount = amount;
			return;
		}
		else timerIdle++;

		// If too idle...
		if (owner.CountInv("CGUpgradeA2") == 0 && timerIdle >= TICRATE * ENERGY_WAITSEC) {

			if (timerRate++ >= ENERGY_TICRATE && amount > 0) {

				amount--; // Substract
				timerRate = 0;
			}

			lastAmount = amount; // And make sure this does not count as a change
		}

		// Regeneration upgrade
		if (owner.CountInv("CGUpgradeA2") && (owner.vel.x != 0 || owner.vel.y != 0) && amount < MaxAmount) {

			if (timerWalk++ >= ENERGY_TICRATE * 2) {

				amount++;
				timerWalk = 0;
			}
		}
		else timerWalk = 0;
	}
	
	default {
		
		inventory.amount 1;
		inventory.maxAmount 200;
		inventory.icon "CELLA0";
	}
}
