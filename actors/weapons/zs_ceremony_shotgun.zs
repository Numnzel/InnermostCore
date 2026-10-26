class CeremonyShotgun : weapon {

	default {
		
		weapon.selectionOrder 100;
		weapon.ammouse 2;
		weapon.ammogive 10;
		weapon.ammotype "Shell";
		weapon.kickback 100;
		weapon.slotNumber 3;
		weapon.weaponscalex 0.25;
		weapon.weaponscaley 0.25;
		weapon.BobRangeX 2.0;
		weapon.BobRangeY 2.0;
		inventory.pickupmessage "You got the Ceremony Shotgun";
		obituary "You got killed by the Ceremony Shotgun";
	}

	states {
		ready:
			CSHT Z 1 A_WeaponReady;
			loop;
		deselect:
			CSHT Y 1 A_Lower;
			loop;
		select:
			CSHT Y 1 A_Raise;
			loop;
		fire:
			CSHT A 3;
			CSHT B 2 A_FireShotgun2;
			CSHT C 4;
			CSHT D 8 A_CheckReload;
			CSHT E 3;
			CSHT F 6 A_OpenShotgun2;
			CSHT G 3;
			CSHT I 3;
			CSHT J 8 A_LoadShotgun2;
			CSHT K 3;
			CSHT L 3;
			CSHT M 6 A_CloseShotgun2;
			CSHT N 3;
			CSHT O 3 A_ReFire;
			goto ready;
		flash:
			TNT1 A 4 bright A_Light1;
			TNT1 A 3 bright A_Light2;
			goto lightDone;
		spawn:
			SGN2 A -1;
			stop;
	}
}
