class ArtifactMakeLucky extends DruidArtifactMakeMagicWeapon;

function int getCost()
{
	return 50;
}

function bool shouldBreak()
{
	return false;
}

function constructionFinished(RPGWeapon result)
{
	local RW_EnhancedLuck Luck;

	if(RW_EnhancedLuck(result) != None)
	{
		Luck = RW_EnhancedLuck(Instigator.FindInventoryType(class'RW_EnhancedLuck'));
	}
}

function class<RPGWeapon> GetRandomWeaponModifier(class<Weapon> WeaponType, Pawn Other)
{
	if(class'RW_EnhancedLuck'.static.AllowedFor(WeaponType, Other))
		return class'RW_EnhancedLuck';
	return class'RPGWeapon';
}

exec function TossArtifact()
{
	//do nothing. This artifact cant be thrown
}

function DropFrom(vector StartLocation)
{
	if (bActive)
		GotoState('');
	bActive = false;

	Destroy();
	Instigator.NextItem();
}

function Activate()
{
	local Weapon OldWeapon;
	
		if (bActive)
	{
		Instigator.ReceiveLocalizedMessage(MessageClass, 4000, None, None, Class);
		GotoState('');
		ActivatedOldWeapon = None;
		return;
	}

	if (Instigator != None)
	{
		if(Instigator.Controller.Adrenaline < getCost())
		{
			Instigator.ReceiveLocalizedMessage(MessageClass, getCost(), None, None, Class);
			GotoState('');
			bActive = false;
			ActivatedOldWeapon = None;
			return;
		}

		if (Translauncher(Instigator.Weapon) != None)
		{
			Instigator.ReceiveLocalizedMessage(MessageClass, 6000, None, None, Class);
			GotoState('');
			bActive = false;
			ActivatedOldWeapon = None;
			return;
		}

		OldWeapon = Instigator.Weapon;
		ActivatedOldWeapon = OldWeapon;
		if(RPGWeapon(OldWeapon) != None)
			OldWeapon = RPGWeapon(OldWeapon).ModifiedWeapon;
		
		if(OldWeapon != None)
		{

			if
			(
				(
					OldWeapon.default.FireModeClass[0] != None && 
					OldWeapon.default.FireModeClass[0].default.AmmoClass != None && 
					OldWeapon.AmmoClass[0] != None&&
					OldWeapon.AmmoClass[0].default.MaxAmmo > 0 &&
					class'MutUT2004RPG'.static.IsSuperWeaponAmmo(OldWeapon.default.FireModeClass[0].default.AmmoClass)
				) ||
				(
					OldWeapon.default.FireModeClass[1] != None && 
					OldWeapon.default.FireModeClass[1].default.AmmoClass != None && 
					OldWeapon.AmmoClass[1] != None &&
					OldWeapon.AmmoClass[1].default.MaxAmmo > 0 &&
					class'MutUT2004RPG'.static.IsSuperWeaponAmmo(OldWeapon.default.FireModeClass[1].default.AmmoClass)
				)
			)
			{

				Instigator.ReceiveLocalizedMessage(MessageClass, 3000, None, None, Class);
				GotoState('');
				ActivatedOldWeapon = None;
				bActive = false;
				return;
			}
		}
		
		If(OldWeapon != None)
			Super.Activate();
		else
		{
			Instigator.ReceiveLocalizedMessage(MessageClass, 2000, None, None, Class);
			GotoState('');
			ActivatedOldWeapon = None;
			bActive = false;
			return;
		}
	}
	else
	{
		Instigator.ReceiveLocalizedMessage(MessageClass, 7000, None, None, Class);
	}
}

static function string GetLocalString(optional int Switch, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2)
{
	if (Switch == 2000)
		return "Unable to generate magic weapon";
	if (Switch == 3000)
		return "Unable to generate super weapon magic weapons";
	if (Switch == 4000)
		return "Already constructing Lucky";
	if (Switch == 5000)
		return "Your charm has broken";
	if (Switch == 6000)
		return "You cannot convert this weapon";
	if (Switch == 7000)
		return "Crafting your Lucky weapon";
	else
		return Switch@"Adrenaline is required to generate a magic weapon";
}

defaultproperties
{
     CostPerSec=5
     IconMaterial=Shader'DEKRPGTexturesMaster207P.Artifacts.LuckyWeaponMakerIconShader'
     ItemName="Lucky Enchanter"
}
