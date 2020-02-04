class AbilityNecroPossess extends CostRPGAbility
	config(UT2004RPG);
	
var config float RangeMultiplier;

static function ModifyPawn(Pawn Other, int AbilityLevel)
{
	local ArtifactPossess AP;
	Local RPGArtifact Artifact;

	AP = ArtifactPossess(Other.FindInventoryType(class'ArtifactPossess'));
	
	if (AP == None)
	{
		AP = Other.spawn(class'ArtifactPossess', Other,,, rot(0,0,0));
		if(AP == None)
			return;
		AP.AbilityLevel = AbilityLevel;
		AP.giveTo(Other);
	}
	
	Artifact = Other.spawn(class'ArtifactKillAllPets', Other,,, rot(0,0,0));
	Artifact.GiveTo(Other);
	Artifact = Other.spawn(class'ArtifactKillOnePet', Other,,, rot(0,0,0));
	Artifact.GiveTo(Other);
		
	if(Other.SelectedItem == None)
		Other.NextItem();
}

static function HandleDamage(out int Damage, Pawn Injured, Pawn Instigator, out vector Momentum, class<DamageType> DamageType, bool bOwnedByInstigator, int AbilityLevel)
{
	// need to check that summoned monsters do not get xp for not doing damage to same species
	local DEKFriendlyMonsterController C;
	
	if (Instigator == None || Injured == None)
		return;

	if(!bOwnedByInstigator)
	{   // this is hitting a pet, so the pet will not get xp.
	    // while we are here, let's make sure the pet is not hurt by the spawner. This is a deliberate ommission in RPGRules
		C = DEKFriendlyMonsterController(injured.Controller);
		if (C != None && C.Master != None && C.Master == Instigator.Controller)
		{
			Damage *= TeamGame(injured.Level.Game).FriendlyFireScale;
		}
		return;
 	}

	if (Monster(Instigator) == None || Monster(Injured) == None)
		return;
		
	// now know this is damage done by a monster on a pet
	if ( Monster(Injured).SameSpeciesAs(Instigator) )
		Damage = 0;

}

defaultproperties
{
     RangeMultiplier=0.100000
	 RequiredAbilities(0)=class'DEKRPG208.AbilityMonsterPoints'
     AbilityName="Possess"
     Description="Grants the Possess artifact, which turns a hostile monster into a friendly pet. The amount of adrenaline and monster points required varies with the monster's scoring value. Each level of this ability allows you to possess a higher scoring monster.||You must have at least level one of Monster Points before purchasing this skill.||Cost: 2,3,4,5..."
     StartingCost=2
     CostAddPerLevel=1
     MaxLevel=30
}
