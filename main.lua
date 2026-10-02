-- 1. Cargar la librería Rayfield
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- 2. Crear la ventana principal
local Window = Rayfield:CreateWindow({
   Name = "Mi Script Hub",
   LoadingTitle = "Cargando Interfaz...",
   LoadingSubtitle = "Por Dev",
   ConfigurationSaving = {
      Enabled = false, -- Cambia a true si quieres guardar la configuración en un archivo local
      FolderName = "MiScriptHub",
      FileName = "Config"
   },
   Discord = {
      Enabled = false,
      Invite = "",
      RememberJoins = true
   },
   KeySystem = false -- Cambia a true si quieres añadir un sistema de clave/key
})

-- 3. Crear Pestañas (Tabs)
local MainTab = Window:CreateTab("Principal", 4483362458) -- ID del icono de Roblox
local PlayerTab = Window:CreateTab("Jugador", 4483362458)

-- =======================================================
-- PESTAÑA: PRINCIPAL
-- =======================================================

MainTab:CreateSection("Acciones Básicas")

-- Botón
MainTab:CreateButton({
   Name = "Enviar Notificación",
   Callback = function()
       Rayfield:Notify({
           Title = "Prueba Exitosa",
           Content = "¡El botón de Rayfield está funcionando!",
           Duration = 4,
           Image = 4483362458,
       })
   end,
})

-- Toggle (Interruptor)
MainTab:CreateToggle({
   Name = "Modo Automático",
   CurrentValue = false,
   Flag = "ToggleAuto",
   Callback = function(Value)
       print("Estado del Toggle:", Value)
   end,
})

-- Dropdown (Lista Desplegable)
MainTab:CreateDropdown({
   Name = "Seleccionar Opción",
   Options = {"Opción 1", "Opción 2", "Opción 3"},
   CurrentOption = {"Opción 1"},
   MultipleOptions = false,
   Flag = "DropdownOpt",
   Callback = function(Option)
       print("Seleccionado:", Option[1])
   end,
})

-- Input de Texto
MainTab:CreateInput({
   Name = "Mensaje Personalizado",
   PlaceholderText = "Escribe algo aquí...",
   RemoveTextAfterFocusLost = false,
   Callback = function(Text)
       print("Texto ingresado:", Text)
   end,
})

-- =======================================================
-- PESTAÑA: JUGADOR
-- =======================================================

PlayerTab:CreateSection("Modificadores de Personaje")

-- Slider de Velocidad
PlayerTab:CreateSlider({
   Name = "Velocidad de Caminado (WalkSpeed)",
   Range = {16, 200},
   Increment = 1,
   Suffix = "Speed",
   CurrentValue = 16,
   Flag = "SliderSpeed",
   Callback = function(Value)
       local player = game.Players.LocalPlayer
       if player.Character and player.Character:FindFirstChild("Humanoid") then
           player.Character.Humanoid.WalkSpeed = Value
       end
   end,
})

-- Keybind para ocultar la interfaz
PlayerTab:CreateKeybind({
   Name = "Ocultar / Mostrar UI",
   CurrentKeybind = "K",
   HoldToInteract = false,
   Flag = "KeybindUI",
   Callback = function(Keybind)
       -- Rayfield gestiona el ocultado automáticamente o puedes personalizarlo
   end,
})
