local Client = {}
local socket = require "socket"

local json = require "lib.json"
local camera = require "lib.camera"
-- local hero = require "lib.hero"

local Gui = require "src.piggo.ui.Gui"
local Player = require "src.piggo.core.Player"
local PlayerController = require "src.piggo.core.PlayerController"

local Skelly = require "src.contrib.aram.characters.Skelly"


local load, update, draw, handleKeyPressed, handleMousePressed
local sendCommandsToServer, processServerPacket, connectToServer
local defaultHost = "localhost"
local defaultPort = 12345

-- ref https://love2d.org/wiki/Tutorial:Networking_with_UDP
-- ref https://web.archive.org/web/20200415042448/http://w3.impa.br/~diego/software/luasocket/udp.html
function Client.new(game, host, port)
    assert(game)

    -- connect to game server
    local udp = connectToServer(host or defaultHost, port or defaultPort)

    local playerName = "KetoMojito" -- TODO
    local player = Player.new(playerName, Skelly.new(game.state.world, 500, 250, 500))
    game:addPlayer(playerName, player)

    local client = {
        frameBuffer = {
            data = {},
            size = 20,
            push = function(self, data)
                if #self.data >= self.size then
                    table.remove(self.data, 1)
                end
                table.insert(self.data, data)
            end,
        },
        serverFrame = nil,
        dt = 0,
        nextFrameTarget = 0,
        framerate = 100, -- server frames per second
        load = load, update = update, draw = draw,
        handleKeyPressed = handleKeyPressed, handleMousePressed = handleMousePressed,
        sendCommandsToServer = sendCommandsToServer, processServerPacket = processServerPacket,
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
    -- debug(dt)
    self.dt = self.dt + dt

    -- debug(self.lastFrameTime)
    if self.dt - self.nextFrameTarget > 0 then
        if self.nextFrameTarget == 0 then self.nextFrameTarget = self.dt end
        self.nextFrameTarget = self.nextFrameTarget + 1.0/self.framerate

        -- process server packet
        self:processServerPacket()

        -- update game state
        self.game:update(dt)

        -- send player's commands to server
        self:sendCommandsToServer()
    end

    -- snap camera to player
    self.camera:follow(
        self.player.character.body:getX(),
        self.player.character.body:getY()
    )
    self.camera:update(dt)
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

    -- debug draw where the server thinks i am
    if debug() and self.serverFrame then
        love.graphics.setColor(1, 0, 0, 0.5)
        love.graphics.circle(
            "fill",
            self.serverFrame.gameFramePayload.players["KetoMojito"].x,
            self.serverFrame.gameFramePayload.players["KetoMojito"].y,
            10
        )
    end

    -- draw player indicators
    self.playerController:draw()

    -- draw and detach camera
    self.camera:detach()
    self.camera:draw()

    -- draw the GUI
    self.gui:draw()
end

function sendCommandsToServer(self)
    if #self.playerController.bufferedCommands > 0 then
        -- apply commands locally
        self.game:handlePlayerCommands("KetoMojito", self.playerController.bufferedCommands)

        -- send commands to server
        self.udp:send(json:encode(self.playerController.bufferedCommands))

        -- reset command buffer
        self.playerController.bufferedCommands = {}
    else
        self.udp:send(json:encode({}))
    end
end

function processServerPacket(self)
    while true do
        local packet, _ = self.udp:receive()
        if not packet then break end

        local payload = json:decode(packet)
        -- assert(payload.gameFramePayload and payload.playerFramePayload and payload.frame)

        -- debug(self.game.state.frame, payload.frame)
        if self.game.state.frame - payload.frame < 2 then
            self.game.state.frame = payload.frame + 5
        end

        self.serverFrame = payload

        -- update all player state
        -- for playerName, player in pairs(payload.gameFramePayload.players) do
        --     -- if player.x >= self.frameBuffer[payload.frame]
        --     self.game.state.players[playerName]:setPosition(
        --         player.x, player.y, player.velocity
        --     )
        -- end
    end
end

function handleKeyPressed(self, key, scancode, isrepeat, state)
    self.playerController:handleKeyPressed(
        key, scancode, isrepeat, self.camera.mx, self.camera.my, state
    )
end

function handleMousePressed(self, x, y, mouseButton, state)
    local markerX, markerY = self.camera:toWorldCoords(x, y)
    self.playerController:handleMousePressed(
        markerX, markerY, mouseButton, state
    )
end

function connectToServer(host, port)
    local udp = socket.udp()
    udp:settimeout(0)
    udp:setpeername(host, port)
    return udp
end

return Client
