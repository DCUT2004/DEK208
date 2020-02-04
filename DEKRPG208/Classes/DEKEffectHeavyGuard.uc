//=============================================================================
// FX_SpaceFighter_Shield
//=============================================================================
// Created by Laurent Delayen
// © 2003, Epic Games, Inc.  All Rights Reserved
//=============================================================================

class DEKEffectHeavyGuard extends Actor;


simulated function Tick(float deltaTime)
{
	local float pct;

	if ( Level.NetMode == NM_DedicatedServer )
	{
		Disable('Tick');
		return;
	}

	pct = LifeSpan / default.LifeSpan;
	SetDrawScale( 6 + 7*(1-pct) );
}

defaultproperties
{
     DrawType=DT_StaticMesh
     StaticMesh=StaticMesh'WeaponStaticMesh.Shield'
     bNetTemporary=True
     bReplicateInstigator=True
     bNetInitialRotation=True
     RemoteRole=ROLE_SimulatedProxy
     LifeSpan=0.250000
     DrawScale=0.500000
     Skins(0)=FinalBlend'D-E-K-HoloGramFX.NonWireframe.FunkyStuff_3'
     Skins(1)=FinalBlend'D-E-K-HoloGramFX.NonWireframe.FunkyStuff_3'
     AmbientGlow=200
     bUnlit=True
     bOwnerNoSee=True
     bHardAttach=True
}
