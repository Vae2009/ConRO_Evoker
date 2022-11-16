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
		self.Description = "Evoker [No Specialization Under 10]";
		self.NextSpell = ConRO.Evoker.Under10;
		self.ToggleHealer();
	end;
	if mode == 1 then
		self.Description = "Evoker [Devastation - Caster]";
		if ConRO.db.profile._Spec_1_Enabled then
			self.NextSpell = ConRO.Evoker.Devastation;
			self.ToggleDamage();
			ConROWindow:SetAlpha(ConRO.db.profile.transparencyWindow);
			ConRODefenseWindow:SetAlpha(ConRO.db.profile.transparencyWindow);
		else
			self.NextSpell = ConRO.Evoker.Disabled;
			self.ToggleHealer();
			ConROWindow:SetAlpha(0);
			ConRODefenseWindow:SetAlpha(0);
		end
	end;
	if mode == 2 then
		self.Description = "Evoker [Preservation - Healer]";
		if ConRO.db.profile._Spec_2_Enabled then
			self.NextSpell = ConRO.Evoker.Preservation;
			self.ToggleDamage();
			self.BlockAoE();
			ConROWindow:SetAlpha(ConRO.db.profile.transparencyWindow);
			ConRODefenseWindow:SetAlpha(ConRO.db.profile.transparencyWindow);
		else
			self.NextSpell = ConRO.Evoker.Disabled;
			self.ToggleHealer();
			ConROWindow:SetAlpha(0);
			ConRODefenseWindow:SetAlpha(0);
		end
	end;
	self:RegisterEvent('UNIT_SPELLCAST_SUCCEEDED');
	self.lastSpellId = 0;
end

function ConRO:EnableDefenseModule(mode)
	mode = mode or 0;
	if mode == 0 then
		self.NextDef = ConRO.Evoker.Under10Def;
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
end

function ConRO:UNIT_SPELLCAST_SUCCEEDED(event, unitID, lineID, spellID)
	if unitID == 'player' then
		self.lastSpellId = spellID;
	end
end

function ConRO.Evoker.Disabled(_, timeShift, currentSpell, gcd, tChosen, pvpChosen)
	return nil;
end

function ConRO.Evoker.Under10(_, timeShift, currentSpell, gcd, tChosen, pvpChosen)
--Info
	local _Player_Level																														= UnitLevel("player");
	local _Player_Percent_Health 																									= ConRO:PercentHealth('player');
	local _is_PvP																																	= ConRO:IsPvP();
	local _in_combat 																															= UnitAffectingCombat('player');
	local _party_size																															= GetNumGroupMembers();

	local _is_PC																																	= UnitPlayerControlled("target");
	local _is_Enemy 																															= ConRO:TarHostile();
	local _Target_Health 																													= UnitHealth('target');
	local _Target_Percent_Health 																									= ConRO:PercentHealth('target');

--Resources

--Racials

--Abilities

--Conditions
	local _is_moving 																															= ConRO:PlayerSpeed();
	local _enemies_in_melee, _target_in_melee																			= ConRO:Targets("Melee");
	local _target_in_10yrds 																											= CheckInteractDistance("target", 3);

--Warnings

--Rotations


	return nil;
end

function ConRO.Evoker.Under10Def(_, timeShift, currentSpell, gcd, tChosen, pvpChosen)
--Info
	local _Player_Level																														= UnitLevel("player");
	local _Player_Percent_Health 																									= ConRO:PercentHealth('player');
	local _is_PvP																																	= ConRO:IsPvP();
	local _in_combat 																															= UnitAffectingCombat('player');
	local _party_size																															= GetNumGroupMembers();

	local _is_PC																																	= UnitPlayerControlled("target");
	local _is_Enemy 																															= ConRO:TarHostile();
	local _Target_Health 																													= UnitHealth('target');
	local _Target_Percent_Health 																									= ConRO:PercentHealth('target');

--Resources

--Racials

--Abilities

--Conditions
	local _is_moving 																															= ConRO:PlayerSpeed();
	local _enemies_in_melee, _target_in_melee																			= ConRO:Targets("Melee");
	local _target_in_10yrds 																											= CheckInteractDistance("target", 3);

--Warnings

--Rotations

	return nil;
end

function ConRO.Evoker.Devastation(_, timeShift, currentSpell, gcd, tChosen, pvpChosen)
	wipe(ConRO.SuggestedSpells)
	local Racial, Ability, Passive, Form, Buff, Debuff, PetAbility, PvPTalent, Glyph = ids.Racial, ids.Dev_Ability, ids.Dev_Passive, ids.Dev_Form, ids.Dev_Buff, ids.Dev_Debuff, ids.Dev_PetAbility, ids.Dev_PvPTalent, ids.Glyph;
--Info
	local _Player_Level																														= UnitLevel("player");
	local _Player_Percent_Health 																									= ConRO:PercentHealth('player');
	local _is_PvP																																	= ConRO:IsPvP();
	local _in_combat 																															= UnitAffectingCombat('player');
	local _party_size																															= GetNumGroupMembers();

	local _is_PC																																	= UnitPlayerControlled("target");
	local _is_Enemy 																															= ConRO:TarHostile();
	local _Target_Health 																													= UnitHealth('target');
	local _Target_Percent_Health 																									= ConRO:PercentHealth('target');

--Resources
	local _Fury, _Fury_Max, _Fury_Percent																					= ConRO:PlayerPower('Fury');

--Racials

--Abilities
	local _BladeDance, _BladeDance_RDY, _BladeDance_CD 														= ConRO:AbilityReady(ids.Devastation_Ability.BladeDance, timeShift);
		local _Momentum_BUFF 																													= ConRO:Aura(ids.Devastation_Buff.Momentum, timeShift);

--Conditions
	local _is_moving 																															= ConRO:PlayerSpeed();
	local _enemies_in_melee, _target_in_melee																			= ConRO:Targets("Melee");
	local _target_in_10yrds 																											= CheckInteractDistance("target", 3);

--Indicators
	ConRO:AbilityInterrupt(_Disrupt, _Disrupt_RDY and ConRO:Interrupt());
	ConRO:AbilityPurge(_ConsumeMagic, _ConsumeMagic_RDY and ConRO:Purgable());
	ConRO:AbilityMovement(_FelRush, _FelRush_RDY and not _target_in_melee);

	ConRO:AbilityBurst(_Metamorphosis, _Metamorphosis_RDY and not _Metamorphosis_BUFF and not _EyeBeam_RDY and _Fury >= 100 and ConRO:BurstMode(_Metamorphosis));

--Rotations

	return nil;
end

function ConRO.Evoker.DevastationDef(_, timeShift, currentSpell, gcd, tChosen, pvpChosen)
	wipe(ConRO.SuggestedDefSpells)
	local Racial, Ability, Passive, Form, Buff, Debuff, PetAbility, PvPTalent, Glyph = ids.Racial, ids.Dev_Ability, ids.Dev_Passive, ids.Dev_Form, ids.Dev_Buff, ids.Dev_Debuff, ids.Dev_PetAbility, ids.Dev_PvPTalent, ids.Glyph;
--Info
	local _Player_Level																														= UnitLevel("player");
	local _Player_Percent_Health 																									= ConRO:PercentHealth('player');
	local _is_PvP																																	= ConRO:IsPvP();
	local _in_combat 																															= UnitAffectingCombat('player');
	local _party_size																															= GetNumGroupMembers();

	local _is_PC																																	= UnitPlayerControlled("target");
	local _is_Enemy 																															= ConRO:TarHostile();
	local _Target_Health 																													= UnitHealth('target');
	local _Target_Percent_Health 																									= ConRO:PercentHealth('target');

--Resources
	local _Fury, _Fury_Max, _Fury_Percent																					= ConRO:PlayerPower('Fury');

--Abilities

--Conditions
	local _is_moving 																															= ConRO:PlayerSpeed();
	local _enemies_in_melee, _target_in_melee																			= ConRO:Targets("Melee");
	local _target_in_10yrds 																											= CheckInteractDistance("target", 3);

--Rotations

	return nil;
end

function ConRO.Evoker.Preservation(_, timeShift, currentSpell, gcd, tChosen, pvpChosen)
	wipe(ConRO.SuggestedSpells)
	local Racial, Ability, Passive, Form, Buff, Debuff, PetAbility, PvPTalent, Glyph = ids.Racial, ids.Pres_Ability, ids.Pres_Passive, ids.Pres_Form, ids.Pres_Buff, ids.Pres_Debuff, ids.Pres_PetAbility, ids.Pres_PvPTalent, ids.Glyph;
--Info
	local _Player_Level																														= UnitLevel("player");
	local _Player_Percent_Health 																									= ConRO:PercentHealth('player');
	local _is_PvP																																	= ConRO:IsPvP();
	local _in_combat 																															= UnitAffectingCombat('player');
	local _party_size																															= GetNumGroupMembers();

	local _is_PC																																	= UnitPlayerControlled("target");
	local _is_Enemy 																															= ConRO:TarHostile();
	local _Target_Health 																													= UnitHealth('target');
	local _Target_Percent_Health 																									= ConRO:PercentHealth('target');

--Resources

--Racials

--Abilities

--Conditions
	local _is_moving 																															= ConRO:PlayerSpeed();
	local _enemies_in_melee, _target_in_melee																			= ConRO:Targets("Melee");
	local _target_in_10yrds 																											= CheckInteractDistance("target", 3);

--Indicators

--Rotations

	return nil;
end

function ConRO.Evoker.PreservationDef(_, timeShift, currentSpell, gcd, tChosen, pvpChosen)
	wipe(ConRO.SuggestedDefSpells)
	local Racial, Ability, Passive, Form, Buff, Debuff, PetAbility, PvPTalent, Glyph = ids.Racial, ids.Pres_Ability, ids.Pres_Passive, ids.Pres_Form, ids.Pres_Buff, ids.Pres_Debuff, ids.Pres_PetAbility, ids.Pres_PvPTalent, ids.Glyph;
--Info
	local _Player_Level																														= UnitLevel("player");
	local _Player_Percent_Health 																									= ConRO:PercentHealth('player');
	local _is_PvP																																	= ConRO:IsPvP();
	local _in_combat 																															= UnitAffectingCombat('player');
	local _party_size																															= GetNumGroupMembers();

	local _is_PC																																	= UnitPlayerControlled("target");
	local _is_Enemy 																															= ConRO:TarHostile();
	local _Target_Health 																													= UnitHealth('target');
	local _Target_Percent_Health 																									= ConRO:PercentHealth('target');

--Resources

--Abilities

--Conditions
	local _is_moving 																															= ConRO:PlayerSpeed();
	local _enemies_in_melee, _target_in_melee																			= ConRO:Targets("Melee");
	local _target_in_10yrds 																											= CheckInteractDistance("target", 3);

--Rotations

	return nil;
end
