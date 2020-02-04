//Code from SpecialSkaarjPackv4, based on the Crystalis. Author: Ace08.
class IceTitanBigCrystal extends SMPTitanBigRock;

#exec OBJ LOAD FILE=DEKStaticsMaster207P.usx
#exec OBJ LOAD FILE=AW-2004Crystals.usx

var config float BaseChance;

simulated function PostBeginPlay()
{
	local vector Dir;
	if ( bDeleteMe || IsInState('Dying') )
		return;

	Dir = vector(Rotation);
	Velocity = (speed+Rand(MaxSpeed-speed)) * Dir;
	SetPhysics(PHYS_Falling);

	DesiredRotation.Roll = Rotation.Roll + Rand(2000) - 1000;

    if ( (RotationRate.Pitch == 0) || (FRand() < 0.8) )
		RotationRate.Roll = Max(0, 50000 + Rand(200000) - RotationRate.Pitch);
}


function ProcessTouch (Actor Other, Vector HitLocation)
{
	local int hitdamage;
	local FreezeInv Inv;
	local Pawn P;
	local MagicShieldInv MInv;

	if (Other==none || Other == instigator )
		return;
		
	PlaySound(ImpactSound, SLOT_Interact, DrawScale);
	if(Projectile(Other)!=none)
		Other.Destroy();
	else if ( !Other.IsA('IceTitanBigCrystal'))
	{
		Hitdamage = Damage * 0.00002 * (DrawScale**3) * speed;
		if ( (HitDamage > 3) && (speed > 150) && ( Role == ROLE_Authority ))
			Other.TakeDamage(hitdamage, instigator,HitLocation,
				(35000.0 * Normal(Velocity)*DrawScale), MyDamageType );
		// now see if we can freeze em
		P = Pawn(Other);
		if (P != None && P.Controller != None && P.Health > 0 && !P.Controller.SameTeamAs(InstigatorController) && class'RW_Freeze'.static.canTriggerPhysics(P))
		{
			MInv = MagicShieldInv(P.FindInventoryType(class'MagicShieldInv'));
			if (MInv == None)
			{
				if(rand(99) < int(BaseChance))
				{
					Inv = FreezeInv(P.FindInventoryType(class'FreezeInv'));
					//dont add to the time a pawn is already frozen. It just wouldn't be fair.
					if (Inv == None)
					{
						Inv = spawn(class'FreezeInv', P,,, rot(0,0,0));
						Inv.Modifier = 2;
						Inv.LifeSpan = 3.0;
						Inv.GiveTo(P);
					}
				}
			}
		}
	}
}
//Ajust to hear impactsound
simulated function HitWall (vector HitNormal, actor Wall)
{
	local vector RealHitNormal;
	local int HitDamage;


	if ( !Wall.bStatic && !Wall.bWorldGeometry
		&& ((Mover(Wall) == None) || Mover(Wall).bDamageTriggered) )
	{
		if ( Level.NetMode != NM_Client )
		{
			Hitdamage = Damage * 0.00002 * (DrawScale**3) * speed;
			if ( Instigator == None || Instigator.Controller == None )
				Wall.SetDelayedDamageInstigatorController( InstigatorController );
			Wall.TakeDamage( Hitdamage, instigator, Location, MomentumTransfer * Normal(Velocity), MyDamageType);
		}
	}

	speed = VSize(velocity);
	if (Bounces > 0 && speed>100)
	{
		PlaySound(ImpactSound, SLOT_Interact, DrawScale/10);
		SetPhysics(PHYS_Falling);
		RealHitNormal = HitNormal;
		if ( FRand() < 0.5 )
			RotationRate.Pitch = Max(RotationRate.Pitch, 100000);
		else
			RotationRate.Roll = Max(RotationRate.Roll, 100000);
		HitNormal = Normal(HitNormal + 0.5 * VRand());
		if ( (RealHitNormal Dot HitNormal) < 0 )
			HitNormal.Z *= -0.7;
		Velocity = 0.7 * (Velocity - 2 * HitNormal * (Velocity Dot HitNormal));
		DesiredRotation = rotator(HitNormal);

		if ( speed > 250)
			SpawnChunks(4);
		Bounces = Bounces - 1;
		return;
	}
	bFixedRotationDir=false;
	bBounce = false;
}

function TakeDamage( int Damage, Pawn instigatedBy, Vector hitlocation,
							Vector momentum, class<DamageType> damageType) {

	// If a rock is shot, it will fragment into a number of smaller
	// pieces.  The player can fragment a giant boulder which would
	// otherwise crush him/her, and escape with minor or no wounds
	// when a multitude of smaller rocks hit.

	//log ("Rock gets hit by something...");

	if(instigatedBy==none)
		return;
	if(Damage<10)
		return;
	Velocity += Momentum/(DrawScale * 10);
	if (Physics == PHYS_None )
	{
		SetPhysics(PHYS_Falling);
		Velocity.Z += 0.4 * VSize(momentum);
	}
	if ( 2 < DrawScale )
		SpawnChunks(4);
}

function SpawnChunks(int num)
{
	local int    NumChunks,i;
	local IceTitanCrystalShard   TempRock;
	local float pscale;

	if ( DrawScale < 2 + FRand()*2 )
		return;
	if(Level.Game.IsA('Invasion') && DrawScale < 4 + FRand()*2)
		return;


	NumChunks = 1+Rand(num);
	pscale = sqrt(0.52/NumChunks);
	if ( pscale * DrawScale < 1 )
	{
		NumChunks *= pscale * DrawScale;
		pscale = 1/DrawScale;
	}
	speed = VSize(Velocity);
	for (i=0; i<NumChunks; i++)
	{
		TempRock = Spawn(class'IceTitanCrystalShard');
        if (TempRock != None )
			TempRock.InitFrag(self, pscale);
	}
	InitFrag(self, 0.5);
}

defaultproperties
{
     BaseChance=25.000000
     Damage=20.000000
     MyDamageType=Class'DEKMonsters208.DamTypeIceTitan'
     ImpactSound=ProceduralSound'WeaponSounds.PGrenFloor1.P1GrenFloor1'
     StaticMesh=StaticMesh'DEKStaticsMaster207P.Meshes.CrystalA'
     DrawScale=4.000000
     DrawScale3D=(X=2.000000,Y=2.000000,Z=2.000000)
     SoundVolume=255
     SoundRadius=200.000000
}
