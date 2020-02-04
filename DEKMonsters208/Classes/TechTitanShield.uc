class TechTitanShield extends ShieldEffect3rdBLUE;

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
     AimedOffset=(X=40.000000,Y=40.000000)
     bHidden=False
     DrawScale=16.000000
     bCollideActors=True
}
