class ThunderGodInv extends Inventory;

var Controller InstigatorController;
var bool stopped;
var Pawn PawnOwner;
var class<xEmitter> HitEmitterClass;
var config int DamagePerHit;
var float TargetRadius;

replication
{
	reliable if (bNetInitial && Role == ROLE_Authority)
		PawnOwner;
	reliable if (Role == ROLE_Authority)
		stopped;
}

simulated function PostBeginPlay()
{
	Super.PostBeginPlay();

	if (Instigator != None)
		InstigatorController = Instigator.Controller;

	SetTimer(30.0, true);
}

function GiveTo(Pawn Other, optional Pickup Pickup)
{
	local Pawn OldInstigator;

	if(Other == None)
	{
		destroy();
		return;
	}

	stopped = false;
	if (InstigatorController == None)
		InstigatorController = Other.Controller;

	//want Instigator to be the one that caused the freeze
	OldInstigator = Instigator;
	Super.GiveTo(Other);
	PawnOwner = Other;

	Instigator = OldInstigator;
}

function Timer()
{
	local Controller C, NextC;
	local xEmitter HitEmitter;
	local Pawn P;
	
	P = Pawn(Owner);

	C = Level.ControllerList;
	while (C != None)
	{
		// get next controller here because C may be destroyed if it's a nonplayer and C.Pawn is killed
		NextC = C.NextController;
		if ( C.Pawn != None && P != None && C.Pawn != P && C.Pawn.Health > 0 && !C.SameTeamAs(P.Controller)
			    && VSize(C.Pawn.Location - P.Location) < TargetRadius && FastTrace(C.Pawn.Location, P.Location) && !C.Pawn.IsA('HealerNali') && !C.Pawn.IsA('MissionCow') )
		{
			if ( P != None && P.Controller != None)
			{
				C.Pawn.TakeDamage(DamagePerHit, P, C.Pawn.Location, vect(0,0,0), class'DamTypeEnhLightningRod');
				HitEmitter = spawn(HitEmitterClass,,, P.Location, rotator(C.Pawn.Location - P.Location));
				if (HitEmitter != None)
					HitEmitter.mSpawnVecA = C.Pawn.Location;

				//now see if we killed it
				if (C == None || C.Pawn == None || C.Pawn.Health <= 0 )
					if ( P != None)
						class'ArtifactLightningBeam'.static.AddArtifactKill(P, class'WeaponRod');	// assume killed
			}
		}
		C = NextC;
	}
}

defaultproperties
{
     DamagePerHit=10
     TargetRadius=2000.000000
     HitEmitterClass=Class'XEffects.LightningBolt'
     bOnlyRelevantToOwner=False
     bAlwaysRelevant=True
     bReplicateInstigator=True
}
