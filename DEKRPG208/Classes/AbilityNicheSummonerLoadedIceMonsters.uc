class AbilityNicheSummonerLoadedIceMonsters extends AbilityLoadedMonsters
	config(UT2004RPG)
	abstract;

defaultproperties
{
     ExtremeLevel=1
     PlayerLevelReqd(1)=180
     ExcludingAbilities(1)=Class'DEKRPG208.AbilityLoadedMonsters'
     AbilityName="Niche: Loaded Ice Monsters"
     Description="One of several Summoner niches. You must be level 180 before buying a niche.||Allows you to summon Ice monsters which will do more damage to Fire monsters. Each level of this ability increases your Ice monsters' damage to Fire monsters by 5%. This stacks on top of the Monster Damage ability.||Cost (per level): 2,4,6,8,10,12,14,16,18,20,22,24,26,28,30,32,.."
     CostAddPerLevel=2
}
