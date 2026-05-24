local Library = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Library:CreateWindow({
   Name = "Cem Hub",
   LoadingTitle = "Cem Hub",
   LoadingSubtitle = "Simple Version"
})

local Tab = Window:CreateTab("Player")

local player = game.Players.LocalPlayer

-- WALK SPEED
Tab:CreateInput({
   Name = "WalkSpeed",
   PlaceholderText = "Enter speed",
   Callback = function(Value)
      local char = player.Character
      if char then
         local hum = char:FindFirstChildOfClass("Humanoid")
         if hum then
            hum.WalkSpeed = tonumber(Value) or 16
         end
      end
   end,
})

-- JUMP POWER
Tab:CreateInput({
   Name = "JumpPower",
   PlaceholderText = "Enter jump power",
   Callback = function(Value)
      local char = player.Character
      if char then
         local hum = char:FindFirstChildOfClass("Humanoid")
         if hum then
            hum.UseJumpPower = true
            hum.JumpPower = tonumber(Value) or 50
         end
      end
   end,
})

-- NOCLIP TOGGLE
local noclip = false

Tab:CreateToggle({
   Name = "NoClip",
   CurrentValue = false,
   Callback = function(Value)
      noclip = Value
   end,
})

game:GetService("RunService").Stepped:Connect(function()
   if noclip then
      local char = player.Character
      if char then
         for _, v in pairs(char:GetDescendants()) do
            if v:IsA("BasePart") then
               v.CanCollide = false
            end
         end
      end
   end
end)

-- FLY SPEED
local flySpeed = 50

Tab:CreateInput({
   Name = "Fly Speed",
   PlaceholderText = "Enter fly speed",
   Callback = function(Value)
      flySpeed = tonumber(Value) or 50
   end,
})

-- FLY TOGGLE
local flying = false
local bodyVel
local bodyGyro

local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

Tab:CreateToggle({
   Name = "Fly",
   CurrentValue = false,
   Callback = function(Value)
      flying = Value

      local char = player.Character
      if not char then return end

      local root = char:FindFirstChild("HumanoidRootPart")
      if not root then return end

      if flying then
         bodyVel = Instance.new("BodyVelocity")
         bodyVel.MaxForce = Vector3.new(1e9,1e9,1e9)
         bodyVel.Parent = root

         bodyGyro = Instance.new("BodyGyro")
         bodyGyro.MaxTorque = Vector3.new(1e9,1e9,1e9)
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
