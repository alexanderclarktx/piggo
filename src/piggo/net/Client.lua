local Client = {}
local socket = require "socket"
local json = require "lib.json"
local camera = require "lib.camera"
local TableUtils = require "src.piggo.util.TableUtils"
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
        state = {
            camera = camera(),
            dt = 0,
            frameBuffer = {},
            framerate = 100,
            game = game,
            gui = Gui.new(player),
            host = host or defaultHost,
            nextFrameTime = 0,
            player = player,
            playerController = PlayerController.new(player),
            port = port or defaultPort,
            serverFrame = nil,
            udp = udp,
        },
        handleKeyPressed = handleKeyPressed,
        handleMousePressed = handleMousePressed,
        load = load, update = update, draw = draw,
        processServerPacket = processServerPacket,
        sendCommandsToServer = sendCommandsToServer,
    }

    return client
end

function load(self)
    self.state.game:load()

    love.mouse.setGrabbed(true)

    -- camera fade in
    self.state.camera.fade_color = {0, 0, 0, 1}
    self.state.camera:fade(2, {0, 0, 0, 0})
end

function update(self, dt)
    -- log:debug(dt)
    self.state.dt = self.state.dt + dt

    -- log:debug(self.lastFrameTime)
    if self.state.dt - self.state.nextFrameTime > 0 then
        if self.state.nextFrameTime == 0 then self.state.nextFrameTime = self.state.dt end
        self.state.nextFrameTime = self.state.nextFrameTime + 1.0/self.state.framerate

        -- process server packet
        self:processServerPacket()

        -- send player's commands to server
        self:sendCommandsToServer()

        -- update game state
        self.state.game:update(dt)

        -- TODO move this
        self.state.frameBuffer[self.state.game.state.frame] = self.state.game:serialize()
    end

    -- snap camera to player
    self.state.camera:follow(
        self.state.player.state.character.state.body:getX(),
        self.state.player.state.character.state.body:getY()
    )
    self.state.camera:update(dt)
end

function draw(self)
    -- attach camera
    self.state.camera:attach()

    -- draw all terrain
    for _, terrain in pairs(self.state.game.state.terrains) do terrain:draw() end

    -- draw all players
    for _, player in pairs(self.state.game.state.players) do player:draw() end

    -- draw all npcs
    for _, npc in pairs(self.state.game.state.npcs) do npc:draw() end

    -- draw all non-npc objects
    for _, object in pairs(self.state.game.state.objects) do object:draw() end

    -- draw game-specific things
    self.state.game:draw()

    -- debug draw where the server thinks i am
    if debug and self.state.serverFrame then
        love.graphics.setColor(0, 1, 0.9, 0.5)
        love.graphics.circle(
            "fill",
            self.state.serverFrame.gameFramePayload.players["KetoMojito"].character.x,
            self.state.serverFrame.gameFramePayload.players["KetoMojito"].character.y,
            10
        )
    end

    -- draw player indicators
    self.state.playerController:draw()

    -- draw and detach camera
    self.state.camera:detach()
    self.state.camera:draw()

    -- draw the GUI
    self.state.gui:draw()
end

function sendCommandsToServer(self)
    if #self.state.playerController.bufferedCommands > 0 then
        -- apply commands locally
        for _, command in ipairs(self.state.playerController.bufferedCommands) do
            self.state.game:handlePlayerCommand("KetoMojito", command)
        end

        -- send commands to server
        self.state.udp:send(json:encode(self.state.playerController.bufferedCommands))

        -- reset command buffer
        self.state.playerController.bufferedCommands = {}
    else
        self.state.udp:send(json:encode({}))
    end
end

function processServerPacket(self)
    while true do
        local packet, _ = self.state.udp:receive()
        if not packet then break end

        local payload = json:decode(packet)
        -- assert(payload.gameFramePayload and payload.playerFramePayload and payload.frame)

        -- log:debug(self.state.game.state.frame, payload.frame)
        if self.state.game.state.frame - payload.frame < 2 then
            log:warn("frame +5")
            self.state.game.state.frame = payload.frame + 5
        end

        self.state.serverFrame = payload

        if TableUtils.deep_compare(
            payload.gameFramePayload,
            self.state.frameBuffer[payload.frame]
        ) then
            -- log:info("frames matched")
        else
            log:warn("client rollback")
            -- frame to roll forward
            local frameForward = self.state.game.state.frame

            -- set the frame counter
            self.state.game.state.frame = payload.frame

            -- set the game state
            self.state.game:deserialize(payload.gameFramePayload)

            -- game update
            for i = payload.frame, frameForward - 1, 1 do
                self.state.game:update()
            end
        end
    end
end

function handleKeyPressed(self, key, scancode, isrepeat, state)
    self.state.playerController:handleKeyPressed(
        key, scancode, isrepeat, self.state.camera.mx, self.state.camera.my, state
    )
end

function handleMousePressed(self, x, y, mouseButton, state)
    local markerX, markerY = self.state.camera:toWorldCoords(x, y)
    self.state.playerController:handleMousePressed(
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
