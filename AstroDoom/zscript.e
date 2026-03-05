Class E_AN94 : DoomWeapon
{
	Default
	{
		Tag "AN-94";
		Weapon.Kickback 50;
		Weapon.AmmoUse1 1;
		Weapon.AmmoGive2 20;
		Weapon.SelectionOrder 3000;
		Inventory.PickupMessage "Avtomat Nikonova 1994";
		Weapon.AmmoType "Clip";
		Obituary "%o was killed by %k Assault Rifle";
		Scale 0.275;
		Decal "Bulletchip";
		+WEAPON.NOAUTOSWITCHTO
		+WEAPON.NOALERT
		+NOEXTREMEDEATH
		+WEAPON.AMMO_OPTIONAL
		+WEAPON.NOAUTOFIRE
		Weapon.SlotNumber 4;
	}
	bool Burst;
	Action Void A_AN94Fire()
	{
		A_WeaponReady(WRF_NOSWITCH);
		A_Overlay(-2,"Muzzle", false);
		A_OverlayRenderstyle(-2,STYLE_Translucent);
		A_OverlayAlpha(-2,0.99);
		A_FireBullets(2,2,-1,5,"BulletPuff", FBF_USEAMMO);
		A_StartSound("AN94/Fire",CHAN_WEAPON);
		A_QuakeEx(6,6,6,1,0,1,"",QF_SCALEDOWN);
		A_SetPitch(pitch-0.75);
	}
	Action Void A_AN94Burst()
	{
	If (CountInv("Clip")==0)
		{
		A_StartSound("AN94/Empty", CHAN_5);
		}
	Else
		{
		A_WeaponReady(WRF_NOSWITCH);
		A_Overlay(-2,"Muzzle", false);
		A_OverlayRenderstyle(-2,STYLE_Translucent);
		A_OverlayAlpha(-2,0.99);
		A_FireBullets(2.75,2.75,-1,5,"BulletPuff", FBF_USEAMMO);
		A_QuakeEx(6,6,6,1,0,1,"",QF_SCALEDOWN);
		A_SetPitch(pitch-0.75);
		}
	}
	States
	{
	Spawn:
		AN9P Z -1;
		Stop;
	Ready:
		AN9G A 1 A_WeaponReady();
		Loop;
	Select:
		AN9S GFEDCBA 1 A_WeaponReady(WRF_NOFIRE);
		Goto Ready;
	Deselect:
		AN9D ABCDEFG 1 ;
		TNT1 A 0 A_Lower(128);
		Wait;
	OutAmmo:
		TNT1 A 0 A_StartSound("AN94/Empty", CHAN_WEAPON);
		AN9F ABCA 2 A_WeaponReady(WRF_NOFIRE);
		AN9G A 2 A_WeaponReady(WRF_NOFIRE);
		Goto Ready;
	Fire:
		TNT1 A 0 A_JumpIf(invoker.Burst,"Burst.fire");
		TNT1 A 0 
			{If (CountInv("Clip")==0)
			{
				Return ResolveState("OutAmmo");
			}
			Else
			{
			A_AlertMonsters(500);
			}
			Return ResolveState(null);}
		AN9F A 1 Bright A_AN94Fire();
		AN9F BCA 1 A_WeaponReady(WRF_NOFIRE|WRF_NOSWITCH);
		TNT1 A 0 A_Refire();
		AN9G A 1 A_WeaponReady(); 
		Goto Ready;
	Burst.fire:
		TNT1 A 0 
			{If (CountInv("Clip")==0)
			{
				Return ResolveState("OutAmmo");
			}
			Else
			{
			A_AlertMonsters(500);
			}
			Return ResolveState(null);}
		AN9F A 1 Bright A_AN94Fire();
		TNT1 A 0 A_AN94Burst();
		AN9F BCA 1 A_WeaponReady(WRF_NOFIRE|WRF_NOSWITCH);
		AN9G A 1 A_WeaponReady(WRF_ALLOWRELOAD); 
		Goto Ready;
	Muzzle:
		TNT1 A 0 A_Jump(128,"Muzzle2","Muzzle3","Muzzle4");
		MUZZ A 2 Bright;
		Stop;
	Muzzle2:
		MUZZ B 2 Bright;
		Stop;
	Muzzle3:
		MUZZ C 2 Bright;
		Stop;
	Muzzle4:
		MUZZ D 2 Bright;
		Stop;
	Altfire:
		TNT1 A 0 A_JumpIf(invoker.Burst,"FullAuto");
		TNT1 A 0 A_StartSound("AN94/Alt", CHAN_6);
		TNT1 A 0 A_Print("Burst mode", 5);
		AN9G A 8 A_WeaponReady(WRF_NOFIRE|WRF_NOSWITCH);
		TNT1 A 0 { invoker.Burst=true; }
		goto Ready;
	FullAuto:
		TNT1 A 0 A_StartSound("AN94/Alt", CHAN_6);
		TNT1 A 0 A_Print("Full Auto mode", 5);
		AN9G A 8 A_WeaponReady(WRF_NOFIRE|WRF_NOSWITCH);
		TNT1 A 0 { invoker.Burst=false; }
		goto Ready;
		}
	}