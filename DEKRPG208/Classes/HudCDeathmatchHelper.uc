class HudCDeathmatchHelper extends HudCDeathmatch;

////////////////////////////////////////////////////////////////////////////////

static function SpriteWidget GetBarBorder(int iIndex) {
	return default.BarBorder[iIndex];
}

////////////////////////////////////////////////////////////////////////////////

static function float GetBarBorderScaledPosition(int iIndex) {
	return default.BarBorderScaledPosition[iIndex];
}

////////////////////////////////////////////////////////////////////////////////

static function color GetHudTeamColor(
	Pawn HudOwner
) {
	if (
		(HudOwner == None) ||
		(HudOwner.PlayerReplicationInfo == None) ||
		(HudOwner.PlayerReplicationInfo.Team == None)
	)	{
		if (HudOwner.Controller == None) {
			return class'HudBase'.default.BlueColor;
		}

		return HudCDeathMatch(PlayerController(HudOwner.Controller).myHUD).HudColorBlue;
	} else {
		if (HudOwner.PlayerReplicationInfo.Team.TeamIndex == 1) {
			return class'HudCDeathMatch'.default.HudColorBlue;
		} else {
			return class'HudCDeathMatch'.default.HudColorRed;
		}
	}
}

////////////////////////////////////////////////////////////////////////////////

static function color ShiftHue(
	color c,
	float fShift
) {
	local float fR;
	local float fG;
	local float fB;
	local float fMin;
	local float fMax;
	local float fDeltaMax;
	local float fH;
	local float fL;
	local float fS;
	local float fDeltaR;
	local float fDeltaG;
	local float fDeltaB;
	local float fTemp1;
	local float fTemp2;

	local color newColor;

	fR = (c.R / 255);
	fG = (c.G / 255);
	fB = (c.B / 255);

	fMin = min(fR, min(fG, fB));
	fMax = max(fR, max(fG, fB));

	fDeltaMax = fMax - fMin;

	fL = (fMax + fMin) / 2;

	if (fDeltaMax == 0) {
		fH = 0;
		fS = 0;
	} else {
		if (fL < 0.5) {
			fS = fDeltaMax / (fMax + fMin);
		} else {
			fS = fDeltaMax / (2 - fMax - fMin);
		}

		fDeltaR = (((fMax - fR) / 6) + (fDeltaMax / 2)) / fDeltaMax;
		fDeltaG = (((fMax - fG) / 6) + (fDeltaMax / 2)) / fDeltaMax;
		fDeltaB = (((fMax - fB) / 6) + (fDeltaMax / 2)) / fDeltaMax;

		if (fR == fMax) {
			fH = fDeltaB - fDeltaG;
		} else if (fG == fMax) {
			fH = (1 / 3) + fDeltaR - fDeltaB;
		} else if (fB == fMax) {
			fH = (2 / 3) + fDeltaG - fDeltaR;
		}

		fH += fShift;

		if (fH < 0) {
			fH += 1;
		} else if (fH > 1) {
			fH -= 1;
		}
	}

	if (fS == 0) {
	   fR = fL * 255;
	   fG = fL * 255;
	   fB = fL * 255;
	} else {
		if (fL < 0.5) {
			fTemp2 = fL * (1 + fS);
		} else {
			fTemp2 = (fL + fS) - (fS * fL);
		}

		fTemp1 = 2 * fL - fTemp2;

		fR = 255 * ShiftUtility(fTemp1, fTemp2, fH + (1.0 / 3.0));
		fG = 255 * ShiftUtility(fTemp1, fTemp2, fH);
		fB = 255 * ShiftUtility(fTemp1, fTemp2, fH - (1.0 / 3.0));
	}

	newColor.R = (fR * 255);
	newColor.G = (fG * 255);
	newColor.B = (fB * 255);
	newColor.A = 255;

	return newColor;
}

////////////////////////////////////////////////////////////////////////////////

static function float ShiftUtility(
	float fTemp1,
	float fTemp2,
	float fH
) {
	if (fH < 0) {
		fH += 1;
	} else if (fH > 1) {
		fH -= 1;
	}

	if ((6 * fH) < 1) {
		return (fTemp1 + (fTemp2 - fTemp1) * 6 * fH);
	}

	if ((2 * fH) < 1) {
		return (fTemp2);
	}

	if ((3 * fH) < 2) {
		return (fTemp1 + (fTemp2 - fTemp1) * ((2 / 3) - fH) * 6);
	}

	return (fTemp1);
}

////////////////////////////////////////////////////////////////////////////////

defaultproperties
{
}
