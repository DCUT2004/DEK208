//=============================================================================
// DEKGhost. 2x HP, 1.1x Speed, 1.25x Score, 0.5x Mass
//=============================================================================

class DEKGhostNaliFighter extends DCNaliFighter config(satoreMonsterPack);

function SetMovementPhysics()
{
	SetPhysics(PHYS_Flying); 
}

simulated function TakeDamage( int Damage, Pawn InstigatedBy, Vector Hitlocation, Vector Momentum, class<DamageType> damageType)
{
	Momentum = vect(0,0,0);		// its a ghost - you can't knock it back
	Super.TakeDamage( Damage, InstigatedBy, Hitlocation, Momentum, damageType);
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
     WeaponClassName(1)="XWeapons.RocketLauncher"
     WeaponClassName(2)="Onslaught.ONSMineLayer"
     WeaponClassName(3)="Onslaught.ONSGrenadeLauncher"
     WeaponClassName(4)="DEKMonsters203a.DEKINIREdeemer"
     WeaponClassName(5)="XWeapons.MiniGun"
     WeaponClassName(6)="UTClassic.ClassicSniperRifle"
     WeaponClassName(7)="XWeapons.BioRifle"
     WeaponClassName(8)="XWeapons.ShieldGun"
     ScoringValue=5
     InvisMaterial=FinalBlend'DEKMonstersTexturesMaster206E.GhostMonsters.InvshadeFB'
     GibGroupClass=Class'DEKMonsters208.DEKGhostGibGroup'
     bCanFly=True
     AirSpeed=300.000000
     AccelRate=400.000000
     Health=140
     Skins(0)=FinalBlend'DEKMonstersTexturesMaster206E.GhostMonsters.shadeFB'
     Skins(1)=FinalBlend'DEKMonstersTexturesMaster206E.GhostMonsters.shadeFB'
}
