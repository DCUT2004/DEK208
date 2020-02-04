class MissionCoin extends Projectile;

#exec  AUDIO IMPORT NAME="Coin" FILE="C:\UT2004\Sounds\Coin.WAV" GROUP="MissionSounds"

simulated event PreBeginPlay()
{
    Super.PreBeginPlay();

    if( Pawn(Owner) != None )
        Instigator = Pawn( Owner );
}

simulated function PostBeginPlay()
{
	local Rotator R;
	
	R = Rotation;
	R.Pitch = -20000;
	SetRotation(R);
	Velocity = Vector(R) * Speed;  
	Velocity.z += TossZ; 
	Super.PostBeginPlay();
}

simulated function Landed( vector HitNormal )
{
	Explode(Location,HitNormal);
}

simulated function ProcessTouch (Actor Other, vector HitLocation)
{
	local Pawn P;
	local MissionMultiplayerInv MMPI;
	local Actor A;
	
	if (Other.IsA('Projectile'))
		return;
	
	P = Pawn(Other);
	
	if (P != None && P.Health > 0 && P.Controller != None && P.Controller.SameTeamAs(InstigatorController) && !P.IsA('Monster'))
	{
		MMPI = MissionMultiplayerInv(P.FindInventoryType(class'MissionMultiplayerInv'));
		if (MMPI != None && MMPI.CoinGrabActive)
			MMPI.UpdateCounts(1);
		CoinSound(P);
		A = spawn(class'MissionCoinFX',,,Self.Location);
		if (A != None)
			A.RemoteRole = ROLE_SimulatedProxy;
		SetDrawscale(0.1);
		Destroy();
	}
}

function CoinSound(Pawn P)
{
	if (P != None && P.Health > 0)
		P.PlaySound(Sound'DEKRPG208.MissionSounds.Coin',,200.00);
}

simulated function Explode(vector HitLocation,vector HitNormal)
{	
	Destroy();
}

defaultproperties
{
	 TossZ=-100.00
	 bCanBeDamaged=False;
     //Physics=PHYS_Falling
     Speed=100.000000
     MaxSpeed=100.00000
     Damage=0.000000
	 DamageRadius=0.000
     MomentumTransfer=0.000000
     MaxEffectDistance=7000.000000
     DrawType=DT_StaticMesh
	 StaticMesh=StaticMesh'UTRPGStatics.Artifacts.MonsterCoin'
	 Skins(0)=Texture'MissionsTex4.Colors.Yellow'
	 Skins(1)=Texture'MissionsTex4.Colors.Yellow'
     CullDistance=4000.000000
     bDynamicLight=False
     bOnlyDirtyReplication=True
	 Mass=5.00
     LifeSpan=30.000000
     DrawScale=0.350000
     Style=STY_Translucent
     FluidSurfaceShootStrengthMod=8.000000
     SoundVolume=0
     SoundRadius=0.00
     CollisionRadius=20.000000
     CollisionHeight=20.000000
     bProjTarget=True
     ForceType=FT_Constant
     ForceRadius=40.000000
     ForceScale=5.000000
	 bFixedRotationDir=True
     RotationRate=(Pitch=50000)
     DesiredRotation=(Pitch=30000)
	 bBlockZeroExtentTraces=False
}
