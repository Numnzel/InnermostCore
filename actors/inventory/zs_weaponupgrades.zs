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
