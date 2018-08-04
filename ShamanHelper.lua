local AddonName, Addon = ...

local UNIT_PLAYER = "player"
local TIDAL_WAVES = "Tidal Waves"
local TIDEBRINGER = "Tidebringer"
local EARTH_SHIELD = "Earth Shield"

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

  local earthShield = CreateFrame("Frame", nil)
  earthShield:SetPoint("TOP", tidebringer, "BOTTOM")

  earthShield:Hide()

  local earthShieldName = earthShield:CreateFontString(nil, "ARTWORK")
  earthShieldName:SetFont("Fonts\\FRIZQT__.TTF", 10, "OUTLINE")
  earthShieldName:SetVertexColor(1, 1, .5)
  earthShieldName:SetPoint("LEFT", earthShield, "LEFT")

  earthShieldName:SetText("earth shield: ")

  local earthShieldCount = earthShield:CreateFontString(nil, "ARTWORK")
  earthShieldCount:SetFont("Fonts\\FRIZQT__.TTF", 24, "OUTLINE")
  earthShieldCount:SetVertexColor(.5, 1, .5)
  earthShieldCount:SetPoint("LEFT", earthShieldName, "RIGHT")

  -- -- debug
  -- earthShieldCount:SetText("5")

  self.earthShield = earthShield
  self.earthShieldName = earthShieldName
  self.earthShieldCount = earthShieldCount

  self:ResizeEarthShield()
end

function Addon:ResizeTidalWaves()
  self.tidalWaves:SetWidth(self.tidalWavesCount:GetStringWidth() + self.tidalWavesDuration:GetStringWidth())
  self.tidalWaves:SetHeight(self.tidalWavesCount:GetStringHeight() + self.tidalWavesDuration:GetStringHeight())
end

function Addon:ResizeTidebringer()
  self.tidebringer:SetWidth(self.tidebringerName:GetStringWidth() + self.tidebringerCount:GetStringWidth())
  self.tidebringer:SetHeight(self.tidebringerName:GetStringHeight() + self.tidebringerCount:GetStringHeight())
end

function Addon:ResizeEarthShield()
  self.earthShield:SetWidth(self.earthShieldName:GetStringWidth() + self.earthShieldCount:GetStringWidth())
  self.earthShield:SetHeight(self.earthShieldName:GetStringHeight() + self.earthShieldCount:GetStringHeight())
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

function Addon:HandleEarthShield(count)
  self:SetCount(self.earthShieldCount, count)

  if self.handlingEarthShield then
    return
  end

  self.earthShield:SetScript("OnUpdate", function(frame, elapsed)
    Addon:OnUpdateearthShield(elapsed)
  end)

  if not self.earthShield:IsVisible() then
    self.earthShield:Show()
  end

  self:ResizeEarthShield()

  self.handlingEarthShield = true
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

function Addon:DisableEarthShield()
  self.earthShield:SetScript("OnUpdate", nil)

  if self.earthShield:IsVisible() then
    self.earthShield:Hide()
  end

  self:SetCount(self.earthShieldCount, 0)

  self.lastEarthShieldUpdate = 0

  self.handlingEarthShield = false
end

function Addon:OnUpdateearthShield(elapsed)
  self.lastEarthShieldUpdate = self.lastEarthShieldUpdate + elapsed

  if self.lastEarthShieldUpdate < UPDATE_INTERVAL then
    return
  end

  if not UnitAffectingCombat(UNIT_PLAYER) and self.lastEarthShieldUpdate < OOC_UPDATE_INTERVAL then
    return
  end

  local buff, _, count = AuraUtil.FindAuraByName(EARTH_SHIELD, UNIT_PLAYER)
  if not buff then
    return self:DisableEarthShield()
  end

  self:SetCount(self.earthShieldCount, count)

  self.lastEarthShieldUpdate = 0
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

  local earthShield, _, earthShieldCount, _, _, earthShieldExpirationTime = AuraUtil.FindAuraByName(EARTH_SHIELD, UNIT_PLAYER)
  if (earthShield) then
    self:HandleEarthShield(earthShieldCount)
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

    self.handlingEarthShield = false
    self.lastEarthShieldUpdate = 0
  end
end

Addon:Load()
