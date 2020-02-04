class CosmicWarlord extends Warlord;

#exec  AUDIO IMPORT NAME="CosmicWarlordFire" FILE="C:\UT2004\Sounds\CosmicWarlordFire.WAV" GROUP="MonsterSounds"

var bool SummonedMonster;

function PostBeginPlay()
{
	Instigator = self;
	Super.PostBeginPlay();
	CheckController();
}

function CheckController()
{
	if (Instigator.ControllerClass == class'DEKFriendlyMonsterController')
		SummonedMonster = true;
	else
		SummonedMonster = false;
}

function SetMovementPhysics()
{
	SetPhysics(PHYS_Flying); 
}

function bool SameSpeciesAs(Pawn P)
{
	if (SummonedMonster)
		return ( P.class == class'HealerNali' || P.class == class'HealerNaliAdren' || P.class == class'HealerNaliShield');
	else
		return ( P.class == class'Monster' );
}

function FireProjectile()
{	
	local vector FireStart,X,Y,Z;
	
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

		Spawn(MyAmmo.ProjectileClass,,,FireStart,Controller.AdjustAim(SavedFireProperties,FireStart,600));
		PlaySound(FireSound,SLOT_Interact);
	}
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
     FireSound=Sound'DEKMonsters208.MonsterSounds.CosmicWarlordFire'
     AmmunitionClass=Class'DEKMonsters208.CosmicWarlordAmmo'
     ScoringValue=12
     GibGroupClass=Class'DEKMonsters208.CosmicGibGroup'
     GroundSpeed=700.000000
     AirSpeed=800.000000
     AccelRate=600.000000
     Health=300
     Skins(0)=Shader'DEKMonstersTexturesMaster206E.CosmicMonsters.CosmicWarlord'
     Skins(1)=Shader'DEKMonstersTexturesMaster206E.CosmicMonsters.CosmicWarlord'
     Mass=100.000000
}
