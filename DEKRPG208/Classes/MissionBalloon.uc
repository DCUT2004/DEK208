class MissionBalloon extends DruidBlock;

var config bool PopOnTimer;
var config float PopTimer;

#exec OBJ LOAD FILE=..\Sounds\ONSVehicleSounds-S.uax
#exec OBJ LOAD FILE=..\Textures\VMParticleTextures.utx

simulated function PostBeginPlay()
{
    Super.PostBeginPlay();
	Velocity = Vector(Rotation) * AirSpeed;  
	Velocity.z += 225; 
	
	if (PopOnTimer)
		SetTimer(PopTimer, True);
}

simulated function Timer()
{
	Destroy();
}

function TakeDamage(int Damage, Pawn instigatedBy, Vector hitlocation, Vector momentum, class<DamageType> damageType)
{
	local MissionMultiplayerInv MMPI;
	local Actor A;
	local Pawn P;
	
	P = instigatedBy;
	
	if ( damagetype == None )
	{
		if ( InstigatedBy != None )
			warn("No damagetype for damage by "$instigatedby$" with weapon "$InstigatedBy.Weapon);
		DamageType = class'DamageType';
	}

	if ( Role < ROLE_Authority )
		return;

	if ( Health <= 0 )
		return;
		
	if (DamageType == class'DamTypeLightningRod' || DamageType == class'DamTypeEnhLightningRod' || DamageType == class'DamTypeLightningBolt' || DamageType == class'DamTypeLightningSent')
		return;
		
	if (instigatedBy.IsA('Monster'))
		return;
	
	if (P != None && P.IsA('Vehicle'))
		P = Vehicle(P).Driver;
	MMPI = MissionMultiplayerInv(P.FindInventoryType(class'MissionMultiplayerInv'));
	if (P != None && P.Health > 0 && MMPI != None && !MMPI.stopped && MMPI.BalloonPopActive)
	{
		class'MissionMultiplayerInv'.static.UpdateCounts(1);
	}

	A = spawn(class'MissionBalloonRedPopEffect',,, Self.Location + vect(0,0,60));
	if (A != None)
	{
		A.RemoteRole = ROLE_SimulatedProxy;
		A.PlaySound(sound'ONSVehicleSounds-S.VehicleTakeFire.VehicleHitBullet03',,5.5*TransientSoundVolume,,TransientSoundRadius);
	}
	
    gibbedBy(instigatedBy);
}


defaultproperties
{
	PopOnTimer=True
	PopTimer=30.00000
    AirSpeed=540.000000
    Physics=PHYS_Flying
    Mass=10.000000
    DrawScale=0.350000
    CollisionRadius=15.500000
    CollisionHeight=15.000000
	HealthMax=1.000000
	Health=1
	StaticMesh=StaticMesh'DEKStaticsMaster207P.Meshes.Balloon1'
	Skins(0)=Texture'MissionsTex4.Colors.Red'
	Skins(1)=Texture'MissionsTex4.Colors.Black'
}
