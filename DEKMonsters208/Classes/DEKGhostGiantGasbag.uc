//=============================================================================
// DEKGhost. 2x HP, 1.1x Speed, 1.5x Score, 0.5x Mass
//=============================================================================

class DEKGhostGiantGasbag extends DCGiantGasbag;

var config int GhostChance;

function SetMovementPhysics()
{
	SetPhysics(PHYS_Flying); 
}

simulated function TakeDamage( int Damage, Pawn InstigatedBy, Vector Hitlocation, Vector Momentum, class<DamageType> damageType)
{
	Momentum = vect(0,0,0);		// its a ghost - you can't knock it back
	Super.TakeDamage( Damage, InstigatedBy, Hitlocation, Momentum, damageType);
}

function SpawnBelch()
{
	local DEKGhostChildGasbag G;
	local vector X,Y,Z, FireStart;

	GetAxes(Rotation,X,Y,Z);
	FireStart = Location + 0.5 * CollisionRadius * X - 0.3 * CollisionHeight * Z;
	if ( (numChildren >= MaxChildren) || (FRand() > 0.2) ||(DrawScale==1) )
	{
		if ( Controller != None )
		{
			if ( !SavedFireProperties.bInitialized )
			{
				SavedFireProperties.AmmoClass = MyAmmo.Class;
				SavedFireProperties.ProjectileClass = MyAmmo.ProjectileClass;
				SavedFireProperties.WarnTargetPct = MyAmmo.WarnTargetPct;
				SavedFireProperties.MaxRange = MyAmmo.MaxRange;
				SavedFireProperties.bTossed = MyAmmo.bTossed;
				SavedFireProperties.bTrySplash = MyAmmo.bTrySplash;
				SavedFireProperties.bLeadTarget = MyAmmo.bLeadTarget;
				SavedFireProperties.bInstantHit = MyAmmo.bInstantHit;
				SavedFireProperties.bInitialized = true;
			}
			Spawn(MyAmmo.ProjectileClass,,,FireStart,Controller.AdjustAim(SavedFireProperties,FireStart,600));
			PlaySound(FireSound,SLOT_Interact);
		}

	}
	else
	{
		G = spawn(class 'DEKGhostChildGasbag',self,,FireStart + (0.6 * CollisionRadius + class'SMPGiantGasbag'.Default.CollisionRadius) * X);
		if ( G != None )
		{
			G.ParentBag = self;
			numChildren++;
		}
	}
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

defaultproperties
{
     GhostChance=60
     ScoringValue=11
     InvisMaterial=FinalBlend'DEKMonstersTexturesMaster206E.GhostMonsters.InvshadeFB'
     GibGroupClass=Class'DEKMonsters208.DEKGhostGibGroup'
     AirSpeed=363.000000
     Health=1200
     Skins(0)=FinalBlend'DEKMonstersTexturesMaster206E.GhostMonsters.shadeFB'
     Skins(1)=FinalBlend'DEKMonstersTexturesMaster206E.GhostMonsters.shadeFB'
     ControllerClass=Class'DEKMonsters208.DCMonsterController'
}
