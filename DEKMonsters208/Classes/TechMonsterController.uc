class TechMonsterController extends MonsterController;

// this type of monster targets blocks.
// if attacked by something else it will defend itself, unless a block is closer
// and it gets back health from eating blocks

function bool FindNewEnemy()
{
	local Pawn BestEnemy;
	local bool bSeeNew, bSeeBest;
	local int BestWeight, NewWeight;
	local float BestDist, NewDist;
	local Pawn P;
	local Controller C;
	local int LoopCount;
	local PhantomDeathGhostInv Inv;

	if ( Level.Game.bGameEnded )
		return false;

	LoopCount = 0;
	for ( C=Level.ControllerList; C != None && LoopCount < 1000; C = C.NextController )
	{
		LoopCount++;
		if ( C != None && C.bIsPlayer && C.Pawn != None)
		{
			if ( Enemy != None && Enemy.Health > 0 && VSize(Enemy.Location - Pawn.Location) < 2000)
				return false;

			// look for a block if possible
			// if not, go for a vehicle
			// otherwise it will just have to be a pawn
			BestEnemy = None;
			foreach DynamicActors(class'Pawn', P)
			{
				// look for enemy pawns
				if (P != Pawn && P.Health > 0 && (P.GetTeamNum() != Pawn.GetTeamNum() || (TeamGame(Level.Game) == None) ) && !P.IsA('GenomeProjectNode') && !P.IsA('RingBlue') && !P.IsA('RingRed') && !P.IsA('RingGold') && !P.IsA('MissionBalloon') && !ClassIsChildOf(P.Class, class'MissionBalloon') && PhantomDeathGhostInv(P.FindInventoryType(class'PhantomDeathGhostInv')) == None)
				{
					// might not target enemy monsters. But eventually they will target us, so SetEnemy might get them
					if ( BestEnemy == None )
					{
						// anything is better than nothing
						BestEnemy = P;
						BestDist = VSize(BestEnemy.Location - Pawn.Location);
						bSeeBest = CanSee(BestEnemy);
						if (DruidBlock(P) != None && !P.IsA('GenomeProjectNode') && !P.IsA('RingBlue') && !P.IsA('RingRed') && !P.IsA('RingGold'))
							BestWeight = 2; // best target
						else if (vehicle(P) != None)
							BestWeight = 1; // second best 
						else
							BestWeight = 0; // worst
					}
					else
					{
						NewDist = VSize(P.Location - Pawn.Location);
						bSeeNew = CanSee(P);
						if (DruidBlock(P) != None && !P.IsA('GenomeProjectNode') && !P.IsA('RingBlue') && !P.IsA('RingRed') && !P.IsA('RingGold'))
							NewWeight = 2; // best target
						else if (vehicle(P) != None)
							NewWeight = 1; // second best
						else
							NewWeight = 0; // worst
						if (!bSeeBest)
						{
							// can't see best one
							if ( bSeeNew )
							{
								// can see new one. So go for it unless it is too far away
								if (NewDist < (BestDist * 3))
								{
									BestEnemy = P;
									BestDist = NewDist;
									bSeeBest = bSeeNew;
									BestWeight = NewWeight;
								}
							}
							else
							{
								// can't see either. Go for new if as good a target and closer, or better target not much further away
								if (((NewDist < BestDist) && (NewWeight >= BestWeight)) || (NewWeight > BestWeight) && (NewDist < (BestDist*2)))
								{
									BestEnemy = P;
									BestDist = NewDist;
									bSeeBest = bSeeNew;
									BestWeight = NewWeight;
								}
							}
						}
						else
						{
							// can see best one
							if ( bSeeNew )
							{
								// and new
								if (((NewDist < BestDist) && (NewWeight >= BestWeight)) || (NewWeight > BestWeight) && (NewDist < (BestDist*2)))
								{
									BestEnemy = P;
									BestDist = NewDist;
									bSeeBest = bSeeNew;
									BestWeight = NewWeight;
								}
							}
							else
							{
								// can see best but not new. Only go for new if better and much closer
								if (NewDist < (BestDist * 4) && (NewWeight > BestWeight))
								{
									BestEnemy = P;
									BestDist = NewDist;
									bSeeBest = bSeeNew;
									BestWeight = NewWeight;
								}
							}
						}
					}
				}
			}
		}
	}
	if ( LoopCount >= 1000)
	{
		Log("TechMonsterController in FindNewEnemy looping more than 1000 times. Terminating search.");
		return false;
	}
	if ( BestEnemy == Enemy )
		return false;
	if ( BestEnemy != None )
	{
		Inv = PhantomDeathGhostInv(BestEnemy.FindInventoryType(class'PhantomDeathGhostInv'));
		if (Inv != None)
			return false;
		else
		{
			ChangeEnemy(BestEnemy,CanSee(BestEnemy));
			return true;
		}
	}
	else
		return false;
}

// subclass the next one just to get rid of a controller none error
function FightEnemy(bool bCanCharge)
{
	local vector X,Y,Z;
	local float enemyDist;
	local float AdjustedCombatStyle, Aggression;
	local bool bFarAway, bOldForcedCharge;
	local NavigationPoint N;

	if ( (Enemy == None) || (Pawn == None) )
		log("HERE 3 Enemy "$Enemy$" pawn "$Pawn);
	
	if (Enemy != None)
	{
		if (PhantomDeathGhostInv(Enemy.FindInventoryType(class'PhantomDeathGhostInv')) != None)
		{
			WanderOrCamp(true);
			return;
		}
	}

	if ( (Enemy == FailedHuntEnemy) && (Level.TimeSeconds == FailedHuntTime) )
	{
		if ( Enemy == None )
			FindNewEnemy();

		if ( Enemy != None && Enemy == FailedHuntEnemy )
		{
			GoalString = "FAILED HUNT - HANG OUT";
			if ( EnemyVisible() )
				bCanCharge = false;
			else if ( (LastRespawnTime != Level.TimeSeconds) && ((LastSeenTime == 0) || (Level.TimeSeconds - LastSeenTime) > 15) && !Pawn.PlayerCanSeeMe() )
			{
				LastRespawnTime = Level.TimeSeconds;
				EnemyVisibilityTime = 0;
				N = Level.Game.FindPlayerStart(self,1);
				Pawn.SetLocation(N.Location+(Pawn.CollisionHeight - N.CollisionHeight) * vect(0,0,1));
			}
			if ( !EnemyVisible() )
			{
				WanderOrCamp(true);
				return;
			}
		}
	}

	bOldForcedCharge = bMustCharge;
	bMustCharge = false;
	enemyDist = VSize(Pawn.Location - Enemy.Location);
	AdjustedCombatStyle = CombatStyle;
	Aggression = 1.5 * FRand() - 0.8 + 2 * AdjustedCombatStyle
				+ FRand() * (Normal(Enemy.Velocity - Pawn.Velocity) Dot Normal(Enemy.Location - Pawn.Location));
	if ( Enemy.Weapon != None )
		Aggression += 2 * Enemy.Weapon.SuggestDefenseStyle();
	if ( enemyDist > MAXSTAKEOUTDIST )
		Aggression += 0.5;
	if ( (Pawn.Physics == PHYS_Walking) || (Pawn.Physics == PHYS_Falling) )
	{
		if (Pawn.Location.Z > Enemy.Location.Z + TACTICALHEIGHTADVANTAGE)
			Aggression = FMax(0.0, Aggression - 1.0 + AdjustedCombatStyle);
		else if ( (Skill < 4) && (enemyDist > 0.65 * MAXSTAKEOUTDIST) )
		{
			bFarAway = true;
			Aggression += 0.5;
		}
		else if (Pawn.Location.Z < Enemy.Location.Z - Pawn.CollisionHeight) // below enemy
			Aggression += CombatStyle;
	}

	if ( !EnemyVisible() )
	{
		GoalString = "Enemy not visible";
		if ( !bCanCharge )
		{
			GoalString = "Stake Out";
			DoStakeOut();
		}
		else
		{
			GoalString = "Hunt";
			GotoState('Hunting');
		}
		return;
	}

	// see enemy - decide whether to charge it or strafe around/stand and fire
	Target = Enemy;
	if( Monster(Pawn).PreferMelee() || (bCanCharge && bOldForcedCharge) )
	{
		GoalString = "Charge";
		DoCharge();
		return;
	}

	if ( bCanCharge && (Skill < 5) && bFarAway && (Aggression > 1) && (FRand() < 0.5) )
	{
		GoalString = "Charge closer";
		DoCharge();
		return;
	}

	if ( !Monster(Pawn).PreferMelee() && (FRand() > 0.17 * (skill - 1)) && !DefendMelee(enemyDist) )
	{
		GoalString = "Ranged Attack";
		DoRangedAttackOn(Enemy);
		return;
	}

	if ( bCanCharge )
	{
		if ( Aggression > 1 )
		{
			GoalString = "Charge 2";
			DoCharge();
			return;
		}
	}

	if ( !Pawn.bCanStrafe )
	{
		GoalString = "Ranged Attack";
		DoRangedAttackOn(Enemy);
		return;
	}

	GoalString = "Do tactical move";
	if ( !Monster(Pawn).RecommendSplashDamage() && Monster(Pawn).bCanDodge && (FRand() < 0.7) && (FRand()*Skill > 3) )
	{
		GetAxes(Pawn.Rotation,X,Y,Z);
		GoalString = "Try to Duck ";
		if ( FRand() < 0.5 )
		{
			Y *= -1;
			TryToDuck(Y, true);
		}
		else
			TryToDuck(Y, false);
	}
	DoTacticalMove();
}

function bool SetEnemy( Pawn NewEnemy, optional bool bHateMonster )
{
	local float EnemyDist, NewDist;
	local Controller C;
	local int LoopCount;
	local PhantomDeathGhostInv Inv;
	
	LoopCount = 0;
	for ( C=Level.ControllerList; C != None && LoopCount < 1000; C = C.NextController )
	{
		LoopCount++;
		if ( C.bIsPlayer && (C.Pawn != None) )
		{
			if ( (NewEnemy == None) || (NewEnemy.Health <= 0) || (NewEnemy.Controller == None) || (NewEnemy == Enemy) )
				return false;
		
			if (NewEnemy.GetTeamNum() == Pawn.GetTeamNum() && (TeamGame(Level.Game) != None) && VampireGnat(NewEnemy) == None)
				return false;       // same team. But watch out for VampireGnats as they attack anything

			// so, NewEnemy is a valid target
			if ( Enemy == None || Enemy.Health <= 0)
			{
				ChangeEnemy(NewEnemy,CanSee(NewEnemy));
				return true;
			}

			if ( !LineOfSightTo(NewEnemy) )
				return false;		// cannot attack it so what's the point

			if ( !EnemyVisible() )
			{	// lost track of the enemy we were following, and know we can get to NewEnemy
				ChangeEnemy(NewEnemy,CanSee(NewEnemy));
				return true;
			}

			EnemyDist = VSize(Enemy.Location - Pawn.Location);
			if ( EnemyDist < Pawn.MeleeRange )
				return false;	// currently in a melee, so do not break out

			// so can access both, which do we hit
			NewDist = VSize(NewEnemy.Location - Pawn.Location);
			if ( DruidBlock(Enemy) == None && FRand() < 0.9)
				return false;       // stop with the block
	    
			// ok, time to get distracted
			if (vehicle(Enemy) == None && vehicle(NewEnemy) != None && NewDist < (EnemyDist * 1.2))
			{
				ChangeEnemy(NewEnemy,CanSee(NewEnemy));
					return true;
			}

			if (NewDist < EnemyDist && FRand() < 0.9)
			{
				ChangeEnemy(NewEnemy,CanSee(NewEnemy));
					return true;
			}
		}
	}
	
	if ( LoopCount >= 1000)
	{
		Log("TechMonsterController in SetEnemy looping more than 1000 times. Terminating search.");
		return false;
	}
	if (NewEnemy != None)
	{
		Inv = PhantomDeathGhostInv(NewEnemy.FindInventoryType(class'PhantomDeathGhostInv'));
		if (Inv != None)
			return false;
	}
	return false;
}

//function bool EnemyVisible()
//{
//	local PhantomDeathGhostInv Inv;
//	
//	if (Enemy != None)
//	{
//		Inv = PhantomDeathGhostInv(Enemy.FindInventoryType(class'PhantomDeathGhostInv'));
//		if (Inv != None)
//		{
//			bEnemyIsVisible = False;
//			return false;
//		}
//		else
//		{
//			if ( (EnemyVisibilityTime == Level.TimeSeconds) && (VisibleEnemy == Enemy) )
//				return bEnemyIsVisible;
//			VisibleEnemy = Enemy;
//			EnemyVisibilityTime = Level.TimeSeconds;
//			bEnemyIsVisible = LineOfSightTo(Enemy);
//			return bEnemyIsVisible;		
//		}
//	}
//	else
//	{
//		return false;
//		bEnemyIsVisible = False;
//	}
//}


defaultproperties
{
}
