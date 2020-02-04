class IceMercRocket extends SMPMercRocket;

var float IceLifeSpan;
var config float BaseChance;
var Sound FreezeSound;
var	xEmitter RealSmokeTrail;

simulated function Destroyed()
{
	if ( RealSmokeTrail != None )
		RealSmokeTrail.mRegen = False;
	Super.Destroyed();
}

simulated function PostBeginPlay()
{
	Super.PostBeginPlay();
	
	if (SmokeTrail != None)
	{
		SmokeTrail.mRegen = False;
		SmokeTrail.Destroy();
	}
	
	if (Corona != None)
		Corona.Destroy();
		
	if ( Level.NetMode != NM_DedicatedServer)
	{
		RealSmokeTrail = Spawn(class'IceKrallTrailSmoke',self);
	}

	Dir = vector(Rotation);
	Velocity = speed * Dir;
	if (PhysicsVolume.bWaterVolume)
	{
		bHitWater = True;
		Velocity=0.6*Velocity;
	}
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

simulated function Explode(vector HitLocation, vector HitNormal)
{
	local PlayerController PC;

	PlaySound(sound'WeaponSounds.BExplosion3',,2.5*TransientSoundVolume);
    if ( EffectIsRelevant(Location,false) )
    {
    	Spawn(class'BlueGoopSmokeLarge',,,HitLocation + HitNormal*20,rotator(HitNormal));
    	Spawn(class'IceRocketExplosion',,,HitLocation + HitNormal*20,rotator(HitNormal));
    	PC = Level.GetLocalPlayerController();
		if ( (PC.ViewTarget != None) && VSize(PC.ViewTarget.Location - Location) < 5000 )
	        Spawn(class'ExplosionCrap',,, HitLocation + HitNormal*20, rotator(HitNormal));
//		if ( (ExplosionDecal != None) && (Level.NetMode != NM_DedicatedServer) )
//			Spawn(ExplosionDecal,self,,Location, rotator(-HitNormal));
    }

	BlowUp(HitLocation);
	Destroy();
}

defaultproperties
{
     IceLifespan=3.000000
     BaseChance=25.000000
     FreezeSound=Sound'Slaughtersounds.Machinery.Heavy_End'
     MyDamageType=Class'DEKMonsters208.DamTypeIceMercenary'
     ExplosionDecal=None
     LightHue=120
     StaticMesh=StaticMesh'DEKStaticsMaster207P.Meshes.IceRocketProj'
     Skins(0)=Texture'DEKMonstersTexturesMaster206E.IceMonsters.IceGib'
}
