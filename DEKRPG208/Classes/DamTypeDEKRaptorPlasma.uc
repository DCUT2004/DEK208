class DamTypeDEKRaptorPlasma extends VehicleDamageType
	abstract;

static function ScoreKill(Controller Killer, Controller Killed)
{
	if (Killed != None && Killer != Killed && Vehicle(Killed.Pawn) != None && Vehicle(Killed.Pawn).bCanFly)
	{
		//Maybe add to game stats?
		if (PlayerController(Killer) != None)
			PlayerController(Killer).ReceiveLocalizedMessage(class'ONSVehicleKillMessage', 6);
	}
}

defaultproperties
{
     VehicleClass=Class'DEKRPG208.DEKRaptor'
     DeathString="Pro Tip for %k: %o is not a monster."
     FemaleSuicide="Pro Tip for %o: You are not a monster."
     MaleSuicide="Pro Tip for %o: You are not a monster."
     bDetonatesGoop=True
     bDelayedDamage=True
     FlashFog=(X=700.000000)
     VehicleDamageScaling=0.800000
}
