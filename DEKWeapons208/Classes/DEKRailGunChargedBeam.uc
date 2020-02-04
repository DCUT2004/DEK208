class DEKRailGunChargedBeam extends Emitter;

var vector	arcEnd;
var int		Charge;

replication
{
	reliable if ( Role == ROLE_Authority && bNetInitial )
		arcEnd,Charge;
}

simulated function PostNetBeginPlay()
{
	local xWeaponAttachment Attachment;
	local vector X,Y,Z;
	local BeamEmitter myBeam;
	
    if ( (xPawn(Instigator) != None) && !Instigator.IsFirstPerson() )
    {	
        Attachment = xPawn(Instigator).WeaponAttachment;
        if ( (Attachment != None) && (Level.TimeSeconds - Attachment.LastRenderTime < 0.1) )
        {
			GetAxes(Attachment.Rotation,X,Y,Z);
            SetLocation(Attachment.Location -40*X -10*Z);
			SetRotation(Attachment.Rotation);
        }
    }
	
	myBeam = BeamEmitter(Emitters[0]);
		
	if ( myBeam != None )
	{
		if ( myBeam.BeamEndPoints.Length <= 0 )
			myBeam.BeamEndPoints.Insert(0,1);

		// Set the endpoint of the beam emitter
		myBeam.BeamEndPoints[0].Offset.X.Min = arcEnd.X;
		myBeam.BeamEndPoints[0].Offset.X.Max = arcEnd.X;

		myBeam.BeamEndPoints[0].Offset.Y.Min = arcEnd.Y;
		myBeam.BeamEndPoints[0].Offset.Y.Max = arcEnd.Y;

		myBeam.BeamEndPoints[0].Offset.Z.Min = arcEnd.Z;
		myBeam.BeamEndPoints[0].Offset.Z.Max = arcEnd.Z;

		myBeam.StartSizeRange.X.Min = 2 * fClamp(Charge,1,15);
		myBeam.StartSizeRange.X.Max = 3 * fClamp(Charge,1,15);
	}
}
	

defaultproperties
{
     Begin Object Class=BeamEmitter Name=BeamEmitter8
         BeamDistanceRange=(Min=1024.000000,Max=1024.000000)
         DetermineEndPointBy=PTEP_OffsetAsAbsolute
         LowFrequencyNoiseRange=(X=(Min=-5.000000,Max=5.000000),Y=(Min=-5.000000,Max=5.000000),Z=(Min=-5.000000,Max=5.000000))
         LowFrequencyPoints=15
         HighFrequencyNoiseRange=(X=(Min=-2.000000,Max=2.000000),Y=(Min=-2.000000,Max=2.000000),Z=(Min=-2.000000,Max=2.000000))
         UseColorScale=True
         FadeOut=True
         RespawnDeadParticles=False
         AutomaticInitialSpawning=False
         ColorScale(0)=(Color=(B=255,G=255,R=255))
         ColorScale(1)=(RelativeTime=1.000000,Color=(B=250,G=227,R=22))
         MaxParticles=5
         StartSizeRange=(X=(Min=35.000000,Max=55.000000))
         InitialParticlesPerSecond=50.000000
         Texture=Texture'DEKRPGTexturesMaster207P.fX.TexLightningBeam'
         SecondsBeforeInactive=0.000000
         LifetimeRange=(Min=0.500000,Max=0.500000)
         StartVelocityRange=(X=(Min=1.000000,Max=1.000000))
     End Object
     Emitters(0)=BeamEmitter'DEKWeapons208.DEKRailGunChargedBeam.BeamEmitter8'

     AutoDestroy=True
     bNoDelete=False
     bNetTemporary=True
     RemoteRole=ROLE_DumbProxy
     bDirectional=True
}
