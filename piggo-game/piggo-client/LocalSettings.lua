local LocalSettings = {}
local json = require "lib.json"

local load, applySettings

local settingsFilePath = love.filesystem.getSaveDirectory() .. "/LocalSettings.json"

function LocalSettings.new()
    local localSettings = {
        state = {
            settings = {
                window = {
                    width = 2000,
                    height = 1200,
                    fullscreen = false,
                    borderless = false,
                    resizable = true,
                    usedpiscaling = false,
                    vsync = 0,
                    msaa = 4,
                    title = "Piggo"
                }
            },
            path = ""
        },
        load = load, applySettings = applySettings
    }
    return localSettings
end

function load(self, t)
    local settingsFile = love.filesystem.read(settingsFilePath)
    if settingsFile then
        self.state.settings = json:decode(settingsFile)
    end
    self:applySettings(t)
end

function applySettings(self, t)
    t.window.width = self.state.settings.window.width
    t.window.height = self.state.settings.window.height
    t.window.fullscreen = self.state.settings.window.fullscreen
    t.window.borderless = self.state.settings.window.borderless
    t.window.usedpiscaling = self.state.settings.window.usedpiscaling
    t.window.vsync = self.state.settings.window.vsync
    t.window.msaa = self.state.settings.window.msaa
    t.window.title = self.state.settings.window.title
    t.window.resizable = self.state.settings.window.resizable
end

return LocalSettings
