class NecromancerWeaponChildBoltFX extends ChildLightningBolt;

simulated function PostBeginPlay()
{
    Super.PostBeginPlay();
    // pass in +vect(0,0,2) to EffectIsRelevant() because this actor just spawned too (not valid to check if its been rendered)
	if( EffectIsRelevant(Location+vect(0,0,2),false) )
        Spawn(class'ChildBlueSparks',,,Location,Rotation);
}

defaultproperties
{
     mStartParticles=11
     mMaxParticles=11
     mLifeRange(0)=1.900000
     mLifeRange(1)=1.900000
     Skins(0)=Texture'DEKRPGTexturesMaster207P.fX.TexMineChargerLightningBeam'
}
