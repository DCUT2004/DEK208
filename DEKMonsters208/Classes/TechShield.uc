class TechShield extends ShieldEffect3rdBLUE;

var int Health;

simulated function PostBeginPlay()
{
     SetTimer(5,false);

     Super.PostBeginPlay();
}

simulated function Timer()
{
     Destroy();
}


function Touch( actor Other )
{
	if(Other.IsA('xPawn') && !Other.IsA('Monster'))
		Destroy();
}
simulated function Flash(int Drain)
{
	super.Flash(Drain);
	Health-=Drain;
	if(Health<0)
		Destroy();
}

defaultproperties
{
     Health=350
     bHidden=False
     bCollideActors=True
}
