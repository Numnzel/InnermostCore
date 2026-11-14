class WeaponUpgrade : Inventory abstract {

	default {

		inventory.Amount 1;
		inventory.MaxAmount 1;
	}
}

class CGUpgradeA1 : WeaponUpgrade {}
class CGUpgradeA2 : WeaponUpgrade {}
class CGUpgradeB1 : WeaponUpgrade {}
class CGUpgradeB2 : WeaponUpgrade {}
class CGUpgradeDuo : WeaponUpgrade {}

class CSUpgradeA1 : WeaponUpgrade {}
class CSUpgradeA2 : WeaponUpgrade {}
class CSUpgradeB1 : WeaponUpgrade {}
class CSUpgradeB2 : WeaponUpgrade {}
class CSUpgradeDuo : WeaponUpgrade {}