local IGame = {}
local physics = require 'love.physics'
local DamageController = require "piggo-core.DamageController"

local load, update, draw
local addPlayer, addNpc, handlePlayerCommand, handleMouseMoved
local serialize, deserialize

-- IGame is a baseclass for all games
function IGame.new(gameLoad, gameUpdate, gameDraw, gameHandleMouseMoved)
    assert(gameLoad and gameUpdate and gameDraw)

    local damageController = DamageController.new()

    local iGame = {
        state = {
            players = {}, npcs = {}, hurtboxes = {}, objects = {}, terrains = {},
            world = physics.newWorld(),
            frame = 0,
            damageController = damageController,
            npcName = 1
        },
        gameLoad = gameLoad, gameUpdate = gameUpdate, gameDraw = gameDraw,
        gameHandleMouseMoved = gameHandleMouseMoved,
        load = load, update = update, draw = draw,
        handlePlayerCommand = handlePlayerCommand,
        addPlayer = addPlayer,
        addNpc = addNpc,
        serialize = serialize,
        deserialize = deserialize,
        handleMouseMoved = handleMouseMoved,
    }

    return iGame
end

function load(self)
    self:gameLoad()
end

function update(self)
    -- increment frame and dt
    self.state.frame = self.state.frame + 1

    -- update damage controller
    self.state.damageController:update(self.state)

    -- update all internal states
    for _, player in pairs(self.state.players) do player:update(self.state) end

    -- update all npcs
    for _, npc in pairs(self.state.npcs) do npc:update(self.state) end

    -- handle non-player non-npc objects
    for _, object in pairs(self.state.objects) do object:update() end

    -- update game loop
    self.gameUpdate(self)

    -- collisions
    self.state.world:update(1.0/100)
end

function draw(self, x, y)
    self.gameDraw(self, x, y)

    -- draw all terrain
    for _, terrain in pairs(self.state.terrains) do terrain:draw() end

    -- draw all players
    for _, player in pairs(self.state.players) do player:draw() end

    -- draw all npcs
    for _, npc in pairs(self.state.npcs) do npc:draw() end

    -- draw all non-npc objects
    for _, object in pairs(self.state.objects) do object:draw() end
end

-- validate/process a player command
function handlePlayerCommand(self, playerName, command)
    local player = self.state.players[playerName]
    if command.action == "stop" then
        player.state.character.state.marker = nil
        player.state.character.state.target = nil
        player.state.character.state.body:setLinearVelocity(0, 0)
    elseif command.action == "move" then
        assert(command.marker)
        player.state.character.state.marker = command.marker
    elseif command.action == "cast" then
        assert(command.ability and command.mouseX and command.mouseY)
        player.state.character.state.abilities[command.ability]:cast(player.state.character, command.mouseX, command.mouseY)
    end
end

function addPlayer(self, playerName, player)
    assert(playerName and player)
    self.state.players[playerName] = player
end

function addNpc(self, npc)
    assert(npc)
    self.state.npcs[tostring(self.state.npcName)] = npc
    self.state.npcName = self.state.npcName + 1
end

function handleMouseMoved(self, x, y, state)
    if self.gameHandleMouseMoved then
        self:gameHandleMouseMoved(x, y, state)
    end
end

-- serialize into a single table ready for json encoding
function serialize(self)
    local framedata = {
        players = {},
        npcs = {}
    }

    for playerName, player in pairs(self.state.players) do
        framedata.players[playerName] = player:serialize()
    end

    for npcName, npc in pairs(self.state.npcs) do
        framedata.npcs[npcName] = npc:serialize()
    end

    return framedata
end

function deserialize(self, framedata)
    for playerName, player in pairs(framedata.players) do
        self.state.players[playerName].state.character:setPosition(
            player.character.x,
            player.character.y,
            player.character.marker
        )
    end

    for npcName, npc in pairs(framedata.npcs) do
        -- self.state.npcs[npcName]:setPosition(
        --     npc.x,
        --     npc.y,
        --     npc.marker
        -- )
        -- log:debug(self.state.npcs[npcName].state.body:getMass())
        -- log:debug(npcName)
        -- log:debug(npc.y)
        -- log:debug(self.state.npcs[npcName].state.body:getPosition())
    end
end

return IGame
