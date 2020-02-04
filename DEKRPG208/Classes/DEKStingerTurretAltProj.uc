class DEKStingerTurretAltProj extends DEKStingerTurretProj;

function SpawnChunks(int num)
{
	local int NumChunks,i;
	local DEKStingerTurretAltMiniShard TempShard;
	local float pscale;

	if ( DrawScale < 2 + FRand()*2 )
		return;
	if(Level.Game.IsA('Invasion') && DrawScale < 1 + FRand()*2)
		return;


	NumChunks = 1+Rand(num);
	pscale = sqrt(0.52/NumChunks);
	if ( pscale * DrawScale < 1 )
	{
		NumChunks *= pscale * DrawScale;
		pscale = 1/DrawScale;
	}
	speed = VSize(Velocity);
	for (i=0; i<NumChunks; i++)
	{
		TempShard = Spawn(class'DEKStingerTurretAltMiniShard');
        if (TempShard != None )
			TempSHard.InitFrag(self, pscale);
	}
	InitFrag(self, 0.5);
}

defaultproperties
{
     Speed=3000.000000
     Damage=35.000000
     LightBrightness=15.000000
     LifeSpan=3.000000
     DrawScale=3.000000
     DrawScale3D=(X=0.525000,Y=0.525000,Z=0.525000)
}
