-- 1. Cargar Kavo Library desde su repositorio oficial
local Kavo = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()

-- 2. Crear la ventana principal y aplicar un tema (puedes usar "DarkTheme", "Midnight", "BloodTheme", etc.)
local Window = Kavo.CreateLib("Mi Script de Testeo", "Midnight")

-- 3. Crear una Pestaña (Tab)
local MainTab = Window:NewTab("Principal")

-- 4. Crear una Sección dentro de la pestaña
local MainSection = MainTab:NewSection("Elementos de Prueba")

-- --- BOTÓN ---
MainSection:NewButton("Ejecutar Test", "Imprime un mensaje en la consola de F12", function()
    print("¡El botón funciona correctamente!")
end)

-- --- TOGGLE (SWITCH) ---
MainSection:NewToggle("Velocidad Aumentada", "Activa o desactiva la velocidad extra", function(state)
    local player = game.Players.LocalPlayer
    if player and player.Character and player.Character:FindFirstChild("Humanoid") then
        if state then
            player.Character.Humanoid.WalkSpeed = 50
            print("Velocidad activada (50)")
        else
            player.Character.Humanoid.WalkSpeed = 16
            print("Velocidad normal (16)")
        end
    end
end)

-- --- DROPDOWN (MENÚ DESPLEGABLE) ---
MainSection:NewDropdown("Selecciona un Objeto", "Elige una opción de la lista", {"Manzana", "Espada", "Poción"}, function(selectedOption)
    print("Has seleccionado:", selectedOption)
end)

-- --- SLIDER (BARRA DESLIZANTE) ---
MainSection:NewSlider("Salto", "Ajusta la fuerza del salto", 120, 50, function(value)
    local player = game.Players.LocalPlayer
    if player and player.Character and player.Character:FindFirstChild("Humanoid") then
        player.Character.Humanoid.JumpPower = value
    end
end)

-- --- SECCIÓN DE CONFIGURACIÓN ---
local SettingsTab = Window:NewTab("Ajustes")
local SettingsSection = SettingsTab:NewSection("Keybind de Interfaz")

-- Permite ocultar/mostrar la interfaz presionando una tecla (por ejemplo, RightControl)
SettingsSection:NewKeybind("Ocultar UI", "Presiona la tecla para ocultar/mostrar", Enum.KeyCode.RightControl, function()
    Kavo:ToggleUI()
end)
