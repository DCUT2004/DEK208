class UpgradeMineProjectile extends ONSMineProjectile;

#exec OBJ LOAD FILE="..\Sounds\GeneralAmbience.uax"

var class<Emitter> ExplosionEffect;

simulated function Destroyed()
{
    if ( !bNoFX && EffectIsRelevant(Location,false) )
        Spawn(ExplosionEffect);

    if (Role == ROLE_Authority && bScriptInitialized && ONSMineLayer(Owner) != None)
    	ONSMineLayer(Owner).CurrentMines--;

    Super.Destroyed();
}

//simulated function BlowUp(Vector HitLocation)
//{
	//local vector start;
    //local rotator rot;
    //local int j;
    //local UpgradeFlakChunk NewChunk;

	//start = HitLocation;
	//if ( Role == ROLE_Authority )
	//{
	//	for (j=0; j<9; j++)
	//	{
	//		rot = Rotation;
	//		rot.yaw += FRand()*32000-16000;
	//		rot.pitch += FRand()*32000-16000;
	//		rot.roll += FRand()*32000-16000;
	//		NewChunk = Spawn( class 'UpgradeFlakChunk',, '', Start, rot);
	//	}
	//}
    //Spawn(ExplosionEffect);
	//Super(ONSMineProjectile).BlowUp(HitLocation);
//}

defaultproperties
{
     ExplodeSound=Sound'GeneralAmbience.electricalfx5'
     ExplosionEffect=Class'DEKWeapons208.UpgradeMineProjectileFX'
     ScurrySpeed=825.000000
}
