class GemExperiencePickupPurple extends ExperiencePickup;

#exec  AUDIO IMPORT NAME="ExpPickup" FILE="C:\UT2004\Sounds\ExpPickup.WAV" GROUP="ArtifactSounds"

event float BotDesireability(Pawn Bot)
{
	return 0;
}

function inventory SpawnCopy( pawn Other )
{
	return None;
}

auto state Pickup
{
	function Touch(Actor Other)
	{
	        local Pawn P;
	        local RPGStatsInv StatsInv;

		if (ValidTouch(Other))
		{
			P = Pawn(Other);
			if (P != None && P.Health > 0)
			{
				StatsInv = RPGStatsInv(P.FindInventoryType(class'RPGStatsInv'));
				if (StatsInv == None)
					return;
				if (P.PlayerReplicationInfo != None && P.PlayerReplicationInfo.bBot)
					return;
				if (StatsInv != None)
				{
					StatsInv.DataObject.Experience += Amount;
					RPGMut.CheckLevelUp(StatsInv.DataObject, P.PlayerReplicationInfo);
					AnnouncePickup(P);
					SetRespawn();
				}
			}
			else
				return;
		}
	}
}

defaultproperties
{
     Amount=15
     MaxDesireability=0.000000
     PickupMessage="Experience Gem +"
     PickupSound=Sound'DEKRPG208.ArtifactSounds.ExpPickup'
     LightType=LT_Steady
     LightEffect=LE_QuadraticNonIncidence
     LightHue=210
     LightBrightness=255.000000
     LightRadius=6.000000
     StaticMesh=StaticMesh'AW-2004Crystals.Crops.CrystalShard'
     bDynamicLight=True
     LifeSpan=5.000000
     DrawScale=0.500000
     Skins(0)=FinalBlend'PickupSkins.Shaders.FinalDamShader'
     AmbientGlow=50
     CollisionHeight=48.000000
     Physics=PHYS_Rotating
}
