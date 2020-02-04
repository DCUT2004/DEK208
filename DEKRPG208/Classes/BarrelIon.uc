class BarrelIon extends DruidExplosive;

#exec OBJ LOAD FILE=..\StaticMeshes\CP_MechStaticPack1.usx

var config float MinDetonationRadius;




//****************************************************************************************************************************

function SetDelayedDamageInstigatorController(Controller C)
{
	DelayedDamageInstigatorController = C;
}

function HurtRadius( float DamageAmount, float DamageRadius, class<DamageType> DamageType, float Momentum, vector HitLocation )
{
	local Pawn P, Target;
	local float dist;
	local vector dir;

	if( bHurtEntry )
		return;
		
	bHurtEntry = true;
	dir = PawnOwner.Location - Target.Location;
	dist = FMax(1,VSize(dir));

	foreach VisibleCollidingActors( class 'Pawn', P, DamageRadius, HitLocation )
	{
		if ( P != None && P.Health > 0 && P.Controller != None && PawnOwner != None && PawnOwner.Controller != None && !P.Controller.SameTeamAs(PawnOwner.Controller) )
		{
			if( (P != self) && (P.Role == ROLE_Authority) )
			{
				if ( dist < default.MinDetonationRadius)
					GiveExplodingDamage(P, DamageAmount, RadiusDamage, Location, Momentum, class'DamTypeExploBarrel' );
					Spawn( EffectWhenDestroyed, Owner,, Location );
			}
		}
	}
	bHurtEntry = false;
}


//=============================================================================
// defaultproperties
//=============================================================================

defaultproperties
{
     MinDetonationRadius=300.000000
     EffectWhenDestroyed=Class'XEffects.IonCannonDeathEffect'
     bDamageable=False
     RadiusDamage=1000.000000
     ExplodingDamage=550.000000
}
