local AddonName, Addon = ...

local UNIT_PLAYER = "player"
local TIDAL_WAVES = "Tidal Waves"
local TIDEBRINGER = "Tidebringer"
local JONATS_FOCUS = "Jonat's Focus"

local UPDATE_INTERVAL = .5
local OOC_UPDATE_INTERVAL = 2

local AuraUtil = AuraUtil

function Addon:ADDON_LOADED(name)
  if name ~= AddonName then
    return
  end

  self.eventHandler:UnregisterEvent("ADDON_LOADED")
end

function Addon:PLAYER_LOGIN()
  self:SetupFrames()

  self.eventHandler:UnregisterEvent("PLAYER_LOGIN")
end

function Addon:FormatDuration(duration)
  return duration .. "s"
end

function Addon:SetCount(frame, count)
  frame:SetText(count)
end

function Addon:SetDuration(frame, duration)
  frame:SetText(self:FormatDuration(duration))
end

function Addon:SetupFrames()
  -- local frame = CreateFrame("Frame", nil)
  -- frame:SetPoint("CENTER", "UIParent", "CENTER", 0)
  --
  -- frame:SetHeight(175)
  -- frame:SetWidth(175)

  local tidalWaves = CreateFrame("Frame", "TidalWavesTracker")
  tidalWaves:SetPoint("CENTER", "UIParent", "CENTER")

  tidalWaves:Hide()

  -- tidalWaves:SetPoint("TOPLEFT", frame, "TOPLEFT")

  local tidalWavesCount = tidalWaves:CreateFontString(nil, "ARTWORK")
  tidalWavesCount:SetFont("Fonts\\FRIZQT__.TTF", 24, "OUTLINE")
  tidalWavesCount:SetVertexColor(.5, 1, .5)
  tidalWavesCount:SetPoint("LEFT", tidalWaves, "LEFT")

  -- -- debug
  -- tidalWavesCount:SetText("3")

  local tidalWavesDuration = tidalWaves:CreateFontString(nil, "ARTWORK")
  tidalWavesDuration:SetFont("Fonts\\FRIZQT__.TTF", 12, "OUTLINE")
  tidalWavesDuration:SetVertexColor(1, 1, .5)
  tidalWavesDuration:SetPoint("LEFT", tidalWavesCount, "RIGHT")

  -- -- debug
  -- tidalWavesDuration:SetText("12s")

  -- self.frame = frame

  self.tidalWaves = tidalWaves
  self.tidalWavesCount = tidalWavesCount
  self.tidalWavesDuration = tidalWavesDuration

  self:ResizeTidalWaves()

  -- test

  local tidebringer = CreateFrame("Frame", nil)
  tidebringer:SetPoint("TOP", tidalWaves, "BOTTOM")

  tidebringer:Hide()

  local tidebringerName = tidebringer:CreateFontString(nil, "ARTWORK")
  tidebringerName:SetFont("Fonts\\FRIZQT__.TTF", 10, "OUTLINE")
  tidebringerName:SetVertexColor(1, 1, .5)
  tidebringerName:SetPoint("LEFT", tidebringer, "LEFT")

  tidebringerName:SetText("tidebringer: ")

  local tidebringerCount = tidebringer:CreateFontString(nil, "ARTWORK")
  tidebringerCount:SetFont("Fonts\\FRIZQT__.TTF", 24, "OUTLINE")
  tidebringerCount:SetVertexColor(.5, 1, .5)
  tidebringerCount:SetPoint("LEFT", tidebringerName, "RIGHT")

  -- -- debug
  -- tidebringerCount:SetText("2")

  self.tidebringer = tidebringer
  self.tidebringerName = tidebringerName
  self.tidebringerCount = tidebringerCount

  self:ResizeTidebringer()

  -- test 2

  local jonatsFocus = CreateFrame("Frame", nil)
  jonatsFocus:SetPoint("TOP", tidebringer, "BOTTOM")

  jonatsFocus:Hide()

  local jonatsFocusName = jonatsFocus:CreateFontString(nil, "ARTWORK")
  jonatsFocusName:SetFont("Fonts\\FRIZQT__.TTF", 10, "OUTLINE")
  jonatsFocusName:SetVertexColor(1, 1, .5)
  jonatsFocusName:SetPoint("LEFT", jonatsFocus, "LEFT")

  jonatsFocusName:SetText("jonat's focus: ")

  local jonatsFocusCount = jonatsFocus:CreateFontString(nil, "ARTWORK")
  jonatsFocusCount:SetFont("Fonts\\FRIZQT__.TTF", 24, "OUTLINE")
  jonatsFocusCount:SetVertexColor(.5, 1, .5)
  jonatsFocusCount:SetPoint("LEFT", jonatsFocusName, "RIGHT")

  -- -- debug
  -- jonatsFocusCount:SetText("5")

  self.jonatsFocus = jonatsFocus
  self.jonatsFocusName = jonatsFocusName
  self.jonatsFocusCount = jonatsFocusCount

  self:ResizeJonatsFocus()
end

function Addon:ResizeTidalWaves()
  self.tidalWaves:SetWidth(self.tidalWavesCount:GetStringWidth() + self.tidalWavesDuration:GetStringWidth())
  self.tidalWaves:SetHeight(self.tidalWavesCount:GetStringHeight() + self.tidalWavesDuration:GetStringHeight())
end

function Addon:ResizeTidebringer()
  self.tidebringer:SetWidth(self.tidebringerName:GetStringWidth() + self.tidebringerCount:GetStringWidth())
  self.tidebringer:SetHeight(self.tidebringerName:GetStringHeight() + self.tidebringerCount:GetStringHeight())
end

function Addon:ResizeJonatsFocus()
  self.jonatsFocus:SetWidth(self.jonatsFocusName:GetStringWidth() + self.jonatsFocusCount:GetStringWidth())
  self.jonatsFocus:SetHeight(self.jonatsFocusName:GetStringHeight() + self.jonatsFocusCount:GetStringHeight())
end

function Addon:HandleTidalWaves(count, expirationTime)
  local duration = math.floor(expirationTime - GetTime())

  self:SetCount(self.tidalWavesCount, count)
  self:SetDuration(self.tidalWavesDuration, duration)

  if self.handlingTidalWaves then
    return
  end

  self.tidalWaves:SetScript("OnUpdate", function(frame, elapsed)
    Addon:OnUpdateTidalWaves(elapsed)
  end)

  if not self.tidalWaves:IsVisible() then
    self.tidalWaves:Show()
  end

  self:ResizeTidalWaves()

  self.handlingTidalWaves = true
end

function Addon:HandleTidebringer(count)
  self:SetCount(self.tidebringerCount, count)

  if self.handlingTidebringer then
    return
  end

  self.tidebringer:SetScript("OnUpdate", function(frame, elapsed)
    Addon:OnUpdateTidebringer(elapsed)
  end)

  if not self.tidebringer:IsVisible() then
    self.tidebringer:Show()
  end

  self:ResizeTidebringer()

  self.handlingTidebringer = true
end

function Addon:HandleJonatsFocus(count)
  self:SetCount(self.jonatsFocusCount, count)

  if self.handlingJonatsFocus then
    return
  end

  self.jonatsFocus:SetScript("OnUpdate", function(frame, elapsed)
    Addon:OnUpdateJonatsFocus(elapsed)
  end)

  if not self.jonatsFocus:IsVisible() then
    self.jonatsFocus:Show()
  end

  self:ResizeJonatsFocus()

  self.handlingjonatsFocus = true
end

function Addon:DisableTidalWaves()
  self.tidalWaves:SetScript("OnUpdate", nil)

  if self.tidalWaves:IsVisible() then
    self.tidalWaves:Hide()
  end

  self:SetCount(self.tidalWavesCount, 0)
  self:SetDuration(self.tidalWavesDuration, 0)

  self.lastTidalWavesUpdate = 0

  self.handlingTidalWaves = false
end

function Addon:OnUpdateTidalWaves(elapsed)
  self.lastTidalWavesUpdate = self.lastTidalWavesUpdate + elapsed

  if self.lastTidalWavesUpdate < UPDATE_INTERVAL then
    return
  end

  local buff, _, count, _, _, expirationTime = AuraUtil.FindAuraByName(TIDAL_WAVES, UNIT_PLAYER)
  if not buff then
    return self:DisableTidalWaves()
  end

  local duration = math.floor(expirationTime - GetTime())

  self:SetCount(self.tidalWavesCount, count)
  self:SetDuration(self.tidalWavesDuration, duration)

  self.lastTidalWavesUpdate = 0
end

function Addon:DisableTidebringer()
  self.tidebringer:SetScript("OnUpdate", nil)

  if self.tidebringer:IsVisible() then
    self.tidebringer:Hide()
  end

  self:SetCount(self.tidebringerCount, 0)

  self.lastTidebringerUpdate = 0

  self.handlingTidebringer = false
end

function Addon:OnUpdateTidebringer(elapsed)
  self.lastTidebringerUpdate = self.lastTidebringerUpdate + elapsed

  if self.lastTidebringerUpdate < UPDATE_INTERVAL then
    return
  end

  if not UnitAffectingCombat(UNIT_PLAYER) and self.lastTidebringerUpdate < OOC_UPDATE_INTERVAL then
    return
  end

  local buff, _, count = AuraUtil.FindAuraByName(TIDEBRINGER, UNIT_PLAYER)
  if not buff then
    return self:DisableTidebringer()
  end

  self:SetCount(self.tidebringerCount, count)

  self.lastTidebringerUpdate = 0
end

function Addon:DisableJonatsFocus()
  self.jonatsFocus:SetScript("OnUpdate", nil)

  if self.jonatsFocus:IsVisible() then
    self.jonatsFocus:Hide()
  end

  self:SetCount(self.jonatsFocusCount, 0)

  self.lastJonatsFocusUpdate = 0

  self.handlingJonatsFocus = false
end

function Addon:OnUpdateJonatsFocus(elapsed)
  self.lastJonatsFocusUpdate = self.lastJonatsFocusUpdate + elapsed

  if self.lastJonatsFocusUpdate < UPDATE_INTERVAL then
    return
  end

  if not UnitAffectingCombat(UNIT_PLAYER) and self.lastJonatsFocusUpdate < OOC_UPDATE_INTERVAL then
    return
  end

  local buff, _, count = AuraUtil.FindAuraByName(JONATS_FOCUS, UNIT_PLAYER)
  if not buff then
    return self:DisableJonatsFocus()
  end

  self:SetCount(self.jonatsFocusCount, count)

  self.lastJonatsFocusUpdate = 0
end

function Addon:UNIT_AURA(unit)
  if unit ~= "player" then
    return
  end

  local tidalWaves, _, tidalWavesCount, _, _, tidalWavesExpirationTime = AuraUtil.FindAuraByName(TIDAL_WAVES, UNIT_PLAYER)
  if (tidalWaves) then
    self:HandleTidalWaves(tidalWavesCount, tidalWavesExpirationTime)
  end

  local tidebringer, _, tidebringerCount, _, _, tidebringerExpirationTime = AuraUtil.FindAuraByName(TIDEBRINGER, UNIT_PLAYER)
  if (tidebringer) then
    self:HandleTidebringer(tidebringerCount)
  end
end

do
  function Addon:OnEvent(event, ...)
    local action = self[event]

    if action then
      action(self, ...)
    end
  end

  function Addon:Load()
    local eventHandler = CreateFrame("Frame", nil)

    eventHandler:SetScript("OnEvent", function(handler, ...)
      self:OnEvent(...)
    end)

    eventHandler:RegisterEvent("PLAYER_LOGIN")
    eventHandler:RegisterUnitEvent("UNIT_AURA", "player")

    self.eventHandler = eventHandler

    self.handlingTidalWaves = false
    self.lastTidalWavesUpdate = 0

    self.handlingTidebringer = false
    self.lastTidebringerUpdate = 0

    self.handlingJonatsFocus = false
    self.lastJonatsFocusUpdate = 0
  end
end

Addon:Load()
