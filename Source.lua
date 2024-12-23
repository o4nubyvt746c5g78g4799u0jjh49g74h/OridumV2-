getgenv().Ordium = {
    SilentAim = { 
        Key = "C",
        Enabled = false,
        Prediction = 0.119,
        AimingType = "Closest Part", -- Closest Part, Default
        AimPart = "HumanoidRootPart",

        ChanceData = {UseChance = false, Chance = 100},
        FOVData = {Radius = 100, Visibility = false, Filled = false},

        AimingData = {CheckKnocked = true, CheckGrabbed = true,
        CheckWalls = true},

    },
    Tracing = {
        Key = 'E',
         Enabled = true,
          Prediction = 09,
          AimPart = "Head",
        TracingOptions = {Strength = "Hard", AimingType = "Default",  Smoothness = 0.245}
                            -- Hard, Soft               
    },
    a360 = {
        Toggle = false,
          RotationSpeed = 2500, 
        Keybind = Enum.KeyCode.V

    },
    Macro = {
        Enabled = true,
          Speed = 0.065,
       Type = "---",
    },
    NoJumpCooldown = {
        Enabled = false,
  },
}










local cam = workspace.CurrentCamera
local x = cam.ViewportSize.X
local y = cam.ViewportSize.Y
local newx = math.floor(x * 0.51)
local newy = math.floor(y * 0.44)

local SpashScreen = Instance.new("ScreenGui")
local Image = Instance.new("ImageLabel")
SpashScreen.Name = "SpashScreen"
SpashScreen.Parent = game.CoreGui
SpashScreen.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
Image.Name = "Image"
Image.Parent = SpashScreen
Image.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Image.BackgroundTransparency = 1
Image.Position = UDim2.new(0, newx, 0, newy)
Image.Size = UDim2.new(0, 500, 0, 300)
Image.Image = "rbxassetid://111282042799862"
Image.ImageTransparency = 1
Image.AnchorPoint = Vector2.new(0.5, 0.5)

local Blur = Instance.new("BlurEffect")
Blur.Parent = game.Lighting
Blur.Size = 0
Blur.Name = math.random(1, 123123)

local function gui(last, sex, t, s, inorout)
    local TI = TweenInfo.new(t or 1, s or Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
    local Tweening = game:GetService("TweenService"):Create(last, TI, sex)
    Tweening:Play()
end

gui(Image, { ImageTransparency = 0 }, 0.3)
gui(Blur, { Size = 20 }, 0.3)
wait(3)
gui(Image, { ImageTransparency = 1 }, 0.3)
gui(Blur, { Size = 0 }, 0.3)
wait(0.3)
wait(0.5)
wait(0.5)














local Ordium = {functions = {}}
local Vector2New = Vector2.new
local Cam = game.Workspace.CurrentCamera
local Mouse = game.Players.LocalPlayer:GetMouse()
local client = game.Players.LocalPlayer
local find = table.find
local Draw = Drawing.new
local Inset = game:GetService("GuiService"):GetGuiInset().Y
local players = game.Players
local RunService = game:GetService("RunService")
local UIS = game:GetService('UserInputService')


local mf, rnew = math.floor, Random.new

local Targetting
local lockedCamTo

local Circle = Draw("Circle")
Circle.Thickness = 1
Circle.Transparency = 0.7
Circle.Color = Color3.new(1,1,1)

Ordium.functions.update_FOVs = function ()
    if not (Circle) then
        return Circle
    end
    Circle.Radius =  getgenv().Ordium.SilentAim.FOVData.Radius * 3
    Circle.Visible = getgenv().Ordium.SilentAim.FOVData.Visibility
    Circle.Filled = getgenv().Ordium.SilentAim.FOVData.Filled
    Circle.Position = UIS:GetMouseLocation()
    return Circle
end

Ordium.functions.onKeyPress = function(inputObject)
    if inputObject.KeyCode == Enum.KeyCode[getgenv().Ordium.SilentAim.Key:upper()] then
        getgenv().Ordium.SilentAim.Enabled = not getgenv().Ordium.SilentAim.Enabled
    end

    if inputObject.KeyCode == Enum.KeyCode[getgenv().Ordium.Tracing.Key:upper()] then
        getgenv().Ordium.Tracing.Enabled = not getgenv().Ordium.Tracing.Enabled
        if getgenv().Ordium.Tracing.Enabled then
            lockedCamTo = Ordium.functions.returnClosestPlayer(getgenv().Ordium.SilentAim.ChanceData.Chance)
        end
    end
end

UIS.InputBegan:Connect(Ordium.functions.onKeyPress)


Ordium.functions.wallCheck = function(direction, ignoreList)
    if not getgenv().Ordium.SilentAim.AimingData.CheckWalls then
        return true
    end

    local ray = Ray.new(Cam.CFrame.p, direction - Cam.CFrame.p)
    local part, _, _ = game:GetService("Workspace"):FindPartOnRayWithIgnoreList(ray, ignoreList)

    return not part
end

Ordium.functions.pointDistance = function(part)
    local OnScreen = Cam.WorldToScreenPoint(Cam, part.Position)
    if OnScreen then
        return (Vector2New(OnScreen.X, OnScreen.Y) - Vector2New(Mouse.X, Mouse.Y)).Magnitude
    end
end

Ordium.functions.returnClosestPart = function(Character)
    local data = {
        dist = math.huge,
        part = nil,
        filteredparts = {},
        classes = {"Part", "BasePart", "MeshPart"}
    }

    if not (Character and Character:IsA("Model")) then
        return data.part
    end
    local children = Character:GetChildren()
    for _, child in pairs(children) do
        if table.find(data.classes, child.ClassName) then
            table.insert(data.filteredparts, child)
            for _, part in pairs(data.filteredparts) do
                local dist = Ordium.functions.pointDistance(part)
                if Circle.Radius > dist and dist < data.dist then
                    data.part = part
                    data.dist = dist
                end
            end
        end
    end
    return data.part
end

Ordium.functions.returnClosestPlayer = function (amount)
    local data = {
        dist = 1/0,
        player = nil
    }

    amount = amount or nil

    for _, player in pairs(players:GetPlayers()) do
        if (player.Character and player ~= client) then
            local dist = Ordium.functions.pointDistance(player.Character.HumanoidRootPart)
            if Circle.Radius > dist and dist < data.dist and
            Ordium.functions.wallCheck(player.Character.Head.Position,{client, player.Character}) then
                data.dist = dist
                data.player = player
            end
        end
    end
    local calc = mf(rnew().NextNumber(rnew(), 0, 1) * 100) / 100
    local use = getgenv().Ordium.SilentAim.ChanceData.UseChance
    if use and calc <= mf(amount) / 100 then
        return calc and data.player
    else
        return data.player
    end
end

Ordium.functions.setAimingType = function (player, type)
    local previousSilentAimPart = getgenv().Ordium.SilentAim.AimPart
    local previousTracingPart = getgenv().Ordium.Tracing.AimPart
    if type == "Closest Part" then
        getgenv().Ordium.SilentAim.AimPart = tostring(Ordium.functions.returnClosestPart(player.Character))
        getgenv().Ordium.Tracing.AimPart = tostring(Ordium.functions.returnClosestPart(player.Character))
    elseif type == "Closest Point" then
        Ordium.functions.returnClosestPoint()
    elseif type == "Default" then
        getgenv().Ordium.SilentAim.AimPart = previousSilentAimPart
        getgenv().Ordium.Tracing.AimPart = previousTracingPart
    else
        getgenv().Ordium.SilentAim.AimPart = previousSilentAimPart
        getgenv().Ordium.Tracing.AimPart = previousTracingPart
    end
end

Ordium.functions.aimingCheck = function (player)
    if getgenv().Ordium.SilentAim.AimingData.CheckKnocked == true and player and player.Character then
        if player.Character.BodyEffects["K.O"].Value then
            return true
        end
    end
    if getgenv().Ordium.SilentAim.AimingData.CheckGrabbed == true and player and player.Character then
        if player.Character:FindFirstChild("GRABBING_CONSTRAINT") then
            return true
        end
    end
    return false
end
    


local lastRender = 1
local interpolation = 0.01

RunService.RenderStepped:Connect(function(delta)
    local valueTypes = 1.375
    lastRender = lastRender + delta
    while lastRender > interpolation do
        lastRender = lastRender - interpolation
    end
    if getgenv().Ordium.Tracing.Enabled and lockedCamTo ~= nil and getgenv().Ordium.Tracing.TracingOptions.Strength == "Hard" then
        local Vel =  lockedCamTo.Character[getgenv().Ordium.Tracing.AimPart].Velocity / (getgenv().Ordium.Tracing.Prediction * valueTypes)
        local Main = CFrame.new(Cam.CFrame.p, lockedCamTo.Character[getgenv().Ordium.Tracing.AimPart].Position + (Vel))
        Cam.CFrame = Cam.CFrame:Lerp(Main ,getgenv().Ordium.Tracing.TracingOptions.Smoothness , Enum.EasingStyle.Sine, Enum.EasingDirection.Out)
        Ordium.functions.setAimingType(lockedCamTo, getgenv().Ordium.Tracing.TracingOptions.AimingType)
    elseif getgenv().Ordium.Tracing.Enabled and lockedCamTo ~= nil and getgenv().Ordium.Tracing.TracingOptions.Strength == "Soft" then
        local Vel =  lockedCamTo.Character[getgenv().Ordium.Tracing.AimPart].Velocity / (getgenv().Ordium.Tracing.Prediction / valueTypes)
        local Main = CFrame.new(Cam.CFrame.p, lockedCamTo.Character[getgenv().Ordium.Tracing.AimPart].Position + (Vel))
        Cam.CFrame = Cam.CFrame:Lerp(Main ,getgenv().Ordium.Tracing.TracingOptions.Smoothness , Enum.EasingStyle.Sine, Enum.EasingDirection.Out)
        Ordium.functions.setAimingType(lockedCamTo, getgenv().Ordium.Tracing.TracingOptions.AimingType)
    else

    end
end)

task.spawn(function ()
    while task.wait() do
        if Targetting then
            Ordium.functions.setAimingType(Targetting, getgenv().Ordium.SilentAim.AimingType)
        end
        Ordium.functions.update_FOVs()
    end
end)


local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Camera = workspace.CurrentCamera
local Toggle = getgenv().Ordium.a360.Toggle
local RotationSpeed = getgenv().Ordium.a360.RotationSpeed
local Keybind = getgenv().Ordium.a360.Keybind

local function OnKeyPress(Input, GameProcessedEvent)
    if Input.KeyCode == Keybind and not GameProcessedEvent then 
        Toggle = not Toggle
    end
end

UserInputService.InputBegan:Connect(OnKeyPress)

local LastRenderTime = 0
local FullCircleRotation = 2 * math.pi
local TotalRotation = 0

local function RotateCamera()
    if Toggle then

        local CurrentTime = tick()
        local TimeDelta = math.min(CurrentTime - LastRenderTime, 0.01)
        LastRenderTime = CurrentTime

        local Rotation = CFrame.fromAxisAngle(Vector3.new(0, 1, 0), math.rad(RotationSpeed * TimeDelta))
        Camera.CFrame = Camera.CFrame * Rotation

        TotalRotation = TotalRotation + math.rad(RotationSpeed * TimeDelta)
        if TotalRotation >= FullCircleRotation then
            Toggle = false
            TotalRotation = 0
        end
    end
end

RunService.RenderStepped:Connect(RotateCamera)


local mainevent = MainEventLocate()


if getgenv().Ordium.Macro.Enabled == true then
    local macro = getgenv().Ordium.Macro

    if inputKeyCode == enumKeyCode[sub(upper(keyBind.Macro), 1, 1)] and macro.Type == "Third" then
        speedGlitching = not speedGlitching
        if speedGlitching == true then
            repeat
                local waittime = macro.Speed / 100
                twait(waittime)
                virtualInputManager:SendKeyEvent(true, "I", false, game)
                twait(waittime)
                virtualInputManager:SendKeyEvent(true, "O", false, game)
                twait(waittime)
                virtualInputManager:SendKeyEvent(true, "I", false, game)
                twait(waittime)
                virtualInputManager:SendKeyEvent(true, "O", false, game)
                twait(waittime)
            until not speedGlitching
        end
    elseif inputKeyCode == enumKeyCode[sub(upper(keyBind.Macro), 1, 1)] and macro.Type == "First" then
        speedGlitching = not speedGlitching
        if speedGlitching == true then
            repeat
                local waittime = macro.Speed / 100
                twait(waittime)
                virtualInputManager:SendMouseWheelEvent("0", "0", true, game)
                twait(waittime)
                virtualInputManager:SendMouseWheelEvent("0", "0", false, game)
                twait(waittime)
                virtualInputManager:SendMouseWheelEvent("0", "0", true, game)
                twait(waittime)
                virtualInputManager:SendMouseWheelEvent("0", "0", false, game)
                twait(waittime)
            until not speedGlitching
        end
    elseif inputKeyCode == enumKeyCode[sub(upper(keyBind.Macro), 1, 1)] and macro.Type == "Electron" then
        speedGlitching = not speedGlitching
        if speedGlitching == true then
            repeat
                runService.Heartbeat:Wait()
                keypress(0x49)
                runService.Heartbeat:Wait()
                keypress(0x4F)
                runService.Heartbeat:Wait()
                keyrelease(0x49)
                runService.Heartbeat:Wait()
                keyrelease(0x4F)
                runService.Heartbeat:Wait()
            until not speedGlitching
        end
    end
end



if getgenv().Ordium.NoJumpCooldown.Enabled == true  and game.PlaceId == 2788229376 then
    local gmt = getrawmetatable(game)
    setreadonly(gmt, false)
    local old = gmt.__newindex

    gmt.__newindex = newcclosure(function(t,i,v)
        if i == "JumpPower" then
            return old(t,i,50)
        end
        return old(t,i,v)
    end)
end
