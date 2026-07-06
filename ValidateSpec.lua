function validateSpec()
	-- This is the ID related to talent trees, such as 255 for Survival, 70 for Retribution, etc.
	local specID = PlayerUtil.GetCurrentSpecID()

	-- Uses the current specID to either retrieve the last known selected config or defaults to the one in memory
	local configID = C_ClassTalents.GetLastSelectedSavedConfigID(specID) or C_ClassTalents.GetActiveConfigID()

	-- Retrieves the stored configuration data based off the active spec
	local configInfo = C_Traits.GetConfigInfo(configID)

	-- This is retrieving the index of the current talent specialization. 3 for Survival, 2 for Holy (Priests), etc.
	local playerSpecID = GetSpecialization()

	-- Holds all of the spec information returned from the in-game function that we can use.
	local specID, name, description, icon, role, primaryStat = C_SpecializationInfo.GetSpecializationInfo(playerSpecID)
	currentPlayerSpec = name
	currentPlayerSpecIcon = icon

	-- Retrieves the numberical number representing the current hero talentID. We use our enum below to turn it into the string value.
	activeHeroTalent = C_ClassTalents.GetActiveHeroTalentSpec()

	-- Name of the talent loadout the player has selected.
	talentLoadoutName = configInfo.name

	-- The Atlas Name of the Hero Spec Icon, which functions different than a file ID
	local heroInfo = C_Traits.GetSubTreeInfo(configID, activeHeroTalent)
	currentPlayerHeroIcon = heroInfo.iconElementID
end