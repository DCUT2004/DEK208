class AbilityLoadedMonsters extends CostRPGAbility
	config(UT2004RPG)
	abstract;

struct MonsterConfig
{
	Var String FriendlyName;
	var Class<Monster> Monster;
	var int Adrenaline;
	var int MonsterPoints;
	var int Level;
};

var config Array<MonsterConfig> MonsterConfigs;

var config int MaxNormalLevel;
var config float PetHealthFraction;
var config float WeaponDamage;
var config int ExtremeLevel;

static function ModifyPawn(Pawn Other, int AbilityLevel)
{
	local int i;
	local LoadedInv LoadedInv;
	Local RPGArtifact Artifact;
	Local bool PreciseLevel;

	LoadedInv = LoadedInv(Other.FindInventoryType(class'LoadedInv'));

	if(LoadedInv != None)
	{
		if(LoadedInv.bGotLoadedMonsters)
		{
			if (LoadedInv.LMAbilityLevel == AbilityLevel)
				return;
			PreciseLevel = true; //only giving artifacts for this level.
		}
	}
	else
	{
		LoadedInv = Other.spawn(class'LoadedInv');
		LoadedInv.giveTo(Other);
		PreciseLevel = false; 	//give all artifacts up to this level.
	}

	if(LoadedInv == None)
		return;

	LoadedInv.bGotLoadedMonsters = true;
	LoadedInv.LMAbilityLevel = AbilityLevel;

	for(i = 0; i < Default.MonsterConfigs.length; i++)
	{
		if(Default.MonsterConfigs[i].Monster != None) //make sure the object is sane.
		{
			if(PreciseLevel && Default.MonsterConfigs[i].Level != AbilityLevel) //checkertrap for purchases during a game.
				continue;
			if(Default.MonsterConfigs[i].Level <= AbilityLevel)
			{
				Artifact = Other.spawn(class'DruidMonsterMasterArtifactMonsterSummon', Other,,, rot(0,0,0));
				if(Artifact == None)
					continue; // wow.
				DruidMonsterMasterArtifactMonsterSummon(Artifact).Setup(Default.MonsterConfigs[i].FriendlyName, Default.MonsterConfigs[i].Monster, Default.MonsterConfigs[i].Adrenaline, Default.MonsterConfigs[i].MonsterPoints);
				Artifact.GiveTo(Other);
			}
		}
	}

	if(!PreciseLevel)
	{
		Artifact = Other.spawn(class'ArtifactKillAllPets', Other,,, rot(0,0,0));
		Artifact.GiveTo(Other);
		Artifact = Other.spawn(class'ArtifactKillOnePet', Other,,, rot(0,0,0));
		Artifact.GiveTo(Other);
	}
	
	//Hollon: below sets the level required to use pet commands. I'm changing it so any level can use pet commands.
	//if (AbilityLevel > default.MaxNormalLevel)
	//	LoadedInv.DirectMonsters = true;
	//else
	//	LoadedInv.DirectMonsters = false;
	
	LoadedInv.DirectMonsters = true;
	
// I'm guessing that NextItem is here to ensure players don't start with
// no item selected.  So the if should stop wierd artifact scrambles.
	if(Other.SelectedItem == None)
		Other.NextItem();
}

static function HandleDamage(out int Damage, Pawn Injured, Pawn Instigator, out vector Momentum, class<DamageType> DamageType, bool bOwnedByInstigator, int AbilityLevel)
{
	// need to check that summoned monsters do not get xp for not doing damage to same species
	local DEKFriendlyMonsterController C;
	
	if (Instigator == None || Injured == None)
		return;
		
	if(Damage > 0 && bOwnedByInstigator && ClassIsChildOf(DamageType, class'WeaponDamageType') && Monster(Instigator) == None && AbilityLevel >= default.ExtremeLevel)
		Damage *= default.WeaponDamage;

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
     MonsterConfigs(0)=(FriendlyName="Pupae",Monster=Class'SkaarjPack.SkaarjPupae',Adrenaline=15,MonsterPoints=1,Level=1)
     MaxNormalLevel=15
     PetHealthFraction=1.000000
     WeaponDamage=0.500000
     ExtremeLevel=11
     ExcludingAbilities(0)=Class'DEKRPG208.AbilityNicheSummonerLoadedFireMonsters'
     ExcludingAbilities(1)=Class'DEKRPG208.AbilityNicheSummonerLoadedIceMonsters'
     AbilityName="Loaded Monsters"
     Description="Learn new monsters to summon with Monster Points. At each level, you can summon a better monster. At level 11 and beyond, weapon damage is reduced for Summoners.|Cost (per level): 2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,.."
     StartingCost=2
     CostAddPerLevel=1
     MaxLevel=30
}
