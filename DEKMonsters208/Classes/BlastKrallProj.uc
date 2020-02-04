class BlastKrallProj extends LinkProjectile;

var BlastKrallTrail BlastTrail;

simulated function Destroyed()
{
    if (BlastTrail != None)
    {
        BlastTrail.Destroy();
    }
    Super.Destroyed();
}

simulated function LinkAdjust()
{
}

simulated function PostNetBeginPlay()
{
	local float dist;
	local PlayerController PC;

	Acceleration = Normal(Velocity) * 3000.0;

	if ( (Level.NetMode != NM_DedicatedServer) && (Level.DetailMode != DM_Low) )
		BlastTrail = Spawn(class'BlastKrallTrail',self);
	if ( (BlastTrail != None) && (Instigator != None) && Instigator.IsLocallyControlled() )
	{
		if ( Role == ROLE_Authority )
			BlastTrail.Delay(0.1);
		else
		{
			dist = VSize(Location - Instigator.Location);
			if ( dist < 100 )
				BlastTrail.Delay(0.1 - dist/1000);
		}
	}

    if ( Level.NetMode == NM_DedicatedServer )
		return;
	if ( Level.bDropDetail || (Level.DetailMode == DM_Low) )
	{
		bDynamicLight = false;
		LightType = LT_None;
	}
	else
	{
		PC = Level.GetLocalPlayerController();
		if ( (PC == None) || (Instigator == None) || (PC != Instigator.Controller) )
		{
			bDynamicLight = false;
			LightType = LT_None;
		}
	}
}

defaultproperties
{
     Speed=1500.000000
     Damage=80.000000
     MyDamageType=Class'DEKMonsters208.DamTypeBlastKrallPlasma'
     LightHue=40
     DrawScale3D=(X=5.295000)
     Skins(0)=FinalBlend'AW-2004Particles.Weapons.MuzzlePart2Final'
}
