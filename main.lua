print("SCRIPT RUNNING")
local Library = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Library:CreateWindow({
   Name = "Cem Hub",
   LoadingTitle = "Cem Hub",
   LoadingSubtitle = "Stable Version"
})

local Tab = Window:CreateTab("Main")

local player = game.Players.LocalPlayer

-- =====================
-- CHARACTER HANDLING FIX
-- =====================
local character
local humanoid
local hrp

local function setupChar(char)
   character = char
   humanoid = char:WaitForChild("Humanoid")
   hrp = char:WaitForChild("HumanoidRootPart")
end

setupChar(player.Character or player.CharacterAdded:Wait())
player.CharacterAdded:Connect(setupChar)

-- =====================
-- WALK SPEED
-- =====================
Tab:CreateInput({
   Name = "WalkSpeed",
   Callback = function(Value)
      if humanoid then
         humanoid.WalkSpeed = tonumber(Value) or 16
      end
   end,
})

-- =====================
-- JUMP POWER FIX
-- =====================
Tab:CreateInput({
   Name = "JumpPower",
   Callback = function(Value)
      if humanoid then
         humanoid.UseJumpPower = true
         humanoid.JumpPower = tonumber(Value) or 50
      end
   end,
})

-- =====================
-- NOCLIP STABLE
-- =====================
local noclip = false

Tab:CreateToggle({
   Name = "NoClip",
   Callback = function(Value)
      noclip = Value
   end,
})

game:GetService("RunService").Stepped:Connect(function()
   if noclip and character then
      for _, v in pairs(character:GetDescendants()) do
         if v:IsA("BasePart") then
            v.CanCollide = false
         end
      end
   end
end)

-- =====================
-- FLY FIXED (NO BUG)
-- =====================
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

      if flying and hrp then
         bodyVel = Instance.new("BodyVelocity")
         bodyVel.MaxForce = Vector3.new(1e9,1e9,1e9)
         bodyVel.Velocity = Vector3.zero
         bodyVel.Parent = hrp

         bodyGyro = Instance.new("BodyGyro")
         bodyGyro.MaxTorque = Vector3.new(1e9,1e9,1e9)
         bodyGyro.CFrame = hrp.CFrame
         bodyGyro.Parent = hrp
      else
         if bodyVel then bodyVel:Destroy() end
         if bodyGyro then bodyGyro:Destroy() end
      end
   end,
})

RunService.RenderStepped:Connect(function()
   if flying and hrp then
      local cam = workspace.CurrentCamera
      local move = Vector3.zero

      if UIS:IsKeyDown(Enum.KeyCode.W) then move += cam.CFrame.LookVector end
      if UIS:IsKeyDown(Enum.KeyCode.S) then move -= cam.CFrame.LookVector end
      if UIS:IsKeyDown(Enum.KeyCode.A) then move -= cam.CFrame.RightVector end
      if UIS:IsKeyDown(Enum.KeyCode.D) then move += cam.CFrame.RightVector end
      if UIS:IsKeyDown(Enum.KeyCode.Space) then move += Vector3.new(0,1,0) end
      if UIS:IsKeyDown(Enum.KeyCode.LeftControl) then move -= Vector3.new(0,1,0) end

      bodyVel.Velocity = move * flySpeed
      bodyGyro.CFrame = cam.CFrame
   end
end)
