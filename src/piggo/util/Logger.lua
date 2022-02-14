local Logger = {}

local info, warn, error, logdebug

function Logger.new(debugFlag)
    debugog = debug
    -- debug = function() return debugFlag end
    if debugFlag then debug = true else debug = false end

    local logger = {
        debugFlag = debugFlag,
        info = info, warn = warn, error = error, debug = logdebug
    }

    return logger
end

function info(self, ...)
    assert(type(self) == "table")
    if ... then
        io.write(
            "\27[32m[" ..
            debugog.getinfo(2).source:match("%a+.lua") ..
            "]\27[00m "
        )
        print(...)
    end
    return true
end

function logdebug(self, ...)
    assert(type(self) == "table")
    if not self.debugFlag then return end
    if ... then
        io.write(
            "\27[34m[" ..
            debugog.getinfo(2).source:match("%a+.lua") ..
            "]\27[00m "
        )
        print(...)
    end
    return true
end

function warn(self, ...)
    assert(type(self) == "table")
    if ... then
        io.write(
            "\27[35m[" ..
            debugog.getinfo(2).source:match("%a+.lua") ..
            "]\27[00m "
        )
        print(...)
    end
    return true
end

function error(self, ...)
    assert(type(self) == "table")
    if ... then
        io.write(
            "\27[31m[" ..
            debugog.getinfo(2).source:match("%a+.lua") ..
            "]\27[00m "
        )
        print(...)
    end
    return true
end

return Logger
