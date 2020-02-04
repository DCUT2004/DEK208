class TechQueenEgg extends FlakShell;

var config float HatchChance;

simulated function Explode(vector HitLocation, vector HitNormal)
{
	if (Role == ROLE_Authority)
	
	if(rand(99) < int(HatchChance))
	
			if ( EffectIsRelevant(Location,false) )
			Spawn(class'TechRazorfly',,, HitLocation, rotator(HitNormal));
			PlaySound(Sound'ONSVehicleSounds-S.PowerNode.PwrNodeStartBuild03',,2.1*TransientSoundVolume);
	BlowUp(HitLocation);
	Destroy();
}

defaultproperties
{
     HatchChance=20.000000
     Damage=0.000000
     MomentumTransfer=100.000000
     MyDamageType=Class'DEKMonsters208.DamTypeTechQueen'
     DrawScale=4.000000
     Skins(0)=FinalBlend'DEKMonstersTexturesMaster206E.TechMonsters.TechProjFB'
}
