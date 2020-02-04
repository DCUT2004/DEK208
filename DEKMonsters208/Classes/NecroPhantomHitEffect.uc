class NecroPhantomHitEffect extends Emitter;

simulated function PostBeginPlay()
{
	local PlayerController PC;
	local float dist;
		
	PC = Level.GetLocalPlayerController();
	if ( PC.ViewTarget == None )
		dist = 10000;
	else
		dist = VSize(PC.ViewTarget.Location - Location);
	if ( dist > 4000 ) 
	{
		LightType = LT_None;
		bDynamicLight = false;
		if ( dist > 7000 )
			Emitters[1].Disabled = true;
	}
	else if ( Level.bDropDetail )
		LightRadius = 7;	
}

defaultproperties
{
     Begin Object Class=SpriteEmitter Name=SpriteEmitter1
         RespawnDeadParticles=False
         SpinParticles=True
         UniformSize=True
         AutomaticInitialSpawning=False
         BlendBetweenSubdivisions=True
         MaxParticles=3
         StartLocationShape=PTLS_Sphere
         SphereRadiusRange=(Max=24.000000)
         StartSpinRange=(X=(Max=1.000000))
         StartSizeRange=(X=(Min=60.000000,Max=80.000000),Y=(Min=60.000000,Max=80.000000),Z=(Min=60.000000,Max=80.000000))
         InitialParticlesPerSecond=10.000000
         Texture=Texture'ExplosionTex.Framed.exp2_framesP'
         TextureUSubdivisions=4
         TextureVSubdivisions=4
         SecondsBeforeInactive=0.000000
         LifetimeRange=(Min=0.400000,Max=0.600000)
     End Object
     Emitters(0)=SpriteEmitter'DEKMonsters208.NecroPhantomHitEffect.SpriteEmitter1'

     AutoDestroy=True
     LightType=LT_FadeOut
     LightEffect=LE_QuadraticNonIncidence
     LightHue=28
     LightSaturation=90
     LightBrightness=255.000000
     LightRadius=9.000000
     LightPeriod=32
     LightCone=128
     bNoDelete=False
     bDynamicLight=True
}
