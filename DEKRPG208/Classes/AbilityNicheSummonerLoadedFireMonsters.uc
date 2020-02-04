class AbilityNicheSummonerLoadedFireMonsters extends AbilityLoadedMonsters
	config(UT2004RPG)
	abstract;

defaultproperties
{
     ExtremeLevel=1
     PlayerLevelReqd(1)=180
     ExcludingAbilities(0)=Class'DEKRPG208.AbilityNicheSummonerLoadedIceMonsters'
     ExcludingAbilities(1)=Class'DEKRPG208.AbilityLoadedMonsters'
     AbilityName="Niche: Loaded Fire Monsters"
     Description="One of several Summoner niches. You must be level 180 before buying a niche.||Allows you to summon Fire monsters which will do more damage to Ice monsters. Each level of this ability increases your Fire monsters' damage to Ice monsters by 5%. This stacks on top of the Monster Damage ability. |Cost (per level): 2,4,6,8,10,12,14,16,18,20,22,24,26,28,30,.."
     CostAddPerLevel=2
}
