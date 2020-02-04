class PossessedPrincess extends Princess;

var PossessFlameFX Flame;

function PostNetBeginPlay()
{
	Flame = Spawn(class'PossessFlameFX', Self,,Self.Location, Self.Rotation);
	if (Flame != None)
	{
		Flame.Emitters[0].SkeletalMeshActor = Self;
		Flame.SetLocation(Self.Location);
		Flame.SetRotation(Self.Rotation + rot(0, -16384, 0));
		Flame.SetBase(Self);
		Flame.bOwnerNoSee = true;
		Flame.RemoteRole = ROLE_SimulatedProxy;
	}
	Super.PostNetBeginPlay();
}

function Died(Controller Killer, class<DamageType> damageType, vector HitLocation)
{
	if (SummonedMonster)
		Destroy();	// do not want to execute the invasion Killed function which decrements the number of monsters
	else
		Super.Died(Killer, damageType, HitLocation);
    if (Flame != None)
    {
        Flame.Emitters[0].SkeletalMeshActor = None;
        Flame.Kill();
        Flame = None;
    }
	
}

defaultproperties
{
     ControllerClass=Class'DEKMonsters208.DCMonsterController'
}
