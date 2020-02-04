//Code from Special Skaarj Packv4, based off of the Crystalis Titan.
class IceTitanBigCrystalA extends SMPTitanBigRock;

#exec OBJ LOAD FILE=DEKStaticsMaster207P
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

function MakeSound()
{
	local float soundRad;
	soundRad = 90 * DrawScale;

	PlaySound(ImpactSound, SLOT_Misc, DrawScale/20,,soundRad);
}

simulated function HitWall (vector HitNormal, actor Wall)
{
	Velocity = 0.75 * (Velocity - 2 * HitNormal * (Velocity Dot HitNormal));
	SetRotation(rotator(HitNormal));
	setDrawScale( DrawScale* 0.7);
	SpawnChunks(9);
	Destroy();
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
	local IceTitanBigCrystal   TempRock;
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
		TempRock = Spawn(class'IceTitanBigCrystal');
		if (TempRock != None )
			TempRock.InitFrag(self, pscale);
	}
	InitFrag(self, 0.5);
}

defaultproperties
{
     BaseChance=25.000000
     Speed=1300.000000
     MaxSpeed=1300.000000
     StaticMesh=StaticMesh'DEKStaticsMaster207P.Meshes.crystal'
     DrawScale=15.000000
     DrawScale3D=(X=0.500000,Y=0.500000,Z=0.500000)
     CollisionRadius=60.000000
     CollisionHeight=60.000000
}
