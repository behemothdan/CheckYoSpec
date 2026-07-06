local CheckYoSpecFrame = CreateFrame("Frame", "CheckYoSpecFrame", UIParent, "TooltipBorderedFrameTemplate")

CheckYoSpecFrame:SetPoint("CENTER", UIParent, "CENTER", 0, 180)
CheckYoSpecFrame:SetSize(670, 250)
CheckYoSpecFrame.Hide(CheckYoSpecFrame)

-- Adds our window to the list of windows closed by hitting escape
table.insert(UISpecialFrames, "CheckYoSpecFrame")

-- Create listener frame for Ready Checks
local eventListenerFrame = CreateFrame("Frame", "CheckYoSpecListenerFrame", UIParent)

-- Commands to pop-up the window in-game
SLASH_CHECKYOSPEC1, SLASH_CHECKYOSPEC2, SLASH_CHECKYOSPEC3 = '/cys', '/qq', '/checkit';

-- Reusable function to show and hide the CheckYoSpec frame
local function CheckYoSpecShowHide()
	if CheckYoSpecFrame:IsShown() then
		CheckYoSpecFrame:Hide()
	else
		CheckYoSpecFrame:Show()
	end
end

-- Function to only hide the frame. We can probably make the function above take a parameter however we need to seee why Timer.After doesn't like parameters.
local function CheckYoSpecHide()
	CheckYoSpecFrame:Hide()
end

-- Loads Talent Reminder Frame when one of the comamands is executed
SlashCmdList["CHECKYOSPEC"] = function()
	CheckYoSpecShowHide()
end

-- Function to handle when a Ready Check event is called
local function eventHandler(self, event, ...)
	if event and event == "READY_CHECK" then
		CheckYoSpecShowHide()
	end

	-- Automatically close the frame after the specified number of seconds if still open.
	-- We call the specific hide function so we don't repop the window if it is already closed.
	C_Timer.After(7, CheckYoSpecHide)
end

-- Registers our scripts with our listener frame looking for Ready Check events
eventListenerFrame:SetScript("OnEvent", eventHandler)
eventListenerFrame:RegisterEvent("READY_CHECK")

-- Feedback strings, can be altered retrieved data about player specs
talentLoadoutName = "No loadout selected."
activeHeroTalent = "No Hero Talents selected."
currentPlayerSpec = ''
currentPlayerSpecIcon = ''
currentPlayerHeroIcon = ''

-- When the frame is shown, execute the function to get the current talent load out and display it in the frame.
CheckYoSpecFrame:SetScript("OnShow", function()
	validateSpec()
	CheckYoSpecFrame.playerTalentLoadout:SetText(talentLoadoutName)
	CheckYoSpecFrame.talentSpec:SetText(HeroTalentTree[activeHeroTalent] .. ' - ' .. currentPlayerSpec)

	-- Sets the player talent icon in the frame we created
	talentIcon:SetTexture(currentPlayerSpecIcon)

	-- Sets the retrieved hero icon to the frame we created
	heroIcon:SetAtlas(currentPlayerHeroIcon)
	secondHeroIcon.Icon:SetTexture(currentPlayerSpecIcon)
end)

-- Scaffolds the frame to be loaded with the command or when a ready check happens
-- The string calling out the player
CheckYoSpecFrame.playerName = CheckYoSpecFrame:CreateFontString(nil, "OVERLAY", "GameFontHighlightLarge")
CheckYoSpecFrame.playerName:SetPoint("TOP", CheckYoSpecFrame, "TOP", 0, -35)
CheckYoSpecFrame.playerName:SetText("Hey " .. UnitName("player") .. "! Are you in the right spec?")
local namefile, _, nameflags = CheckYoSpecFrame.playerName:GetFont()
CheckYoSpecFrame.playerName:SetFont(namefile, 28, nameflags)

-- Displays the current talent spec and hero talent names as a string
CheckYoSpecFrame.talentSpec = CheckYoSpecFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
CheckYoSpecFrame.talentSpec:SetPoint("BOTTOM", CheckYoSpecFrame, "BOTTOM", 0, 30)
CheckYoSpecFrame.talentSpec:SetText(activeHeroTalent .. ' ' .. currentPlayerSpec)

-- Displays the name of the player's current talent loadout
CheckYoSpecFrame.playerTalentLoadout = CheckYoSpecFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
CheckYoSpecFrame.playerTalentLoadout:SetPoint("CENTER", CheckYoSpecFrame, "CENTER", 0, 0)
CheckYoSpecFrame.playerTalentLoadout:SetText(talentLoadoutName)
local loadoutfile, _, loadoutflags = CheckYoSpecFrame.playerTalentLoadout:GetFont()
CheckYoSpecFrame.playerTalentLoadout:SetFont(loadoutfile, 28, loadoutflags)

-- HERO SPECIALIZATION ICON
-- This creates a texture frame to load the player's hero talent specialization icon.
heroTalentSpecFrame = CreateFrame("Frame", "CheckYoSpecHeroTalentSpecIconFrame", CheckYoSpecFrame)
heroTalentSpecFrame:SetSize(60, 60)
heroTalentSpecFrame:SetAlpha(1)
heroTalentSpecFrame:SetPoint("BOTTOMLEFT", CheckYoSpecFrame, "BOTTOMLEFT", 10, 10)
heroIcon = heroTalentSpecFrame:CreateTexture(nil, "ARTWORK")
heroIcon:SetAllPoints()

-- CLASS TALENT ICON
-- This creates a texture frame to load the player's talent specialization icon.
talentSpecFrame = CreateFrame("Frame", "CheckYoSpecTalentSpecIconFrame", CheckYoSpecFrame)
talentSpecFrame:SetSize(60, 60)
talentSpecFrame:SetAlpha(1)
talentSpecFrame:SetPoint("BOTTOMRIGHT", CheckYoSpecFrame, "BOTTOMRIGHT", -10, 10)
talentIcon = talentSpecFrame:CreateTexture(nil, "ARTWORK")
talentIcon:SetAllPoints()