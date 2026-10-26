class UpgradeableWeapon : weapon abstract {

	// Function to update weapon sprite
	action void A_SetWeaponSprite(name weaponSprite) {

		let psp = player.FindPSprite(PSP_WEAPON);
		if (!psp) return;

		psp.Sprite = GetSpriteIndex(weaponSprite);
	}
}
