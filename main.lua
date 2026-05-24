local Library = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Library:CreateWindow({
   Name = "TEST HUB"
})

local Tab = Window:CreateTab("Main")

Tab:CreateInput({
   Name = "WalkSpeed",
   Callback = function(v)
      print("WS:", v)
   end
})

Tab:CreateInput({
   Name = "JumpPower",
   Callback = function(v)
      print("JP:", v)
   end
})

Tab:CreateToggle({
   Name = "NoClip",
   Callback = function(v)
      print("NoClip:", v)
   end
})

Tab:CreateInput({
   Name = "Fly Speed",
   Callback = function(v)
      print("FlySpeed:", v)
   end
})
