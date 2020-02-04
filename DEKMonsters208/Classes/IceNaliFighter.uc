//=============================================================================
// DEK Ice. 2x HP, 0.7x Speed, 1.50x Score, 1.5x Mass
//=============================================================================

class IceNaliFighter extends DCNaliFighter config(satoreMonsterPack);

defaultproperties
{
     WeaponClassName(1)="XWeapons.RocketLauncher"
     WeaponClassName(2)="Onslaught.ONSMineLayer"
     WeaponClassName(3)="Onslaught.ONSGrenadeLauncher"
     WeaponClassName(4)="DEKMonsters203a.DEKINIREdeemer"
     WeaponClassName(5)="XWeapons.MiniGun"
     WeaponClassName(6)="UTClassic.ClassicSniperRifle"
     WeaponClassName(7)="XWeapons.BioRifle"
     WeaponClassName(8)="XWeapons.ShieldGun"
     ScoringValue=5
     GibGroupClass=Class'DEKMonsters208.IceGibGroup'
     Health=122.5
     Skins(0)=Shader'DEKMonstersTexturesMaster206E.IceMonsters.IceNaliShader'
     Skins(1)=Shader'DEKMonstersTexturesMaster206E.IceMonsters.IceNaliShader'
     Mass=150.000000
}
