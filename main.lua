-- 1. Cargar la librería Rayfield
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- 2. Crear la ventana principal
local Window = Rayfield:CreateWindow({
   Name = "Blob Hub",
   LoadingTitle = "Cargando Interfaz...",
   LoadingSubtitle = "Por MblobFuck",
   ConfigurationSaving = {
      Enabled = false, -- Cambia a true si quieres guardar la configuración en un archivo local
      FolderName = "Blob Hub",
      FileName = "BlobHubConfig"
   },
   Discord = {
      Enabled = false,
      Invite = "",
      RememberJoins = true
   },
   KeySystem = false -- Cambia a true si quieres añadir un sistema de clave/key
})

-- 3. Crear Pestañas (Tabs)
local MainTab = Window:CreateTab("TreeFinder", "tree-pine")
local PlayerTab = Window:CreateTab("Jugador", 4483362458)

-- =======================================================
-- PESTAÑA: PRINCIPAL
-- =======================================================

MainTab:CreateSection("Tree Option")

-- Dropdown (Lista Desplegable)
MainTab:CreateDropdown({
   Name = "Tree Type",
   Options = {"Spooky", "SpookyNeon", "BlueSpruce", "LoneCave"},
   CurrentOption = {"Spooky"},
   MultipleOptions = false,
   Flag = "DropdownOpt",
   Callback = function(Option)
       print("Seleccionado:", Option[1])
   end,
})

-- Dropdown (Lista Desplegable)
MainTab:CreateDropdown({
   Name = "Tree Size",
   Options = {"Small", "Medium", "Large", "Any"},
   CurrentOption = {"Small"},
   MultipleOptions = false,
   Flag = "DropdownOpt",
   Callback = function(Option)
       print("Tamaño Seleccionado:", Option[1])
   end,
})

-- Toggle (Interruptor)
MainTab:CreateToggle({
   Name = "Find SpookyNeon Too?",
   CurrentValue = false,
   Flag = "ToggleAuto",
   Callback = function(Value)
       print("Estado del Toggle:", Value)
   end,
})

MainTab:CreateSection("Webhook Option")

-- Input de Texto
MainTab:CreateInput({
   Name = "Webhook Link",
   PlaceholderText = "Webhook Link Here",
   RemoveTextAfterFocusLost = false,
   Callback = function(Text)
       print("Texto ingresado:", Text)
   end,
})

-- Toggle (Interruptor)
MainTab:CreateToggle({
   Name = "Send Webhooks",
   CurrentValue = false,
   Flag = "ToggleAuto",
   Callback = function(Value)
       print("Estado del Toggle webhook:", Value)
   end,
})

MainTab:CreateSection("Settings")

-- Toggle (Interruptor)
MainTab:CreateToggle({
   Name = "Stop hopping when found",
   CurrentValue = false,
   Flag = "ToggleAuto",
   Callback = function(Value)
       print("Estado del Toggle hop:", Value)
   end,
})

-- Toggle (Interruptor)
MainTab:CreateToggle({
   Name = "Load BlobHub when found",
   CurrentValue = false,
   Flag = "ToggleAuto",
   Callback = function(Value)
       print("Estado del Toggle load:", Value)
   end,
})

-- Toggle (Interruptor)
MainTab:CreateToggle({
   Name = "Teleport to tree when found",
   CurrentValue = false,
   Flag = "ToggleAuto",
   Callback = function(Value)
       print("Estado del Toggle teleport:", Value)
   end,
})

MainTab:CreateSection("Finder")

-- Botón
MainTab:CreateButton({
   Name = "Find Tree",
   Callback = function()
       Rayfield:Notify({
           Title = "Prueba Exitosa",
           Content = "¡El botón de Rayfield está funcionando!",
           Duration = 4,
           Image = 4483362458,
       })
   end,
})

-- =======================================================
-- PESTAÑA: JUGADOR
-- =======================================================

PlayerTab:CreateSection("Modificadores de Personaje")

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
