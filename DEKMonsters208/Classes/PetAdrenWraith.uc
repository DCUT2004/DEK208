class PetAdrenWraith extends NecroAdrenWraith;

function PostBeginPlay()
{
	Super(NecroAdrenWraith).PostBeginPlay();
	Instigator = self;
	SummonedMonster = True;
}

function SuckAdrenaline(float SuckDamage, vector pushdir)
{
	local Pawn P;
	local NecroEnergyParticle FX;
	local float Damage;
	local DEKFriendlyMonsterController FMC;

	Damage = (SuckDamage + Rand(SuckDamageMax - SuckDamage));
	
	P = Controller.Enemy;
	
	if (P != None && P.Health<=0 && P.Controller.Adrenaline <=0)
		return;

	if (P != None)
		P.Controller.Adrenaline -= Damage;
		
	FMC = DEKFriendlyMonsterController(Self.Controller);
	Master = FMC.Master;
	if (FMC != None && FMC.Master != None)
	{
		if (Master.Adrenaline < Master.AdrenalineMax)
		{
			Master.Adrenaline += Damage;
		}
		Self.Controller.Adrenaline += Damage;	//Give to wraith too.
		if (Self.Controller.Adrenaline >= BlackHoleAdren)
		{
			Self.Spawn(class'NecroAdrenWraithBlackHole',self,,Instigator.Location);
			GotoState('Teleporting');
			Self.Controller.Adrenaline = 0;
		}
	}
	else
	{
		Instigator.Controller.Adrenaline += Damage;
		if (Instigator.Controller.Adrenaline >= BlackHoleAdren)
		{
			Instigator.Spawn(class'NecroAdrenWraithBlackHole',self,,Instigator.Location);
			GotoState('Teleporting'); //don't stay in your own black hole, dummy.. hopefully you don't teleport to a player in the black hole.
			Instigator.Controller.Adrenaline = 0;
		}
	}
	FX = Spawn(class'NecroEnergyParticle',,,P.Location,Rotation);
	FX.Seeking = self;
}

defaultproperties
{
}
