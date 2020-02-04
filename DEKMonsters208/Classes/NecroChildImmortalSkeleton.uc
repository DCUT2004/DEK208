class NecroChildImmortalSkeleton extends NecroImmortalSkeleton;

var NecroSorcerer ParentSorcerer;
const  TargetRadius= 1200;

function bool SameSpeciesAs(Pawn P)
{
	return ( P.class == class'NecroImmortalSkeleton' || P.Class == class'NecroSorcerer');
}

simulated function Timer() // so bots won't wase time attacking something that can't be killed.
{
	local Monster other;
	foreach VisibleCollidingActors(class'Monster',Other,TargetRadius,Location)
	{
		if(!Other.bAmbientCreature && Other.Controller!=none)
			Other.Controller.Trigger(none,self);
	}
}

simulated function PreBeginPlay()
{
//	Log(Owner);
	ParentSorcerer=NecroSorcerer(Owner);
	if(ParentSorcerer==none)
		Destroy();
	Super.PreBeginPlay();
}

function Tick(float DeltaTime)
{
	super.Tick(DeltaTime);
	if(ParentSorcerer==none || ParentSorcerer.Controller==none || ParentSorcerer.Controller.Enemy==self)
	{
		Destroy();
		return;
	}
	if(ParentSorcerer.Controller!=none && Controller!=none && Health>=0)
	{
		Controller.Enemy=ParentSorcerer.Controller.Enemy;
		Controller.Target=ParentSorcerer.Controller.Target;
	}
}

simulated function Destroyed()
{
	if ( ParentSorcerer != None )
		ParentSorcerer.numChildren--;
	Super.Destroyed();
}

simulated function Died(Controller Killer, class<DamageType> damageType, vector HitLocation)
{
	Destroy();
}

defaultproperties
{
     ScoringValue=0
     ControllerClass=Class'DEKMonsters208.DCMonsterController'
}
