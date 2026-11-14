class UpgradeableWeapon : weapon abstract {

	bool upgradeA1;
	bool upgradeA2;
	bool upgradeB1;
	bool upgradeB2;
	bool upgradeDuo;
	name upgrades[5];

	override void AttachToOwner(Actor other) {

		Super.AttachToOwner(other);

		upgradeA1 = other.CountInv(upgrades[0]);
		upgradeA2 = other.CountInv(upgrades[1]);
		upgradeB1 = other.CountInv(upgrades[2]);
		upgradeB2 = other.CountInv(upgrades[3]);
		upgradeDuo = other.CountInv(upgrades[4]);
	}

	// Function to update weapon sprite
	action void A_SetWeaponSprite(name weaponSprite) {

		let psp = player.FindPSprite(PSP_WEAPON);
		if (!psp) return;

		psp.Sprite = GetSpriteIndex(weaponSprite);
	}

	default {

		weapon.weaponscalex 0.25;
		weapon.weaponscaley 0.25;
		weapon.BobRangeX 2.0;
		weapon.BobRangeY 2.0;
	}
}
