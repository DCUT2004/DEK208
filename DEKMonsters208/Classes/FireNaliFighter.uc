//=============================================================================
// DEK Fire. 3x HP, 1.1x Speed, 2.0x Score, 0.75x Mass
//=============================================================================

class FireNaliFighter extends DCNaliFighter config(satoreMonsterPack);

function bool SameSpeciesAs(Pawn P)
{
	if (SummonedMonster)
		return ( P.class == class'HealerNali' || P.class == class'HealerNaliAdren' || P.class == class'HealerNaliShield' || P.class == class'FireBrute' || P.Class == class'FireChildGasbag' || P.Class == class'FireChildSkaarjPupae' || P.Class == class'FireGasbag' || P.Class == class'FireGiantGasbag' || P.Class == class'FireKrall' || P.Class == class'FireLord' || P.Class == class'FireManta' || P.Class == class'FireMercenary' || P.Class == class'FireNali' || P.Class == class'FireNaliFighter' || P.Class == class'FireQueen' || P.Class == class'FireRazorfly' || P.Class == class'FireSkaarjPupae' || P.Class == class'FireSkaarjSniper' || P.Class == class'FireSkaarjSuperHeat' || P.Class == class'FireSlith' || P.Class == class'FireSlug' || P.Class == class'FireTitan');
	else
		return ( P.class == class'FireBrute' || P.Class == class'FireChildGasbag' || P.Class == class'FireChildSkaarjPupae' || P.Class == class'FireGasbag' || P.Class == class'FireGiantGasbag' || P.Class == class'FireKrall' || P.Class == class'FireLord' || P.Class == class'FireManta' || P.Class == class'FireMercenary' || P.Class == class'FireNali' || P.Class == class'FireNaliFighter' || P.Class == class'FireQueen' || P.Class == class'FireRazorfly' || P.Class == class'FireSkaarjPupae' || P.Class == class'FireSkaarjSniper' || P.Class == class'FireSkaarjSuperHeat' || P.Class == class'FireSlith' || P.Class == class'FireSlug' || P.Class == class'FireTitan');
}

function Died(Controller Killer, class<DamageType> damageType, vector HitLocation)
{
	if (SummonedMonster)
		Destroy();	// do not want to execute the invasion Killed function which decrements the number of monsters
	else
		Super.Died(Killer, damageType, HitLocation);
}

defaultproperties
{
     WeaponClassName(0)="XWeapons.RocketLauncher"
     WeaponClassName(1)="XWeapons.ShockRifle"
     WeaponClassName(2)="Onslaught.ONSMineLayer"
     WeaponClassName(3)="Onslaught.ONSGrenadeLauncher"
     WeaponClassName(4)="DEKMonsters208.DEKINIREdeemer"
     WeaponClassName(5)="XWeapons.MiniGun"
     WeaponClassName(6)="XWeapons.BioRifle"
     WeaponClassName(7)="XWeapons.ShieldGun"
     ScoringValue=6
     GibGroupClass=Class'DEKMonsters208.FireGibGroup'
     Health=175
     Skins(0)=Texture'DEKMonstersTexturesMaster206E.FireMonsters.FireNali'
     Skins(1)=Texture'DEKMonstersTexturesMaster206E.FireMonsters.FireNali'
}
