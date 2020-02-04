class UpgradeGrenadeProjectile extends ONSGrenadeProjectile;

simulated function Explode(vector HitLocation, vector HitNormal)
{
	local vector start;
    local rotator rot;
    local int i;
    local UpgradeFlakChunk NewChunk;

	start = Location + 10 * HitNormal;
	if ( Role == ROLE_Authority )
	{
		for (i=0; i<3; i++)
		{
			rot = Rotation;
			rot.yaw += FRand()*32000-16000;
			rot.pitch += FRand()*32000-16000;
			rot.roll += FRand()*32000-16000;
			NewChunk = Spawn( class 'UpgradeFlakChunk',, '', Start, rot);
		}
	}
	
    LastTouched = Base;
    BlowUp(HitLocation);
    Destroy();
}

defaultproperties
{
}
