local Library = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Library:CreateWindow({
   Name = "Cem Hub",
   LoadingTitle = "Cem Hub",
   LoadingSubtitle = "Stable Build"
})

local Tab = Window:CreateTab("Main")

local player = game.Players.LocalPlayer

-- SAFE CHARACTER GETTER
local function getChar()
   local char = player.Character or player.CharacterAdded:Wait()
   return char
end

local function getHumanoid()
   local char = getChar()
   return char:FindFirstChildOfClass("Humanoid")
end

local function getRoot()
   local char = getChar()
   return char:FindFirstChild("HumanoidRootPart")
end

-- =====================
-- WALK SPEED
-- =====================
Tab:CreateInput({
   Name = "WalkSpeed",
   Callback = function(v)
      local hum = getHumanoid()
      if hum then
         hum.WalkSpeed = tonumber(v) or 16
      end
   end,
})

-- =====================
-- JUMP POWER
-- =====================
Tab:CreateInput({
   Name = "JumpPower",
   Callback = function(v)
      local hum = getHumanoid()
      if hum then
         hum.UseJumpPower = true
         hum.JumpPower = tonumber(v) or 50
      end
   end,
})

-- =====================
-- NOCLIP
-- =====================
local noclip = false

Tab:CreateToggle({
   Name = "NoClip",
   Callback = function(v)
      noclip = v
   end,
})

game:GetService("RunService").Stepped:Connect(function()
   if not noclip then return end

   local char = player.Character
   if not char then return end

   for _, p in pairs(char:GetDescendants()) do
      if p:IsA("BasePart") then
         p.CanCollide = false
      end
   end
end)

-- =====================
-- FLY (100% SAFE FIX)
-- =====================
local flying = false
local flySpeed = 50

local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local bodyVel
local bodyGyro

Tab:CreateInput({
   Name = "Fly Speed",
   Callback = function(v)
      flySpeed = tonumber(v) or 50
   end,
})

Tab:CreateToggle({
   Name = "Fly",
   Callback = function(v)
      flying = v

      local root = getRoot()
      local hum = getHumanoid()

      if not root or not hum then return end

      if flying then
         hum.PlatformStand = true

         bodyVel = Instance.new("BodyVelocity")
         bodyVel.MaxForce = Vector3.new(1e9,1e9,1e9)
         bodyVel.Velocity = Vector3.zero
         bodyVel.Parent = root

         bodyGyro = Instance.new("BodyGyro")
         bodyGyro.MaxTorque = Vector3.new(1e9,1e9,1e9)
         bodyGyro.CFrame = root.CFrame
         bodyGyro.Parent = root
      else
         hum.PlatformStand = false

         if bodyVel then bodyVel:Destroy() end
         if bodyGyro then bodyGyro:Destroy() end
      end
   end,
})

RunService.RenderStepped:Connect(function()
   if not flying then return end

   local root = getRoot()
   if not root then return end

   local cam = workspace.CurrentCamera
   local move = Vector3.zero

   if UIS:IsKeyDown(Enum.KeyCode.W) then move += cam.CFrame.LookVector end
   if UIS:IsKeyDown(Enum.KeyCode.S) then move -= cam.CFrame.LookVector end
   if UIS:IsKeyDown(Enum.KeyCode.A) then move -= cam.CFrame.RightVector end
   if UIS:IsKeyDown(Enum.KeyCode.D) then move += cam.CFrame.RightVector end
   if UIS:IsKeyDown(Enum.KeyCode.Space) then move += Vector3.new(0,1,0) end
   if UIS:IsKeyDown(Enum.KeyCode.LeftControl) then move -= Vector3.new(0,1,0) end

   if bodyVel then
      bodyVel.Velocity = move * flySpeed
   end

   if bodyGyro then
      bodyGyro.CFrame = cam.CFrame
   end
end)
