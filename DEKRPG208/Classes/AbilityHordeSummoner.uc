class AbilityHordeSummoner extends CostRPGAbility
	abstract;
	
var config float AdrenalineUsage;

static simulated function ModifyPawn(Pawn Other, int AbilityLevel)
{
	local MonsterPointsInv Inv;
	local ArtifactHealingBlast AHB;
	local ArtifactSphereHealing ASH;

	Inv = MonsterPointsInv(Other.FindInventoryType(class'MonsterPointsInv'));
	AHB = ArtifactHealingBlast(Other.FindInventoryType(class'ArtifactHealingBlast'));
	ASH = ArtifactSphereHealing(Other.FindInventoryType(class'ArtifactSphereHealing'));
	
	if (Inv == None)
		return;
	else
	{
		Inv.TotalMonsterPoints += 5;
		Inv.MaxMonsters += 1;
	}
	
	if (AHB != None)
		AHB.EnhanceArtifact(default.AdrenalineUsage);
	if (ASH != None)
		ASH.EnhanceArtifact(default.AdrenalineUsage);

}

defaultproperties
{
	 AdrenalineUsage=1.50000
	 RequiredAbilities(0)=class'DEKRPG208.AbilityMonsterPoints'
     ExcludingAbilities(0)=Class'DEKRPG208.AbilityBeastSummoner'
     ExcludingAbilities(1)=Class'DEKRPG208.AbilityMindControlSummoner'
     AbilityName="Niche: Horde"
     Description="Increases your maximum Monster Points by 5, and increases your maximum summonable pets by 1. However, the cost of your healing artifacts also increases.|You must be level 180 and have at least level 1 of Monster Points before buying this niche. You can not be in more than one niche at a same time.||Cost(per level): 50"
     StartingCost=50
     MaxLevel=1
}
