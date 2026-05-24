local Library = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Library:CreateWindow({
   Name = "Cem Hub",
   LoadingTitle = "Cem Hub",
   LoadingSubtitle = "Clean Version"
})

local Tab = Window:CreateTab("Main")

local player = game.Players.LocalPlayer

-- SAFE CHARACTER
local function getChar()
   return player.Character or player.CharacterAdded:Wait()
end

local function getHumanoid()
   local char = getChar()
   return char:FindFirstChildOfClass("Humanoid")
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

   for _, part in pairs(char:GetDescendants()) do
      if part:IsA("BasePart") then
         part.CanCollide = false
      end
   end
end)
