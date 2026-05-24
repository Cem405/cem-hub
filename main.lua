print("SCRIPT RUNNING")
local Library = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Library:CreateWindow({
   Name = "Cem Hub",
   LoadingTitle = "Cem Hub",
   LoadingSubtitle = "Stable Build"
})

local Tab = Window:CreateTab("Main")

local player = game.Players.LocalPlayer

-- =========================
-- CHARACTER SAFE HANDLER
-- =========================
local character
local humanoid
local hrp

local function updateCharacter(char)
   character = char
   humanoid = char:WaitForChild("Humanoid")
   hrp = char:WaitForChild("HumanoidRootPart")
end

updateCharacter(player.Character or player.CharacterAdded:Wait())
player.CharacterAdded:Connect(updateCharacter)

-- =========================
-- WALK SPEED (SAFE)
-- =========================
Tab:CreateInput({
   Name = "WalkSpeed",
   Callback = function(Value)
      local char = player.Character
      if not char then return end

      local hum = char:FindFirstChildOfClass("Humanoid")
      if hum then
         hum.WalkSpeed = tonumber(Value) or 16
      end
   end,
})

-- =========================
-- JUMP POWER (SAFE)
-- =========================
Tab:CreateInput({
   Name = "JumpPower",
   Callback = function(Value)
      local char = player.Character
      if not char then return end

      local hum = char:FindFirstChildOfClass("Humanoid")
      if hum then
         hum.UseJumpPower = true
         hum.JumpPower = tonumber(Value) or 50
      end
   end,
})

-- =========================
-- NOCLIP (STABLE)
-- =========================
local noclip = false

Tab:CreateToggle({
   Name = "NoClip",
   CurrentValue = false,
   Callback = function(Value)
      noclip = Value
   end,
})

game:GetService("RunService").Stepped:Connect(function()
   if noclip and player.Character then
      for _, v in pairs(player.Character:GetDescendants()) do
         if v:IsA("BasePart") then
            v.CanCollide = false
         end
      end
   end
end)

-- =========================
-- FLY (SAFE + NO CRASH)
-- =========================
local flying = false
local flySpeed = 50

local bodyVel
local bodyGyro

local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

Tab:CreateInput({
   Name = "Fly Speed",
   Callback = function(Value)
      flySpeed = tonumber(Value) or 50
   end,
})

Tab:CreateToggle({
   Name = "Fly",
   Callback = function(Value)
      flying = Value

      if flying then
         local char = player.Character
         if not char then return end

         local root = char:FindFirstChild("HumanoidRootPart")
         if not root then return end

         bodyVel = Instance.new("BodyVelocity")
         bodyVel.MaxForce = Vector3.new(1e9,1e9,1e9)
         bodyVel.Velocity = Vector3.zero
         bodyVel.Parent = root

         bodyGyro = Instance.new("BodyGyro")
         bodyGyro.MaxTorque = Vector3.new(1e9,1e9,1e9)
         bodyGyro.CFrame = root.CFrame
         bodyGyro.Parent = root
      else
         if bodyVel then bodyVel:Destroy() end
         if bodyGyro then bodyGyro:Destroy() end
      end
   end,
})

RunService.RenderStepped:Connect(function()
   if not flying then return end

   local char = player.Character
   if not char then return end

   local root = char:FindFirstChild("HumanoidRootPart")
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
