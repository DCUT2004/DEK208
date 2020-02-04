class ArtifactMissionTeamPickup extends RPGArtifactPickup;

#exec OBJ LOAD FILE=..\StaticMeshes\cf_staticMushrooms.usx
#exec OBJ LOAD FILE=..\Textures\MissionsTex4.utx

function float BotDesireability(Pawn Bot)
{
		return 0;
}

auto state Pickup
{	
	function bool ValidTouch(Actor Other)
	{
		local Pawn P;
		
		P = Pawn(Other);
		if (P != None && P.Health > 0)
		{
			if (P.PlayerReplicationInfo != None && P.PlayerReplicationInfo.bBot)
				return false;
		}
		if (Other != None)
		{
			if (!Super.ValidTouch(Other))
				return false;
		}
		return CanPickupArtifact(Pawn(Other));
	}
}

defaultproperties
{
     PickupMessage="You picked up a Team Mission!"
     MaxDesireability=0.000000
     PickupSound=Sound'PickupSounds.SniperRiflePickup'
     PickupForce="SniperRiflePickup"
     DrawType=DT_StaticMesh
     StaticMesh=StaticMesh'DEKStaticsMaster207P.Meshes.TeamMushrooms'
	 Skins(0)=Texture'MissionsTex4.TeamMissions.TeamMushroomRedSkin'
	 Drawscale=0.4000
     AmbientGlow=128
     LightType=LT_Steady
     LightEffect=LE_QuadraticNonIncidence
     LightHue=255
     LightSaturation=0
     LightBrightness=255.000000
     LightRadius=3.000000
     bDynamicLight=True
}
