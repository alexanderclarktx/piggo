local Client = {}
local socket = require "socket"

local json = require "lib.json"
local camera = require "lib.camera"
-- local hero = require "lib.hero"

local Gui = require "src.piggo.ui.Gui"
local Player = require "src.piggo.core.Player"
local PlayerController = require "src.piggo.core.PlayerController"

local Skelly = require "src.contrib.aram.characters.Skelly"


local load, update, draw, handleKeyPressed
local defaultHost = "localhost"
local defaultPort = 12345

-- ref https://love2d.org/wiki/Tutorial:Networking_with_UDP
-- ref https://web.archive.org/web/20200415042448/http://w3.impa.br/~diego/software/luasocket/udp.html
function Client.new(game, host, port)
    assert(game)
    -- connect to server
    local udp = socket.udp()
    udp:settimeout(0)
    udp:setpeername(host or defaultHost, port or defaultPort)

    -- print(udp:send("hello world"))
    -- -- connect (blocking)
    -- local payload, msg = udp:receive()
    -- if payload then
    --     -- debug(payload)
    --     local state = json:decode(payload)
    --     state.world = hero.load(state.world)
    --     self.game.state = state

    --     player = state.players[1]
    -- else print(msg) end
    -- print(player)

    -- -- don't block once we've connected
    -- udp:settimeout(0)
    -- -- debug(player)

    local player = Player.new("p1", Skelly.new(game.state.world, 500, 250, 500))
    game:addPlayer(player)

    local client = {
        load = load, update = update, draw = draw, handleKeyPressed = handleKeyPressed,
        host = host or defaultHost, port = port or defaultPort,
        udp = udp, game = game, player = player,
        gui = Gui.new(player), playerController = PlayerController.new(player),
        camera = camera()
    }

    return client
end

function load(self)
    self.game:load()

    love.mouse.setGrabbed(true)

    -- camera fade in
    self.camera.fade_color = {0, 0, 0, 1}
    self.camera:fade(2, {0, 0, 0, 0})
end

function update(self, dt)
    -- snap camera to player
    self.camera:follow(
        self.player.character.body:getX(),
        self.player.character.body:getY()
    )
    self.camera:update(dt)

    -- update player controller
    self.playerController:update(dt, self.camera.mx, self.camera.my, self.game.state)

    -- send actions to server
    self.udp:send("hello world")
    self.udp:send(json:encode({
        marker = {
            x = 50,
            y = 200
        }
    }))

    local payload, _ = self.udp:receive()
    if payload then
        debug("got something from server")

        local data = json:decode(payload)
        self.game.state.players[1].character.body:setX(data.x)
        self.game.state.players[1].character.body:setY(data.y)

        -- state.world = hero.load(state.world)
        -- self.game.state = state
    end

    -- self.game:update(dt)
end

function draw(self)
    -- attach camera
    self.camera:attach()

    -- draw all terrain
    for _, terrain in pairs(self.game.state.terrains) do terrain:draw() end

    -- draw all players
    for _, player in pairs(self.game.state.players) do player:draw() end

    -- draw all npcs
    for _, npc in pairs(self.game.state.npcs) do npc:draw() end

    -- draw all non-npc objects
    for _, object in pairs(self.game.state.objects) do object:draw() end

    -- draw game-specific things
    self.game:draw()

    -- draw player indicators
    self.playerController:draw()

    -- draw and detach camera
    self.camera:detach()
    self.camera:draw()

    -- draw the GUI
    self.gui:draw()
end

function handleKeyPressed(self, key, scancode, isrepeat)
    self.playerController:handleKeyPressed(
        key, scancode, isrepeat, self.camera.mx, self.camera.my
    )
end

return Client
