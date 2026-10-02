local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "Rayfield Hub",
   LoadingTitle = "Cargando Interfaz...",
   LoadingSubtitle = "Por Dev",
   ConfigurationSaving = { Enabled = false }
})

local Tab = Window:CreateTab("General", 4483362458)

Tab:CreateButton({
   Name = "Notificación de Prueba",
   Callback = function()
       Rayfield:Notify({
           Title = "Rayfield",
           Content = "¡Diseño fluido y moderno!",
           Duration = 3,
       })
   end,
})

Tab:CreateToggle({
   Name = "Activar Función",
   CurrentValue = false,
   Callback = function(Value)
       print("Estado:", Value)
   end,
})

Tab:CreateSlider({
   Name = "Ajuste de Salto",
   Range = {50, 200},
   Increment = 10,
   CurrentValue = 50,
   Callback = function(Value)
       local player = game.Players.LocalPlayer
       if player and player.Character and player.Character:FindFirstChild("Humanoid") then
           player.Character.Humanoid.JumpPower = Value
       end
   end,
})
