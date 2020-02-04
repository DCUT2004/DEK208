class DualityInvHolder extends Actor;

var int DualityKills;

function PostBeginPlay()
{
	SetTimer(5.0, true);

	Super.PostBeginPlay();
}

function Timer()
{
	if (Controller(Owner) == None)
		Destroy();
}

defaultproperties
{
     bHidden=True
     RemoteRole=ROLE_None
}
