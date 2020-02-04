class DruidEnergyWallPost extends Actor;

var DruidEnergyWall wall;


simulated function PostNetBeginPlay()
{
	super.PostBeginPlay();
	
	self.SetDrawScale3D( vect(0.8,0.8,1.3) );
}

function TakeDamage(int Damage, Pawn instigatedBy, Vector hitlocation, Vector momentum, class<DamageType> damageType) 
{
	// Defer damage to Wall...
	if ( Role == Role_Authority && InstigatedBy != Owner )
	{
		if (wall != None)
		{
			if (wall.DamageFraction > 0)
				wall.TakeDamage(Damage/wall.DamageFraction, instigatedBy, hitlocation, momentum, damageType) ;  // since direct hit on post, need to do whole of damage to wall
			// else if Damagefraction <=0 then do not pass on damage.
		}
		else
			wall.TakeDamage(Damage, instigatedBy, hitlocation, momentum, damageType) ;  
	}
}

defaultproperties
{
     DrawType=DT_StaticMesh
     StaticMesh=StaticMesh'ParticleMeshes.Simple.ParticleBomb'
     bReplicateMovement=False
     bUpdateSimulatedPosition=True
     NetUpdateFrequency=4.000000
     DrawScale=0.220000
     AmbientGlow=10
     bMovable=False
     CollisionRadius=8.000000
     CollisionHeight=60.000000
     bCollideActors=True
     bCollideWorld=True
     bBlockActors=True
     bBlockPlayers=True
     bProjTarget=True
     bUseCylinderCollision=True
     Mass=1000.000000
}
