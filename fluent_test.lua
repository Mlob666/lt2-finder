-- 1. Cargar Fluent UI Library
local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()

-- 2. Crear la Ventana Principal
local Window = Fluent:CreateWindow({
    Title = "Mi Hub Pro",
    SubTitle = "v1.0",
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 460),
    Acrylic = true, -- Efecto de desenfoque/transparencia
    Theme = "Dark"
})

-- 3. Crear Pestañas (Tabs) con Iconos (Lucide Icons)
local Tabs = {
    Main = Window:AddTab({ Title = "Principal", Icon = "home" }),
    Settings = Window:AddTab({ Title = "Ajustes", Icon = "settings" })
}

-- --- BOTÓN ---
Tabs.Main:AddButton({
    Title = "Ejecutar Test",
    Description = "Imprime un mensaje de prueba",
    Callback = function()
        Fluent:Notify({
            Title = "Notificación",
            Content = "¡El botón funcionó correctamente!",
            Duration = 3
        })
    end
})

-- --- TOGGLE (SWITCH) ---
Tabs.Main:AddToggle("SpeedToggle", {
    Title = "Super Velocidad",
    Default = false,
    Callback = function(Value)
        local player = game.Players.LocalPlayer
        if player and player.Character and player.Character:FindFirstChild("Humanoid") then
            player.Character.Humanoid.WalkSpeed = Value and 50 or 16
        end
    end
})

-- --- SLIDER ---
Tabs.Main:AddSlider("JumpSlider", {
    Title = "Fuerza de Salto",
    Description = "Ajusta la altura del salto",
    Default = 50,
    Min = 50,
    Max = 150,
    Rounding = 0,
    Callback = function(Value)
        local player = game.Players.LocalPlayer
        if player and player.Character and player.Character:FindFirstChild("Humanoid") then
            player.Character.Humanoid.JumpPower = Value
        end
    end
})

-- --- DROPDOWN ---
Tabs.Main:AddDropdown("ItemDropdown", {
    Title = "Seleccionar Objeto",
    Values = {"Manzana", "Espada", "Poción"},
    Multi = false,
    Default = 1,
    Callback = function(Value)
        print("Objeto seleccionado:", Value)
    end
})

-- Notificación de carga
Fluent:Notify({
    Title = "Script Cargado",
    Content = "La interfaz se cargó con éxito.",
    Duration = 5
})
