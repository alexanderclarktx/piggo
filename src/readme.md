lua source code

## OO in Lua
Lua has no built in inheritance model, but there are a few ways it can be emulated

I've decided against using any OOP library

### classes
classes (files which create instance objects)

```lua
local MyClass = {} -- lua file exports this class as a table

local update, draw -- locally scoped methods (later attached to instance)

local a = "a" -- locally scoped variable (later attached to instance)

function MyClass.new(constructorArg)
    return {
        constructorArg = constructorArg, -- attach constructor argument to the instance
        update = update, draw = draw, -- attach instance methods
        varA = "a", varNil = nil, -- attach member variables
    }
end

function update(self, dt) end -- called like: myClass:update(dt)

function draw(self) end -- called like: myClass:draw()

return MyClass -- export class table, only callable method is MyClass.new
```

### pseudo inheritance

some classes are written using pseudo inheritance (see [Minion.lua](./character/Minion.lua) and [ICharacter.lua](./character/ICharacter.lua)). The mechanism is that `IBaseClass` wraps an instance of `SubClass`

```lua
local IBaseClass = {}

function IBaseClass.new(varA, subClassUpdate, subClassDraw)
    assert(varA) -- fail fast
    return {
        varA = varA
        subClassUpdate = subClassUpdate, subClassDraw = subClassDraw
    }
end

function update(self, dt)
    print("updating baseclass")
    self.subClassUpdate(self, dt)
end

function draw(self)
    print("drawing baseclass")
    self.subClassDraw(self, dt)
end

return IBaseClass
```

```lua
local SubClass = {}

local update, draw

function ISubClass.new()
    return IBaseClass("a", update, draw)
end

function update(self, dt) print("updating subclass") end

function draw(self) print("drawing subclass") end

return SubClass
```

## Code Styling

```
indentation is 4 spaces
```