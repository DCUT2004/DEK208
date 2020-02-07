class MutWaveRandomizer extends Mutator
	config(satoreMonsterPack);

/*
METHOD ONE:
Before each game starts, give a % chance that a randomizer will activate on specific waves
If Randomizer is true, loop through all monsters in that particular wave and replace it with
either an array of monsters, or just one specific type of monsters.

Use event PreBeginPlay() to set % chance and boolean randomizer.
Use Timer() to loop through all monster classes (not the actual monster pawns) and do a replace.
mutsatoreMonsterPack is a good example of this.

Create a struct containing:
struct SMPWaveInfo
{
	var byte MonsterNum[16];
};

var config Array<SMPWaveInfo> SMPWaves;

And then in timer:
{
	local class<Monster> MonsterClass;
	local int i;
	if(Invasion.bWaveInProgress && SetupWaveNum!=Invasion.WaveNum)
	{
		Invasion.WaveNumClasses=0;

		for(i=0;i<16;i++)
		{
			MonsterClass=none;
			MonsterClass=MonsterClasses[SMPWaves[Invasion.WaveNum].MonsterNum[i]];

			if(MonsterClass!=none)
			{
				Invasion.WaveMonsterClass[Invasion.WaveNumClasses] = MonsterClass;
				Invasion.WaveNumClasses++;

			}
		}
	}
}

OR

METHOD TWO:
Let SMP stuff run its course
In PreBeginPlay(), do x% chance for randomization.
If Randomization = True, loop through all monsters in a wave DURING gameplay
Remove that monster and spawn a specified replacement for that monster.
Spawn "this specific monster" if invasion wave is "this specific number"
	- wave specific. Warlord on 12, element on 13, etc.
	- Create sub chances for the same waves. If wave 12, x% chance for warlord wave, y % chance for element wave, 1-x%-y% normal wave
Spawn "this specifc monster" if replacing "this specific monster"
	- Monster specific. Less control over this.



*/

defaultproperties
{
     GroupName="WaveRandomizer"
     FriendlyName="Wave Randomizer"
     Description="Wave Randomizer"
}
