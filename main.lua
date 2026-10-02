-- Cargar la librería Rayfield
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- Crear la ventana principal
local Window = Rayfield:CreateWindow({
   Name = "TreeFinder Hub",
   LoadingTitle = "Cargando Script...",
   LoadingSubtitle = "Por Dev",
   ConfigurationSaving = { Enabled = false }
})

-- Crear la pestaña de opciones principales
local TreeTab = Window:CreateTab("Tree Options", 4483362458)

-- 1. Selector desplegable (Dropdown) para tipo de árbol
local TreeDropdown = TreeTab:CreateDropdown({
   Name = "Tree Type",
   Options = {"Spooky", "Oak", "Birch", "Palm"},
   CurrentOption = {"Spooky"},
   MultipleOptions = false,
   Callback = function(Option)
       print("Tipo de árbol seleccionado:", Option[1])
   end,
})

-- 2. Selector para tamaño de árbol
local SizeDropdown = TreeTab:CreateDropdown({
   Name = "Tree Size",
   Options = {"Small", "Medium", "Large", "Huge"},
   CurrentOption = {"Small"},
   MultipleOptions = false,
   Callback = function(Option)
       print("Tamaño de árbol seleccionado:", Option[1])
   end,
})

-- 3. Interruptor (Toggle)
local SpookyToggle = TreeTab:CreateToggle({
   Name = "Find SpookyNeon too ?",
   CurrentValue = false,
   Callback = function(Value)
       print("SpookyNeon activado:", Value)
   end,
})

-- Pestaña para Configuración de Servidor
local ServerTab = Window:CreateTab("Server Options", 4483362458)

-- 4. Botón de Server Hop (Cambiar de servidor a uno público disponible)
ServerTab:CreateButton({
   Name = "Server Hop (Buscar otro servidor)",
   Callback = function()
       local HttpService = game:GetService("HttpService")
       local TeleportService = game:GetService("TeleportService")
       local PlaceId = game.PlaceId
       local JobId = game.JobId

       Rayfield:Notify({
           Title = "Server Hop",
           Content = "Buscando un nuevo servidor...",
           Duration = 3,
       })

       -- Obtener la lista de servidores del juego mediante API pública
       local serversApi = "https://games.roblox.com/v1/games/" .. PlaceId .. "/servers/Public?sortOrder=Asc&limit=100"
       local success, result = pcall(function()
           return HttpService:JSONDecode(game:HttpGet(serversApi))
       end)

       if success and result and result.data then
           for _, server in ipairs(result.data) do
               -- Verificar que el servidor no sea el actual y tenga espacio disponible
               if server.id ~= JobId and server.playing < server.maxPlayers then
                   TeleportService:TeleportToPlaceInstance(PlaceId, server.id, game.Players.LocalPlayer)
                   break
               end
           end
       else
           Rayfield:Notify({
               Title = "Error",
               Content = "No se pudieron obtener servidores.",
               Duration = 3,
           })
       end
   end,
})
