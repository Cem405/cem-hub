local Library = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Library:CreateWindow({
   Name = "Cem Hub"
})

local Tab = Window:CreateTab("Player")

local player = game.Players.LocalPlayer

-- SAFE GET CHARACTER
local function getChar()
   local char = player.Character or player.CharacterAdded:Wait()
   local hum = char:FindFirstChildOfClass("Humanoid")
   local root = char:FindFirstChild("HumanoidRootPart")
   return char, hum, root
end

-- WALK SPEED
Tab:CreateInput({
   Name = "WalkSpeed",
   Callback = function(v)
      local _, hum = getChar()
      if hum then hum.WalkSpeed = tonumber(v) end
   end,
})

-- JUMP POWER
Tab:CreateInput({
   Name = "JumpPower",
   Callback = function(v)
      local _, hum = getChar()
      if hum then
         hum.UseJumpPower = true
         hum.JumpPower = tonumber(v)
      end
   end,
})

-- NOCLIP (SAFE LOOP)
local noclip = false

Tab:CreateToggle({
   Name = "NoClip",
   Callback = function(v)
      noclip = v
   end,
})

task.spawn(function()
   while true do
      task.wait()
      if noclip then
         local char = player.Character
         if char then
            for _,p in pairs(char:GetDescendants()) do
               if p:IsA("BasePart") then
                  p.CanCollide = false
               end
            end
         end
      end
   end
end)

-- FLY (SAFE)
local flying = false
local speed = 50

local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local bodyVel, bodyGyro

Tab:CreateInput({
   Name = "Fly Speed",
   Callback = function(v)
      speed = tonumber(v) or 50
   end,
})

Tab:CreateToggle({
   Name = "Fly",
   Callback = function(v)
      flying = v

      local _,_,root = getChar()
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

   local _,_,root = getChar()
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
      bodyVel.Velocity = move * speed
   end

   if bodyGyro then
      bodyGyro.CFrame = cam.CFrame
   end
end)
