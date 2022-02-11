debugog = debug

return function (...)
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
