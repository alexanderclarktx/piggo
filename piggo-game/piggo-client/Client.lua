local Client = {}
local camera = require "lib.camera"
local Gui = require "piggo-client.ui.Gui"
local json = require "lib.json"
local Player = require "piggo-core.Player"
local PlayerController = require "piggo-client.PlayerController"
local Skelly = require "piggo-contrib.characters.Skelly"
local Cardflipper = require "piggo-contrib.characters.Cardflipper"
local socket = require "socket"
local wsClient = require("lib/wsclient")
local TableUtils = require "piggo-core.util.TableUtils"

local load, update, draw, handleKeyPressed, handleMousePressed, handleMouseMoved
local sendCommandsToServer, processLatestServerPacket, connectToServer
local defaultHost = "localhost"
-- local defaultHost = "piggo.io"
local defaultPort = 12345

function Client.new(game, host, port)
    assert(game)

    local playerName = "KetoMojito" -- TODO
    local player = Player.new(playerName, Cardflipper.new(game.state.world, 200, 500))
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
            wsClient = connectToServer(host or defaultHost, port or defaultPort),
        },
        handleKeyPressed = handleKeyPressed,
        handleMousePressed = handleMousePressed,
        handleMouseMoved = handleMouseMoved,
        load = load, update = update, draw = draw,
        processLatestServerPacket = processLatestServerPacket,
        sendCommandsToServer = sendCommandsToServer,
    }

    return client
end

function load(self)
    self.state.game:load()

    love.mouse.setGrabbed(true)

    -- camera fade in
    self.state.camera.fade_color = {0, 0, 0, 1}
    self.state.camera:fade(1, {0, 0, 0, 0})
end

function update(self, dt, state)
    self.state.dt = self.state.dt + dt

    self.state.wsClient:update()

    -- log:debug(self.lastFrameTime)
    if self.state.dt - self.state.nextFrameTime > 0 then
        if self.state.nextFrameTime == 0 then self.state.nextFrameTime = self.state.dt end
        self.state.nextFrameTime = self.state.nextFrameTime + 1.0/self.state.framerate

        -- process server packet
        -- self:processLatestServerPacket()

        -- update the player controller
        local markerX, markerY = self.state.camera:toWorldCoords(love.mouse.getPosition())
        self.state.playerController:update(markerX, markerY, state)

        -- send player's commands to server
        self:sendCommandsToServer()

        -- update game state
        self.state.game:update()

        -- TODO
        for _, terrain in ipairs(self.state.game.state.terrains) do
            terrain:update()
        end

        -- TODO move this
        self.state.frameBuffer[self.state.game.state.frame] = self.state.game:serialize()

        -- snap camera to player
        self.state.camera:follow(
            self.state.player.state.character.state.body:getX(),
            self.state.player.state.character.state.body:getY()
        )
        self.state.camera:update(dt)
    end
end

function draw(self)
    -- attach camera
    self.state.camera:attach()

    -- draw game-specific things
    self.state.game:draw(self.state.camera.x, self.state.camera.y)

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
            log:info("commands locally")
            self.state.game:handlePlayerCommand("KetoMojito", command)
        end

        -- send commands to server
        self.state.wsClient:send(json:encode({
            name = self.state.player.state.name,
            commands = self.state.playerController.bufferedCommands
        }))
        log:info("sent command to server")

        -- reset command buffer
        self.state.playerController.bufferedCommands = {}
    else
        -- log:info("sent empty over connection")
    end
end

function processLatestServerPacket(self)
    local latestPayload = nil
    -- while true do
    --     -- get packet from the socket
    --     local packet, _ = self.state.udp:receive()
    --     if not packet then break end

    --     -- update latestPayload if this data is newer
    --     local payload = json:decode(packet)
    --     if latestPayload == nil or latestPayload.frame < payload.frame then
    --         latestPayload = payload
    --     end
    -- end

    if not latestPayload then return end

    if self.state.game.state.frame - latestPayload.frame < 2 then
        log:warn("frame +5")
        self.state.game.state.frame = latestPayload.frame + 5
    end

    self.state.serverFrame = latestPayload

    if TableUtils.deep_compare(
        latestPayload.gameFramePayload,
        self.state.frameBuffer[latestPayload.frame]
    ) then
        -- log:info("frames matched")
    else
        -- log:debug(json:encode(self.state.frameBuffer[latestPayload.frame]))
        -- log:debug(json:encode(latestPayload.gameFramePayload.npcs))
        log:warn("client rollback")
        -- frame to roll forward
        -- local frameForward = self.state.game.state.frame
        local frameForward = latestPayload.frame + 5

        -- set the frame counter
        self.state.game.state.frame = latestPayload.frame

        -- set the game state
        self.state.game:deserialize(latestPayload.gameFramePayload)
        self.state.frameBuffer[self.state.game.state.frame] = self.state.game:serialize()

        -- game update
        for i = latestPayload.frame, frameForward - 1, 1 do
            self.state.game:update()
            -- TODO move this
            self.state.frameBuffer[self.state.game.state.frame] = self.state.game:serialize()
        end
        -- log:debug(json:encode(self.state.frameBuffer[latestPayload.frame]))
    end
end

function handleKeyPressed(self, key, scancode, isrepeat, state)
    self.state.playerController:handleKeyPressed(
        key, scancode, isrepeat, self.state.camera.mx, self.state.camera.my, state
    )
end

function handleMousePressed(self, x, y, mouseButton, state)
end
 
function handleMouseMoved(self, x, y, state)
    local markerX, markerY = self.state.camera:toWorldCoords(x, y)

    -- self.state.playerController:handleMouseMoved(
    --     markerX, markerY, state
    -- )

    -- self.state.gui:handleMouseMoved(
    --     markerX, markerY, state
    -- )

    self.state.game:handleMouseMoved(
        markerX, markerY, state
    )
end

function connectToServer(host, port)
    log:info("connecting to server")
    local z = wsClient.new("localhost", 12345, "/")
    function z:onmessage(s) log:info("message", s) end
    function z:onopen() log:info("connected") end
    function z:onclose(code, reason) log:warn("close") end
    function z:onerror(e) log:error("error") end
    return z
end

return Client
