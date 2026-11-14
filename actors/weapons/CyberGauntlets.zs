class CyberGauntlets : UpgradeableWeapon {

	const AMMO2_CONTROLLER = "WRCCGEnergy";
	const AMMO2 = "CGEnergy";
	const AMMO2_USE = 150;
	const AMMO2_USE_ALT = 200;
	const AMMO2_GEN = 50;
	const DMG1_MIN = 3;
	const DMG1_MAX = 12;
	const DMG1_MULT = 2;
	const UPG_B2_VAL = 5; // Blood armor generation amount
	const UPG_A1_VAL = 240; // Energy capacity upgrade
	const SFX_FIRE = "*fist";

	WeaponResourceController WRC;

	static const name weaponSprites[] = {

		'CYBG',
		'CYB2',
		'CYB3'
	};

	override void BeginPlay() {

		upgrades[0] = "CGUpgradeA1";
		upgrades[1] = "CGUpgradeA2";
		upgrades[2] = "CGUpgradeB1";
		upgrades[3] = "CGUpgradeB2";
		upgrades[4] = "CGUpgradeDuo";
	}

	override void AttachToOwner(Actor other) {

		WRC = WeaponResourceController(other.FindInventory(AMMO2_CONTROLLER));

		if (!WRC)
			WRC = WeaponResourceController(other.GiveInventoryType(AMMO2_CONTROLLER));

		Super.AttachToOwner(other);

		if (upgradeA1 && GetAmmoCapacity(AMMO2) < UPG_A1_VAL)
			SetAmmoCapacity(AMMO2, UPG_A1_VAL);
	}

	// Logic by which update the weapon sprites
	action void A_UpdateSprite() {

		A_SetWeaponSprite(invoker.weaponSprites[invoker.GetEnergyState()]);
	}

	// Melee attack logic
	action void A_CyberGauntletsMeleeAttack() {

		FTranslatedLineTarget t;
		double ang = angle + Random2() * (5.625 / 256);
		double pitch = AimLineAttack(ang, 64, null, 0., ALF_CHECK3D);
		int dmg = DMG1_MULT * random(DMG1_MIN, DMG1_MAX);
		int dmg2 = dmg;
		actor puff;
		int hitdmg;
		[puff, hitdmg] = LineAttack(ang, meleeRange + 20.0, pitch, dmg, 'Melee', "BulletPuff", LAF_ISMELEEATTACK, t);

		if (!t.linetarget) return;

		if (hitdmg > 0) {

			// Melee burst upgrade
			if (invoker.upgradeB1 && t.linetarget.health > 0 && invoker.GetEnergyState() == 2) {

				dmg2 *= ((invoker.WRC.GetAmount() + AMMO2_GEN) / 100.0); // Multiplier based on energy amount
				LineAttack(ang, meleeRange + 20.0, pitch, dmg2, 'Melee', "EnergyPuff", LAF_ISMELEEATTACK);

				invoker.WRC.RemoveAmount(invoker.WRC.GetAmount());
			}
			else invoker.WRC.AddAmount(AMMO2_GEN);

			// Armor generation upgrade
			if (invoker.upgradeB2 && t.linetarget.bNOBLOOD == FALSE)
				invoker.GiveBloodArmor(UPG_B2_VAL);

			A_AlertMonsters();
			A_StartSound(SFX_FIRE, CHAN_WEAPON);
		}

		// Turn to face the hit actor.
		angle = t.angleFromSource;
	}

	// Ranged attack logic
	action void A_CyberGauntletsRangedAttack() {

		invoker.WRC.RemoveAmount(AMMO2_USE);
		A_FireProjectile("Energyball");
		A_AlertMonsters();
	}

	void GiveBloodArmor(int amount) {

		if (!owner) return;

		let currentArmor = BasicArmor(owner.FindInventory("BasicArmor"));

		if (currentArmor && currentArmor.Amount > 0)
			if (currentArmor.SavePercent > 0.335 || currentArmor.Amount >= 50)
				return;

		owner.GiveInventory("BloodArmor", amount);
    }

	int GetEnergyState() {

		int energy = WRC.GetAmount();

		if (energy >= AMMO2_USE_ALT)
			return 2;
		else if (energy >= AMMO2_USE)
			return 1;
		else
			return 0;
	}

	default {

		weapon.selectionOrder 3000;
		weapon.kickback 100;
		weapon.slotNumber 1;
		weapon.ammotype2 AMMO2;
		weapon.ammoUse2 0;
		inventory.pickupmessage "You got the CyberGauntlets";
		obituary "%o got killed by %k's CyberGauntlets";

		+WEAPON.WIMPY_WEAPON;
		+WEAPON.MELEEWEAPON;
		+WEAPON.NOAUTOSWITCHTO;
		+WEAPON.AMMO_OPTIONAL;
		+WEAPON.NOALERT;
	}

	states {
		cache:
			CYBG A 0; // Sprite caching
			CYB2 A 0;
			CYB3 A 0;
		ready:
			//CYB2 ABCDEFGHIJKLMNOPQRSTUVWXYZ 8;
			TNT1 A 0;
		ready2:
			#### A 0 A_UpdateSprite();
			#### A 1 A_WeaponReady;
			loop;
		deselect:
			#### A 1 A_Lower(12);
			loop;
		select:
			TNT1 A 0 A_UpdateSprite();
			#### A 1 A_Raise(12);
			wait;
		fire:
			#### ABC 4;
		left:
			#### D 3; // Left melee
			#### E 6 A_CyberGauntletsMeleeAttack();
			#### A 0 A_UpdateSprite();
			#### D 2;
			#### G 3;
			#### A 2 A_ReFire("right");
			goto ready2;
		right:
			#### H 3; // Right melee
			#### I 6 A_CyberGauntletsMeleeAttack();
			#### A 0 A_UpdateSprite();
			#### J 2;
			#### B 3;
			#### A 2 A_ReFire("left");
			goto ready2;
		altfire:
			#### A 0 A_JumpIfInventory(AMMO2, AMMO2_USE, "altfire2");
			goto ready2;
		altfire2:
			#### B 4; // Ranged
			#### N 3;
			#### N 5 A_CyberGauntletsRangedAttack();
			#### A 0 A_UpdateSprite();
			#### L 8;
			#### B 4;
			goto ready2;
	}
}