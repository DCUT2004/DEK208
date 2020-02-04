class FireChildGasbag extends FireGasbag;

var FireGiantGasBag ParentBag;

var() byte
	PunchDamage,	// Basic damage done by each punch.
	PoundDamage;	// Basic damage done by pound.

simulated function PreBeginPlay()
{
//	Log(Owner);
	ParentBag=FireGiantGasbag(Owner);
	if(ParentBag==none)
		Destroy();
	Super.PreBeginPlay();
}

function Tick(float DeltaTime)
{
	super.Tick(DeltaTime);
	if(ParentBag==none || ParentBag.Controller==none || ParentBag.Controller.Enemy==self)
	{
		Destroy();
		return;
	}
	if(ParentBag.Controller!=none && Controller!=none && Health>=0)
	{
		Controller.Enemy=ParentBag.Controller.Enemy;
		Controller.Target=ParentBag.Controller.Target;
	}
}

function PunchDamageTarget()
{
	if(Controller==none || Controller.Target==none) return;
	if (MeleeDamageTarget(PunchDamage, (39000 * Normal(Controller.Target.Location - Location))))
		PlaySound(sound'Hit1g', SLOT_Interact);
}

function PoundDamageTarget()
{
	if(Controller==none || Controller.Target==none) return;
	if (MeleeDamageTarget(PoundDamage, (24000 * Normal(Controller.Target.Location - Location))))
		PlaySound(sound'Hit1g', SLOT_Interact);
}

simulated function Died(Controller Killer, class<DamageType> damageType, vector HitLocation)
{
	Spawn(class'RocketSmokeRing');
	Destroy();
}

simulated function Destroyed()
{
	if ( ParentBag != None )
		ParentBag.numChildren--;
	Super.Destroyed();
	Spawn(class'RocketSmokeRing');
}

defaultproperties
{
     PunchDamage=25
     PoundDamage=35
}
