class NecroGhostPossessorInvasionOrb extends UntargetedProjectile
	config(satoreMonsterPack);

#exec obj load file=GeneralAmbience.uax

var class<Emitter> OrbEffectClass;
var Emitter OrbEffect;
var config float SpawnInterval;
var Pawn GhostPossessor;
var vector initialDir;
var config int LowWave, MediumWave;
var NecroGhostPossessorMonsterInv Inv;

simulated function PostBeginPlay()
{
    Super.PostBeginPlay();
	
	if (Level.NetMode != NM_DedicatedServer)
	{
		OrbEffect = Spawn(OrbEffectClass, Self);
		OrbEffect.SetBase(Self);
	}
	SetTimer(SpawnInterval, true);
}

simulated function PostNetBeginPlay() 
  {
  	SetTimer(SpawnInterval, true);
  	Super.PostNetBeginPlay();
}

function Timer() 
{
	local int decision;
	
	Decision = Rand(99);
	SpawnMonster(Decision);
}

simulated function SpawnMonster(int Decision)
{
	local NecroMortalSkeleton S;
	local DCTentacle T;
	local DCManta M;
	local DCKrall K;
	local DCGasbag G;
	local DCBrute B;
	local DCMercenary Me;
	local DCSlith Sl;
	local DCSkaarj Sk;
	local DCWarlord W;
	local IceMercenary IM;
	local CosmicBrute CB;
	local FireSkaarjSuperHeat FS;
	
	
	if (!Invasion(Level.Game).bWaveInProgress && Invasion(Level.Game).WaveCountDown > 1)
		return;
	
	if (Invasion(Level.Game) != None)
	{
		if (Invasion(Level.Game).WaveNum <= LowWave)
		{
			if (Decision <= 20)
			{
				S = Spawn(class'NecroMortalSkeleton',,,Location);
				if (S != None)
				{
					Invasion(Level.Game).NumMonsters++;
					Spawn(class'NecroGhostPossessorDeres',S,,S.Location);
					Spawn(class'NecroGhostPossessorDeresEffect',S,,S.Location);
					Inv = S.Spawn(class'NecroGhostPossessorMonsterInv');
					Inv.GiveTo(S);
				}
			}
			else if (Decision <= 40)
			{
				T = Spawn(class'DCTentacle',,,Location);
				if (T != None)
				{
					Invasion(Level.Game).NumMonsters++;
					Spawn(class'NecroGhostPossessorDeres',T,,T.Location);
					Spawn(class'NecroGhostPossessorDeresEffect',T,,T.Location);
					Inv = T.Spawn(class'NecroGhostPossessorMonsterInv');
					Inv.GiveTo(T);
				}
			}
			else if (Decision <= 60)
			{
				M = Spawn(class'DCManta',,,Location);
				if (M != None)
				{
					Invasion(Level.Game).NumMonsters++;
					Spawn(class'NecroGhostPossessorDeres',M,,M.Location);
					Spawn(class'NecroGhostPossessorDeresEffect',M,,M.Location);
					Inv = M.Spawn(class'NecroGhostPossessorMonsterInv');
					Inv.GiveTo(M);
				}
			}
			else if (Decision <= 80)
			{
				K = Spawn(class'DCKrall',,,Location);
				if (K != None)
				{
					Invasion(Level.Game).NumMonsters++;
					Spawn(class'NecroGhostPossessorDeres',K,,K.Location);
					Spawn(class'NecroGhostPossessorDeresEffect',K,,K.Location);
					Inv = K.Spawn(class'NecroGhostPossessorMonsterInv');
					Inv.GiveTo(K);
				}
			}
			else
			{
				G = Spawn(class'DCGasbag',,,Location);	
				if (G != None)
				{
					Invasion(Level.Game).NumMonsters++;
					Spawn(class'NecroGhostPossessorDeres',G,,G.Location);
					Spawn(class'NecroGhostPossessorDeresEffect',G,,G.Location);
					Inv = G.Spawn(class'NecroGhostPossessorMonsterInv');
					Inv.GiveTo(G);
				}
			}
		}
		else if (Invasion(Level.Game).WaveNum <= MediumWave)
		{
			if (Decision <= 25)
			{
				B = Spawn(class'DCBrute',,,Location);
				if (B != None)
				{
					Invasion(Level.Game).NumMonsters++;
					Spawn(class'NecroGhostPossessorDeres',B,,B.Location);
					Spawn(class'NecroGhostPossessorDeresEffect',B,,B.Location);
					Inv = B.Spawn(class'NecroGhostPossessorMonsterInv');
					Inv.GiveTo(B);
				}
			}
			else if (Decision <= 50)
			{
				Me = Spawn(class'DCMercenary',,,Location);
				if (Me != None)
				{
					Invasion(Level.Game).NumMonsters++;
					Spawn(class'NecroGhostPossessorDeres',Me,,Me.Location);
					Spawn(class'NecroGhostPossessorDeresEffect',Me,,Me.Location);
					Inv = Me.Spawn(class'NecroGhostPossessorMonsterInv');
					Inv.GiveTo(Me);
				}
			}
			else if (Decision <= 75)
			{
				Sl = Spawn(class'DCSlith',,,Location);
				if (Sl != None)
				{
					Invasion(Level.Game).NumMonsters++;
					Spawn(class'NecroGhostPossessorDeres',Sl,,Sl.Location);
					Spawn(class'NecroGhostPossessorDeresEffect',Sl,,Sl.Location);
					Inv = Sl.Spawn(class'NecroGhostPossessorMonsterInv');
					Inv.GiveTo(Sl);
				}
			}
			else
			{
				Sk = Spawn(class'DCSkaarj',,,Location);
				if (Sk != None)
				{
					Invasion(Level.Game).NumMonsters++;
					Spawn(class'NecroGhostPossessorDeres',Sk,,Sk.Location);
					Spawn(class'NecroGhostPossessorDeresEffect',Sk,,Sk.Location);
					Inv = Sk.Spawn(class'NecroGhostPossessorMonsterInv');
					Inv.GiveTo(Sk);
				}
			}
		}
		else
		{
			if (Decision <= 25)
			{
				W = Spawn(class'DCWarlord',,,Location);
				if (W != None)
				{
					Invasion(Level.Game).NumMonsters++;
					Spawn(class'NecroGhostPossessorDeres',W,,W.Location);
					Spawn(class'NecroGhostPossessorDeresEffect',W,,W.Location);
					Inv = W.Spawn(class'NecroGhostPossessorMonsterInv');
					Inv.GiveTo(W);
				}
			}
			else if (Decision <= 50)
			{
				IM = Spawn(class'IceMercenary',,,Location);
				if (IM != None)
				{
					Invasion(Level.Game).NumMonsters++;
					Spawn(class'NecroGhostPossessorDeres',IM,,IM.Location);
					Spawn(class'NecroGhostPossessorDeresEffect',IM,,IM.Location);
					Inv = IM.Spawn(class'NecroGhostPossessorMonsterInv');
					Inv.GiveTo(IM);
				}
			}
			else if (Decision <= 75)
			{
				CB = Spawn(class'CosmicBrute',,,Location);
				if (CB != None)
				{
					Invasion(Level.Game).NumMonsters++;
					Spawn(class'NecroGhostPossessorDeres',CB,,CB.Location);
					Spawn(class'NecroGhostPossessorDeresEffect',CB,,CB.Location);
					Inv = CB.Spawn(class'NecroGhostPossessorMonsterInv');
					Inv.GiveTo(CB);
				}
			}
			else
			{
				FS = Spawn(class'FireSkaarjSuperHeat',,,Location);
				if (FS != None)
				{
					Invasion(Level.Game).NumMonsters++;
					Spawn(class'NecroGhostPossessorDeres',FS,,FS.Location);
					Spawn(class'NecroGhostPossessorDeresEffect',FS,,FS.Location);
					Inv = FS.Spawn(class'NecroGhostPossessorMonsterInv');
					Inv.GiveTo(FS);
				}
			}
		}
	}
	else
		return;
}

simulated function ProcessTouch(Actor Other, Vector HitLocation)
{
	return;
	//do nothing.
}

simulated function SpawnEffects( vector HitLocation, vector HitNormal )
{
	local PlayerController PC;

	PlaySound (Sound'ONSVehicleSounds-S.Explosions.VehicleExplosion02',,3*TransientSoundVolume);
	if ( EffectIsRelevant(Location,false) )
	{
		PC = Level.GetLocalPlayerController();
		if ( (PC.ViewTarget != None) && VSize(PC.ViewTarget.Location - Location) < 3000 )
		spawn(class'FlashExplosion',,,HitLocation + HitNormal*16 );
	}
}

simulated function DestroyTrails()
{
	if (OrbEffect != None)
		OrbEffect.Destroy();
}

simulated function Destroyed()
{
	if (OrbEffect != None)
	{
		if (bNoFX)
			OrbEffect.Destroy();
		else
			OrbEffect.Kill();
	}
	Super.Destroyed();
}

defaultproperties
{
     OrbEffectClass=Class'DEKMonsters208.NecroGhostPossessorInvasionOrbEffect'
     SpawnInterval=10.000000
     LowWave=5
     MediumWave=11
     MaxSpeed=0.000000
     TossZ=0.000000
     LightType=LT_Steady
     LightEffect=LE_QuadraticNonIncidence
     LightHue=90
     LightBrightness=100.000000
     LightRadius=10.000000
     DrawType=DT_None
     bDynamicLight=True
     Physics=PHYS_Flying
     AmbientSound=Sound'GeneralAmbience.aliendrone2'
     LifeSpan=30.000000
     bFullVolume=True
     SoundVolume=232
     TransientSoundVolume=1000.000000
}
