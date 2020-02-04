class GenomeProjectNode extends DruidBlock;

var config float TargetRadius;
var GenomeVialCosmic GVC;
var GenomeVialTech GVT;
var GenomeVialFire GVF;
var GenomeVialIce GVI;
var GenomeVialGhost GVG;
var Pawn Spawner;
var GenomeProjectNodeFX FX;

#EXEC OBJ LOAD FILE=..\Sounds\ONSBPSounds.uax

simulated function PostBeginPlay()
{
	SetTimer(1.0, True);
	FX = Self.spawn(class'DEKRPG208.GenomeProjectNodeFX', Self,,Self.Location + vect(0,0,-50));
	if (FX != None)
	{
		FX.SetCollision(False,False,False);
		FX.RemoteRole = ROLE_SimulatedProxy;
	}
	Super.PostBeginPlay();
}

simulated function Timer()
{
	local MissionMultiplayerInv MMPI;
	
	MMPI = MissionMultiplayerInv(Spawner.FindInventoryType(class'MissionMultiplayerInv'));
	if (Spawner != None && Spawner.Health > 0)
	{
		if (MMPI != None && !MMPI.stopped && MMPI.Countdown <= 0 && MMPI.GenomeProjectActive)
		{
			if (CheckRadius())
			{
				MMPI.UpdateCounts(1);
				if (GVC != None)
					GVC.Destroy();
				if (GVT != None)
					GVT.Destroy();
				if (GVF != None)
					GVF.Destroy();
				if (GVI != None)
					GVI.Destroy();
				if (GVG != None)
					GVG.Destroy();
				Self.PlayOwnedSound(Sound'ONSBPSounds.Artillery.CameraDeploy', SLOT_None, TransientSoundVolume * 5.0);
			}
		}
	}
	else if (Spawner == None || Spawner.Health <= 0)
	{
		if (GVC != None)
			GVC.Destroy();
		if (GVT != None)
			GVT.Destroy();
		if (GVF != None)
			GVF.Destroy();
		if (GVI != None)
			GVI.Destroy();
		if (GVG != None)
			GVG.Destroy();
		Destroy();
	}
}

simulated function bool CheckRadius()
{
	local float Dist;
	local Pawn P;
	
	foreach VisibleCollidingActors(class'Pawn', P, TargetRadius, Self.Location)
	{
		if (P != None && P.Health > 0 && P.GetTeamNum() == Self.GetTeamNum() && !P.IsA('Monster') && P.IsA('xPawn'))
		{
			Dist = VSize(Self.Location - P.Location);
			if (Dist <= TargetRadius)
			{
				GVC = GenomeVialCosmic(P.FindInventoryType(class'GenomeVialCosmic'));
				GVT = GenomeVialTech(P.FindInventoryType(class'GenomeVialTech'));
				GVF = GenomeVialFire(P.FindInventoryType(class'GenomeVialFire'));
				GVI = GenomeVialIce(P.FindInventoryType(class'GenomeVialIce'));
				GVG = GenomeVialGhost(P.FindInventoryType(class'GenomeVialGhost'));
				if (GVC != None || GVT != None || GVF != None || GVI != None || GVG != None)
				{
					return True;
					P = None;
				}
				else
				{
					return False;
					P = None;
				}
			}
			else
				return False;
				P = None;
		}
		else
			return False;
			P = None;
	}
}

function TakeDamage(int Damage, Pawn instigatedBy, Vector hitlocation, Vector momentum, class<DamageType> damageType)
{
	return;
}

simulated function Destroyed()
{
	local TournamentPickup P;
	
	if (FX != None)
		FX.Destroy();
	super.Destroyed();
	
	foreach DynamicActors(class'TournamentPickup', P)
	{
		if (P != None && ClassIsChildOf(P.Class, class'GenomeVialCosmicPickup'))
			P.Destroy();
	}
	super.Destroyed();
}

event EncroachedBy( actor Other )
{
	// do nothing. Adding this stub stops telefragging
}

defaultproperties
{
	bIgnoreEncroachers=True
	Skins(0)=Texture'ONSstructureTextures.CoreGroup.PowerNodeTEX'
	Skins(1)=FinalBlend'ONSstructureTextures.CoreGroup.InvisibleFinal'
	StaticMesh=StaticMesh'VMStructures.CoreGroup.powerNodeBaseSM'
	TargetRadius=100.00
    CollisionRadius=40.500000
    CollisionHeight=10.000000
    DrawScale=1.000000
}
