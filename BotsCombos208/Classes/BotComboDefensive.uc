/* Originally tried to extend ComboDefensive, but that didn't go over well.
 * Server would bomb with Infinite script recursions!  Really, the only
 * function that's essentially different is Timer. */
class BotComboDefensive extends Combo;

var xEmitter Effect;

function StartEffect(xPawn P)
{
	if (P.Role == ROLE_Authority)
		Effect = Spawn(class'RegenCrosses', P,, P.Location, P.Rotation);

	SetTimer(0.9, true);
	Timer();
}

function Timer()
{
	local Pawn P;

	P = Pawn(Owner);
	if (P == None || P.Controller == None)
	{
		Destroy();
		return;
	}
	if (P.Role == ROLE_Authority)
	{
		P.GiveHealth(5, P.SuperHealthMax);
		if ( P.Health >= Pawn(Owner).SuperHealthMax )
// AddShieldStrength returns True if ShieldStrength is changed
			if(!P.AddShieldStrength(5))
				Destroy();
	}
}

function StopEffect(xPawn P)
{
	if ( Effect != None )
		Effect.Destroy();
}

defaultproperties
{
     ExecMessage="Booster!"
     ComboAnnouncementName="Booster"
     keys(0)=2
     keys(1)=2
     keys(2)=2
     keys(3)=2
}
