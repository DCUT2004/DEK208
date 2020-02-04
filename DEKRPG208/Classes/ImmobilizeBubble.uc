class ImmobilizeBubble extends Actor;

function PostBeginPlay()
{
	SetCollision(False,False,False);
	bCollideWorld = true;
	Super.PostBeginPlay();
}

defaultproperties
{
     DrawType=DT_StaticMesh
	 Drawscale=2.00
     StaticMesh=StaticMesh'AW-2004Particles.Weapons.PlasmaSphere'
	 Skins(0)=Shader'ONSBPTextures.fX.RedShieldShader'
     bUnlit=True
	 bCollideWorld=True
	 Physics=PHYS_None
	 bCanBeDamaged=False
	 bHardAttach=True
}
