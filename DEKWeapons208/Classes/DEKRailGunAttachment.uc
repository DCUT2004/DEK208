class DEKRailGunAttachment extends SniperAttachment;

simulated event ThirdPersonEffects()
{
    if ( Level.NetMode != NM_DedicatedServer )
    {
        if (charge == None)
        {
            charge = Spawn(class'LightningCharge3rd');
            AttachToBone(charge, 'Bone_Flash');
        }
        WeaponLight();
    }

    Super.ThirdPersonEffects();
}

defaultproperties
{
}
