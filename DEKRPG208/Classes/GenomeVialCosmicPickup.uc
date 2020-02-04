class GenomeVialCosmicPickup extends TournamentPickup;

var MutUT2004RPG RPGMut;

#EXEC OBJ LOAD FILE=..\Sounds\SkaarjPack_rc.uax

function PostBeginPlay()
{
	Super.PostBeginPlay();

	RPGMut = class'MutUT2004RPG'.static.GetRPGMutator(Level.Game);
}

function float DetourWeight(Pawn Other, float PathWeight)
{
	return MaxDesireability;
}

event float BotDesireability(Pawn Bot)
{
	if (Bot.Controller.bHuntPlayer)
		return 0;
	return MaxDesireability;
}

auto state Pickup
{
	function bool ValidTouch(Actor Other)
	{
		local GenomeVialCosmic GVC;
		local GenomeVialTech GVT;
		local GenomeVialFire GVF;
		local GenomeVialIce GVI;
		local GenomeVialGhost GVG;
		local MissionMultiplayerInv MMPI;	
		
		if (!Super.ValidTouch(Other))
			return false;
			
		MMPI = MissionMultiplayerInv(Pawn(Other).FindInventoryType(class'MissionMultiplayerInv'));			
		if (MMPI == None)
			return false;
			
		GVC = GenomeVialCosmic(Pawn(Other).FindInventoryType(class'GenomeVialCosmic'));
		GVT = GenomeVialTech(Pawn(Other).FindInventoryType(class'GenomeVialTech'));
		GVF = GenomeVialFire(Pawn(Other).FindInventoryType(class'GenomeVialFire'));
		GVI = GenomeVialIce(Pawn(Other).FindInventoryType(class'GenomeVialIce'));
		GVG = GenomeVialGhost(Pawn(Other).FindInventoryType(class'GenomeVialGhost'));
		if (GVC != None || GVT != None || GVF != None || GVI != None || GVG != None)
			return false;
		else
			return True;

	}
	function Touch(Actor Other)
	{
		local Inventory Copy;
		local MissionMultiplayerInv MMPI;
		local Pawn P;
		local GenomeVialCosmicPickup GVC;
		local GenomeVialTechPickup GVT;
		local GenomeVialFirePickup GVF;
		local GenomeVialIcePickup GVI;
		local GenomeVialGhostPickup GVG;
		local NavigationPoint Dest;
		
		P = Pawn(Other);

		// If touched by a player pawn, let him pick this up.
		if( ValidTouch(Other) )
		{
			if (P != None)
			{
				MMPI = MissionMultiplayerInv(P.FindInventoryType(class'MissionMultiplayerInv'));
				Dest = P.Controller.FindRandomDest();
				if (MMPI != None)
				{
					if (MMPI.GenomeProjectActive)
					{
						Copy = SpawnCopy(P);
						AnnouncePickup(P);
						if ( Copy != None )
							Copy.PickupFunction(P);
						if (Rand(99) <= 20)
						{
							GVT = Spawn(class'GenomeVialTechPickup',,,Dest.Location + (vect(0,0,20)),);
							if (GVT != None)
								Destroy();
						}
						else if (Rand(99) <= 40)
						{
							GVC = Spawn(class'GenomeVialCosmicPickup',,,Dest.Location + (vect(0,0,20)),);
							if (GVC != None)
								Destroy();
						}
						else if (Rand(99) <= 60)
						{
							GVF = Spawn(class'GenomeVialFirePickup',,,Dest.Location + (vect(0,0,20)),);
							if (GVF != None)
								Destroy();
						}
						else if (Rand(99) <= 80)
						{
							GVI = Spawn(class'GenomeVialIcePickup',,,Dest.Location + (vect(0,0,20)),);
							if (GVI != None)
								Destroy();
						}
						else if (Rand(99) <= 100)
						{
							GVG = Spawn(class'GenomeVialGhostPickup',,,Dest.Location + (vect(0,0,20)),);
							if (GVG != None)
								Destroy();
						}					
					}
					else
						Destroy();
				}
				else
					return;
			}
		}
	}
}

defaultproperties
{
    RespawnTime=10.000000
    PickupMessage="You picked up a cosmic vial."
	InventoryType=class'DEKRPG208.GenomeVialCosmic'
    PickupSound=Sound'SkaarjPack_rc.roam11s'
	StaticMesh=StaticMesh'XPickups_rc.MiniHealthPack'
	Skins(0)=Texture'XGameTextures.SuperPickups.MHPickup'
	Skins(1)=Shader'DEKMonstersTexturesMaster206E.CosmicMonsters.CosmicGibs'
    CollisionRadius=24.000000
    CollisionHeight=10.000000
	DrawScale=0.120000
    MaxDesireability=0.000000
    DrawType=DT_StaticMesh
    Physics=PHYS_Rotating
    Style=STY_AlphaZ
    bDynamicLight=True
    LightType=LT_Steady
    LightEffect=LE_QuadraticNonIncidence
    LightHue=210
    LightSaturation=30
    LightBrightness=255.000000
    LightRadius=6.000000
}
