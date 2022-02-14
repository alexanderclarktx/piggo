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

function info(...)
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

function logdebug(...)
    if type(...) == "function" then
        -- return true
    end
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

function warn(...)

end

function error(...)

end

return Logger
