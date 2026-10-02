-- 1. Cargar la librería Rayfield
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- 2. Crear la ventana principal
local Window = Rayfield:CreateWindow({
   Name = "Blob Hub",
   LoadingTitle = "Cargando Interfaz...",
   LoadingSubtitle = "Por MblobFuck",
   ConfigurationSaving = {
      Enabled = false,
      FolderName = "Blob Hub",
      FileName = "BlobHubConfig"
   },
   Discord = {
      Enabled = false,
      Invite = "",
      RememberJoins = true
   },
   KeySystem = false
})

-- Tabla para almacenar la configuración seleccionada en la UI
local BlobConfig = {
    TreeType = "Spooky",
    TreeSize = "Small",
    FindSpookyNeon = false,
    WebhookURL = "",
    SendWebhooks = false,
    StopHopping = false,
    LoadBlobHub = false,
    TeleportToTree = false
}

-- 3. Crear Pestañas (Tabs)
local MainTab = Window:CreateTab("TreeFinder", "tree-pine")
local PlayerTab = Window:CreateTab("Jugador", 4483362458)

-- =======================================================
-- PESTAÑA: PRINCIPAL
-- =======================================================

MainTab:CreateSection("Tree Option")

-- Dropdown: Tipo de árbol
MainTab:CreateDropdown({
   Name = "Tree Type",
   Options = {"Spooky", "SpookyNeon", "BlueSpruce", "LoneCave"},
   CurrentOption = {BlobConfig.TreeType},
   MultipleOptions = false,
   Flag = "TreeType",
   Callback = function(Option)
       BlobConfig.TreeType = Option[1]
   end,
})

-- Dropdown: Tamaño de árbol
MainTab:CreateDropdown({
   Name = "Tree Size",
   Options = {"Small", "Medium", "Large", "Any"},
   CurrentOption = {BlobConfig.TreeSize},
   MultipleOptions = false,
   Flag = "TreeSize",
   Callback = function(Option)
       BlobConfig.TreeSize = Option[1]
   end,
})

-- Toggle: Buscar SpookyNeon
MainTab:CreateToggle({
   Name = "Find SpookyNeon Too?",
   CurrentValue = BlobConfig.FindSpookyNeon,
   Flag = "ToggleSpookyNeon",
   Callback = function(Value)
       BlobConfig.FindSpookyNeon = Value
   end,
})

MainTab:CreateSection("Webhook Option")

-- Input: Enlace de Webhook
MainTab:CreateInput({
   Name = "Webhook Link",
   PlaceholderText = "Webhook Link Here",
   RemoveTextAfterFocusLost = false,
   Flag = "WebhookLinkInput",
   Callback = function(Text)
       BlobConfig.WebhookURL = Text
   end,
})

-- Toggle: Enviar Webhooks
MainTab:CreateToggle({
   Name = "Send Webhooks",
   CurrentValue = BlobConfig.SendWebhooks,
   Flag = "ToggleSendWebhooks",
   Callback = function(Value)
       BlobConfig.SendWebhooks = Value
   end,
})

MainTab:CreateSection("Settings")

-- Toggle: Detener Server Hop al encontrar
MainTab:CreateToggle({
   Name = "Stop hopping when found",
   CurrentValue = BlobConfig.StopHopping,
   Flag = "ToggleHopping",
   Callback = function(Value)
       BlobConfig.StopHopping = Value
   end,
})

-- Toggle: Cargar Hub al encontrar
MainTab:CreateToggle({
   Name = "Load BlobHub when found",
   CurrentValue = BlobConfig.LoadBlobHub,
   Flag = "ToggleLoadWhenFound",
   Callback = function(Value)
       BlobConfig.LoadBlobHub = Value
   end,
})

-- Toggle: Teletransporte
MainTab:CreateToggle({
   Name = "Teleport to tree when found",
   CurrentValue = BlobConfig.TeleportToTree,
   Flag = "ToggleTPWhenFound",
   Callback = function(Value)
       BlobConfig.TeleportToTree = Value
   end,
})

MainTab:CreateSection("Finder")

-- Botón principal
MainTab:CreateButton({
   Name = "Find Tree",
   Callback = function()
       Rayfield:Notify({
           Title = "Búsqueda Iniciada",
           Content = "Buscando árbol: " .. BlobConfig.TreeType .. " (" .. BlobConfig.TreeSize .. ")",
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
       -- Rayfield gestiona el ocultado automáticamente
   end,
})
