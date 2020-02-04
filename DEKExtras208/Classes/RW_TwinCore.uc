class RW_TwinCore extends OneDropRPGWeapon
	HideDropDown
	CacheExempt
	config(UT2004RPG);

var config float DamageBonus;

static function bool AllowedFor(class<Weapon> Weapon, Pawn Other)
{	
	if ( Weapon.default.FireModeClass[0] != None && Weapon.default.FireModeClass[0].default.AmmoClass != None
	          && class'MutUT2004RPG'.static.IsSuperWeaponAmmo(Weapon.default.FireModeClass[0].default.AmmoClass) )
		return false;
	
	if ( ClassIsChildOf(Weapon, class'TransLauncher') )
        return false;

	return true;
}	

function AdjustTargetDamage(out int Damage, Actor Victim, Vector HitLocation, out Vector Momentum, class<DamageType> DamageType)
{
	Local Pawn P;
	Local Actor A;
	local int TempModifier;
	local float TempDamageBonus;
	local bool bSkaarjHit;

	if (!bIdentified)
		Identify();

	if (!class'OneDropRPGWeapon'.static.CheckCorrectDamage(ModifiedWeapon, DamageType))
		return;
		
	TempModifier = Modifier+1;      //Add +1 here because we want to handle 0 modifier
	TempDamageBonus = DamageBonus;
	bSkaarjHit = false;

	if(damage > 0)
	{
   		P = Pawn(Victim);
		if (P != None)
		{	
		//If we hit a Fire or Ice Monster, then we need to adjust some things
		//Use IsA instead of ClassIsChildOf
		if (ClassIsChildOf(Victim.Class, class'FireBrute') || ClassIsChildOf(Victim.Class,class'FireGasbag') || ClassIsChildOf(Victim.Class,class'FireGiantGasbag') || ClassIsChildOf(Victim.Class,class'FireKrall') || ClassIsChildOf(Victim.Class,class'FireMercenary') || ClassIsChildOf(Victim.Class,Class'FireQueen') || ClassIsChildOf(Victim.Class,Class'FireSkaarjSuperHeat') || ClassIsChildOf(Victim.Class,Class'FireSkaarjTrooper') || ClassIsChildOf(Victim.Class,Class'LavaBioSkaarj') || ClassIsChildOf(Victim.Class,Class'FireSkaarjSniper') || ClassIsChildOf(Victim.Class,Class'FireSlith') || ClassIsChildOf(Victim.Class,Class'FireTitan') || ClassIsChildOf(Victim.Class,Class'FireSlug') || ClassIsChildOf(Victim.Class,Class'FireManta') || ClassIsChildOf(Victim.Class,Class'FireRazorFly') || ClassIsChildOf(Victim.Class,Class'FireSkaarjPupae') || ClassIsChildOf(Victim.Class,Class'FireNali') || ClassIsChildOf(Victim.Class,Class'FireNaliFighter') || ClassIsChildOf(Victim.Class,Class'FireLord') || Victim.IsA('FireBrute') || Victim.IsA('FireGasbag') || Victim.IsA('FireGiantGasbag') || Victim.IsA('FireKrall') || Victim.IsA('FireMercenary') || Victim.IsA('FireQueen') || Victim.IsA('FireSkaarjSuperHeat') || Victim.IsA('FireSkaarjSniper') || Victim.IsA('FireSlith') || Victim.IsA('FireTitan') || Victim.IsA('FireLord') || ClassIsChildOf(Victim.Class, class'IceBrute') || ClassIsChildOf(Victim.Class,class'IceGasbag') || ClassIsChildOf(Victim.Class,class'IceGiantGasbag') || ClassIsChildOf(Victim.Class,class'IceKrall') || ClassIsChildOf(Victim.Class,class'IceMercenary') || ClassIsChildOf(Victim.Class,Class'IceQueen') || ClassIsChildOf(Victim.Class,Class'IceSkaarjFreezing') || ClassIsChildOf(Victim.Class,Class'IceSkaarjTrooper') || ClassIsChildOf(Victim.Class,Class'ArcticBioSkaarj') || ClassIsChildOf(Victim.Class,Class'IceSkaarjSniper') || ClassIsChildOf(Victim.Class,Class'IceSlith') || ClassIsChildOf(Victim.Class,Class'IceTitan') || ClassIsChildOf(Victim.Class,Class'IceSlug') || ClassIsChildOf(Victim.Class,Class'IceManta') || ClassIsChildOf(Victim.Class,Class'IceRazorFly') || ClassIsChildOf(Victim.Class,Class'IceSkaarjPupae') || ClassIsChildOf(Victim.Class,Class'IceNali') || ClassIsChildOf(Victim.Class,Class'IceNaliFighter') || ClassIsChildOf(Victim.Class,Class'IceWarlord') || Victim.IsA('IceBrute') || Victim.IsA('IceGasbag') || Victim.IsA('IceGiantGasbag') || Victim.IsA('IceKrall') || Victim.IsA('IceMercenary') || Victim.IsA('IceQueen') || Victim.IsA('IceSkaarjFreezing') || Victim.IsA('IceSkaarjSniper') || Victim.IsA('IceSlith') || Victim.IsA('IceTitan') || Victim.IsA('IceWarlord'))
			{
				//Twin core weapons do more damage to Fire and Ice Monsters
				TempDamageBonus *= 10;
				//Because we don't want Twin Core to be able to be tripled, we note here whether we hit a Fire or Ice Monster
				bSkaarjHit=true;
				A = P.spawn(class'ONSPlasmaHitPurple', P,, P.Location, P.Rotation);
				if (A != None)
				{
					A.RemoteRole = ROLE_SimulatedProxy;
				}	
			}
		//To reduce the effectiveness of Double Magic Modifier somewhat, we only give half the benefit for modifier levels beyond normal.
		if (Modifier > MaxModifier)
			TempModifier = MaxModifier + Min(1,(Modifier - MaxModifier)/2);
			
		Damage = Max(1, Damage * (1.0 + TempDamageBonus * TempModifier));
		Momentum *= 1.0 + TempDamageBonus * Modifier;
		
		//If we hit a Fire or Ice Monster and we have double damage or triple damage going, reduce the total damage. We do this here because we want to reduce the total modified damage, not just the base damage.
		if (bSkaarjHit && Pawn(Owner).HasUDamage())
			Damage /= 2;
		}
	}	
	Super(RPGWeapon).AdjustTargetDamage(Damage, Victim, HitLocation, Momentum, DamageType);	
}

defaultproperties
{
     DamageBonus=0.010000
     ModifierOverlay=FinalBlend'XEffectMat.Shock.ShockCoilFB'
     MinModifier=1
     MaxModifier=5
     AIRatingBonus=0.025000
     PrefixPos="Twin Core "
}
