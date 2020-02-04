//=============================================================================
// DEKGhost. 2x HP, 1.1x Speed, 1.25x Score, 0.5x Mass
//=============================================================================
class DEKGhostManta extends DCManta;

var config int GhostChance;

function SetMovementPhysics()
{
	SetPhysics(PHYS_Flying); 
}

function WingBeat()
{
	PlaySound(sound'fly1m', SLOT_Interact);
	
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
     GhostChance=60
     ScoringValue=3
     InvisMaterial=FinalBlend'DEKMonstersTexturesMaster206E.GhostMonsters.InvshadeFB'
     GibGroupClass=Class'DEKMonsters208.DEKGhostGibGroup'
     GroundSpeed=300.000000
     AirSpeed=440.000000
     AccelRate=400.000000
     Health=200
     Skins(0)=FinalBlend'DEKMonstersTexturesMaster206E.GhostMonsters.shadeFB'
     Skins(1)=FinalBlend'DEKMonstersTexturesMaster206E.GhostMonsters.shadeFB'
     Mass=120.000000
     ControllerClass=Class'DEKMonsters208.DCMonsterController'
}
