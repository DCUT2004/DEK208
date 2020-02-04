//Credit goes to WailofSuicide for the code; Jefe for the idea against Ghost Monsters. This modifier increases damage towards ghost monsters.

class RW_SuperPlasma extends OneDropRPGWeapon
   HideDropDown
   CacheExempt
   config(UT2004RPG);

var config float DamageBonus;

static function bool AllowedFor(class<Weapon> Weapon, Pawn Other)
{
   if ( ClassIsChildOf(Weapon, class'TransLauncher') )
      return false;

   return true;
}

simulated function SetWeaponInfo()
{
   //DamageBonus = SetWeaponDamageBonus(default.DamageBonus);
   
   Super.SetWeaponInfo();
}

function AdjustTargetDamage(out int Damage, Actor Victim, Vector HitLocation, out Vector Momentum, class<DamageType> DamageType)
{
   local int TempModifier;
   local float TempDamageBonus;
   local bool bSkaarjHit;

   if (!bIdentified)
      Identify();

   if (Victim == None)
      return; //nothing to do


   //Prevents "weaponswitch" exploit allowing a player to use a weapon (e.g. Mines) and then switch to another weapon (e.g. Vorpal) and get the effect applied to the first weapon
   if (!CheckCorrectDamage(ModifiedWeapon, DamageType))
      return;


   TempModifier = Modifier+1;      //Add +1 here because we want to handle 0 modifier
   TempDamageBonus = DamageBonus;
   bSkaarjHit = false;

   if (Damage > 0)
   {
      //If we hit a Skaarj, then we need to adjust some things
      //Use IsA instead of ClassIsChildOf
      if ( ClassIsChildOf(Victim.Class, class'DEKGhostBehemoth') || ClassIsChildOf(Victim.Class,class'DEKGhostGasbag') || ClassIsChildOf(Victim.Class,class'DEKGhostGiantGasbag') || ClassIsChildOf(Victim.Class,class'DEKGhostKrall') || ClassIsChildOf(Victim.Class,class'DEKGhostMercenary') || ClassIsChildOf(Victim.Class,Class'DEKGhostQueen') || ClassIsChildOf(Victim.Class,Class'DEKGhostSkaarj') || ClassIsChildOf(Victim.Class,Class'DEKGhostSkaarjSniper') || ClassIsChildOf(Victim.Class,Class'DEKGhostSlith') || ClassIsChildOf(Victim.Class,Class'DEKGhostTitan') || ClassIsChildOf(Victim.Class,Class'DEKGhostWarlord')
         || Victim.IsA('DEKGhostBehemoth') || Victim.IsA('DEKGhostGasbag') || Victim.IsA('DEKGhostGiantGasbag') || Victim.IsA('DEKGhostKrall') || Victim.IsA('DEKGhostMercenary') || Victim.IsA('DEKGhostQueen') || Victim.IsA('DEKGhostSkaarj') || Victim.IsA('DEKGhostSkaarjSniper') || Victim.IsA('DEKGhostSlith') || Victim.IsA('DEKGhostTitan') || Victim.IsA('DEKGhostWarlord') || Victim.IsA('DEKGhostSkaarjPupae') )
      {
         //Skaarjbane weapons do a lot of damage to Skaarj
         TempDamageBonus *= 16;
         //Because we don't want Skaarjbane to be able to be tripled, we note here whether we hit a Skaarj
         bSkaarjHit=true;
      }

      //To reduce the effectiveness of Double Magic Modifier somewhat, we only give half the benefit for modifier levels beyond normal.
      if (Modifier > MaxModifier)
         TempModifier = MaxModifier + Min(1,(Modifier - MaxModifier)/2);


      Damage = Max(1, Damage * (1.0 + TempDamageBonus * TempModifier));
      Momentum *= 1.0 + TempDamageBonus * Modifier;

      //If we hit a Skaarj and we have double damage or triple damage going, reduce the total damage. We do this here because we want to reduce the total modified damage, not just the base damage.
      if (bSkaarjHit && Pawn(Owner).HasUDamage())
         Damage /= 2;
   }

  //Skip over DWRPGWeapon.AdjustTargetDamage, we already did everything it does.
  Super(RPGWeapon).AdjustTargetDamage(Damage, Victim, HitLocation, Momentum, DamageType);
}

defaultproperties
{
     DamageBonus=0.100000
     ModifierOverlay=FinalBlend'DEKWeaponsMaster206.fX.SuperPlasmaFB'
     MinModifier=1
     MaxModifier=4
     AIRatingBonus=0.102000
     PrefixPos="Ectoplasmic "
     bCanHaveZeroModifier=True
}
