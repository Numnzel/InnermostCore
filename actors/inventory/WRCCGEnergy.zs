class WRCCGEnergy : WeaponResourceController {

	int walkAmount;
	int timerWalk; // Timer for checking walked time
	int rateWalkMult; // Multiplier for walking rate generation
	bool walkConditions;

	override void BeginPlay() {

		resource = "CGEnergy";
		idleConditions = true;
		idleTime = TICRATE * ENERGY_WAITSEC;
		rateTime = ENERGY_TICRATE;
		rateAmount = -1;
		rateWalkMult = 2;
		walkAmount = 1;
	}

	override bool HandlePickup(Inventory item) {

		if (owner && item.GetClassName() == "CyberGauntlets") {

			/* TODO: this should ideally be done reading the weapon like this, but the WRC is too late setting the vars
			CyberGauntlets weapon = CyberGauntlets(item);
			idleConditions = !weapon.upgradeA2;
			walkConditions = weapon.upgradeA2;
			*/

			idleConditions = !owner.FindInventory("CGUpgradeA2");
			walkConditions = owner.FindInventory("CGUpgradeA2");
		}

		return super.HandlePickup(item);
	}

	override void DoEffect() {

		super.DoEffect();

		if (!owner) return;

		Ammo maxResource = Ammo(owner.FindInventory(resource));

		if (!maxResource) return;

		// Regeneration upgrade
		if (walkConditions && (owner.vel.x != 0 || owner.vel.y != 0) && GetAmount() < maxResource.maxAmount) {

			if (timerWalk++ >= rateTime * rateWalkMult) {

				if (walkAmount < 0)
					owner.A_TakeInventory(resource, walkAmount);
				if (walkAmount > 0)
					owner.A_GiveInventory(resource, walkAmount);

				timerWalk = 0;
			}
		}
		else timerWalk = 0;
	}
}
