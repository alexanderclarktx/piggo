local Logger = {}

require "lib/js/js" -- JS

local info, warn, error, logdebug

function Logger.new(debugFlag)
    debugog = debug
    if debugFlag then debug = true else debug = false end

    local logger = {
        debugFlag = debugFlag,
        info = info, warn = warn, error = error, debug = logdebug
    }

    return logger
end

local function writestuff(colorNumber, ...)
    if ... then
        local z = 'console.log(%s);'
        JS.callJS(z:format(...))
        -- io.write(table.concat({
        --     "\27[",
        --     tostring(colorNumber),
        --     "m[",
        --     debugog.getinfo(2).source:match("%a+.lua"),
        --     "]\27[00m "
        -- }))
        print(...)
    end
    return true
end

function info(self, ...)
    assert(type(self) == "table")
    return writestuff(32, ...)
end

function logdebug(self, ...)
    assert(type(self) == "table")
    if not self.debugFlag then return end
    return writestuff(34, ...)
end

function warn(self, ...)
    assert(type(self) == "table")
    return writestuff(35, ...)
end

function error(self, ...)
    assert(type(self) == "table")
    return writestuff(31, ...)
end

return Logger
