class MissionBalloonBlue extends MissionBalloon;

function TakeDamage(int Damage, Pawn instigatedBy, Vector hitlocation, Vector momentum, class<DamageType> damageType)
{
	local MissionMultiplayerInv MMPI;
	local Actor A;
	local Pawn P;
	
	P = instigatedBy;
	
	if ( damagetype == None )
	{
		if ( InstigatedBy != None )
			warn("No damagetype for damage by "$instigatedby$" with weapon "$InstigatedBy.Weapon);
		DamageType = class'DamageType';
	}

	if ( Role < ROLE_Authority )
		return;

	if ( Health <= 0 )
		return;
		
	if (DamageType == class'DamTypeLightningRod' || DamageType == class'DamTypeEnhLightningRod' || DamageType == class'DamTypeLightningBolt' || DamageType == class'DamTypeLightningSent')
		return;
		
	if (instigatedBy.IsA('Monster'))
		return;
		
	if (P != None && P.IsA('Vehicle'))
		P = Vehicle(P).Driver;
	MMPI = MissionMultiplayerInv(P.FindInventoryType(class'MissionMultiplayerInv'));
	if (P != None && P.Health > 0 && MMPI != None && !MMPI.stopped && MMPI.BalloonPopActive)
	{
		class'MissionMultiplayerInv'.static.UpdateCounts(1);
	}

	A = spawn(class'MissionBalloonBluePopEffect',,, Self.Location + vect(0,0,55));
	if (A != None)
	{
		A.RemoteRole = ROLE_SimulatedProxy;
		A.PlaySound(sound'ONSVehicleSounds-S.VehicleTakeFire.VehicleHitBullet03',,5.5*TransientSoundVolume,,TransientSoundRadius);
	}
	
    gibbedBy(instigatedBy);
}

defaultproperties
{
	Skins(0)=Texture'MissionsTex4.Colors.Cyan'
}
