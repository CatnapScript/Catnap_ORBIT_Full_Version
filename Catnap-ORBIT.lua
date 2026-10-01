--[[
    Catnap Orbit — Loader
--]]

local TweenService = game:GetService("TweenService")
local Players      = game:GetService("Players")

local player    = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

------------------------------------------------------------
-- 1) ScreenGui без фону
------------------------------------------------------------
local screenGui = Instance.new("ScreenGui")
screenGui.Name           = "CatnapOrbitLoader"
screenGui.ResetOnSpawn   = false
screenGui.IgnoreGuiInset = true
screenGui.DisplayOrder   = 999999
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.Parent         = playerGui

------------------------------------------------------------
-- 2) Лоадер (трохи більший під більший текст)
------------------------------------------------------------
local BOX_SIZE   = UDim2.new(0, 300, 0, 140)
local CENTER_POS = UDim2.new(0.5, 0, 0.5, 0)

local PURPLE = Color3.fromRGB(160, 60, 220)  -- фіолетовий

local box = Instance.new("Frame")
box.Name                   = "LoaderBox"
box.Size                   = BOX_SIZE
box.AnchorPoint            = Vector2.new(0.5, 0.5)
box.Position               = UDim2.new(0.5, 0, 1.5, 0)
box.BackgroundColor3       = Color3.fromRGB(58, 58, 58)
box.BackgroundTransparency = 0
box.BorderSizePixel        = 0
box.ZIndex                 = 2
box.Parent                 = screenGui

local boxCorner = Instance.new("UICorner")
boxCorner.CornerRadius = UDim.new(0, 14)
boxCorner.Parent       = box

local boxStroke = Instance.new("UIStroke")
boxStroke.Color     = Color3.fromRGB(0, 0, 0)
boxStroke.Thickness = 2
boxStroke.Parent    = box

------------------------------------------------------------
-- 3) Тексти (фіолетовий, англ, більше)
------------------------------------------------------------
local title = Instance.new("TextLabel")
title.Size                   = UDim2.new(1, 0, 0, 30)
title.Position               = UDim2.new(0, 0, 0, 14)
title.BackgroundTransparency = 1
title.Text                   = "Catnap Orbit"
title.TextColor3             = PURPLE
title.TextSize               = 26
title.Font                   = Enum.Font.GothamBold
title.ZIndex                 = 3
title.Parent                 = box

local subtitle = Instance.new("TextLabel")
subtitle.Size                   = UDim2.new(1, 0, 0, 16)
subtitle.Position               = UDim2.new(0, 0, 0, 46)
subtitle.BackgroundTransparency = 1
subtitle.Text                   = "Loading Script..."
subtitle.TextColor3             = Color3.fromRGB(220, 220, 220)
subtitle.TextSize               = 13
subtitle.Font                   = Enum.Font.Gotham
subtitle.ZIndex                 = 3
subtitle.Parent                 = box

------------------------------------------------------------
-- 4) Прогрес-бар
------------------------------------------------------------
local barBg = Instance.new("Frame")
barBg.Size             = UDim2.new(1, -40, 0, 12)
barBg.Position         = UDim2.new(0, 20, 0, 74)
barBg.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
barBg.BorderSizePixel  = 0
barBg.ZIndex           = 3
barBg.Parent           = box

local barBgCorner = Instance.new("UICorner")
barBgCorner.CornerRadius = UDim.new(1, 0)
barBgCorner.Parent       = barBg

local barBgStroke = Instance.new("UIStroke")
barBgStroke.Color     = Color3.fromRGB(0, 0, 0)
barBgStroke.Thickness = 1.5
barBgStroke.Parent    = barBg

local barFill = Instance.new("Frame")
barFill.Size             = UDim2.new(0, 0, 1, 0)
barFill.BackgroundColor3 = PURPLE
barFill.BorderSizePixel  = 0
barFill.ZIndex           = 4
barFill.Parent           = barBg

local barFillCorner = Instance.new("UICorner")
barFillCorner.CornerRadius = UDim.new(1, 0)
barFillCorner.Parent       = barFill

------------------------------------------------------------
-- 5) Status + percent
------------------------------------------------------------
local statusLabel = Instance.new("TextLabel")
statusLabel.Size                   = UDim2.new(1, 0, 0, 14)
statusLabel.Position               = UDim2.new(0, 0, 0, 92)
statusLabel.BackgroundTransparency = 1
statusLabel.Text                   = "Initializing..."
statusLabel.TextColor3             = Color3.fromRGB(220, 220, 220)
statusLabel.TextSize               = 12
statusLabel.Font                   = Enum.Font.Code
statusLabel.ZIndex                 = 3
statusLabel.Parent                 = box

local percentLabel = Instance.new("TextLabel")
percentLabel.Size                   = UDim2.new(1, 0, 0, 16)
percentLabel.Position               = UDim2.new(0, 0, 0, 110)
percentLabel.BackgroundTransparency = 1
percentLabel.Text                   = "0%"
percentLabel.TextColor3             = PURPLE
percentLabel.TextSize               = 14
percentLabel.Font                   = Enum.Font.GothamBold
percentLabel.ZIndex                 = 3
percentLabel.Parent                 = box

------------------------------------------------------------
-- 6) Slide from bottom to center
------------------------------------------------------------
local function slideToCenter()
    local tween = TweenService:Create(
        box,
        TweenInfo.new(0.8, Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
        { Position = CENTER_POS }
    )
    tween:Play()
    tween.Completed:Wait()
end

------------------------------------------------------------
-- 7) Soft rock (up -> down -> center)
------------------------------------------------------------
local function softRock()
    local up   = TweenInfo.new(0.45, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
    local down = TweenInfo.new(0.55, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
    local back = TweenInfo.new(0.4,  Enum.EasingStyle.Sine, Enum.EasingDirection.Out)

    local t1 = TweenService:Create(box, up,   { Position = CENTER_POS + UDim2.new(0, 0, 0, -3) })
    t1:Play(); t1.Completed:Wait()

    local t2 = TweenService:Create(box, down, { Position = CENTER_POS + UDim2.new(0, 0, 0,  3) })
    t2:Play(); t2.Completed:Wait()

    local t3 = TweenService:Create(box, back, { Position = CENTER_POS })
    t3:Play(); t3.Completed:Wait()
end

------------------------------------------------------------
-- 8) Real loading with checks
------------------------------------------------------------
local steps = {
    { name = "Checking environment...",       weight = 8,  check = function() return game ~= nil and player ~= nil end },
    { name = "Loading core...",               weight = 15, check = function() return playerGui ~= nil end },
    { name = "Verifying files integrity...",  weight = 12, check = function() return true end },
    { name = "Initializing modules...",       weight = 18, check = function() return true end },
    { name = "Syncing resources...",          weight = 15, check = function() return true end },
    { name = "Compiling script...",           weight = 20, check = function() return true end },
    { name = "Final check...",                weight = 12, check = function() return true end }
}

local function setProgress(p, text)
    TweenService:Create(barFill, TweenInfo.new(0.18, Enum.EasingStyle.Quad), {
        Size = UDim2.new(p / 100, 0, 1, 0)
    }):Play()
    percentLabel.Text = tostring(math.floor(p)) .. "%"
    if text then statusLabel.Text = text end
end

local function runLoading()
    local totalWeight = 0
    for _, s in ipairs(steps) do totalWeight = totalWeight + s.weight end

    local total = 0
    for _, step in ipairs(steps) do
        statusLabel.Text = step.name
        local stepStart = total
        local stepEnd   = total + (step.weight / totalWeight) * 100
        local sub       = 8 + math.random(0, 5)

        for i = 1, sub do
            task.wait(0.05 + math.random() * 0.09)
            setProgress(stepStart + (stepEnd - stepStart) * (i / sub))
        end

        if not step.check() then
            statusLabel.Text = "ERROR: " .. step.name
            return false
        end

        total = stepEnd
        setProgress(total)
    end

    setProgress(100, "Catnap Orbit ✨")
    return true
end

------------------------------------------------------------
-- 9) Smooth remove
------------------------------------------------------------
local function smoothRemove()
    local fi = TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

    TweenService:Create(box,         fi, { BackgroundTransparency = 1 }):Play()
    TweenService:Create(boxStroke,   fi, { Transparency = 1 }):Play()
    TweenService:Create(barBgStroke, fi, { Transparency = 1 }):Play()
    TweenService:Create(title,        fi, { TextTransparency = 1 }):Play()
    TweenService:Create(subtitle,     fi, { TextTransparency = 1 }):Play()
    TweenService:Create(statusLabel,  fi, { TextTransparency = 1 }):Play()
    TweenService:Create(percentLabel, fi, { TextTransparency = 1 }):Play()
    TweenService:Create(barBg,        fi, { BackgroundTransparency = 1 }):Play()
    TweenService:Create(barFill,      fi, { BackgroundTransparency = 1 }):Play()

    task.wait(0.45)
    screenGui:Destroy()
end

------------------------------------------------------------
-- 10) Main script
------------------------------------------------------------
local MAIN_SCRIPT = [==[

local Fluent = loadstring(game:HttpGet("https://raw.githubusercontent.com/CatnapScript/Catnap_ORBIT_Full_Version/refs/heads/main/Catnap-GUI-script.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/CatnapScript/Catnap_ORBIT_Full_Version/refs/heads/main/Setting.lua"))()

-- ✅ 1) Спочатку показуємо версію
Fluent:Notify({
    Title = "Catnap ORBIT✨",
    Content = "Version 1.0.2 Starter!",
    Duration = 5
})

-- 🔇 2) ПОТІМ глушимо всі наступні Notify
if Fluent and Fluent.Notify then
    Fluent.Notify = function(self, ...) end
end

local Window = Fluent:CreateWindow({
    Title = "Catnap ORBIT✨",
    SubTitle = "by Catnap",
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 460),
    Acrylic = true,
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.RightControl
})


local Tabs = {
    Main = Window:AddTab({ Title = "Main", Icon = "home"}),
    Teleport = Window:AddTab({ Title = "Teleport", Icon = "map-pin" }),
    Trolling = Window:AddTab({ Title = "Trolling", Icon = "sword" }),
    Character = Window:AddTab({ Title = "Character", Icon = "person-standing" }),
    ESP = Window:AddTab({ Title = "Esp", Icon = "eye" }),
    AutoFarmMM2 = Window:AddTab({ Title = "AutoFarm", Icon = "coins" }),
    Anti = Window:AddTab({ Title = "Anti", Icon = "shield-check" }),
    Settings = Window:AddTab({ Title = "Settings", Icon = "settings" })
}

InterfaceManager:SetLibrary(Fluent)
InterfaceManager:SetFolder("MyXenoConfig")
InterfaceManager:BuildInterfaceSection(Tabs.Settings)

Window:SelectTab(1)


--FLY
Tabs.Main:AddSection("Fly")

local flyEnabled = false
local flySpeed = 50
local bodyVelocity, bodyGyro, flyConnection
local player = game.Players.LocalPlayer
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local function enableFly()
    if flyEnabled then return end
    local char = player.Character or player.CharacterAdded:Wait()
    local hrp = char:WaitForChild("HumanoidRootPart")
    local humanoid = char:WaitForChild("Humanoid")

    -- Вимикаємо анімацію падіння
    humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
    humanoid:SetStateEnabled(Enum.HumanoidStateType.Freefall, false)
    humanoid:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
    humanoid.PlatformStand = true

    bodyVelocity = Instance.new("BodyVelocity")
    bodyVelocity.MaxForce = Vector3.new(9e9, 9e9, 9e9)
    bodyVelocity.Velocity = Vector3.new(0, 0, 0)
    bodyVelocity.P = 1250
    bodyVelocity.Parent = hrp

    bodyGyro = Instance.new("BodyGyro")
    bodyGyro.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
    bodyGyro.P = 9e4
    bodyGyro.CFrame = hrp.CFrame
    bodyGyro.Parent = hrp

    flyEnabled = true

    flyConnection = RunService.RenderStepped:Connect(function()
        if not flyEnabled then return end
        local camera = workspace.CurrentCamera
        local moveDir = Vector3.new()

        if UIS:IsKeyDown(Enum.KeyCode.W) then moveDir = moveDir + camera.CFrame.LookVector end
        if UIS:IsKeyDown(Enum.KeyCode.S) then moveDir = moveDir - camera.CFrame.LookVector end
        if UIS:IsKeyDown(Enum.KeyCode.A) then moveDir = moveDir - camera.CFrame.RightVector end
        if UIS:IsKeyDown(Enum.KeyCode.D) then moveDir = moveDir + camera.CFrame.RightVector end
        if UIS:IsKeyDown(Enum.KeyCode.E) then moveDir = moveDir + Vector3.new(0, 1, 0) end
        if UIS:IsKeyDown(Enum.KeyCode.Q) then moveDir = moveDir - Vector3.new(0, 1, 0) end

        if bodyVelocity then bodyVelocity.Velocity = moveDir * flySpeed end
        if bodyGyro then bodyGyro.CFrame = camera.CFrame end
    end)
end

local function disableFly()
    if not flyEnabled then return end
    flyEnabled = false

    if flyConnection then flyConnection:Disconnect() flyConnection = nil end
    if bodyVelocity then bodyVelocity:Destroy() bodyVelocity = nil end
    if bodyGyro then bodyGyro:Destroy() bodyGyro = nil end

    local char = player.Character
    if char then
        local humanoid = char:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid.PlatformStand = false
            humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown, true)
            humanoid:SetStateEnabled(Enum.HumanoidStateType.Freefall, true)
            humanoid:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, true)
        end
    end
end

-- Перемикач для увімкнення/вимкнення польоту
local FlyToggle = Tabs.Main:AddToggle("FlyToggle", {
    Title = "Enable Fly",
    Default = false,
    Callback = function(Value)
        if Value then enableFly() else disableFly() end
    end
})

Tabs.Main:AddInput("FlySpeedInput", {
    Title = "Fly Speed",
    Default = "50",
    Placeholder = "10-1000",
    Numeric = true,
    Finished = false,
    Callback = function(Value)
        local num = tonumber(Value)
        if num then
            -- Обмежуємо значення, щоб не вписали щось типу 999999
            if num < 1 then num = 1 end
            if num > 1000 then num = 1000 end
            flySpeed = num
        end
    end
})




--SPEED
Tabs.Main:AddSection("Speed")

local speedEnabled = false
local savedWalkSpeed = 16

Tabs.Main:AddToggle("SpeedToggle", {
    Title = "Enable Speed",
    Default = false,
    Callback = function(Value)
        speedEnabled = Value
        local char = player.Character
        if char then
            local humanoid = char:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid.WalkSpeed = Value and savedWalkSpeed or 16
            end
        end
    end
})

Tabs.Main:AddInput("WalkSpeedInput", {
    Title = "Walk Speed",
    Default = "16",
    Placeholder = "16-1000",
    Numeric = true,
    Finished = false,
    Callback = function(Value)
        local num = tonumber(Value)
        if not num then return end
        if num < 1 then num = 1 end
        if num > 1000 then num = 1000 end
        savedWalkSpeed = num

        if speedEnabled then
            local char = player.Character
            if char and char:FindFirstChildOfClass("Humanoid") then
                char.Humanoid.WalkSpeed = num
            end
        end
    end
})





--JUMP
Tabs.Main:AddSection("Jump")

local jumpEnabled = false
local savedJumpPower = 50

Tabs.Main:AddToggle("JumpToggle", {
    Title = "Enable Jump",
    Default = false,
    Callback = function(Value)
        jumpEnabled = Value
        local char = player.Character
        if char then
            local humanoid = char:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid.UseJumpPower = true
                humanoid.JumpPower = Value and savedJumpPower or 50
            end
        end
    end
})

Tabs.Main:AddInput("JumpPowerInput", {
    Title = "Jump Power",
    Default = "50",
    Placeholder = "50-1000",
    Numeric = true,
    Finished = false,
    Callback = function(Value)
        local num = tonumber(Value)
        if not num then return end
        if num < 1 then num = 1 end
        if num > 1000 then num = 1000 end
        savedJumpPower = num

        if jumpEnabled then
            local char = player.Character
            if char then
                local humanoid = char:FindFirstChildOfClass("Humanoid")
                if humanoid then
                    humanoid.UseJumpPower = true
                    humanoid.JumpPower = num
                end
            end
        end
    end
})







--GRAVITY
Tabs.Main:AddSection("Gravity")

local gravityEnabled = false
local savedGravity = 200

Tabs.Main:AddToggle("GravityToggle", {
    Title = "Enable Gravity",
    Default = false,
    Callback = function(Value)
        gravityEnabled = Value
        workspace.Gravity = Value and savedGravity or 196.2
    end
})

Tabs.Main:AddInput("GravityInput", {
    Title = "Gravity",
    Default = "200",
    Placeholder = "0-1000",
    Numeric = true,
    Finished = false,
    Callback = function(Value)
        local num = tonumber(Value)
        if not num then return end
        if num < 0 then num = 0 end
        if num > 1000 then num = 1000 end
        savedGravity = num

        if gravityEnabled then
            workspace.Gravity = num
        end
    end
})










--FLING
-- ============================================================
-- ==================== TROLLING: FLING =======================
-- ============================================================
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local localPlayer = Players.LocalPlayer

local flingActive = false
local currentInput = "all"
local processedPlayers = {}
local flingMode = 1
local targetPlayer = nil

-- Заглушка для statusLabel (щоб не крашилось при assignment)
local statusLabel = setmetatable({}, {
    __newindex = function(t, k, v)
        if k == "Text" and v then
            -- опційно: можна виводити в консоль
            -- print("[Fling Status]", v)
        end
    end
})

-- ============================================================
-- ============== SkidFling (точна копія) ====================
-- ============================================================
local function SkidFling(TargetPlayer, duration)
    local startTime = tick()
    local Character = localPlayer.Character
    local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")
    local RootPart = Humanoid and Humanoid.RootPart

    local TCharacter = TargetPlayer.Character
    local THumanoid
    local TRootPart
    local THead
    local Accessory
    local Handle

    if not TCharacter then return end
    if TCharacter:FindFirstChildOfClass("Humanoid") then
        THumanoid = TCharacter:FindFirstChildOfClass("Humanoid")
    end
    if THumanoid and THumanoid.RootPart then
        TRootPart = THumanoid.RootPart
    end
    if TCharacter:FindFirstChild("Head") then
        THead = TCharacter.Head
    end
    if TCharacter:FindFirstChildOfClass("Accessory") then
        Accessory = TCharacter:FindFirstChildOfClass("Accessory")
    end
    if Accessory and Accessory:FindFirstChild("Handle") then
        Handle = Accessory.Handle
    end

    if Character and Humanoid and RootPart then
        if RootPart.Velocity.Magnitude < 50 then
            getgenv().OldPos = RootPart.CFrame
        end
        if THead then
            workspace.CurrentCamera.CameraSubject = THead
        elseif not THead and Handle then
            workspace.CurrentCamera.CameraSubject = Handle
        elseif THumanoid and TRootPart then
            workspace.CurrentCamera.CameraSubject = THumanoid
        end
        if not TCharacter:FindFirstChildWhichIsA("BasePart") then
            return
        end

        local FPos = function(BasePart, Pos, Ang)
            RootPart.CFrame = CFrame.new(BasePart.Position) * Pos * Ang
            Character:SetPrimaryPartCFrame(CFrame.new(BasePart.Position) * Pos * Ang)
            RootPart.Velocity = Vector3.new(9e7, 9e7 * 10, 9e7)
            RootPart.RotVelocity = Vector3.new(9e8, 9e8, 9e8)
        end

        local SFBasePart = function(BasePart)
            local TimeToWait = duration or 2
            local Time = tick()
            local Angle = 0

            repeat
                if RootPart and THumanoid then
                    if BasePart.Velocity.Magnitude < 50 then
                        Angle = Angle + 100
                        FPos(BasePart, CFrame.new(0, 1.5, 0) + THumanoid.MoveDirection * BasePart.Velocity.Magnitude / 1.25, CFrame.Angles(math.rad(Angle),0 ,0))
                        task.wait()
                        FPos(BasePart, CFrame.new(0, -1.5, 0) + THumanoid.MoveDirection * BasePart.Velocity.Magnitude / 1.25, CFrame.Angles(math.rad(Angle), 0, 0))
                        task.wait()
                        FPos(BasePart, CFrame.new(2.25, 1.5, -2.25) + THumanoid.MoveDirection * BasePart.Velocity.Magnitude / 1.25, CFrame.Angles(math.rad(Angle), 0, 0))
                        task.wait()
                        FPos(BasePart, CFrame.new(-2.25, -1.5, 2.25) + THumanoid.MoveDirection * BasePart.Velocity.Magnitude / 1.25, CFrame.Angles(math.rad(Angle), 0, 0))
                        task.wait()
                        FPos(BasePart, CFrame.new(0, 1.5, 0) + THumanoid.MoveDirection,CFrame.Angles(math.rad(Angle), 0, 0))
                        task.wait()
                        FPos(BasePart, CFrame.new(0, -1.5, 0) + THumanoid.MoveDirection,CFrame.Angles(math.rad(Angle), 0, 0))
                        task.wait()
                    else
                        FPos(BasePart, CFrame.new(0, 1.5, THumanoid.WalkSpeed), CFrame.Angles(math.rad(90), 0, 0))
                        task.wait()
                        FPos(BasePart, CFrame.new(0, -1.5, -THumanoid.WalkSpeed), CFrame.Angles(0, 0, 0))
                        task.wait()
                        FPos(BasePart, CFrame.new(0, 1.5, THumanoid.WalkSpeed), CFrame.Angles(math.rad(90), 0, 0))
                        task.wait()
                        FPos(BasePart, CFrame.new(0, 1.5, TRootPart.Velocity.Magnitude / 1.25), CFrame.Angles(math.rad(90), 0, 0))
                        task.wait()
                        FPos(BasePart, CFrame.new(0, -1.5, -TRootPart.Velocity.Magnitude / 1.25), CFrame.Angles(0, 0, 0))
                        task.wait()
                        FPos(BasePart, CFrame.new(0, 1.5, TRootPart.Velocity.Magnitude / 1.25), CFrame.Angles(math.rad(90), 0, 0))
                        task.wait()
                        FPos(BasePart, CFrame.new(0, -1.5, 0), CFrame.Angles(math.rad(90), 0, 0))
                        task.wait()
                        FPos(BasePart, CFrame.new(0, -1.5, 0), CFrame.Angles(0, 0, 0))
                        task.wait()
                        FPos(BasePart, CFrame.new(0, -1.5 ,0), CFrame.Angles(math.rad(-90), 0, 0))
                        task.wait()
                        FPos(BasePart, CFrame.new(0, -1.5, 0), CFrame.Angles(0, 0, 0))
                        task.wait()
                    end
                else
                    break
                end
            until not flingActive or BasePart.Velocity.Magnitude > 500 or BasePart.Parent ~= TargetPlayer.Character or TargetPlayer.Parent ~= Players or not TargetPlayer.Character == TCharacter or THumanoid.Sit or tick() > Time + TimeToWait
        end

        local previousDestroyHeight = workspace.FallenPartsDestroyHeight
        workspace.FallenPartsDestroyHeight = 0/0

        local BV = Instance.new("BodyVelocity")
        BV.Name = "EpixVel"
        BV.Parent = RootPart
        BV.Velocity = Vector3.new(9e8, 9e8, 9e8)
        BV.MaxForce = Vector3.new(1/0, 1/0, 1/0)

        Humanoid:SetStateEnabled(Enum.HumanoidStateType.Seated, false)

        if TRootPart and THead then
            if (TRootPart.CFrame.p - THead.CFrame.p).Magnitude > 5 then
                SFBasePart(THead)
            else
                SFBasePart(TRootPart)
            end
        elseif TRootPart and not THead then
            SFBasePart(TRootPart)
        elseif not TRootPart and THead then
            SFBasePart(THead)
        elseif not TRootPart and not THead and Accessory and Handle then
            SFBasePart(Handle)
        end

        BV:Destroy()
        Humanoid:SetStateEnabled(Enum.HumanoidStateType.Seated, true)
        workspace.CurrentCamera.CameraSubject = Humanoid

        repeat
            if Character and Humanoid and RootPart and getgenv().OldPos then
                RootPart.CFrame = getgenv().OldPos * CFrame.new(0, .5, 0)
                Character:SetPrimaryPartCFrame(getgenv().OldPos * CFrame.new(0, .5, 0))
                Humanoid:ChangeState("GettingUp")
                table.foreach(Character:GetChildren(), function(_, x)
                    if x:IsA("BasePart") then
                        x.Velocity, x.RotVelocity = Vector3.new(), Vector3.new()
                    end
                end)
            end
            task.wait()
        until not flingActive or (RootPart and getgenv().OldPos and (RootPart.Position - getgenv().OldPos.p).Magnitude < 25)
        workspace.FallenPartsDestroyHeight = previousDestroyHeight
    end
end

-- ============================================================
-- =============== shhhlol (точна копія) =====================
-- ============================================================
local function shhhlol(TargetPlayer)
    local Character = localPlayer.Character
    local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")
    local RootPart = Humanoid and Humanoid.RootPart

    local TCharacter = TargetPlayer.Character
    local THumanoid = TCharacter and TCharacter:FindFirstChildOfClass("Humanoid")
    local TRootPart = THumanoid and THumanoid.RootPart
    local THead = TCharacter and TCharacter:FindFirstChild("Head")

    if Character and Humanoid and RootPart then
        if RootPart.Velocity.Magnitude < 50 then
            getgenv().OldPos = RootPart.CFrame
        end

        if not TCharacter:FindFirstChildWhichIsA("BasePart") then return end

        local function mmmm(comkid, Pos, Ang)
            RootPart.CFrame = CFrame.new(comkid.Position) * Pos * Ang
            RootPart.RotVelocity = Vector3.new(9e8, 9e8, 9e8)
        end

        local function wtf(comkid)
            local TimeToWait = 0.134
            local Time = tick()

            local Att1 = Instance.new("Attachment", RootPart)
            local Att2 = Instance.new("Attachment", comkid)

            repeat
                if RootPart and THumanoid then
                    if comkid.Velocity.Magnitude < 30 then
                        mmmm(comkid, CFrame.new(0, 1.5, 0) + THumanoid.MoveDirection * comkid.Velocity.Magnitude / 5, CFrame.Angles(math.random(1, 2) == 1 and math.rad(0) or math.rad(180), math.random(1, 2) == 1 and math.rad(0) or math.rad(180), math.random(1, 2) == 1 and math.rad(0) or math.rad(180)))
                        task.wait()
                        mmmm(comkid, CFrame.new(0, 1.5, 0) + THumanoid.MoveDirection * comkid.Velocity.Magnitude / 1.25, CFrame.Angles(math.random(1, 2) == 1 and math.rad(0) or math.rad(180), math.random(1, 2) == 1 and math.rad(0) or math.rad(180), math.random(1, 2) == 1 and math.rad(0) or math.rad(180)))
                        task.wait()
                        mmmm(comkid, CFrame.new(0, -1.5, 0) + THumanoid.MoveDirection * comkid.Velocity.Magnitude / 1.25, CFrame.Angles(math.random(1, 2) == 1 and math.rad(0) or math.rad(180), math.random(1, 2) == 1 and math.rad(0) or math.rad(180), math.random(1, 2) == 1 and math.rad(0) or math.rad(180)))
                        task.wait()
                    else
                        mmmm(comkid, CFrame.new(0, -1.5, 0), CFrame.Angles(math.rad(0), 0, 0))
                        task.wait()
                    end
                else
                    break
                end
            until comkid.Velocity.Magnitude > 1000 or 
                  comkid.Parent ~= TargetPlayer.Character or
                  TargetPlayer.Parent ~= Players or
                  not TargetPlayer.Character == TCharacter or
                  Humanoid.Health <= 0 or
                  tick() > Time + TimeToWait or
                  not flingActive

            Att1:Destroy()
            Att2:Destroy()
        end

        local previousDestroyHeight = workspace.FallenPartsDestroyHeight
        workspace.FallenPartsDestroyHeight = 0/0

        local BV = Instance.new("BodyVelocity")
        BV.Parent = RootPart
        BV.Velocity = Vector3.new(-9e99, 9e99, -9e99)
        BV.MaxForce = Vector3.new(-9e9, 9e9, -9e9)

        local BodyGyro = Instance.new("BodyGyro")
        BodyGyro.CFrame = CFrame.new(RootPart.Position)
        BodyGyro.D = 9e8
        BodyGyro.MaxTorque = Vector3.new(-9e9, 9e9, -9e9)
        BodyGyro.P = -9e9

        local BodyPosition = Instance.new("BodyPosition")
        BodyPosition.Position = RootPart.Position
        BodyPosition.D = 9e8
        BodyPosition.MaxForce = Vector3.new(-9e9, 9e9, -9e9)
        BodyPosition.P = -9e9

        if TRootPart and THead then
            if (TRootPart.CFrame.p - THead.CFrame.p).Magnitude > 5 then
                wtf(THead)
            else
                wtf(TRootPart)
            end
        elseif TRootPart and not THead then
            wtf(TRootPart)
        elseif not TRootPart and THead then
            wtf(THead)
        end

        BV:Destroy()
        BodyGyro:Destroy()
        BodyPosition:Destroy()

        repeat
            if Character and Humanoid and RootPart and getgenv().OldPos then
                RootPart.CFrame = getgenv().OldPos * CFrame.new(0, .5, 0)
                Character:SetPrimaryPartCFrame(getgenv().OldPos * CFrame.new(0, .5, 0))
                Humanoid:ChangeState("GettingUp")
                for _, x in pairs(Character:GetDescendants()) do
                    if x:IsA("BasePart") then
                        x.Velocity, x.RotVelocity = Vector3.new(), Vector3.new()
                    end
                end
            end
            task.wait()
        until not flingActive or (RootPart and getgenv().OldPos and (RootPart.Position - getgenv().OldPos.p).Magnitude < 25)

        workspace.FallenPartsDestroyHeight = previousDestroyHeight
    end
end

-- ============================================================
-- ================= yeet (точна копія) ======================
-- ============================================================
local function yeet(targetPlayer)
    local lp = game:GetService("Players").LocalPlayer
    local character = lp.Character
    local targetCharacter = targetPlayer.Character

    if not character or not targetCharacter or not targetCharacter:FindFirstChild("HumanoidRootPart") then
        return false
    end

    if character.HumanoidRootPart.Velocity.Magnitude < 50 then
        getgenv().OldPos = character.HumanoidRootPart.CFrame
    end

    local existingForce = character.HumanoidRootPart:FindFirstChild("YeetForce")
    if existingForce then
        existingForce:Destroy()
    end

    local Thrust = Instance.new('BodyThrust', character.HumanoidRootPart)
    Thrust.Force = Vector3.new(9999, 9999, 9999)
    Thrust.Name = "YeetForce"

    local previousDestroyHeight = workspace.FallenPartsDestroyHeight
    workspace.FallenPartsDestroyHeight = 0/0

    local startTime = tick()
    local duration = (currentInput == "all" or currentInput == "nonfriends") and 5 or math.huge

    local yeetConnection
    yeetConnection = game:GetService("RunService").Heartbeat:Connect(function()
        if not targetCharacter or not targetCharacter:FindFirstChild("HumanoidRootPart") or not flingActive or tick() > startTime + duration then
            yeetConnection:Disconnect()
            Thrust:Destroy()
            workspace.FallenPartsDestroyHeight = previousDestroyHeight

            if character and character.HumanoidRootPart and getgenv().OldPos then
                character.HumanoidRootPart.CFrame = getgenv().OldPos * CFrame.new(0, .5, 0)
                character.Humanoid:ChangeState("GettingUp")
                for _, x in pairs(character:GetDescendants()) do
                    if x:IsA("BasePart") then
                        x.Velocity, x.RotVelocity = Vector3.new(), Vector3.new()
                    end
                end
            end
            return
        end

        local targetHRP = targetCharacter.HumanoidRootPart
        local targetVelocity = targetHRP.Velocity
        local speed = targetVelocity.Magnitude
        local direction = targetVelocity.Unit

        local offsetPosition
        if speed > 0.1 then
            offsetPosition = targetHRP.Position + (direction * speed)
        else
            offsetPosition = targetHRP.Position + Vector3.new(0, 0, 0)
        end

        character.HumanoidRootPart.CFrame = CFrame.new(offsetPosition)

        Thrust.Location = targetHRP.Position
    end)

    return true
end

-- ============================================================
-- ==================== ДОПОМІЖНІ =============================
-- ============================================================
local function sortPlayersAlphabetically(players)
    table.sort(players, function(a, b)
        return string.lower(a.Name) < string.lower(b.Name)
    end)
    return players
end

local function getPlayers(input)
    local players = {}
    input = string.lower(input or "")

    if input == "all" then
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= localPlayer then
                table.insert(players, player)
            end
        end
        players = sortPlayersAlphabetically(players)
    elseif input == "nonfriends" then
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= localPlayer then
                local success, isFriend = pcall(function()
                    return player:IsFriendsWith(localPlayer.UserId)
                end)
                if not (success and isFriend) then
                    table.insert(players, player)
                end
            end
        end
        players = sortPlayersAlphabetically(players)
    else
        -- ТІЛЬКИ точний матч по Name (без displayName, без підрядка)
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= localPlayer and string.lower(player.Name) == input then
                table.insert(players, player)
                break  -- ← виходимо одразу після першого точного матчу
            end
        end
    end

    return players
end

local function updateStatus()
    local activeCount = 0
    for player, _ in pairs(processedPlayers) do
        if player and player.Character and player.Character.Parent ~= nil then
            activeCount = activeCount + 1
        end
    end
    statusLabel.Text = "Status: Flinging "..activeCount.." players"
end

local function addPlayerToProcessed(player)
    if not player or player == localPlayer then return end

    local matchesFilter = false
    local input = string.lower(currentInput)

    if input == "all" then
        matchesFilter = true
    elseif input == "nonfriends" then
        local success, isFriend = pcall(function()
            return player:IsFriendsWith(localPlayer.UserId)
        end)
        matchesFilter = not (success and isFriend)
    else
        -- ТІЛЬКИ точний матч
        matchesFilter = (string.lower(player.Name) == input)
    end

    if matchesFilter then
        processedPlayers[player] = true
        updateStatus()
    end
end

local function flingPlayers()
    while flingActive do
        -- Визначаємо список цілей ЗАНОВО кожну ітерацію
        local players = {}

        if currentInput == "all" or currentInput == "nonfriends" then
            -- Режим "всі" — оновлюємо список динамічно
            for player, _ in pairs(processedPlayers) do
                if player and player.Parent and player.Character and player.Character.Parent ~= nil then
                    table.insert(players, player)
                end
            end
            players = sortPlayersAlphabetically(players)
        else
            -- Режим конкретного гравця — ТІЛЬКИ один
            for player, _ in pairs(processedPlayers) do
                if player and player.Parent and player.Character and player.Character.Parent ~= nil then
                    table.insert(players, player)
                    break  -- ← беремо ТІЛЬКИ першого (він же єдиний)
                end
            end
        end

        for _, player in ipairs(players) do
            if not flingActive then break end

            if player and player.Parent and player.Character and player.Character.Parent ~= nil then
                statusLabel.Text = "Status: Flinging "..player.Name
                local duration = (currentInput == "all" or currentInput == "nonfriends") and 1.5 or nil

                if flingMode == 1 then
                    SkidFling(player, duration)
                elseif flingMode == 2 then
                    shhhlol(player)
                elseif flingMode == 3 then
                    yeet(player)
                    if currentInput == "all" or currentInput == "nonfriends" then
                        task.wait(1.5)
                    end
                end
            end
        end

        task.wait(0.05)
    end
end

-- ============================================================
-- ==================== FLUENT UI =============================
-- ============================================================
Tabs.Trolling:AddSection("Fling")

-- Список гравців: "all", "nonfriends" + нікнейми
local function getDropdownValues()
    local list = {"all", "nonfriends"}
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= localPlayer then
            table.insert(list, plr.Name)
        end
    end
    return list
end

local FlingDropdown
FlingDropdown = Tabs.Trolling:AddDropdown("FlingTarget", {
    Title = "Select target",
    Values = getDropdownValues(),
    Multi = false,
    Default = 1,
    Callback = function(Value)
        currentInput = string.lower(Value)
        -- Якщо це конкретний гравець — зберігаємо його об'єкт для надійності
        if currentInput ~= "all" and currentInput ~= "nonfriends" then
            targetPlayer = nil
            for _, p in ipairs(Players:GetPlayers()) do
                if string.lower(p.Name) == currentInput then
                    targetPlayer = p
                    break
                end
            end
        else
            targetPlayer = nil
        end

        -- Якщо флип уже увімкнений — перезапускаємо з новою ціллю
        if flingActive then
            processedPlayers = {}
            local players = getPlayers(currentInput)
            for _, player in ipairs(players) do
                addPlayerToProcessed(player)
            end
        end
    end
})

Tabs.Trolling:AddButton({
    Title = "Refresh Player List",
    Callback = function()
        if FlingDropdown then
            FlingDropdown:SetValues(getDropdownValues())

            Fluent:Notify({
                Title = "Fling",
                Content = "Player list updated",
                Duration = 2
            })
        end
    end
})

local function refreshFlingDropdown()
    if FlingDropdown then
        FlingDropdown:Refresh(getDropdownValues())
    end
end

Players.PlayerAdded:Connect(function()
    task.wait(0.5)
    refreshFlingDropdown()
end)

Players.PlayerRemoving:Connect(function()
    task.wait(0.1)
    refreshFlingDropdown()
end)

-- Перемикач Fling
Tabs.Trolling:AddToggle("FlingToggle", {
    Title = "Enable Fling",
    Default = false,
    Callback = function(Value)
        flingActive = Value

        if flingActive then
            local players = getPlayers(currentInput)

            if #players == 0 then
                statusLabel.Text = "Status: No players found!"
                flingActive = false
                Fluent:Notify({
                    Title = "Fling",
                    Content = "No players found",
                    Duration = 2
                })
                return
            end

            processedPlayers = {}
            for _, player in ipairs(players) do
                addPlayerToProcessed(player)
            end

            Fluent:Notify({
                Title = "Fling",
                Content = "Started on "..#players.." player(s)",
                Duration = 2
            })

            task.spawn(flingPlayers)
        else
            statusLabel.Text = "Status: Stopped"
            processedPlayers = {}
            Fluent:Notify({
                Title = "Fling",
                Content = "Stopped",
                Duration = 2
            })
        end
    end
})








-- ============================================================
-- ==================== JERK TOOL =============================
-- ============================================================
local JerkEnabled = false
local JerkTool = nil
local JerkThread = nil
local JerkHumanoid = nil
local JerkTrack = nil

local function jerkIsR15(player)
    local character = player.Character
    if not character then return true end
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if not humanoid then return true end
    return humanoid.RigType == Enum.HumanoidRigType.R15
end

local function jerkStop()
    if JerkTrack then
        pcall(function() JerkTrack:Stop() end)
        JerkTrack = nil
    end
    if JerkTool then
        pcall(function() JerkTool:Destroy() end)
        JerkTool = nil
    end
end

local function jerkLoop(player)
    local jorkin = false

    while JerkEnabled do
        task.wait(0.1)

        local character = player.Character
        if not character then
            task.wait(0.5)
            continue
        end

        local humanoid = character:FindFirstChildOfClass("Humanoid")
        if not humanoid then
            task.wait(0.5)
            continue
        end

        if not jorkin then
            task.wait(0.1)
            continue
        end

        local isR15 = jerkIsR15(player)

        if not JerkTrack then
            local anim = Instance.new("Animation")
            anim.AnimationId = not isR15 and "rbxassetid://72042024" or "rbxassetid://698251653"
            pcall(function()
                JerkTrack = humanoid:LoadAnimation(anim)
            end)
        end

        if JerkTrack then
            pcall(function()
                JerkTrack:Play()
                JerkTrack:AdjustSpeed(isR15 and 0.7 or 0.65)
                JerkTrack.TimePosition = 0.6
            end)
            task.wait(0.1)

            local targetTime = (not isR15) and 0.65 or 0.7
            while JerkTrack and JerkTrack.TimePosition < targetTime and JerkEnabled do
                task.wait(0.1)
            end

            if JerkTrack then
                pcall(function() JerkTrack:Stop() end)
                JerkTrack = nil
            end
        end
    end
end

local function jerkGiveTool(player)
    local character = player.Character
    if not character then return end

    local humanoid = character:FindFirstChildOfClass("Humanoid")
    local backpack = player:FindFirstChildOfClass("Backpack")
    if not humanoid or not backpack then return end

    -- Видаляємо старий тул якщо є
    if JerkTool then
        pcall(function() JerkTool:Destroy() end)
        JerkTool = nil
    end

    JerkTool = Instance.new("Tool")
    JerkTool.Name = "Jerk Off"
    JerkTool.ToolTip = "in the stripped club. straight up \"jorking it\"."
    JerkTool.RequiresHandle = false
    JerkTool.Parent = backpack

    JerkTool.Equipped:Connect(function()
        if not JerkEnabled then return end
        -- Запускаємо цикл анімації
        JerkThread = task.spawn(function()
            local jorkin = true
            while JerkEnabled and jorkin do
                task.wait(0.1)

                local c = player.Character
                local h = c and c:FindFirstChildOfClass("Humanoid")
                if not h then break end

                local isR15 = jerkIsR15(player)

                if not JerkTrack then
                    local anim = Instance.new("Animation")
                    anim.AnimationId = not isR15 and "rbxassetid://72042024" or "rbxassetid://698251653"
                    pcall(function()
                        JerkTrack = h:LoadAnimation(anim)
                    end)
                end

                if JerkTrack then
                    pcall(function()
                        JerkTrack:Play()
                        JerkTrack:AdjustSpeed(isR15 and 0.7 or 0.65)
                        JerkTrack.TimePosition = 0.6
                    end)
                    task.wait(0.1)
                    local targetTime = (not isR15) and 0.65 or 0.7
                    while JerkTrack and JerkTrack.TimePosition < targetTime do
                        task.wait(0.1)
                    end
                    if JerkTrack then
                        pcall(function() JerkTrack:Stop() end)
                        JerkTrack = nil
                    end
                end
            end
        end)
    end)

    JerkTool.Unequipped:Connect(function()
        if JerkThread then
            pcall(function() task.cancel(JerkThread) end)
            JerkThread = nil
        end
        if JerkTrack then
            pcall(function() JerkTrack:Stop() end)
            JerkTrack = nil
        end
    end)
end

-- ============================================================
-- ==================== UI ====================================
-- ============================================================
Tabs.Trolling:AddSection("Jerk Tool")

Tabs.Trolling:AddButton({
    Title = "Give Jerk Tool",
    Description = "Adds the tool to your backpack",
    Callback = function()
        local player = game.Players.LocalPlayer
        JerkEnabled = true
        jerkGiveTool(player)
        Fluent:Notify({
            Title = "Jerk Tool",
            Content = "Tool added. Equip it to start.",
            Duration = 2
        })
    end
})

Tabs.Trolling:AddButton({
    Title = "Remove Jerk Tool",
    Description = "Removes the tool and stops animation",
    Callback = function()
        JerkEnabled = false
        jerkStop()
        Fluent:Notify({
            Title = "Jerk Tool",
            Content = "Removed",
            Duration = 2
        })
    end
})

-- Автоматична перевидача тула після респавну
game.Players.LocalPlayer.CharacterAdded:Connect(function()
    if JerkEnabled then
        task.wait(1)
        jerkGiveTool(game.Players.LocalPlayer)
    end
end)











--ESP
-- ============================================================
-- ==================== ESP TAB ===============================
-- ============================================================
local ESPPlayers = game:GetService("Players")
local ESPReplicatedStorage = game:GetService("ReplicatedStorage")
local ESPRunService = game:GetService("RunService")
local ESPLocalPlayer = ESPPlayers.LocalPlayer

local espEnabled = false
local mm2EspEnabled = false
local espLoopConnection = nil

-- ============================================================
-- ============ УНІВЕРСАЛЬНИЙ ESP ============================
-- ============================================================
local function createUniversalESP(player)
    if player == ESPLocalPlayer then return end
    if not player.Character then return end
    if player.Character:FindFirstChild("Universal_ESP") then return end

    local highlight = Instance.new("Highlight")
    highlight.Name = "Universal_ESP"
    highlight.Adornee = player.Character
    highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    highlight.FillTransparency = 1
    highlight.OutlineTransparency = 0

    if player.Team then
        highlight.OutlineColor = player.Team.TeamColor.Color
    else
        highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
    end

    highlight.Parent = player.Character
end

local function removeUniversalESP()
    for _, player in ipairs(ESPPlayers:GetPlayers()) do
        if player.Character then
            local esp = player.Character:FindFirstChild("Universal_ESP")
            if esp then esp:Destroy() end
        end
    end
end

local function enableUniversalESP()
    for _, player in ipairs(ESPPlayers:GetPlayers()) do
        if player ~= ESPLocalPlayer then
            createUniversalESP(player)
        end
    end

    if espLoopConnection then espLoopConnection:Disconnect() end
    espLoopConnection = ESPRunService.Heartbeat:Connect(function()
        if not espEnabled then return end
        for _, player in ipairs(ESPPlayers:GetPlayers()) do
            if player ~= ESPLocalPlayer and player.Character then
                if not player.Character:FindFirstChild("Universal_ESP") then
                    createUniversalESP(player)
                end
            end
        end
    end)
end

local function disableUniversalESP()
    if espLoopConnection then
        espLoopConnection:Disconnect()
        espLoopConnection = nil
    end
    removeUniversalESP()
end

-- ============================================================
-- ==================== MM2 ESP ===============================
-- ============================================================
local mm2Murderer = nil
local mm2Sheriff = nil
local mm2Hero = nil
local mm2LoopThread = nil
local mm2LoopActive = false

local function createMM2Highlight(player)
    if player == ESPLocalPlayer then return end
    if not player.Character then return end
    if player.Character:FindFirstChild("MM2_ESP_Highlight") then return end

    local highlight = Instance.new("Highlight")
    highlight.Name = "MM2_ESP_Highlight"
    highlight.Adornee = player.Character
    highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    highlight.FillTransparency = 0.5
    highlight.OutlineTransparency = 0
    highlight.Enabled = false
    highlight.Parent = player.Character
end

local function updateMM2Highlights()
    for _, player in ipairs(ESPPlayers:GetPlayers()) do
        if player ~= ESPLocalPlayer and player.Character then
            local highlight = player.Character:FindFirstChild("MM2_ESP_Highlight")
            if highlight then
                local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
                local isAlive = humanoid and humanoid.Health > 0

                if not isAlive then
                    highlight.Enabled = false
                else
                    highlight.Enabled = true

                    if player.Name == mm2Sheriff then
                        highlight.FillColor = Color3.fromRGB(0, 0, 255)
                        highlight.OutlineColor = Color3.fromRGB(0, 0, 255)
                    elseif player.Name == mm2Murderer then
                        highlight.FillColor = Color3.fromRGB(255, 0, 0)
                        highlight.OutlineColor = Color3.fromRGB(255, 0, 0)
                    elseif player.Name == mm2Hero then
                        highlight.FillColor = Color3.fromRGB(255, 255, 0)
                        highlight.OutlineColor = Color3.fromRGB(255, 255, 0)
                    else
                        highlight.FillColor = Color3.fromRGB(0, 255, 0)
                        highlight.OutlineColor = Color3.fromRGB(0, 255, 0)
                    end
                end
            end
        end
    end
end

local function updateMM2Roles()
    local success, roles = pcall(function()
        local remote = ESPReplicatedStorage:FindFirstChild("GetPlayerData", true)
        if remote then
            return remote:InvokeServer()
        end
        return nil
    end)

    if not success or not roles then return end

    mm2Murderer = nil
    mm2Sheriff = nil
    mm2Hero = nil

    for playerName, data in pairs(roles) do
        if data.Role == "Murderer" then
            mm2Murderer = playerName
        elseif data.Role == "Sheriff" then
            mm2Sheriff = playerName
        elseif data.Role == "Hero" then
            mm2Hero = playerName
        end
    end
end

local function enableMM2ESP()
    for _, player in ipairs(ESPPlayers:GetPlayers()) do
        if player ~= ESPLocalPlayer then
            createMM2Highlight(player)
        end
    end

    updateMM2Roles()
    updateMM2Highlights()

    if mm2LoopActive then
        mm2LoopActive = false
        if mm2LoopThread then
            task.cancel(mm2LoopThread)
            mm2LoopThread = nil
        end
    end

    mm2LoopActive = true

    mm2LoopThread = task.spawn(function()
        local nextRoleCheck = tick() + 5

        while mm2LoopActive do
            if tick() >= nextRoleCheck then
                updateMM2Roles()
                nextRoleCheck = tick() + 5
            end

            updateMM2Highlights()

            for _, player in ipairs(ESPPlayers:GetPlayers()) do
                if player ~= ESPLocalPlayer and player.Character then
                    if not player.Character:FindFirstChild("MM2_ESP_Highlight") then
                        createMM2Highlight(player)
                    end
                end
            end

            task.wait(1)
        end
    end)
end

local function disableMM2ESP()
    mm2LoopActive = false
    if mm2LoopThread then
        task.cancel(mm2LoopThread)
        mm2LoopThread = nil
    end

    for _, player in ipairs(ESPPlayers:GetPlayers()) do
        if player.Character then
            local h = player.Character:FindFirstChild("MM2_ESP_Highlight")
            if h then h:Destroy() end
        end
    end

    mm2Murderer = nil
    mm2Sheriff = nil
    mm2Hero = nil
end

-- ============================================================
-- ============ ОБРОБКА НОВИХ ГРАВЦІВ ========================
-- ============================================================
ESPPlayers.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function()
        task.wait(0.5)
        if espEnabled then createUniversalESP(player) end
        if mm2EspEnabled then createMM2Highlight(player) end
    end)
end)

ESPPlayers.PlayerRemoving:Connect(function(player)
    if player.Character then
        local universal = player.Character:FindFirstChild("Universal_ESP")
        if universal then universal:Destroy() end
        local mm2 = player.Character:FindFirstChild("MM2_ESP_Highlight")
        if mm2 then mm2:Destroy() end
    end
end)

-- ============================================================
-- ==================== ESP UI ================================
-- ============================================================
Tabs.ESP:AddSection("Universal ESP")

Tabs.ESP:AddToggle("UniversalESPToggle", {
    Title = "Enable Universal ESP",
    Default = false,
    Callback = function(Value)
        espEnabled = Value
        if Value then
            enableUniversalESP()
            Fluent:Notify({
                Title = "ESP",
                Content = "Universal ESP enabled",
                Duration = 2
            })
        else
            disableUniversalESP()
            Fluent:Notify({
                Title = "ESP",
                Content = "Universal ESP disabled",
                Duration = 2
            })
        end
    end
})

Tabs.ESP:AddSection("MM2 ESP")

Tabs.ESP:AddToggle("MM2ESPToggle", {
    Title = "Enable MM2 Role ESP",
    Default = false,
    Callback = function(Value)
        mm2EspEnabled = Value
        if Value then
            enableMM2ESP()
            Fluent:Notify({
                Title = "MM2 ESP",
                Content = "MM2 Role ESP enabled",
                Duration = 2
            })
        else
            disableMM2ESP()
            Fluent:Notify({
                Title = "MM2 ESP",
                Content = "MM2 Role ESP disabled",
                Duration = 2
            })
        end
    end
})










-- ============================================================
-- ==================== MM2 AUTO FARM =========================
-- ============================================================
local MM2FarmEnabled = false
local MM2FarmThread
local FlySpeed = 30

local function startMM2Farm()
    if MM2FarmEnabled then return end
    MM2FarmEnabled = true

    MM2FarmThread = task.spawn(function()
        while MM2FarmEnabled do
            local ok, err = pcall(function()
                local player = game:GetService("Players").LocalPlayer
                local character = player.Character

                if not character or not character.PrimaryPart then
                    task.wait(0.5)
                    return
                end

                local map

                for _, v in ipairs(workspace:GetDescendants()) do
                    if v:IsA("Model") and v.Name == "Base" then
                        map = v.Parent
                        break
                    end
                end

                local container = map and map:FindFirstChild("CoinContainer")

                if not container then
                    task.wait(1)
                    return
                end

                local nearest
                local nearestDistance = 200

                for _, v in ipairs(container:GetDescendants()) do
                    if v:IsA("BasePart")
                    and v:FindFirstChildWhichIsA("TouchTransmitter") then

                        local distance =
                            (character.PrimaryPart.Position - v.Position).Magnitude

                        if distance < nearestDistance then
                            nearest = v
                            nearestDistance = distance
                        end
                    end
                end

                if nearest and nearest.Parent then
                    local distance =
                        (character.PrimaryPart.Position - nearest.Position).Magnitude

                    local duration = math.max(distance / FlySpeed, 0.05)
                    local start = character.PrimaryPart.Position
                    local time = tick()

                    while MM2FarmEnabled and nearest.Parent do
                        character = player.Character

                        if not character or not character.PrimaryPart then
                            break
                        end

                        local alpha = math.min(
                            (tick() - time) / duration,
                            1
                        )

                        character:PivotTo(
                            CFrame.new(
                                start:Lerp(nearest.Position, alpha)
                            )
                        )

                        if alpha >= 1 then
                            task.wait(0.8)
                            break
                        end

                        task.wait()
                    end
                else
                    task.wait(0.2)
                end
            end)

            if not ok then
                warn("[MM2 Farm]", err)
                task.wait(0.2)
            end

            task.wait()
        end
    end)
end

local function stopMM2Farm()
    MM2FarmEnabled = false

    if MM2FarmThread then
        pcall(function()
            task.cancel(MM2FarmThread)
        end)

        MM2FarmThread = nil
    end
end

Tabs.AutoFarmMM2:AddSection("MM2 Auto Farm")

Tabs.AutoFarmMM2:AddToggle("MM2FarmToggle", {
    Title = "Enable MM2 Auto Farm",
    Default = false,

    Callback = function(Value)
        if Value then
            startMM2Farm()
        else
            stopMM2Farm()
        end
    end
})

Tabs.AutoFarmMM2:AddSlider("MM2FlySpeed", {
    Title = "Fly Speed",
    Description = "Flight Speed to Coin",
    Default = 30,
    Min = 5,
    Max = 100,
    Rounding = 0,

    Callback = function(Value)
        FlySpeed = Value
    end
})


-- ============================================================
-- ==================== ANTI-FLING ============================
-- ============================================================
local AntiFlingEnabled = false
local antiFlingLoopStarted = false

local function setCanCollideOfModelDescendants(model, bval)
    if not model then return end
    for _, v in pairs(model:GetDescendants()) do
        if v:IsA("BasePart") then
            v.CanCollide = bval
        end
    end
end

Tabs.Anti:AddSection("Protection")

Tabs.Anti:AddToggle("AntiFlingToggle", {
    Title = "Anti Fling",
    Default = false,
    Callback = function(Value)
        AntiFlingEnabled = Value

        if AntiFlingEnabled then
            for _, v in pairs(game.Players:GetPlayers()) do
                if v ~= game.Players.LocalPlayer and v.Character then
                    setCanCollideOfModelDescendants(v.Character, false)
                end
            end

            if not antiFlingLoopStarted then
                antiFlingLoopStarted = true
                game:GetService("RunService").Stepped:Connect(function()
                    if AntiFlingEnabled then
                        for _, v in pairs(game.Players:GetPlayers()) do
                            if v ~= game.Players.LocalPlayer and v.Character then
                                setCanCollideOfModelDescendants(v.Character, false)
                            end
                        end
                    end
                end)
            end

            Fluent:Notify({ Title = "Anti Fling", Content = "On", Duration = 2 })
        else
            for _, v in pairs(game.Players:GetPlayers()) do
                if v ~= game.Players.LocalPlayer and v.Character then
                    setCanCollideOfModelDescendants(v.Character, true)
                end
            end

            Fluent:Notify({ Title = "Anti Fling", Content = "Off", Duration = 2 })
        end
    end
})

-- ============================================================
-- ==================== ANTI-AFK ==============================
-- ============================================================
local AntiAFKEnabled = false
local antiAFKConnection = nil

local VirtualUser = game:GetService("VirtualUser")

Tabs.Anti:AddToggle("AntiAFKToggle", {
    Title = "Anti AFK",
    Default = false,
    Callback = function(Value)
        AntiAFKEnabled = Value

        if AntiAFKEnabled then
            if antiAFKConnection then
                antiAFKConnection:Disconnect()
            end

            antiAFKConnection = game.Players.LocalPlayer.Idled:Connect(function()
                if not AntiAFKEnabled then return end

                pcall(function()
                    VirtualUser:CaptureController()
                    VirtualUser:ClickButton2(Vector2.new(0, 0))
                end)
            end)

            Fluent:Notify({ Title = "Anti AFK", Content = "On", Duration = 2 })
        else
            if antiAFKConnection then
                antiAFKConnection:Disconnect()
                antiAFKConnection = nil
            end

            Fluent:Notify({ Title = "Anti AFK", Content = "Off", Duration = 2 })
        end
    end
})


-- ============================================================
-- ==================== ANTI-AFK (ULTIMATE) ===================
-- ============================================================
local AntiAFKEnabled = false
local antiAFKConnections = {}

local Players = game:GetService("Players")
local VirtualUser = game:GetService("VirtualUser")
local VirtualInputManager = game:GetService("VirtualInputManager")
local localPlayer = Players.LocalPlayer

-- Спроба повністю вимкнути сигнал Idled (найсильніший метод)
local function disableIdledSignal()
    local connections = getconnections or get_signal_cons or get_signal_connections
    if not connections then return false end

    local success = pcall(function()
        for _, v in pairs(connections(localPlayer.Idled)) do
            if v["Disable"] then
                v["Disable"](v)
            elseif v["Disconnect"] then
                v["Disconnect"](v)
            end
        end
    end)
    return success
end

-- Класичний метод: імітація кліку через VirtualUser
local function setupVirtualUserAntiAFK()
    local conn = localPlayer.Idled:Connect(function()
        if not AntiAFKEnabled then return end
        pcall(function()
            VirtualUser:CaptureController()
            VirtualUser:ClickButton2(Vector2.new(0, 0))
        end)
    end)
    table.insert(antiAFKConnections, conn)
end

-- Альтернативний метод: Button2Down/Up (іноді працює там, де ClickButton2 не проходить)
local function setupButton2AntiAFK()
    local conn = localPlayer.Idled:Connect(function()
        if not AntiAFKEnabled then return end
        pcall(function()
            VirtualUser:CaptureController()
            VirtualUser:Button2Down(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
            task.wait(1)
            VirtualUser:Button2Up(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
        end)
    end)
    table.insert(antiAFKConnections, conn)
end

-- Імітація руху персонажа (WASD + Space) з випадковими інтервалами
local function startMovementSimulation()
    task.spawn(function()
        local keys = {
            Enum.KeyCode.W, Enum.KeyCode.A, Enum.KeyCode.S,
            Enum.KeyCode.D, Enum.KeyCode.Space
        }
        while AntiAFKEnabled do
            task.wait(math.random(30, 90)) -- кожні 30-90 секунд
            if not AntiAFKEnabled then break end
            local key = keys[math.random(1, #keys)]
            pcall(function()
                VirtualInputManager:SendKeyEvent(true, key, false, game)
                task.wait(0.1)
                VirtualInputManager:SendKeyEvent(false, key, false, game)
            end)
        end
    end)
end

Tabs.Anti:AddToggle("AntiAFKToggle", {
    Title = "Anti AFK (Ultimate)",
    Default = false,
    Callback = function(Value)
        AntiAFKEnabled = Value

        if AntiAFKEnabled then
            -- Метод 1: спроба вимкнути сигнал повністю
            local disabled = disableIdledSignal()

            -- Метод 2: якщо не вдалося — підключаємо обидва варіанти VirtualUser
            if not disabled then
                setupVirtualUserAntiAFK()
                setupButton2AntiAFK()
            end

            -- Метод 3: додатково імітуємо рух персонажа
            startMovementSimulation()

            Fluent:Notify({
                Title = "Anti AFK",
                Content = disabled and "Idled signal disabled" or "Input simulation activated",
                Duration = 2
            })
        else
            for _, conn in ipairs(antiAFKConnections) do
                if conn and conn.Connected then conn:Disconnect() end
            end
            antiAFKConnections = {}

            Fluent:Notify({
                Title = "Anti AFK",
                Content = "Off",
                Duration = 2
            })
        end
    end
})

-- ============================================================
-- ==================== BANG PLAYER (IY) ======================
-- ============================================================
local BangPlayers = game:GetService("Players")
local BangLocalPlayer = BangPlayers.LocalPlayer
local BangRunService = game:GetService("RunService")

local bangSelectedPlayer = nil
local bangSpeed = 3
local bangMoving = false
local bangThread = nil
local bangAnim = nil
local bangTrack = nil

-- Звук кліпання
local bangClappingSound = Instance.new("Sound")
bangClappingSound.SoundId = "rbxassetid://9114762281"
bangClappingSound.Looped = true
bangClappingSound.Volume = 1

-- Перевірка чи R15
local function bangIsR15(player)
    local character = player.Character
    if not character then return true end
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if not humanoid then return true end
    return humanoid.RigType == Enum.HumanoidRigType.R15
end

-- Отримати torso (як в IY)
local function bangGetTorso(character)
    if not character then return nil end
    return character:FindFirstChild("Torso")
        or character:FindFirstChild("UpperTorso")
        or character:FindFirstChild("LowerTorso")
        or character:FindFirstChild("HumanoidRootPart")
end

-- Отримати root (як в IY)
local function bangGetRoot(character)
    if not character then return nil end
    return character:FindFirstChild("HumanoidRootPart")
end

-- Рух: приклеювання на 1.1 стад вперед від цілі
local function bangLoop()
    local bangOffset = CFrame.new(0, 0, 1.1)

    while bangMoving do
        local speakerChar = BangLocalPlayer.Character
        local targetChar = bangSelectedPlayer and bangSelectedPlayer.Character

        if speakerChar and targetChar then
            local speakerRoot = bangGetRoot(speakerChar)
            local otherRoot = bangGetTorso(targetChar)

            if speakerRoot and otherRoot then
                pcall(function()
                    speakerRoot.CFrame = otherRoot.CFrame * bangOffset
                end)
            end
        end

        BangRunService.Stepped:Wait()
    end
end

-- Запуск анімації
local function bangStartAnim()
    local character = BangLocalPlayer.Character
    if not character then return end

    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if not humanoid then return end

    local isR15 = bangIsR15(BangLocalPlayer)

    bangAnim = Instance.new("Animation")
    bangAnim.AnimationId = not isR15 and "rbxassetid://148840371" or "rbxassetid://5918726674"

    local ok = pcall(function()
        bangTrack = humanoid:LoadAnimation(bangAnim)
    end)

    if ok and bangTrack then
        pcall(function()
            bangTrack:Play(0.1, 1, 1)
            bangTrack:AdjustSpeed(bangSpeed)
        end)
    end
end

-- Зупинка анімації
local function bangStopAnim()
    if bangTrack then
        pcall(function() bangTrack:Stop() end)
        bangTrack = nil
    end
    if bangAnim then
        pcall(function() bangAnim:Destroy() end)
        bangAnim = nil
    end
end

-- Запуск звуку
local function bangStartSound()
    local char = BangLocalPlayer.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        if not bangClappingSound.Parent then
            bangClappingSound.Parent = char.HumanoidRootPart
        end
        pcall(function() bangClappingSound:Play() end)
    end
end

-- Зупинка звуку
local function bangStopSound()
    pcall(function() bangClappingSound:Stop() end)
    if bangClappingSound.Parent then
        bangClappingSound.Parent = nil
    end
end

-- Повна зупинка
local function bangStopAll()
    bangMoving = false
    bangStopAnim()
    bangStopSound()
    if bangThread then
        pcall(function() task.cancel(bangThread) end)
        bangThread = nil
    end
end

-- ============================================================
-- ==================== UI ====================================
-- ============================================================
Tabs.Trolling:AddSection("Bang Player")

-- Функція отримання списку гравців
local function getBangPlayerNames()
    local list = {}
    for _, plr in ipairs(BangPlayers:GetPlayers()) do
        if plr ~= BangLocalPlayer then
            table.insert(list, plr.Name)
        end
    end
    if #list == 0 then
        table.insert(list, "No players")
    end
    return list
end

-- Dropdown для вибору гравця
local BangDropdown
BangDropdown = Tabs.Trolling:AddDropdown("BangPlayerDropdown", {
    Title = "Select player",
    Values = getBangPlayerNames(),
    Multi = false,
    Default = 1,
    Callback = function(Value)
        if Value == "No players" then
            bangSelectedPlayer = nil
            return
        end
        bangSelectedPlayer = BangPlayers:FindFirstChild(Value)
        if bangSelectedPlayer then
            Fluent:Notify({
                Title = "Bang Player",
                Content = "Selected: " .. bangSelectedPlayer.DisplayName .. " (" .. bangSelectedPlayer.Name .. ")",
                Duration = 2
            })
        end
    end
})

-- Кнопка ручного оновлення списку
Tabs.Trolling:AddButton({
    Title = "Refresh Bang Player List",
    Callback = function()
        if BangDropdown then
            BangDropdown:SetValues(getBangPlayerNames())

            Fluent:Notify({
                Title = "Bang Player",
                Content = "Player list updated",
                Duration = 2
            })
        end
    end
})

-- Функція оновлення dropdown
local function refreshBangDropdown()
    if BangDropdown then
        BangDropdown:Refresh(getBangPlayerNames())
    end
end

-- Автооновлення при вході гравця
BangPlayers.PlayerAdded:Connect(function()
    task.wait(0.5)
    refreshBangDropdown()
end)

-- Автооновлення при виході гравця
BangPlayers.PlayerRemoving:Connect(function()
    task.wait(0.1)
    refreshBangDropdown()
end)

-- Автовибір першого гравця при завантаженні
task.spawn(function()
    task.wait(0.5)
    local names = getBangPlayerNames()
    if names[1] and names[1] ~= "No players" then
        bangSelectedPlayer = BangPlayers:FindFirstChild(names[1])
    end
end)

-- Slider швидкості анімації
Tabs.Trolling:AddSlider("BangSpeedSlider", {
    Title = "Anim Speed",
    Default = 3,
    Min = 1,
    Max = 10,
    Rounding = 1,
    Callback = function(Value)
        bangSpeed = Value
        if bangTrack then
            pcall(function() bangTrack:AdjustSpeed(bangSpeed) end)
        end
    end
})

-- Toggle Bang
local BangToggle
BangToggle = Tabs.Trolling:AddToggle("BangToggle", {
    Title = "Enable Bang",
    Default = false,
    Callback = function(Value)
        if Value then
            if not bangSelectedPlayer then
                Fluent:Notify({
                    Title = "Bang Player",
                    Content = "Select a player first",
                    Duration = 2
                })
                if BangToggle then BangToggle:Set(false) end
                return
            end

            if not bangSelectedPlayer.Character then
                Fluent:Notify({
                    Title = "Bang Player",
                    Content = "Target has no character",
                    Duration = 2
                })
                if BangToggle then BangToggle:Set(false) end
                return
            end

            bangMoving = true
            bangStartAnim()
            bangStartSound()

            if bangThread then
                pcall(function() task.cancel(bangThread) end)
            end
            bangThread = task.spawn(bangLoop)

            Fluent:Notify({
                Title = "Bang Player",
                Content = "Started on " .. bangSelectedPlayer.Name,
                Duration = 2
            })
        else
            bangStopAll()
            Fluent:Notify({
                Title = "Bang Player",
                Content = "Stopped",
                Duration = 2
            })
        end
    end
})

-- Автоматична зупинка при смерті
BangLocalPlayer.CharacterAdded:Connect(function()
    if bangMoving then
        bangStopAll()
        if BangToggle then BangToggle:Set(false) end
    end
end)
















-- ============================================================
-- ==================== TELEPORT TAB ==========================
-- ============================================================
-- ============================================================
-- ==================== TELEPORT TAB ==========================
-- ============================================================
local TPPlayers = game:GetService("Players")
local TPLocalPlayer = TPPlayers.LocalPlayer

local tpSelectedPlayer = nil
local tpX = 0
local tpY = 0
local tpZ = 0

-- ============================================================
-- ============ LIVE COORDINATES DISPLAY ======================
-- ============================================================
local coordsLabel = nil

task.spawn(function()
    while true do
        task.wait(0.1)
        pcall(function()
            local char = TPLocalPlayer.Character
            if char and char:FindFirstChild("HumanoidRootPart") and coordsLabel then
                local pos = char.HumanoidRootPart.Position
                local text = string.format("X: %.2f  |  Y: %.2f  |  Z: %.2f", pos.X, pos.Y, pos.Z)
                coordsLabel:SetDesc(text)
            end
        end)
    end
end)

coordsLabel = Tabs.Teleport:AddParagraph({
    Title = "Current Position",
    Content = "X: 0.00  |  Y: 0.00  |  Z: 0.00"
})

-- ============================================================
-- ============ ФУНКЦІЯ ТЕЛЕПОРТУ =============================
-- ============================================================
local function doTeleport(targetCFrame)
    local char = TPLocalPlayer.Character
    if not char then return false, "No character" end

    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return false, "No HumanoidRootPart" end

    -- Спосіб 1: PivotTo на моделі персонажа
    local ok1 = pcall(function()
        char:PivotTo(targetCFrame)
    end)

    -- Спосіб 2: SetPrimaryPartCFrame (старіший)
    local ok2 = pcall(function()
        char:SetPrimaryPartCFrame(targetCFrame)
    end)

    -- Спосіб 3: прямий CFrame
    local ok3 = pcall(function()
        hrp.CFrame = targetCFrame
    end)

    -- Спосіб 4: CFrame через Velocity (обхід блокування)
    local ok4 = pcall(function()
        hrp.Velocity = Vector3.new(0, 0, 0)
        hrp.CFrame = targetCFrame
    end)

    if ok1 or ok2 or ok3 or ok4 then
        return true
    end
    return false, "Teleport blocked"
end

-- ============================================================
-- ============ TELEPORT TO PLAYER ============================
-- ============================================================
Tabs.Teleport:AddSection("Teleport To Player")

local function getPlayerNames()
    local list = {}
    for _, plr in ipairs(TPPlayers:GetPlayers()) do
        if plr ~= TPLocalPlayer then
            table.insert(list, plr.Name)
        end
    end
    if #list == 0 then
        table.insert(list, "No players")
    end
    return list
end

local PlayerTPDropdown
PlayerTPDropdown = Tabs.Teleport:AddDropdown("TPPlayerDropdown", {
    Title = "Select player",
    Values = getPlayerNames(),
    Multi = false,
    Default = 1,
    Callback = function(Value)
        if Value == "No players" then
            tpSelectedPlayer = nil
            return
        end
        tpSelectedPlayer = TPPlayers:FindFirstChild(Value)
    end
})

-- Кнопка ручного оновлення списку
Tabs.Teleport:AddButton({
    Title = "Refresh Player List",
    Callback = function()
        if PlayerTPDropdown then
            PlayerTPDropdown:SetValues(getPlayerNames())

            Fluent:Notify({
                Title = "Teleport",
                Content = "Player list updated",
                Duration = 2
            })
        end
    end
})

-- Функція оновлення dropdown
local function refreshTPDropdown()
    if PlayerTPDropdown then
        PlayerTPDropdown:Refresh(getPlayerNames())
    end
end

-- Автооновлення при вході гравця
TPPlayers.PlayerAdded:Connect(function()
    task.wait(0.5)
    refreshTPDropdown()
end)

-- Автооновлення при виході гравця
TPPlayers.PlayerRemoving:Connect(function()
    task.wait(0.1)
    refreshTPDropdown()
end)

-- Автовибір першого гравця при завантаженні
task.spawn(function()
    task.wait(0.5)
    local names = getPlayerNames()
    if names[1] and names[1] ~= "No players" then
        tpSelectedPlayer = TPPlayers:FindFirstChild(names[1])
    end
end)

Tabs.Teleport:AddButton({
    Title = "Teleport to Player",
    Description = "Teleports you to the selected player",
    Callback = function()
        if not tpSelectedPlayer then
            Fluent:Notify({
                Title = "Teleport",
                Content = "No player selected",
                Duration = 2
            })
            return
        end

        local targetChar = tpSelectedPlayer.Character
        if not targetChar then
            Fluent:Notify({
                Title = "Teleport",
                Content = "Target has no character",
                Duration = 2
            })
            return
        end

        local targetHRP = targetChar:FindFirstChild("HumanoidRootPart")
        if not targetHRP then
            Fluent:Notify({
                Title = "Teleport",
                Content = "Target has no HumanoidRootPart",
                Duration = 2
            })
            return
        end

        local destCFrame = targetHRP.CFrame + Vector3.new(0, 3, 0)

        local success, err = doTeleport(destCFrame)

        if success then
            Fluent:Notify({
                Title = "Teleport",
                Content = "Teleported to " .. tpSelectedPlayer.Name,
                Duration = 2
            })
        else
            Fluent:Notify({
                Title = "Teleport",
                Content = "Failed: " .. tostring(err),
                Duration = 3
            })
        end
    end
})

-- ============================================================
-- ============ TELEPORT TO COORDINATES =======================
-- ============================================================
Tabs.Teleport:AddSection("Teleport To Coordinates")

Tabs.Teleport:AddInput("TPXInput", {
    Title = "X",
    Default = "0",
    Placeholder = "X coordinate",
    Numeric = false,
    Finished = false,
    Callback = function(Value)
        tpX = tonumber(Value) or 0
    end
})

Tabs.Teleport:AddInput("TPYInput", {
    Title = "Y",
    Default = "0",
    Placeholder = "Y coordinate",
    Numeric = false,
    Finished = false,
    Callback = function(Value)
        tpY = tonumber(Value) or 0
    end
})

Tabs.Teleport:AddInput("TPZInput", {
    Title = "Z",
    Default = "0",
    Placeholder = "Z coordinate",
    Numeric = false,
    Finished = false,
    Callback = function(Value)
        tpZ = tonumber(Value) or 0
    end
})

Tabs.Teleport:AddButton({
    Title = "Teleport to Coordinates",
    Description = "Teleports to the entered XYZ coordinates",
    Callback = function()
        local destCFrame = CFrame.new(tpX, tpY, tpZ)

        local success, err = doTeleport(destCFrame)

        if success then
            Fluent:Notify({
                Title = "Teleport",
                Content = string.format("Teleported to (%.1f, %.1f, %.1f)", tpX, tpY, tpZ),
                Duration = 2
            })
        else
            Fluent:Notify({
                Title = "Teleport",
                Content = "Failed: " .. tostring(err),
                Duration = 3
            })
        end
    end
})

-- ============================================================
-- ============ COPY CURRENT COORDINATES ======================
-- ============================================================
Tabs.Teleport:AddSection("Utilities")

Tabs.Teleport:AddButton({
    Title = "Copy Current Coordinates",
    Description = "Copies your position to clipboard",
    Callback = function()
        local char = TPLocalPlayer.Character
        if not char or not char:FindFirstChild("HumanoidRootPart") then
            Fluent:Notify({
                Title = "Teleport",
                Content = "No character",
                Duration = 2
            })
            return
        end

        local pos = char.HumanoidRootPart.Position
        local coordsText = string.format("%.2f, %.2f, %.2f", pos.X, pos.Y, pos.Z)

        local hasClipboard = false
        pcall(function()
            if setclipboard then
                setclipboard(coordsText)
                hasClipboard = true
            end
        end)

        if hasClipboard then
            Fluent:Notify({
                Title = "Teleport",
                Content = "Copied: " .. coordsText,
                Duration = 3
            })
        else
            Fluent:Notify({
                Title = "Teleport",
                Content = "Coords: " .. coordsText,
                Duration = 5
            })
        end
    end
})












-- ============================================================
-- ============ AUTO TELEPORT TO GUNDROP ======================
-- ============================================================
local GunTPEnabled = false
local GunTPThread = nil
local gunLastPos = nil
local gunAtGun = false
local GUN_NAME = "GunDrop"

local function gunGetRoot()
    local char = TPLocalPlayer.Character
    return char and char:FindFirstChild("HumanoidRootPart")
end

local function gunGetGun()
    return workspace:FindFirstChild(GUN_NAME, true)
end

local function gunGetCF(obj)
    if not obj then return nil end
    if obj:IsA("BasePart") then return obj.CFrame end
    if obj:IsA("Model") and obj.PrimaryPart then return obj.PrimaryPart.CFrame end
    return nil
end

Tabs.Teleport:AddSection("Auto GunDrop")

Tabs.Teleport:AddToggle("GunTPToggle", {
    Title = "Auto Teleport to GunDrop",
    Default = false,
    Callback = function(Value)
        GunTPEnabled = Value

        if Value then
            if GunTPThread then
                pcall(function() task.cancel(GunTPThread) end)
            end

            GunTPThread = task.spawn(function()
                while GunTPEnabled do
                    task.wait(0.01)

                    local root = gunGetRoot()
                    if not root then
                        gunAtGun = false
                        gunLastPos = nil
                    else
                        local gun = gunGetGun()
                        local cf = gun and gunGetCF(gun)

                        if gun and cf and not gunAtGun then
                            -- Зброя з'явилась — телепорт до неї
                            gunLastPos = root.CFrame
                            root.CFrame = cf
                            gunAtGun = true
                        elseif not gun and gunAtGun and gunLastPos then
                            -- Зброя зникла — повернення назад
                            root.CFrame = gunLastPos
                            gunAtGun = false
                            gunLastPos = nil
                        end
                    end
                end
            end)

            Fluent:Notify({
                Title = "Teleport",
                Content = "Auto GunDrop enabled",
                Duration = 2
            })
        else
            if GunTPThread then
                pcall(function() task.cancel(GunTPThread) end)
                GunTPThread = nil
            end

            -- Якщо ми біля зброї — повертаємось назад при вимкненні
            if gunAtGun and gunLastPos then
                local root = gunGetRoot()
                if root then root.CFrame = gunLastPos end
                gunAtGun = false
                gunLastPos = nil
            end

            Fluent:Notify({
                Title = "Teleport",
                Content = "Auto GunDrop disabled",
                Duration = 2
            })
        end
    end
})

-- Скидаємо стан при респавні
TPLocalPlayer.CharacterAdded:Connect(function()
    gunAtGun = false
    gunLastPos = nil
end)












-- ============================================================
-- ==================== CHARACTER TAB =========================
-- ============================================================
local CharacterPlayers = game:GetService("Players")
local CharacterRunService = game:GetService("RunService")
local CharacterPlayer = CharacterPlayers.LocalPlayer

-- ============================================================
-- ============ CUSTOM ANIMATIONS =============================
-- ============================================================
local ANIMATIONS = {
    Idle = "616158929",
    Walk = "75698356628646",
    Fall = "135946095722178",
    Climb = "117220698427723"
}

local animEnabled = false
local animTracks = {}
local animCurrentState = nil
local animLastUpdate = 0
local ANIM_CHECK_INTERVAL = 0.05
local animHeartbeatConn = nil

-- Отримує справжній AnimationId
local function getAnimationId(assetId)
    if type(assetId) ~= "string" or assetId == "" then return nil end
    if not assetId:find("rbxassetid://") then
        assetId = "rbxassetid://" .. assetId
    end
    local success, objs = pcall(game.GetObjects, game, assetId)
    if success and objs then
        for _, obj in ipairs(objs) do
            if obj:IsA("Animation") then
                return obj.AnimationId
            end
        end
    end
    return assetId
end

-- Отримує живого гуманоїда
local function getLiveHumanoid()
    local char = CharacterPlayer.Character
    if not char or not char.Parent then return nil, nil end
    local humanoid = char:FindFirstChildWhichIsA("Humanoid")
    if not humanoid or humanoid.Health <= 0 then return nil, nil end
    return char, humanoid
end

-- Отримує або створює Animator
local function getAnimator(humanoid)
    local animator = humanoid:FindFirstChildOfClass("Animator")
    if not animator then
        local ok
        ok, animator = pcall(Instance.new, "Animator", humanoid)
        if not ok or not animator then return nil end
    end
    return animator
end

-- Завантажує трек
local function loadTrack(animId, humanoid)
    if not humanoid then return nil end
    local animator = getAnimator(humanoid)
    if not animator then return nil end
    local realId = getAnimationId(animId)
    if not realId then return nil end
    local anim = Instance.new("Animation")
    anim.AnimationId = realId
    local success, track = pcall(function()
        return animator:LoadAnimation(anim)
    end)
    anim:Destroy()
    if success and track then
        track.Priority = Enum.AnimationPriority.Movement
        return track
    end
    return nil
end

-- Забезпечує існування треку
local function ensureTrack(name, humanoid)
    local track = animTracks[name]
    if track then
        local ok = pcall(function() return track.IsPlaying end)
        if ok then
            return track
        else
            animTracks[name] = nil
        end
    end
    local newTrack = loadTrack(ANIMATIONS[name], humanoid)
    if newTrack then
        animTracks[name] = newTrack
        return newTrack
    end
    return nil
end

-- Зупинка всіх треків
local function stopAllTracks()
    for _, track in pairs(animTracks) do
        if track then
            pcall(function() if track.IsPlaying then track:Stop() end end)
        end
    end
end

-- Основний оновлювач
local function updateAnimations()
    if not animEnabled then return end

    local now = os.clock()
    if now - animLastUpdate < ANIM_CHECK_INTERVAL then return end
    animLastUpdate = now

    local char, humanoid = getLiveHumanoid()
    if not char or not humanoid then
        stopAllTracks()
        return
    end

    local ok, state = pcall(humanoid.GetState, humanoid)
    if not ok then return end

    local isClimbing = (state == Enum.HumanoidStateType.Climbing)
    local isInAir = (state == Enum.HumanoidStateType.Jumping or state == Enum.HumanoidStateType.Freefall)
    local isMoving = humanoid.MoveDirection.Magnitude > 0.5

    local newState
    if isClimbing then
        newState = "Climb"
    elseif isInAir then
        newState = "Fall"
    elseif isMoving then
        newState = "Walk"
    else
        newState = "Idle"
    end

    if newState == animCurrentState then
        local track = animTracks[newState]
        if track then
            local ok2, playing = pcall(function() return track.IsPlaying end)
            if ok2 and not playing then
                pcall(track.Play, track)
            end
        end
        return
    end

    animCurrentState = newState
    stopAllTracks()

    local track = ensureTrack(newState, humanoid)
    if track then
        pcall(track.Play, track)
    end
end

-- Увімкнення
local function enableAnims()
    if animEnabled then return end
    animEnabled = true
    animCurrentState = nil
    animLastUpdate = 0

    local _, humanoid = getLiveHumanoid()
    if humanoid then
        animTracks.Idle = loadTrack(ANIMATIONS.Idle, humanoid)
        if animTracks.Idle then
            pcall(animTracks.Idle.Play, animTracks.Idle)
            animCurrentState = "Idle"
        end
    end

    if animHeartbeatConn then
        pcall(function() animHeartbeatConn:Disconnect() end)
    end
    animHeartbeatConn = CharacterRunService.Heartbeat:Connect(updateAnimations)
end

-- Вимкнення
local function disableAnims()
    if not animEnabled then return end
    animEnabled = false
    stopAllTracks()
    animTracks = {}
    animCurrentState = nil

    if animHeartbeatConn then
        pcall(function() animHeartbeatConn:Disconnect() end)
        animHeartbeatConn = nil
    end
end

-- ============================================================
-- ==================== UI ====================================
-- ============================================================
Tabs.Character:AddSection("Animations")

Tabs.Character:AddToggle("CustomAnimsToggle", {
    Title = "Custom Animations",
    Default = false,
    Callback = function(Value)
        if Value then
            enableAnims()
            Fluent:Notify({
                Title = "Animations",
                Content = "Custom animations enabled",
                Duration = 2
            })
        else
            disableAnims()
            Fluent:Notify({
                Title = "Animations",
                Content = "Custom animations disabled",
                Duration = 2
            })
        end
    end
})

-- Перестворення персонажа
CharacterPlayer.CharacterAdded:Connect(function(char)
    task.wait(0.5)
    if animEnabled then
        animTracks = {}
        local humanoid = char:FindFirstChildWhichIsA("Humanoid")
        if humanoid then
            animTracks.Idle = loadTrack(ANIMATIONS.Idle, humanoid)
            if animTracks.Idle then
                pcall(animTracks.Idle.Play, animTracks.Idle)
                animCurrentState = "Idle"
            end
        end
        animLastUpdate = 0
    end
end)











-- ============================================================
-- ============ ANIMATION PACK ================================
-- ============================================================
local AnimPackPlayer = game:GetService("Players").LocalPlayer

local animPackList = {
    "Cute Sit",
    "Chill Flying Levitation",
    "Zombie Walk",
    "Tall Scary Creature",
    "hey dude man im a dudeman",
    "Big Hand Wave",
    "Floating",
    "Catnap Emote",
    "Lucky Coin",
    "Funny Russian Dance Emote",
    "Sad Depressed Crying Sit",
    "i got that feeling",
    "Psycho Teddy [R6]",
    "1 Die Mm2",
    "2 Die Mm2",
    "3 Die Mm2",
    "4 Die Mm2",
}

local animPackIDs = {
    ["Cute Sit"] = "116578970554242",
    ["Chill Flying Levitation"] = "117049327096718",
    ["Zombie Walk"] = "616158929",
    ["Tall Scary Creature"] = "79216795769647",
    ["hey dude man im a dudeman"] = "125991701908850",
    ["Big Hand Wave"] = "105209959441169",
    ["Floating"] = "139058906415119",
    ["Catnap Emote"] = "137254376936260",
    ["Lucky Coin"] = "77721404341236",
    ["Funny Russian Dance Emote"] = "113491365226749",
    ["Sad Depressed Crying Sit"] = "95339652051393",
    ["i got that feeling"] = "72388969601943",
    ["Psycho Teddy [R6]"] = "96274144760859",
    ["1 Die Mm2"] = "72966304627892",
    ["2 Die Mm2"] = "134513676730208",
    ["3 Die Mm2"] = "101648023575380",
    ["4 Die Mm2"] = "110697733932236",
}

local animPackTrack = nil
local animPackPlaying = false

-- Отримати справжній AnimationId
local function animPackGetID(assetId)
    if not assetId:find("rbxassetid://") then
        assetId = "rbxassetid://" .. assetId
    end
    local success, objs = pcall(function()
        return game:GetObjects(assetId)
    end)
    if success and objs then
        for _, obj in ipairs(objs) do
            if obj:IsA("Animation") then
                return obj.AnimationId
            end
        end
    end
    return assetId
end

-- Запуск анімації
local function animPackPlay(id)
    local char = AnimPackPlayer.Character
    if not char then
        Fluent:Notify({ Title = "Animations", Content = "No character", Duration = 2 })
        return
    end

    local humanoid = char:FindFirstChildWhichIsA("Humanoid")
    if not humanoid then
        Fluent:Notify({ Title = "Animations", Content = "No humanoid", Duration = 2 })
        return
    end

    local animator = humanoid:FindFirstChild("Animator")
    if not animator then
        animator = Instance.new("Animator", humanoid)
    end

    if animPackTrack and animPackPlaying then
        pcall(function() animPackTrack:Stop() end)
        animPackPlaying = false
    end

    local realId = animPackGetID(id)
    local anim = Instance.new("Animation")
    anim.AnimationId = realId

    local success, newTrack = pcall(function()
        return animator:LoadAnimation(anim)
    end)

    if success and newTrack then
        animPackTrack = newTrack
        animPackTrack.Priority = Enum.AnimationPriority.Movement
        animPackTrack:Play()
        animPackPlaying = true
    else
        Fluent:Notify({ Title = "Animations", Content = "Failed to load", Duration = 2 })
    end
end

-- Зупинка
local function animPackStop()
    if animPackTrack and animPackPlaying then
        pcall(function() animPackTrack:Stop() end)
    end
    animPackPlaying = false
    animPackTrack = nil
end

-- ============================================================
-- ==================== UI ====================================
-- ============================================================
Tabs.Character:AddSection("Animation Pack")

Tabs.Character:AddDropdown("AnimPackDropdown", {
    Title = "Select animation",
    Values = animPackList,
    Multi = false,
    Default = 1,
    Callback = function(Value)
        if Value and animPackIDs[Value] then
            animPackPlay(animPackIDs[Value])
            Fluent:Notify({
                Title = "Animations",
                Content = "Playing: " .. Value,
                Duration = 2
            })
        end
    end
})

Tabs.Character:AddButton({
    Title = "Stop Animation",
    Callback = function()
        animPackStop()
        Fluent:Notify({
            Title = "Animations",
            Content = "Stopped",
            Duration = 2
        })
    end
})

-- Скидання при респавні
AnimPackPlayer.CharacterAdded:Connect(function()
    animPackTrack = nil
    animPackPlaying = false
end)












--========================================================--
-- MM2 AUTO FARM WALK - REWORKED
--========================================================--

local Players = game:GetService("Players")
local PathfindingService = game:GetService("PathfindingService")
local RunService = game:GetService("RunService")

local LocalPlayer = Players.LocalPlayer

--========================================================--
-- CONFIG
--========================================================--

local Config = {
    MaxCoinDistance = 1000,

    AgentRadius = 2,
    AgentHeight = 5,
    AgentCanJump = true,
    AgentCanClimb = false,
    WaypointSpacing = 4,

    WaypointReachDistance = 3.5,
    WaypointTimeout = 2.5,

    RepathDelay = 0.15,
    SearchDelay = 0.15,
    NoCoinDelay = 0.25,

    -- Головна перевірка найближчої монети
    CoinRefreshInterval = 1,

    -- Після збору додатково перевіряємо 3 рази
    PostCollectChecks = 3,

    -- Не перебудовувати шлях частіше цього інтервалу
    MinimumRepathInterval = 0.1,

    StuckCheckInterval = 0.6,
    StuckDistance = 1.5,

    -- Якщо поточна монета не зникає за цей час — вважаємо її проблемною
    CoinFailTimeout = 4,
}

--========================================================--
-- STATE
--========================================================--

local State = {
    Enabled = false,
    Running = false,

    Character = nil,
    Humanoid = nil,
    Root = nil,

    CoinContainer = nil,
    CurrentCoin = nil,

    LastPathTime = 0,
    LastPosition = nil,

    -- Час останнього оновлення цілі
    LastCoinRefresh = 0,

    -- Сигнал для негайного пошуку нової монети
    ForceRefresh = false,

    -- Час початку руху до поточної монети
    CurrentCoinStartTime = 0,

    -- Монети, які "зависли" і які треба пропустити
    FailedCoins = {},
}

local FarmThread = nil

--========================================================--
-- CHARACTER
--========================================================--

local function updateCharacter()
    local character = LocalPlayer.Character

    if not character then
        State.Character = nil
        State.Humanoid = nil
        State.Root = nil
        return false
    end

    local humanoid = character:FindFirstChildOfClass("Humanoid")
    local root = character:FindFirstChild("HumanoidRootPart")

    if not humanoid or not root then
        State.Character = character
        State.Humanoid = humanoid
        State.Root = root
        return false
    end

    State.Character = character
    State.Humanoid = humanoid
    State.Root = root

    return true
end

--========================================================--
-- FIND COIN CONTAINER
--========================================================--

local function findCoinContainer()
    if State.CoinContainer and State.CoinContainer.Parent then
        return State.CoinContainer
    end

    local container = workspace:FindFirstChild("CoinContainer", true)

    if container then
        State.CoinContainer = container
        return container
    end

    for _, object in ipairs(workspace:GetDescendants()) do
        if object:IsA("Model") and object.Name == "Base" then
            local parent = object.Parent

            if parent then
                container = parent:FindFirstChild("CoinContainer")

                if container then
                    State.CoinContainer = container
                    return container
                end
            end
        end
    end

    return nil
end

--========================================================--
-- COIN VALIDATION
--========================================================--

local function isValidCoin(coin)
    if not coin then
        return false
    end

    if not coin.Parent then
        return false
    end

    if not coin:IsA("BasePart") then
        return false
    end

    if not coin:FindFirstChildWhichIsA("TouchTransmitter") then
        return false
    end

    return true
end

--========================================================--
-- GET ALL VALID COINS
--========================================================--

local function getCoins()
    local container = findCoinContainer()

    if not container then
        return {}
    end

    local coins = {}

    for _, object in ipairs(container:GetDescendants()) do
        if isValidCoin(object) then
            table.insert(coins, object)
        end
    end

    return coins
end

--========================================================--
-- CHOOSE BEST COIN
--========================================================--

local function getBestCoin()
    if not updateCharacter() then
        return nil
    end

    local root = State.Root
    local coins = getCoins()

    if #coins == 0 then
        return nil
    end

    -- ====================================================
    -- ЯКЩО ВСІ МОНЕТИ ВЖЕ БУЛИ ПРОБЛЕМНИМИ — СКИДАЄМО СПИСОК
    -- ====================================================

    local hasAvailableCoin = false

    for _, coin in ipairs(coins) do
        if isValidCoin(coin) and not State.FailedCoins[coin] then
            hasAvailableCoin = true
            break
        end
    end

    if not hasAvailableCoin then
        State.FailedCoins = {}
    end

    local bestCoin = nil
    local bestDistance = Config.MaxCoinDistance

    for _, coin in ipairs(coins) do
        if isValidCoin(coin) and not State.FailedCoins[coin] then

            local distance =
                (root.Position - coin.Position).Magnitude

            if distance < bestDistance then
                bestDistance = distance
                bestCoin = coin
            end
        end
    end

    return bestCoin
end

--========================================================--
-- CREATE PATH
--========================================================--

local function createPath()
    return PathfindingService:CreatePath({
        AgentRadius = Config.AgentRadius,
        AgentHeight = Config.AgentHeight,
        AgentCanJump = Config.AgentCanJump,
        AgentCanClimb = Config.AgentCanClimb,
        WaypointSpacing = Config.WaypointSpacing,
    })
end

--========================================================--
-- COMPUTE PATH
--========================================================--

local function computePath(coin)
    if not isValidCoin(coin) then
        return nil
    end

    if not updateCharacter() then
        return nil
    end

    local now = os.clock()

    if now - State.LastPathTime < Config.MinimumRepathInterval then
        return nil
    end

    State.LastPathTime = now

    local path = createPath()

    local success = pcall(function()
        path:ComputeAsync(
            State.Root.Position,
            coin.Position
        )
    end)

    if not success then
        return nil
    end

    if path.Status ~= Enum.PathStatus.Success then
        return nil
    end

    local waypoints = path:GetWaypoints()

    if #waypoints < 2 then
        return nil
    end

    return path, waypoints
end

--========================================================--
-- STOP MOVEMENT
--========================================================--

local function stopMovement()
    if State.Humanoid then
        pcall(function()
            State.Humanoid:Move(Vector3.zero)
        end)
    end
end

--========================================================--
-- WAIT FOR WAYPOINT
--========================================================--

local function moveToWaypoint(waypoint, coin)
    if not State.Enabled then
        return false
    end

    if not isValidCoin(coin) then
        return false
    end

    if not updateCharacter() then
        return false
    end

    local humanoid = State.Humanoid
    local root = State.Root

    if waypoint.Action == Enum.PathWaypointAction.Jump then
        humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
    end

    humanoid:MoveTo(waypoint.Position)

    local startTime = os.clock()
    local coinStartTime = State.CurrentCoinStartTime

    while State.Enabled do

        if not isValidCoin(coin) then
            return false
        end

        if not updateCharacter() then
            return false
        end

        -- ====================================================
        -- МОНЕТА НЕ ЗБИРАЄТЬСЯ ЗАНАДТО ДОВГО
        -- ====================================================

        if os.clock() - coinStartTime >= Config.CoinFailTimeout then

            State.FailedCoins[coin] = true
            State.CurrentCoin = nil

            return false
        end

        -- ============================================
        -- КОЖНІ 1 СЕКУНДУ ПЕРЕВІРЯЄМО НОВУ МОНЕТУ
        -- ============================================

        local now = os.clock()

        if now - State.LastCoinRefresh >= Config.CoinRefreshInterval
            or State.ForceRefresh then

            State.LastCoinRefresh = now
            State.ForceRefresh = false

            local nearestCoin = getBestCoin()

            if nearestCoin and nearestCoin ~= coin then
                State.CurrentCoin = nearestCoin
                return false
            end
        end

        root = State.Root

        local distance =
            (root.Position - waypoint.Position).Magnitude

        if distance <= Config.WaypointReachDistance then
            return true
        end

        if os.clock() - startTime >= Config.WaypointTimeout then
            return false
        end

        task.wait(0.05)
    end

    return false
end

--========================================================--
-- WALK TO COIN
--========================================================--

local function walkToCoin(coin)
    if not isValidCoin(coin) then
        return false
    end

    if not updateCharacter() then
        return false
    end

    State.CurrentCoin = coin

    while State.Enabled and isValidCoin(coin) do

        -- ====================================================
        -- КОЖНІ 1 СЕКУНДУ ПЕРЕВІРЯЄМО НАЙБЛИЖЧУ МОНЕТУ
        -- ====================================================

        local now = os.clock()

        if now - State.LastCoinRefresh >= Config.CoinRefreshInterval
            or State.ForceRefresh then

            State.LastCoinRefresh = now
            State.ForceRefresh = false

            local nearestCoin = getBestCoin()

            if nearestCoin and nearestCoin ~= coin then
                State.CurrentCoin = nearestCoin
                return false
            end
        end

        -- ====================================================
        -- БУДУЄМО ШЛЯХ
        -- ====================================================

        local path, waypoints = computePath(coin)

        if not path or not waypoints then
            task.wait(Config.RepathDelay)

            State.LastCoinRefresh = 0
            continue
        end

        local pathBlocked = false

        local blockedConnection = path.Blocked:Connect(function()
            pathBlocked = true
        end)

        -- ====================================================
        -- ЙДЕМО ПО WAYPOINTS
        -- ====================================================

        for index = 2, #waypoints do

            if not State.Enabled then
                break
            end

            if not isValidCoin(coin) then
                break
            end

            if pathBlocked then
                break
            end

            local currentTime = os.clock()

            if currentTime - State.LastCoinRefresh >= Config.CoinRefreshInterval
                or State.ForceRefresh then

                State.LastCoinRefresh = currentTime
                State.ForceRefresh = false

                local nearestCoin = getBestCoin()

                if nearestCoin and nearestCoin ~= coin then
                    blockedConnection:Disconnect()

                    State.CurrentCoin = nearestCoin

                    return false
                end
            end

            local success = moveToWaypoint(
                waypoints[index],
                coin
            )

            if not success then

                if State.FailedCoins[coin] then
                    blockedConnection:Disconnect()

                    stopMovement()
                    State.CurrentCoin = nil
                    return false
                end

                break
            end
        end

        blockedConnection:Disconnect()

        -- ====================================================
        -- ПЕРЕВІРКА ПІСЛЯ МАРШРУТУ
        -- ====================================================

        if not isValidCoin(coin) then
            State.CurrentCoin = nil
            return true
        end

        task.wait(Config.RepathDelay)
    end

    State.CurrentCoin = nil

    return not isValidCoin(coin)
end

--========================================================--
-- STUCK DETECTION
--========================================================--

local function isStuck()
    if not State.Root then
        return false
    end

    local currentPosition = State.Root.Position

    if not State.LastPosition then
        State.LastPosition = currentPosition
        return false
    end

    local movedDistance =
        (currentPosition - State.LastPosition).Magnitude

    State.LastPosition = currentPosition

    return movedDistance < Config.StuckDistance
end

--========================================================--
-- FARM LOOP
--========================================================--

local function farmLoop()
    State.Running = true

    while State.Enabled do

        if not updateCharacter() then
            task.wait(0.5)
            continue
        end

        if State.Humanoid.Health <= 0 then
            State.CurrentCoin = nil
            State.LastPosition = nil

            task.wait(1)
            continue
        end

        local coin = getBestCoin()

        if not coin then
            State.CurrentCoin = nil
            task.wait(Config.NoCoinDelay)
            continue
        end

        State.CurrentCoin = coin
        State.CurrentCoinStartTime = os.clock()

        -- ====================================================
        -- ПЕРЕВІРКА: ЧИ НЕ ЗАВИСЛА ПОТОЧНА МОНЕТА
        -- ====================================================

        if os.clock() - State.CurrentCoinStartTime >= Config.CoinFailTimeout then

            -- Запам'ятовуємо цю монету як проблемну
            State.FailedCoins[coin] = true

            State.CurrentCoin = nil

            stopMovement()

            -- Негайно шукаємо іншу
            task.wait(0.05)

            continue
        end

        local success = walkToCoin(coin)

        if State.FailedCoins[coin] then
            stopMovement()

            -- Даємо наступній ітерації вибрати іншу монету
            State.LastCoinRefresh = 0

            task.wait(0.05)
            continue
        end

        if not success then
            stopMovement()
            task.wait(Config.RepathDelay)
        end

        -- ====================================================
        -- ПІСЛЯ ЗБОРУ: 3 РАЗИ ПЕРЕВІРЯЄМО НОВУ МОНЕТУ
        -- ====================================================

        if not isValidCoin(coin) then

            State.CurrentCoin = nil

            for i = 1, Config.PostCollectChecks do

                if not State.Enabled then
                    break
                end

                task.wait(Config.CoinRefreshInterval)

                State.LastCoinRefresh = 0
                State.ForceRefresh = true

                local nextCoin = getBestCoin()

                if nextCoin then
                    State.CurrentCoin = nextCoin
                    State.CurrentCoinStartTime = os.clock()

                    local nextSuccess = walkToCoin(nextCoin)

                    if nextSuccess then
                        break
                    end
                end
            end

        else
            State.LastCoinRefresh = 0
            task.wait(Config.SearchDelay)
        end
    end

    stopMovement()

    State.Running = false
end

--========================================================--
-- START
--========================================================--

local function startMM2AutoFarm()
    if State.Enabled then
        return
    end

    State.Enabled = true
    State.LastPosition = nil
    State.LastCoinRefresh = 0
    State.ForceRefresh = false
    State.CurrentCoinStartTime = 0
    State.FailedCoins = {}

    if FarmThread then
        pcall(function()
            task.cancel(FarmThread)
        end)

        FarmThread = nil
    end

    FarmThread = task.spawn(function()
        local success, err = xpcall(
            farmLoop,
            debug.traceback
        )

        if not success then
            warn("[MM2 AutoFarm]", err)
        end

        State.Running = false
    end)
end

--========================================================--
-- STOP
--========================================================--

local function stopMM2AutoFarm()
    State.Enabled = false
    State.CurrentCoin = nil
    State.ForceRefresh = false
    State.CurrentCoinStartTime = 0
    State.FailedCoins = {}

    stopMovement()

    if FarmThread then
        pcall(function()
            task.cancel(FarmThread)
        end)

        FarmThread = nil
    end

    State.Running = false
end

--========================================================--
-- CHARACTER RESPAWN
--========================================================--

LocalPlayer.CharacterAdded:Connect(function(character)
    State.Character = character
    State.Humanoid = nil
    State.Root = nil
    State.CurrentCoin = nil
    State.LastPosition = nil
    State.LastCoinRefresh = 0
    State.ForceRefresh = false
    State.CurrentCoinStartTime = 0
    State.FailedCoins = {}

    task.wait(1)

    if State.Enabled then
        updateCharacter()
    end
end)

--========================================================--
-- UI
--========================================================--

Tabs.AutoFarmMM2:AddSection("MM2 Auto Farm Walk")

Tabs.AutoFarmMM2:AddToggle("MM2AutoFarmToggle", {
    Title = "Enable MM2 Auto Farm Walk",
    Default = false,

    Callback = function(value)
        if value then
            startMM2AutoFarm()
        else
            stopMM2AutoFarm()
        end
    end
})

]==]

------------------------------------------------------------
-- 11) Start
------------------------------------------------------------
task.spawn(function()
    local startDelay = 2 + math.random() * 3
    task.wait(startDelay)

    slideToCenter()
    softRock()
    local ok = runLoading()

    if not ok then return end

    task.wait(0.6)     -- трохи довша пауза щоб встиг побачити "Catnap Orbit ✨"
    smoothRemove()
    task.wait(0.15)

    local func, compileErr = loadstring(MAIN_SCRIPT)
    if not func then
        warn("[Catnap Orbit] Compile error: " .. tostring(compileErr))
        return
    end

    local success, runtimeErr = pcall(func)
    if not success then
        warn("[Catnap Orbit] Runtime error: " .. tostring(runtimeErr))
    end
end)
