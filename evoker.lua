ConRO.Evoker = {};
ConRO.Evoker.CheckTalents = function()
end
ConRO.Evoker.CheckPvPTalents = function()
end
local ConRO_Evoker, ids = ...;

function ConRO:EnableRotationModule(mode)
	mode = mode or 0;
	self.ModuleOnEnable = ConRO.Evoker.CheckTalents;
	self.ModuleOnEnable = ConRO.Evoker.CheckPvPTalents;
	if mode == 0 then
		self.Description = "Evoker [No Specialization Under 60]";
		self.NextSpell = ConRO.Evoker.Under60;
		self.ToggleHealer();
	end;
	if mode == 1 then
		self.Description = "Evoker [Devastation - Caster]";
		if ConRO.db.profile._Spec_1_Enabled then
			self.NextSpell = ConRO.Evoker.Devastation;
			self.ToggleDamage();
			ConROWindow:SetAlpha(ConRO.db.profile.transparencyWindow);
			ConRONextWindow:SetAlpha(ConRO.db.profile.transparencyWindow);
			ConRODefenseWindow:SetAlpha(ConRO.db.profile.transparencyWindow);
		else
			self.NextSpell = ConRO.Evoker.Disabled;
			self.ToggleHealer();
			ConROWindow:SetAlpha(0);
			ConRONextWindow:SetAlpha(0);
			ConRODefenseWindow:SetAlpha(0);
		end
	end;
	if mode == 2 then
		self.Description = "Evoker [Preservation - Healer]";
		if ConRO.db.profile._Spec_2_Enabled then
			self.NextSpell = ConRO.Evoker.Preservation;
			self.ToggleHealer();
			ConROWindow:SetAlpha(ConRO.db.profile.transparencyWindow);
			ConRONextWindow:SetAlpha(ConRO.db.profile.transparencyWindow);
			ConRODefenseWindow:SetAlpha(ConRO.db.profile.transparencyWindow);
		else
			self.NextSpell = ConRO.Evoker.Disabled;
			self.ToggleHealer();
			ConROWindow:SetAlpha(0);
			ConRONextWindow:SetAlpha(0);
			ConRODefenseWindow:SetAlpha(0);
		end
	end;
	if mode == 3 then
		self.Description = "Evoker [Augmentation - Booster]";
		if ConRO.db.profile._Spec_3_Enabled then
			self.NextSpell = ConRO.Evoker.Augmentation;
			self.ToggleDamage();
			ConROWindow:SetAlpha(ConRO.db.profile.transparencyWindow);
			ConRONextWindow:SetAlpha(ConRO.db.profile.transparencyWindow);
			ConRODefenseWindow:SetAlpha(ConRO.db.profile.transparencyWindow);
		else
			self.NextSpell = ConRO.Evoker.Disabled;
			self.ToggleHealer();
			ConROWindow:SetAlpha(0);
			ConRONextWindow:SetAlpha(0);
			ConRODefenseWindow:SetAlpha(0);
		end
	end;
	self:RegisterEvent('UNIT_SPELLCAST_SUCCEEDED');
	self.lastSpellId = 0;
end

function ConRO:EnableDefenseModule(mode)
	mode = mode or 0;
	if mode == 0 then
		self.NextDef = ConRO.Evoker.Under60Def;
	end;
	if mode == 1 then
		if ConRO.db.profile._Spec_1_Enabled then
			self.NextDef = ConRO.Evoker.DevastationDef;
		else
			self.NextDef = ConRO.Evoker.Disabled;
		end
	end;
	if mode == 2 then
		if ConRO.db.profile._Spec_2_Enabled then
			self.NextDef = ConRO.Evoker.PreservationDef;
		else
			self.NextDef = ConRO.Evoker.Disabled;
		end
	end;
	if mode == 3 then
		if ConRO.db.profile._Spec_3_Enabled then
			self.NextDef = ConRO.Evoker.AugmentationDef;
		else
			self.NextDef = ConRO.Evoker.Disabled;
		end
	end;
end

function ConRO:UNIT_SPELLCAST_SUCCEEDED(event, unitID, lineID, spellID)
	if unitID == 'player' then
		self.lastSpellId = spellID;
	end
end

function ConRO.Evoker.Disabled(_, timeShift, currentSpell, gcd, tChosen, pvpChosen)
	return nil;
end

--Info
local _Player_Level = UnitLevel("player");
local _Player_Percent_Health = ConRO:PercentHealth('player');
local _is_PvP = ConRO:IsPvP();
local _in_combat = UnitAffectingCombat('player');
local _party_size = GetNumGroupMembers();
local _is_PC = UnitPlayerControlled("target");
local _is_Enemy = ConRO:TarHostile();
local _Target_Health = UnitHealth('target');
local _Target_Percent_Health = ConRO:PercentHealth('target');

--Resources
local _Mana, _Mana_Max, _Mana_Percent = ConRO:PlayerPower('Mana');
local _Essence, _Essence_Max = ConRO:PlayerPower('Essence');

--Conditions
local _is_moving = ConRO:PlayerSpeed();
local _enemies_in_melee, _target_in_melee = ConRO:Targets("Melee");
local _enemies_in_10yrds, _target_in_10yrds = ConRO:Targets("10");
local _enemies_in_25yrds, _target_in_25yrds = ConRO:Targets("25");

--Racials
local _TailSwipe, _TailSwipe_RDY = _, _;
local _WingBuffet, _WingBuffet_RDY = _, _;

function ConRO:Stats()
	_Player_Level = UnitLevel("player");
	_Player_Percent_Health = ConRO:PercentHealth('player');
	_is_PvP = ConRO:IsPvP();
	_in_combat = UnitAffectingCombat('player');
	_party_size = GetNumGroupMembers();
	_is_PC = UnitPlayerControlled("target");
	_is_Enemy = ConRO:TarHostile();
	_Target_Health = UnitHealth('target');
	_Target_Percent_Health = ConRO:PercentHealth('target');
	_Mana, _Mana_Max, _Mana_Percent = ConRO:PlayerPower('Mana');
	_Essence, _Essence_Max = ConRO:PlayerPower('Essence');
	_is_moving = ConRO:PlayerSpeed();
	_enemies_in_melee, _target_in_melee = ConRO:Targets("Melee");
	_enemies_in_10yrds, _target_in_10yrds = ConRO:Targets("10");
	_enemies_in_25yrds, _target_in_25yrds = ConRO:Targets("25");

	_TailSwipe, _TailSwipe_RDY = ConRO:AbilityReady(ids.Racial.TailSwipe, timeShift);
	_WingBuffet, _WingBuffet_RDY = ConRO:AbilityReady(ids.Racial.WingBuffet, timeShift);
end

local Empowered_Color = {
    blue = {r = 0.01, b = 0.79, g = 0.37};
    red = {r = 0.8, b = 0, g = 0};
    green = {r = 0.01, b = 0.37, g = 0.78};
	black = {r = 0.3, b = 0.3, g = 0.3};
}

local EmpoweredFrame_Color = Empowered_Color.red;

local Empowered_FireBreath_Rank = "1";
local Empowered_EternitySurge_Rank = "1";
local Empowered_Upheaval_Rank = "1";
local Empowered_DreamBreath_Rank = "1";
local Empowered_Spiritbloom_Rank = "1";

function ConRO.Evoker.Under60(_, timeShift, currentSpell, gcd, tChosen, pvpChosen)
	wipe(ConRO.SuggestedSpells)
	ConRO:Stats();
--Abilities

--Warnings

--Rotations


	return nil;
end

function ConRO.Evoker.Under60Def(_, timeShift, currentSpell, gcd, tChosen, pvpChosen)
	wipe(ConRO.SuggestedDefSpells)
	ConRO:Stats();
--Abilities

--Warnings

--Rotations

	return nil;
end

function ConRO.Evoker.Devastation(_, timeShift, currentSpell, gcd, tChosen, pvpChosen)
	wipe(ConRO.SuggestedSpells)
	ConRO:Stats();
	local Ability, Form, Buff, Debuff, PetAbility, PvPTalent = ids.Dev_Ability, ids.Dev_Form, ids.Dev_Buff, ids.Dev_Debuff, ids.Dev_PetAbility, ids.Dev_PvPTalent;
--Abilities
	local _AzureStrike, _AzureStrike_RDY = ConRO:AbilityReady(Ability.AzureStrike, timeShift);
	local _BlessingoftheBronze, _BlessingoftheBronze_RDY = ConRO:AbilityReady(Ability.BlessingoftheBronze, timeShift);
		local _BlessingoftheBronze_BUFF = ConRO:Aura(Buff.BlessingoftheBronze, timeShift);
	local _DeepBreath, _DeepBreath_RDY = ConRO:AbilityReady(Ability.DeepBreath, timeShift);
	local _Disintegrate, _Disintegrate_RDY = ConRO:AbilityReady(Ability.Disintegrate, timeShift);
	local _Dragonrage, _Dragonrage_RDY, _Dragonrage_CD = ConRO:AbilityReady(Ability.Dragonrage, timeShift);
		local _Dragonrage_BUFF = ConRO:Aura(Buff.Dragonrage, timeShift);
	local _EternitySurge, _EternitySurge_RDY = ConRO:AbilityReady(Ability.EternitySurge, timeShift);
	local _EternitySurge_FoM, _EternitySurge_FoM_RDY = ConRO:AbilityReady(Ability.EternitySurge_FoM, timeShift);
	local _FireBreath, _FireBreath_RDY, _FireBreath_CD = ConRO:AbilityReady(Ability.FireBreath, timeShift);
	local _FireBreath_FoM, _FireBreath_FoM_RDY, _FireBreath_FoM_CD = ConRO:AbilityReady(Ability.FireBreath_FoM, timeShift);
		local _FireBreath_DEBUFF, _, _FireBreath_DUR = ConRO:TargetAura(Debuff.FireBreath, timeShift);
		local _Burnout_BUFF, _Burnout_COUNT = ConRO:Aura(Buff.Burnout, timeShift);
	local _Firestorm, _Firestorm_RDY = ConRO:AbilityReady(Ability.Firestorm, timeShift);
		local _Snapfire_BUFF = ConRO:Aura(Buff.Snapfire, timeShift);
	local _FuryoftheAspects, _FuryoftheAspects_RDY = ConRO:AbilityReady(Ability.FuryoftheAspects, timeShift);
		local _, _Exhaustion = ConRO:Heroism();
	local _Hover, _Hover_RDY = ConRO:AbilityReady(Ability.Hover, timeShift);
	local _Landslide, _Landslide_RDY = ConRO:AbilityReady(Ability.Landslide, timeShift);
	local _LivingFlame, _LivingFlame_RDY = ConRO:AbilityReady(Ability.LivingFlame, timeShift);
		local _EssenceBurst_BUFF, _EssenceBurst_COUNT = ConRO:Aura(Buff.EssenceBurst, timeShift);
	local _Pyre, _Pyre_RDY = ConRO:AbilityReady(Ability.Pyre, timeShift);
		local _ChargedBlast_BUFF, _ChargedBlast_COUNT = ConRO:Aura(Buff.ChargedBlast, timeShift);
	local _Quell, _Quell_RDY = ConRO:AbilityReady(Ability.Quell, timeShift);
	local _ShatteringStar, _ShatteringStar_RDY = ConRO:AbilityReady(Ability.ShatteringStar, timeShift);
	local _SourceofMagic, _SourceofMagic_RDY = ConRO:AbilityReady(Ability.SourceofMagic, timeShift);
	local _TiptheScales, _TiptheScales_RDY = ConRO:AbilityReady(Ability.TiptheScales, timeShift);
	local _Unravel, _Unravel_RDY = ConRO:AbilityReady(Ability.Unravel, timeShift);

	if tChosen[Ability.FontofMagic.talentID] then
		_EternitySurge, _EternitySurge_RDY, _FireBreath, _FireBreath_RDY, _FireBreath_CD = _EternitySurge_FoM, _EternitySurge_FoM_RDY, _FireBreath_FoM, _FireBreath_FoM_RDY, _FireBreath_FoM_CD;
	end

	local _EssenceBurst_MCOUNT = 1;
	if tChosen[Ability.EssenceAttunement.talentID] then
		_EssenceBurst_MCOUNT = 2;
	end

	local _EternitySurge_Targets = _enemies_in_25yrds;
	if tChosen[Ability.EternitysSpan.talentID] then
		_EternitySurge_Targets = _enemies_in_25yrds / 2;
	end

	if _EternitySurge_Targets == 2 then
		Empowered_EternitySurge_Rank = "2";
	else
		if tChosen[Ability.FontofMagic.talentID] then
			if _EternitySurge_Targets == 3 then
				Empowered_EternitySurge_Rank = "3";
			elseif _EternitySurge_Targets >= 4 then
				Empowered_EternitySurge_Rank = "4";
			end
		else
			if _EternitySurge_Targets >= 3 then
				Empowered_EternitySurge_Rank = "3";
			end
		end
	end

--Indicators
	ConRO:AbilityInterrupt(_Quell, _Quell_RDY and ConRO:Interrupt());

	ConRO:AbilityRaidBuffs(_BlessingoftheBronze, _BlessingoftheBronze_RDY and not ConRO:RaidBuff(Buff.BlessingoftheBronze));
	ConRO:AbilityRaidBuffs(_SourceofMagic, _SourceofMagic_RDY and not ConRO:IsSolo() and not ConRO:OneBuff(Buff.SourceofMagic));

	ConRO:AbilityBurst(_TiptheScales, _TiptheScales_RDY and _EternitySurge_RDY and ((ConRO_AutoButton:IsVisible() and _enemies_in_25yrds >= 5) or ConRO_AoEButton:IsVisible()));
	ConRO:AbilityBurst(_Dragonrage, _Dragonrage_RDY and _EssenceBurst_COUNT == 0 and ConRO:BurstMode(_Dragonrage));

--Rotations
	if (select(2, ConRO:EndChannel()) == _EternitySurge) then
		local color = Empowered_Color.blue;
		ConROEmpoweredFrame.texture:SetVertexColor(color.r, color.g, color.b);
		ConROEmpoweredFrame.font:SetText(Empowered_EternitySurge_Rank);
		ConROEmpoweredFrame:Show();
		tinsert(ConRO.SuggestedSpells, _EternitySurge);
	elseif (select(2, ConRO:EndChannel()) == _FireBreath) then
		local color = Empowered_Color.red;
		ConROEmpoweredFrame.texture:SetVertexColor(color.r, color.g, color.b);
		ConROEmpoweredFrame.font:SetText(Empowered_FireBreath_Rank);
		ConROEmpoweredFrame:Show();
		tinsert(ConRO.SuggestedSpells, _FireBreath);
	else
		ConROEmpoweredFrame:Hide();
	end

	for i = 1, 2, 1 do
		if select(2, ConRO:EndChannel()) == _Disintegrate and select(1, ConRO:EndChannel()) > 1 then
			tinsert(ConRO.SuggestedSpells, _Disintegrate);
		end

		if _Dragonrage_RDY and _FireBreath_RDY and (not tChosen[Ability.EternitySurge.talentID] or (tChosen[Ability.EternitySurge.talentID])) and _EternitySurge_RDY and ConRO:FullMode(_Dragonrage) then
			tinsert(ConRO.SuggestedSpells, _Dragonrage);
			_Dragonrage_RDY = false;
		end

		if _FireBreath_RDY and _Dragonrage_CD >= 10 then
			tinsert(ConRO.SuggestedSpells, _FireBreath);
			_FireBreath_RDY = false;
			Empowered_FireBreath_Rank = "1";
		end

		if _Firestorm_RDY and (_Snapfire_BUFF or (tChosen[Ability.EverburningFlame.talentID] and _FireBreath_DUR <= 3 and _FireBreath_DUR < _FireBreath_CD)) then
			tinsert(ConRO.SuggestedSpells, _Firestorm);
			_Firestorm_RDY = false;
		end

		if _ShatteringStar_RDY then
			tinsert(ConRO.SuggestedSpells, _ShatteringStar);
			_ShatteringStar_RDY = false;
		end

		if _DeepBreath_RDY and ((ConRO_AutoButton:IsVisible() and _enemies_in_25yrds >= 2) or ConRO_AoEButton:IsVisible()) then
			tinsert(ConRO.SuggestedSpells, _DeepBreath);
			_DeepBreath_RDY = false;
		end

		if _EternitySurge_RDY and _Dragonrage_CD >= 15 then
			tinsert(ConRO.SuggestedSpells, _EternitySurge);
			_EternitySurge_RDY = false;
		end

		if _LivingFlame_RDY and _Burnout_COUNT >= 1 and _EssenceBurst_COUNT < _EssenceBurst_MCOUNT then
			tinsert(ConRO.SuggestedSpells, _LivingFlame);
			_Burnout_COUNT = _Burnout_COUNT - 1;
		end

		if _Pyre_RDY and (_Essence >= 2 or _EssenceBurst_COUNT >= 1) and _Dragonrage_CD >= 10 and (((_ChargedBlast_COUNT >= 16 and _Dragonrage_BUFF) or _ChargedBlast_COUNT >= 20) and (ConRO_AutoButton:IsVisible() and _enemies_in_25yrds >= 2) or (ConRO_AutoButton:IsVisible() and _enemies_in_25yrds >= 3) or ConRO_AoEButton:IsVisible()) then
			tinsert(ConRO.SuggestedSpells, _Pyre);
			if _EssenceBurst_COUNT >= 1 then
				_EssenceBurst_COUNT = _EssenceBurst_COUNT - 1;
			else
				_Essence = _Essence - 2;
			end
		end

		if _Disintegrate_RDY and (_Essence >= 3 or _EssenceBurst_COUNT >= 1)and ((ConRO_AutoButton:IsVisible() and _enemies_in_25yrds <= 2) or ConRO_SingleButton:IsVisible()) then
			tinsert(ConRO.SuggestedSpells, _Disintegrate);
			if _EssenceBurst_COUNT >= 1 then
				_EssenceBurst_COUNT = _EssenceBurst_COUNT - 1;
			else
				_Essence = _Essence - 3;
			end
		end

		if _AzureStrike_RDY and ((ConRO_AutoButton:IsVisible() and _enemies_in_25yrds >= 2) or ConRO_AoEButton:IsVisible() or _is_moving or _Dragonrage_BUFF) then
			tinsert(ConRO.SuggestedSpells, _AzureStrike);
		end

		if _LivingFlame_RDY then
			tinsert(ConRO.SuggestedSpells, _LivingFlame);
		end
	end
	return nil;
end

function ConRO.Evoker.DevastationDef(_, timeShift, currentSpell, gcd, tChosen, pvpChosen)
	wipe(ConRO.SuggestedDefSpells)
	ConRO:Stats();
	local Ability, Form, Buff, Debuff, PetAbility, PvPTalent = ids.Dev_Ability, ids.Dev_Form, ids.Dev_Buff, ids.Dev_Debuff, ids.Dev_PetAbility, ids.Dev_PvPTalent;
--Abilities
	local _ObsidianScales, _ObsidianScales_RDY = ConRO:AbilityReady(Ability.ObsidianScales, timeShift);

--Rotations
	if _ObsidianScales_RDY then
		tinsert(ConRO.SuggestedDefSpells, _ObsidianScales);
	end

	return nil;
end

function ConRO.Evoker.Preservation(_, timeShift, currentSpell, gcd, tChosen, pvpChosen)
	wipe(ConRO.SuggestedSpells)
	ConRO:Stats();
	local Ability, Form, Buff, Debuff, PetAbility, PvPTalent = ids.Pres_Ability, ids.Pres_Form, ids.Pres_Buff, ids.Pres_Debuff, ids.Pres_PetAbility, ids.Pres_PvPTalent;
--Abilities
	local _AzureStrike, _AzureStrike_RDY = ConRO:AbilityReady(Ability.AzureStrike, timeShift);
	local _BlessingoftheBronze, _BlessingoftheBronze_RDY = ConRO:AbilityReady(Ability.BlessingoftheBronze, timeShift);
		local _BlessingoftheBronze_BUFF = ConRO:Aura(Buff.BlessingoftheBronze, timeShift);
	local _DeepBreath, _DeepBreath_RDY = ConRO:AbilityReady(Ability.DeepBreath, timeShift);
	local _Disintegrate, _Disintegrate_RDY = ConRO:AbilityReady(Ability.Disintegrate, timeShift);
	local _FireBreath, _FireBreath_RDY = ConRO:AbilityReady(Ability.FireBreath, timeShift);
		local _FireBreath_FoM, _FireBreath_FoM_RDY = ConRO:AbilityReady(Ability.FireBreath_FoM, timeShift);
	local _FuryoftheAspects, _FuryoftheAspects_RDY = ConRO:AbilityReady(Ability.FuryoftheAspects, timeShift);
		local _, _Exhaustion = ConRO:Heroism();
	local _Hover, _Hover_RDY = ConRO:AbilityReady(Ability.Hover, timeShift);
	local _Landslide, _Landslide_RDY = ConRO:AbilityReady(Ability.Landslide, timeShift);
	local _LivingFlame, _LivingFlame_RDY = ConRO:AbilityReady(Ability.LivingFlame, timeShift);
		local _EssenceBurst_BUFF, _EssenceBurst_COUNT = ConRO:Aura(Buff.EssenceBurst, timeShift);
	local _Quell, _Quell_RDY = ConRO:AbilityReady(Ability.Quell, timeShift);
	local _SourceofMagic, _SourceofMagic_RDY = ConRO:AbilityReady(Ability.SourceofMagic, timeShift);
	local _TiptheScales, _TiptheScales_RDY = ConRO:AbilityReady(Ability.TiptheScales, timeShift);
	local _Unravel, _Unravel_RDY = ConRO:AbilityReady(Ability.Unravel, timeShift);

	if tChosen[Ability.FontofMagic.talentID] then
		_FireBreath, _FireBreath_RDY =_FireBreath_FoM, _FireBreath_FoM_RDY;
	end

	local _EssenceBurst_MCOUNT = 1;
	if tChosen[Ability.EssenceAttunement.talentID] then
		_EssenceBurst_MCOUNT = 2;
	end

--Indicators
	ConRO:AbilityInterrupt(_Quell, _Quell_RDY and ConRO:Interrupt());

	ConRO:AbilityRaidBuffs(_BlessingoftheBronze, _BlessingoftheBronze_RDY and not ConRO:RaidBuff(Buff.BlessingoftheBronze));
	ConRO:AbilityRaidBuffs(_SourceofMagic, _SourceofMagic_RDY and not ConRO:IsSolo() and not ConRO:OneBuff(Buff.SourceofMagic));

	--ConRO:AbilityBurst(_TiptheScales, _TiptheScales_RDY);


--Rotations
	if (select(2, ConRO:EndChannel()) == _FireBreath) then
		local color = Empowered_Color.red;
		ConROEmpoweredFrame.texture:SetVertexColor(color.r, color.g, color.b);
		ConROEmpoweredFrame.font:SetText(Empowered_FireBreath_Rank);
		ConROEmpoweredFrame:Show();
		tinsert(ConRO.SuggestedSpells, _FireBreath);
	else
		ConROEmpoweredFrame:Hide();
	end

	for i = 1, 2, 1 do
		if _is_Enemy then
			if select(2, ConRO:EndChannel()) == _Disintegrate and select(1, ConRO:EndChannel()) > 1 then
				tinsert(ConRO.SuggestedSpells, _Disintegrate);
			end

			if _FireBreath_RDY then
				tinsert(ConRO.SuggestedSpells, _FireBreath);
				_FireBreath_RDY = false;
			end

			if _Disintegrate_RDY and _Essence >= 3 then
				tinsert(ConRO.SuggestedSpells, _Disintegrate);
				_Essence = _Essence - 3;
			end

			if _DeepBreath_RDY and _enemies_in_10yrds >= 3 then
				tinsert(ConRO.SuggestedSpells, _DeepBreath);
				_DeepBreath_RDY = false;
			end

			if _AzureStrike_RDY and (_is_moving or _enemies_in_10yrds >= 3) then
				tinsert(ConRO.SuggestedSpells, _AzureStrike);
			end

			if _LivingFlame_RDY then
				tinsert(ConRO.SuggestedSpells, _LivingFlame);
			end
		end
	end
	return nil;
end

function ConRO.Evoker.PreservationDef(_, timeShift, currentSpell, gcd, tChosen, pvpChosen)
	wipe(ConRO.SuggestedDefSpells)
	ConRO:Stats();
	local Ability, Form, Buff, Debuff, PetAbility, PvPTalent = ids.Pres_Ability, ids.Pres_Form, ids.Pres_Buff, ids.Pres_Debuff, ids.Pres_PetAbility, ids.Pres_PvPTalent;
--Abilities
	local _ObsidianScales, _ObsidianScales_RDY = ConRO:AbilityReady(Ability.ObsidianScales, timeShift);

--Rotations
	if _ObsidianScales_RDY then
		tinsert(ConRO.SuggestedDefSpells, _ObsidianScales);
	end

	return nil;
end

function ConRO.Evoker.Augmentation(_, timeShift, currentSpell, gcd, tChosen, pvpChosen)
	wipe(ConRO.SuggestedSpells)
	ConRO:Stats();
	local Ability, Form, Buff, Debuff, PetAbility, PvPTalent = ids.Aug_Ability, ids.Aug_Form, ids.Aug_Buff, ids.Aug_Debuff, ids.Aug_PetAbility, ids.Aug_PvPTalent;
--Abilities
	local _AzureStrike, _AzureStrike_RDY = ConRO:AbilityReady(Ability.AzureStrike, timeShift);
	local _BlessingoftheBronze, _BlessingoftheBronze_RDY = ConRO:AbilityReady(Ability.BlessingoftheBronze, timeShift);
	local _BlisteringScales, _BlisteringScales_RDY = ConRO:AbilityReady(Ability.BlisteringScales, timeShift);
		local _BlisteringScales_BUFF = ConRO:Aura(Buff.BlisteringScales, timeShift);
	local _BreathofEons, _BreathofEons_RDY = ConRO:AbilityReady(Ability.BreathofEons, timeShift);
	local _EbonMight, _EbonMight_RDY = ConRO:AbilityReady(Ability.EbonMight, timeShift);
		local _EbonMight_BUFF = ConRO:Aura(Buff.EbonMight, timeShift);
	local _EmeraldBlossom, _EmeraldBlossom_RDY = ConRO:AbilityReady(Ability.EmeraldBlossom, timeShift);
		local _AncientFlame_BUFF = ConRO:Form(Form.AncientFlame);
	local _Eruption, _Eruption_RDY = ConRO:AbilityReady(Ability.Eruption, timeShift);
	local _FireBreath, _FireBreath_RDY = ConRO:AbilityReady(Ability.FireBreath, timeShift);
		local _FireBreath_FoM, _FireBreath_FoM_RDY = ConRO:AbilityReady(Ability.FireBreath_FoM, timeShift);
	local _FuryoftheAspects, _FuryoftheAspects_RDY = ConRO:AbilityReady(Ability.FuryoftheAspects, timeShift);
		local _, _Exhaustion = ConRO:Heroism();
	local _LivingFlame, _LivingFlame_RDY = ConRO:AbilityReady(Ability.LivingFlame, timeShift);
		local _EssenceBurst_BUFF, _EssenceBurst_COUNT = ConRO:Aura(Buff.EssenceBurst, timeShift);
	local _Prescience, _Prescience_RDY = ConRO:AbilityReady(Ability.Prescience, timeShift);
		local _Prescience_BUFF = ConRO:Aura(Buff.Prescience, timeShift);
		local _Prescience_CHARGE = ConRO:SpellCharges(_Prescience);
	local _Quell, _Quell_RDY = ConRO:AbilityReady(Ability.Quell, timeShift);
	local _SourceofMagic, _SourceofMagic_RDY = ConRO:AbilityReady(Ability.SourceofMagic, timeShift);
	local _TimeSkip, _TimeSkip_RDY = ConRO:AbilityReady(Ability.TimeSkip, timeShift);
	local _TiptheScales, _TiptheScales_RDY = ConRO:AbilityReady(Ability.TiptheScales, timeShift);
		local _TiptheScales_BUFF = ConRO:Form(Form.TiptheScales);
	local _Upheaval, _Upheaval_RDY = ConRO:AbilityReady(Ability.Upheaval, timeShift);
		local _Upheaval_FoM, _Upheaval_FoM_RDY = ConRO:AbilityReady(Ability.Upheaval_FoM, timeShift);
	local _VerdantEmbrace, _VerdantEmbrace_RDY = ConRO:AbilityReady(Ability.VerdantEmbrace, timeShift);

	if tChosen[Ability.FontofMagic.talentID] then
		_FireBreath, _FireBreath_RDY, _Upheaval, _Upheaval_RDY =_FireBreath_FoM, _FireBreath_FoM_RDY, _Upheaval_FoM, _Upheaval_FoM_RDY;
	end

	local _EssenceBurst_MCOUNT = 1;
	if tChosen[Ability.EssenceAttunement.talentID] then
		_EssenceBurst_MCOUNT = 2;
	end

	if ConRO:IsSolo() then
		Empowered_FireBreath_Rank = "1";
	else
		if tChosen[Ability.FontofMagic.talentID] then
			Empowered_FireBreath_Rank = "4";
		else
			Empowered_FireBreath_Rank = "3";
		end
	end

	local _Upheaval_Targets = _enemies_in_25yrds;
	if _Upheaval_Targets <= 1 then
		Empowered_Upheaval_Rank = "1";
	else
		if tChosen[Ability.FontofMagic.talentID] then
			if _Upheaval_Targets >= 2 then
				Empowered_Upheaval_Rank = "4";
			end
		else
			if _Upheaval_Targets >= 2 then
				Empowered_Upheaval_Rank = "3";
			end
		end
	end

--Indicators
	ConRO:AbilityInterrupt(_Quell, _Quell_RDY and ConRO:Interrupt());

	ConRO:AbilityRaidBuffs(_BlessingoftheBronze, _BlessingoftheBronze_RDY and not ConRO:RaidBuff(Buff.BlessingoftheBronze));
	ConRO:AbilityRaidBuffs(_SourceofMagic, _SourceofMagic_RDY and not ConRO:IsSolo() and not ConRO:OneBuff(Buff.SourceofMagic));
	ConRO:AbilityRaidBuffs(_BlisteringScales, _BlisteringScales_RDY and not ConRO:OneBuff(Buff.BlisteringScales));

	ConRO:AbilityBurst(_BreathofEons, _BreathofEons_RDY and _EbonMight_BUFF and ConRO:BurstMode(_BreathofEons));
	ConRO:AbilityBurst(_TimeSkip, _TimeSkip_RDY and not tChosen[Ability.InterwovenThreads.talentID] and _EbonMight_BUFF and not _BreathofEons_RDY and not _FireBreath_RDY and not _Upheaval_RDY and ConRO:BurstMode(_TimeSkip));
	ConRO:AbilityBurst(_TiptheScales, _TiptheScales_RDY and not _TiptheScales_BUFF and _FireBreath_RDY and _EbonMight_BUFF and ConRO:BurstMode(_TiptheScales));

--Rotations
	if (select(2, ConRO:EndChannel()) == _Upheaval) then
		local color = Empowered_Color.black;
		ConROEmpoweredFrame.texture:SetVertexColor(color.r, color.g, color.b);
		ConROEmpoweredFrame.font:SetText(Empowered_Upheaval_Rank);
		ConROEmpoweredFrame:Show();
		tinsert(ConRO.SuggestedSpells, _Upheaval);
	elseif (select(2, ConRO:EndChannel()) == _FireBreath) then
		local color = Empowered_Color.red;
		ConROEmpoweredFrame.texture:SetVertexColor(color.r, color.g, color.b);
		ConROEmpoweredFrame.font:SetText(Empowered_FireBreath_Rank);
		ConROEmpoweredFrame:Show();
		tinsert(ConRO.SuggestedSpells, _FireBreath);
	else
		ConROEmpoweredFrame:Hide();
	end

	if currentSpell == _Eruption then
		if _EssenceBurst_COUNT >= 1 then
			_EssenceBurst_COUNT = _EssenceBurst_COUNT - 1;
		else
			_Essence = _Essence - 2;
		end
	end

	if not _in_combat then
		if _TiptheScales_RDY and not _TiptheScales_BUFF and ConRO:FullMode(_TiptheScales) then
			tinsert(ConRO.SuggestedSpells, _TiptheScales);
			_TiptheScales_RDY = false;
			_TiptheScales_BUFF = true;
		end

		if _LivingFlame_RDY and currentSpell ~= _LivingFlame then
			tinsert(ConRO.SuggestedSpells, _LivingFlame);
		end
	end

	for i = 1, 2, 1 do
		if ConRO:IsSolo() then
			if _Prescience_RDY and _Prescience_CHARGE >= 1 and not _Prescience_BUFF then
				tinsert(ConRO.SuggestedSpells, _Prescience);
				_Prescience_CHARGE = _Prescience_CHARGE - 1;
				_Prescience_BUFF = true;
			end
		else
			if _Prescience_RDY and _Prescience_CHARGE >= 1 and not ConRO:RaidBuff(Buff.Prescience) then
				tinsert(ConRO.SuggestedSpells, _Prescience);
				_Prescience_CHARGE = _Prescience_CHARGE - 1;
			end
		end

		if _EbonMight_RDY and not _EbonMight_BUFF and currentSpell ~= _EbonMight then
			tinsert(ConRO.SuggestedSpells, _EbonMight);
			_EbonMight_RDY = false;
			_EbonMight_BUFF = true;
		end

		if _AzureStrike_RDY and _EssenceBurst_COUNT < _EssenceBurst_MCOUNT and (currentSpell == _LivingFlame or currentSpell == _EbonMight or currentSpell == _Eruption) then
			tinsert(ConRO.SuggestedSpells, _AzureStrike);
		end

		if _TimeSkip_RDY and not tChosen[Ability.InterwovenThreads.talentID] and _EbonMight_BUFF and not _BreathofEons_RDY and not _FireBreath_RDY and not _Upheaval_RDY and ConRO:FullMode(_TimeSkip) then
			tinsert(ConRO.SuggestedSpells, _TimeSkip);
			_TimeSkip_RDY = false;
		end

		if _BreathofEons_RDY and _EbonMight_BUFF and ConRO:FullMode(_BreathofEons) then
			tinsert(ConRO.SuggestedSpells, _BreathofEons);
			_BreathofEons_RDY = false;
		end

		if _TiptheScales_RDY and not _TiptheScales_BUFF and _FireBreath_RDY and ConRO:FullMode(_TiptheScales) then
			tinsert(ConRO.SuggestedSpells, _TiptheScales);
			_TiptheScales_RDY = false;
		end

		if _FireBreath_RDY and _EbonMight_BUFF then
			tinsert(ConRO.SuggestedSpells, _FireBreath);
			_FireBreath_RDY = false;
		end

		if _Upheaval_RDY and _EbonMight_BUFF then
			tinsert(ConRO.SuggestedSpells, _Upheaval);
			_Upheaval_RDY = false;
		end

		if _Eruption_RDY and (_Essence >= 2 or _EssenceBurst_COUNT >= 1) and _EbonMight_BUFF then
			tinsert(ConRO.SuggestedSpells, _Eruption);
			if _EssenceBurst_COUNT >= 1 then
				_EssenceBurst_COUNT = _EssenceBurst_COUNT - 1;
			else
				_Essence = _Essence - 2;
			end
		end

		if tChosen[Ability.AncientFlame.talentID] and not _AncientFlame_BUFF then
			if _EmeraldBlossom_RDY then
				tinsert(ConRO.SuggestedSpells, _EmeraldBlossom);
				_AncientFlame_BUFF = true;
				_EmeraldBlossom_RDY = false;
			end

			if _VerdantEmbrace_RDY then
				tinsert(ConRO.SuggestedSpells, _VerdantEmbrace);
				_AncientFlame_BUFF = true;
				_VerdantEmbrace_RDY = false;
			end
		end

		if _LivingFlame_RDY and currentSpell ~= _LivingFlame then
			tinsert(ConRO.SuggestedSpells, _LivingFlame);
		end
	end
	return nil;
end

function ConRO.Evoker.AugmentationDef(_, timeShift, currentSpell, gcd, tChosen, pvpChosen)
	wipe(ConRO.SuggestedDefSpells)
	ConRO:Stats();
	local Ability, Form, Buff, Debuff, PetAbility, PvPTalent = ids.Aug_Ability, ids.Aug_Form, ids.Aug_Buff, ids.Aug_Debuff, ids.Aug_PetAbility, ids.Aug_PvPTalent;
--Abilities
	local _ObsidianScales, _ObsidianScales_RDY = ConRO:AbilityReady(Ability.ObsidianScales, timeShift);

--Rotations
	if _ObsidianScales_RDY then
		tinsert(ConRO.SuggestedDefSpells, _ObsidianScales);
	end

	return nil;
end