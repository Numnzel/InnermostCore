class Cybergauntlets : UpgradeableWeapon {

	static const name weaponSprites[] = 
	{
		'CYBG',
		'CYB2',
		'CYB3'
	};
	
	override void AttachToOwner(Actor other) {

		Super.AttachToOwner(other);

		if (CountInv("CGUpgradeA1") && GetAmmoCapacity("CGEnergy") == 200)
			SetAmmoCapacity("CGEnergy", 240);
	}

	// Logic by which update the weapon sprites
	action void A_UpdateSprite() {
	
		A_SetWeaponSprite(invoker.weaponSprites[GetEnergyState()]);
	}
	
	// Melee attack logic
	action void A_CybergauntletsMelee() {
	
		FTranslatedLineTarget t;
		double ang = angle + Random2() * (5.625 / 256);
		double pitch = AimLineAttack(ang, 64, null, 0., ALF_CHECK3D);
		int dmg = 2 * random(3,12);
		int dmg2 = dmg;
		actor puff;
		int hitdmg;
		[puff, hitdmg] = LineAttack(ang, meleeRange + 20.0, pitch, dmg, 'Melee', "BulletPuff", LAF_ISMELEEATTACK, t);
		
		if (!t.linetarget) return;
		
		if (hitdmg > 0) {
			
			int energy = GetEnergy() + 50;
			
			// Melee burst upgrade
			if (CountInv("CGUpgradeB1") && t.linetarget.health > 0 && GetEnergyState() == 2) {
			
				dmg2 *= (energy / 100.0); // Multiplier based on energy amount
				LineAttack(ang, meleeRange + 20.0, pitch, dmg2, 'Melee', "EnergyPuff", LAF_ISMELEEATTACK);
				A_TakeInventory("CGEnergy");
			}
			else {
			
				A_GiveInventory("CGEnergy", 50);
			}
			
			// Armor generation upgrade
			if (CountInv("CGUpgradeB2") && t.linetarget.bNOBLOOD == FALSE)
				A_GiveBloodArmor(5);
			
			A_AlertMonsters();
			A_StartSound("*fist", CHAN_WEAPON);
		}

		// Turn to face the hit actor.
		angle = t.angleFromSource;
	}
	
	action void A_GiveBloodArmor(int amount) {

		if (!player || !player.mo) return;

		let currentArmor = BasicArmor(player.mo.FindInventory("BasicArmor"));

		if (currentArmor && currentArmor.Amount > 0)
			if (currentArmor.SavePercent > 0.335 || currentArmor.Amount >= 50)
				return;
		
		player.mo.GiveInventory("BloodArmor", amount);
    }
	
	action int GetEnergy() {
	
		return CountInv("CGEnergy");
	}

	action int GetEnergyState() {

		int energy = GetEnergy();
		
		if (energy >= 200)
			return 2;
		else if (energy >= 150)
			return 1;
		else
			return 0;
	}

	default {
		
		weapon.selectionOrder 3000;
		weapon.kickback 100;
		weapon.slotNumber 1;
		weapon.weaponscalex 0.25;
		weapon.weaponscaley 0.25;
		weapon.BobRangeX 2.0;
		weapon.BobRangeY 2.0;
		weapon.ammotype2 "CGEnergy";
		weapon.ammoUse2 150;
		inventory.pickupmessage "You got the Cybergauntlets";
		obituary "You got killed by the Cybergauntlets";

		+WEAPON.WIMPY_WEAPON;
		+WEAPON.MELEEWEAPON;
		+WEAPON.NOAUTOSWITCHTO;
		+WEAPON.AMMO_OPTIONAL;
		+WEAPON.ALT_AMMO_OPTIONAL;
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
			#### E 6 A_CybergauntletsMelee();
			#### A 0 A_UpdateSprite();
			#### D 2;
			#### G 3;
			#### A 2 A_ReFire("right");
			goto ready2;
		right:
			#### H 3; // Right melee
			#### I 6 A_CybergauntletsMelee();
			#### A 0 A_UpdateSprite();
			#### J 2;
			#### B 3;
			#### A 2 A_ReFire("left");
			goto ready2;
		altfire:
			#### A 0 A_JumpIfInventory("CGEnergy", 150, "altfire2");
			goto ready2;
		altfire2:
			#### B 4; // Ranged
			#### N 3;
			#### N 0 A_AlertMonsters();
			#### N 5 A_FireProjectile("Energyball");
			#### A 0 A_UpdateSprite();
			#### L 8;
			#### B 4;
			goto ready2;
	}
}

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
