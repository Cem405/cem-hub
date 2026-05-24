print("SCRIPT RUNNING")
local Library = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Library:CreateWindow({
   Name = "Cem Hub",
   LoadingTitle = "Cem Hub",
   LoadingSubtitle = "Player Tools"
})

local Tab = Window:CreateTab("Main")

local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local hrp = character:WaitForChild("HumanoidRootPart")

-- WALK SPEED
Tab:CreateInput({
   Name = "WalkSpeed",
   PlaceholderText = "Enter Speed",
   Callback = function(Value)
      humanoid.WalkSpeed = tonumber(Value) or 16
   end,
})

-- JUMP POWER
Tab:CreateInput({
   Name = "JumpPower",
   PlaceholderText = "Enter JumpPower",
   Callback = function(Value)
      humanoid.JumpPower = tonumber(Value) or 50
   end,
})

-- NOCLIP
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
      for _, part in pairs(player.Character:GetDescendants()) do
         if part:IsA("BasePart") then
            part.CanCollide = false
         end
      end
   end
end)

-- FLY
local flying = false
local flySpeed = 50
local bodyVelocity
local bodyGyro

local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

Tab:CreateInput({
   Name = "Fly Speed",
   PlaceholderText = "Enter Fly Speed",
   Callback = function(Value)
      flySpeed = tonumber(Value) or 50
   end,
})

Tab:CreateToggle({
   Name = "Fly",
   CurrentValue = false,
   Callback = function(Value)
      flying = Value

      if flying then
         bodyVelocity = Instance.new("BodyVelocity")
         bodyVelocity.MaxForce = Vector3.new(1e9,1e9,1e9)
         bodyVelocity.Parent = hrp

         bodyGyro = Instance.new("BodyGyro")
         bodyGyro.MaxTorque = Vector3.new(1e9,1e9,1e9)
         bodyGyro.CFrame = hrp.CFrame
         bodyGyro.Parent = hrp
      else
         if bodyVelocity then bodyVelocity:Destroy() end
         if bodyGyro then bodyGyro:Destroy() end
      end
   end,
})

RunService.RenderStepped:Connect(function()
   if flying then
      local cam = workspace.CurrentCamera
      local move = Vector3.zero

      if UIS:IsKeyDown(Enum.KeyCode.W) then move += cam.CFrame.LookVector end
      if UIS:IsKeyDown(Enum.KeyCode.S) then move -= cam.CFrame.LookVector end
      if UIS:IsKeyDown(Enum.KeyCode.A) then move -= cam.CFrame.RightVector end
      if UIS:IsKeyDown(Enum.KeyCode.D) then move += cam.CFrame.RightVector end
      if UIS:IsKeyDown(Enum.KeyCode.Space) then move += Vector3.new(0,1,0) end
      if UIS:IsKeyDown(Enum.KeyCode.LeftControl) then move -= Vector3.new(0,1,0) end

      if bodyVelocity then
         bodyVelocity.Velocity = move * flySpeed
      end

      if bodyGyro then
         bodyGyro.CFrame = cam.CFrame
      end
   end
end)
