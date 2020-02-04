class AbilityMagicVault extends CostRPGAbility
	config(UT2004RPG)
	abstract;

defaultproperties
{
     MinPlayerLevel=5
     AbilityName="Magic Vault"
     Description="This ability gives you access to unique and powerful magic modifiers for your weapons. |Level one includes Bullet Time and Gorgon. |Level two includes Heavy Guard. |Level three includes Arctic and Solar Power. |Press F12 to learn more about these magic modifiers. Cost (per level): 10, 13, 16"
     StartingCost=10
     CostAddPerLevel=3
     MaxLevel=5
}
