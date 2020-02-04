//=============================================================================
// DEKGhost. 2x HP, 1.1x Speed, 1.25x Score, 0.5x Mass
//=============================================================================
class DEKGhostTentacle extends DCTentacle;

var config int GhostChance;

simulated function TakeDamage( int Damage, Pawn InstigatedBy, Vector Hitlocation, Vector Momentum, class<DamageType> damageType)
{
	Momentum = vect(0,0,0);		// its a ghost - you can't knock it back
	Super.TakeDamage( Damage, InstigatedBy, Hitlocation, Momentum, damageType);
}

function Shoot()
{
	if (GhostChance > rand(99))
	{
		SetCollision(False,False,False);
		bCollideWorld = True;
		SetInvisibility(60.0);
	}
	else
	{
		SetCollision(True,True,True);
		bCollideWorld = True;
		SetInvisibility(0.0);
	}
	Super(DCTentacle).Shoot();
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
     GhostChance=60
     AmmunitionClass=Class'DEKMonsters208.DEKGhostTentacleAmmo'
     ScoringValue=2
     InvisMaterial=FinalBlend'DEKMonstersTexturesMaster206E.GhostMonsters.InvshadeFB'
     GibGroupClass=Class'DEKMonsters208.DEKGhostGibGroup'
     Health=300
     Skins(0)=FinalBlend'DEKMonstersTexturesMaster206E.GhostMonsters.shadeFB'
     Skins(1)=FinalBlend'DEKMonstersTexturesMaster206E.GhostMonsters.shadeFB'
     ControllerClass=Class'DEKMonsters208.DCMonsterController'
}
