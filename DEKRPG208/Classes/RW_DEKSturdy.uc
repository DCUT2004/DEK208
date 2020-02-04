class RW_DEKSturdy extends RW_EnhancedNoMomentum
	HideDropDown
	CacheExempt
	config(UT2004RPG);

var Pawn PawnOwner;

function GiveTo(Pawn Other, optional Pickup Pickup)
{
	PawnOwner = Other;
	enable('tick');
	super.GiveTo(Other, Pickup);
}

simulated function Tick(Float deltaTime)
{
	if(PawnOwner != None)
	{
		if(PawnOwner.Weapon != None && PawnOwner.Weapon == self)
		{
			PawnOwner.Mass=20000.000000;
		}
		else
		{
			if(PawnOwner != None)
				PawnOwner.Mass=PawnOwner.default.Mass;
		}
	}
	super.Tick(deltaTime);
}

defaultproperties
{
     DamageBonus=0.060000
     ModifierOverlay=Combiner'D-E-K-HoloGramFX.Effects.w00tenv_3'
     PrefixPos="Extra Sturdy "
     PrefixNeg="Extra Sturdy "
}
