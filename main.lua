local flying = false
local flySpeed = 50

local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

local bodyVelocity
local bodyGyro

local RunService = game:GetService("RunService")

-- SPEED INPUT
Tab:CreateInput({
   Name = "Fly Speed",
   PlaceholderText = "Enter Fly Speed",
   RemoveTextAfterFocusLost = false,
   Callback = function(Value)
      flySpeed = tonumber(Value) or 50
   end,
})

-- FLY TOGGLE
Tab:CreateToggle({
   Name = "Fly",
   CurrentValue = false,
   Callback = function(Value)
      flying = Value

      if flying then
         bodyVelocity = Instance.new("BodyVelocity")
         bodyVelocity.MaxForce = Vector3.new(1e9, 1e9, 1e9)
         bodyVelocity.Parent = humanoidRootPart

         bodyGyro = Instance.new("BodyGyro")
         bodyGyro.MaxTorque = Vector3.new(1e9, 1e9, 1e9)
         bodyGyro.CFrame = humanoidRootPart.CFrame
         bodyGyro.Parent = humanoidRootPart
      else
         if bodyVelocity then bodyVelocity:Destroy() end
         if bodyGyro then bodyGyro:Destroy() end
      end
   end,
})

-- FLY LOOP
RunService.RenderStepped:Connect(function()
   if flying and humanoidRootPart then
      local camera = workspace.CurrentCamera
      local moveDirection = Vector3.zero

      if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.W) then
         moveDirection = moveDirection + camera.CFrame.LookVector
      end
      if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.S) then
         moveDirection = moveDirection - camera.CFrame.LookVector
      end
      if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.A) then
         moveDirection = moveDirection - camera.CFrame.RightVector
      end
      if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.D) then
         moveDirection = moveDirection + camera.CFrame.RightVector
      end
      if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.Space) then
         moveDirection = moveDirection + Vector3.new(0, 1, 0)
      end
      if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.LeftControl) then
         moveDirection = moveDirection - Vector3.new(0, 1, 0)
      end

      if bodyVelocity then
         bodyVelocity.Velocity = moveDirection * flySpeed
      end

      if bodyGyro then
         bodyGyro.CFrame = workspace.CurrentCamera.CFrame
      end
   end
end)
