class NullWarLord extends DCWarLord;

var config float MaxNullTime;

function FireProjectile()
{	
	local vector FireStart,X,Y,Z;
	local rotator ProjRot;
	local NullWarlordRocket NWR;
	if ( Controller != None )
	{
		GetAxes(Rotation,X,Y,Z);
		FireStart = GetFireStart(X,Y,Z);
		if ( !SavedFireProperties.bInitialized )
		{
			SavedFireProperties.AmmoClass = MyAmmo.Class;
			SavedFireProperties.ProjectileClass = MyAmmo.ProjectileClass;
			SavedFireProperties.WarnTargetPct = MyAmmo.WarnTargetPct;
			SavedFireProperties.MaxRange = MyAmmo.MaxRange;
			SavedFireProperties.bTossed = MyAmmo.bTossed;
			SavedFireProperties.bTrySplash = MyAmmo.bTrySplash;
			SavedFireProperties.bLeadTarget = MyAmmo.bLeadTarget;
			SavedFireProperties.bInstantHit = MyAmmo.bInstantHit;
			SavedFireProperties.bInitialized = true;
		}
		ProjRot = Controller.AdjustAim(SavedFireProperties,FireStart,600);
		if ( bRocketDir )
			ProjRot.Yaw += 3072; 
		else
			ProjRot.Yaw -= 3072; 
		bRocketDir = !bRocketDir;
		NWR = Spawn(class'NullWarlordRocket',,,FireStart,ProjRot);
		if (NWR != None)
		{
			NWR.MaxNullTime = MaxNullTime;
			NWR.Seeking = Controller.Enemy;
			PlaySound(FireSound,SLOT_Interact);
		}
	}
}

function bool SameSpeciesAs(Pawn P)
{
	if (SummonedMonster)
		return ( P.class == class'HealerNali' || P.class == class'HealerNaliAdren' || P.class == class'HealerNaliShield');
	else
		return ( P.class == class'NullWarlord' );
}

function Died(Controller Killer, class<DamageType> damageType, vector HitLocation)
{
	if (SummonedMonster)
		Destroy();	// do not want to execute the invasion Killed function which decrements the number of monsters
	else
		Super.Died(Killer, damageType, HitLocation);
}

defaultproperties
{
     MaxNullTime=3.000000
     AmmunitionClass=Class'DEKMonsters208.NullWarlordAmmo'
     ControllerClass=Class'DEKMonsters208.DCMonsterController'
     Skins(0)=Shader'DEKMonstersTexturesMaster206E.GenericMonsters.DarkWarlordShader'
     Skins(1)=Shader'DEKMonstersTexturesMaster206E.GenericMonsters.DarkWarlordShader'
}
