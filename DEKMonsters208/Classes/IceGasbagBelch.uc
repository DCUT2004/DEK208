class IceGasbagBelch extends GasbagBelch;

var float IceLifeSpan;
var config float BaseChance;
var Sound FreezeSound;
var	xEmitter RealSmokeTrail;

simulated function PostBeginPlay()
{
	if ( Level.NetMode != NM_DedicatedServer)
	{
		if ( !Level.bDropDetail )
			spawn(class'RocketSmokeRing',,,Location, Rotation );
		RealSmokeTrail = Spawn(class'IceBelchFrost',self);
	}
	
	if (SmokeTrail != None)
	{
		SmokeTrail.mRegen = False;
		SmokeTrail.Destroy();
	}
		
	Dir = vector(Rotation);
	Velocity = speed * Dir;
    if ( Level.bDropDetail )
	{
		bDynamicLight = false;
		LightType = LT_None;
	}
	Super.PostBeginPlay();
}

function NullInBlast(float Radius)
{
	local float damageScale, pawndist;
	local vector pawndir;
	local Controller C, NextC;
	Local FreezeInv Inv;
	Local Actor A;

	// freezes anything not a null warlord. Any side.
	C = Level.ControllerList;
	while (C != None)
	{
		// get next controller here because C may be destroyed if it's a nonplayer and C.Pawn is killed
		NextC = C.NextController;
		if(C.Pawn == None)
		{
			C = NextC;
			break;
		}
		if ( C != None && C.Pawn != None && C.Pawn != Instigator && C.Pawn.Health > 0 && !C.SameTeamAs(InstigatorController) && !C.Pawn.IsA('IceBrute') && !C.Pawn.IsA('IceChildGasbag') && !C.Pawn.IsA('IceChildSkaarjPupae') && !C.Pawn.IsA('IceGasbag') && !C.Pawn.IsA('IceGiantGasbag') && !C.Pawn.IsA('IceKrall') && !C.Pawn.IsA('Manta') && !C.Pawn.IsA('IceMercenary') && !C.Pawn.IsA('IceNali') && !C.Pawn.IsA('IceNaliFighter') && !C.Pawn.IsA('IceQueen') && !C.Pawn.IsA('IceRazorfly') && !C.Pawn.IsA('IceSkaarjFreezing') && !C.Pawn.IsA('IceSkaarjPupae') && !C.Pawn.IsA('IceSkaarjSniper') && !C.Pawn.IsA('IceSkaarjTrooper') && !C.Pawn.IsA('IceSlith') && !C.Pawn.IsA('IceSlug') && !C.Pawn.IsA('IceTitan') && !C.Pawn.IsA('IceWarlord')
		     && VSize(C.Pawn.Location - Location) < Radius && FastTrace(C.Pawn.Location, Location) && MagicShieldInv(C.Pawn.FindInventoryType(class'MagicShieldInv')) == None )
		{
			pawndir = C.Pawn.Location - Location;
			pawndist = FMax(1,VSize(pawndir));
			damageScale = 1 - FMax(0,pawndist/Radius);

			if(!C.Pawn.isA('Vehicle') && class'RW_Freeze'.static.canTriggerPhysics(C.Pawn) && (C.Pawn.FindInventoryType(class'FreezeInv') == None))
			{
				if(C.Pawn == None)
				{
					C = NextC;
					break;
				}
				if(rand(99) < int(BaseChance))
				{
					Inv = spawn(class'FreezeInv', C.Pawn,,, rot(0,0,0));
					if(Inv != None)
					{
						Inv.LifeSpan = (damageScale * IceLifeSpan);	
						Inv.Modifier = (damageScale * IceLifeSpan);	// *3 because the NullEntropyInv divides by 3
						Inv.GiveTo(C.Pawn);
						A = C.Pawn.spawn(class'IceKrallSmoke', C.Pawn,, C.Pawn.Location, C.Pawn.Rotation);  // cant use IceSmoke as it assumes a PlayerController exists
						if(C.Pawn == None)
						{
							C = NextC;
							break;
						}
						if (A != None)
						{
							A.RemoteRole = ROLE_SimulatedProxy;
							A.PlaySound(FreezeSound,,2.5*A.TransientSoundVolume,,A.TransientSoundRadius);
						}
					}
				}
			}
			if(C.Pawn == None)
			{
				C = NextC;
				break;
			}
		}

		C = NextC;
	}
}

function BlowUp(vector HitLocation)
{
	Super.BlowUp(HitLocation);
	// ok, lets null them according to how close to the centre they are
	NullInBlast(DamageRadius);
}

simulated function Destroyed() 
{
	if ( RealSmokeTrail != None )
		RealSmokeTrail.mRegen = False;
	Super.Destroyed();
}

defaultproperties
{
     IceLifespan=3.000000
     BaseChance=25.000000
     FreezeSound=Sound'Slaughtersounds.Machinery.Heavy_End'
     MyDamageType=Class'DEKMonsters208.DamTypeIceGasbag'
     Texture=Texture'XEffectMat.Link.link_muz_blue'
}
