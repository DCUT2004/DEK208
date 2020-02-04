class DEKLightningTurretWeapon extends Weapon_LinkTurret;

simulated function UpdateLinkColor( LinkAttachment.ELinkColor Color )
{
	return; //No need to update colors
}

simulated event WeaponTick(float dt)
{
	return; //No need to update colors
}

function byte BestMode()
{
	local float			EnemyDist;
	local bot			B;
	//local Controller	C;

	B = Bot(Instigator.Controller);
	if ( B == None )
	{
		return 0;
		/*
		C = Instigator.Controller;
		if ( C.Enemy == None || C.Enemy.IsA('Vehicle')
			|| VSize(C.Enemy.Location - C.Pawn.Location) > 2000 ) // probably a bit out of range. Go with primary fire.
			return 1;

		return 0;
		*/
	}

	if ( DestroyableObjective(B.Squad.SquadObjective) != None && DestroyableObjective(B.Squad.SquadObjective).TeamLink(B.GetTeamNum())
	     && VSize(B.Squad.SquadObjective.Location - B.Pawn.Location) < FireMode[1].MaxRange() && (B.Enemy == None || !B.CanSee(B.Enemy)) )
		return 1;

	if ( B.Enemy == None )
		return 0;

	EnemyDist = VSize(B.Enemy.Location - Instigator.Location);
	if ( EnemyDist > 2000 )
		return 1;
	return 0;
}
	

defaultproperties
{
     FireModeClass(0)=Class'DEKRPG208.DEKLightningTurretProjFire'
     FireModeClass(1)=Class'DEKRPG208.DEKLightningTurretInstantFire'
     ItemName="Lightning Turret"
     Skins(0)=Combiner'AS_Weapons_TX.LinkTurret.LinkTurret_Skin2_C'
     Skins(1)=Combiner'AS_Weapons_TX.LinkTurret.LinkTurret_Skin1_C'
     Skins(2)=Shader'EpicParticles.Beams.hotbolt03SHAD'
}
