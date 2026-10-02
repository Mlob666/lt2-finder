-- 1. Cargar Rayfield
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- Servicios
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")

local LocalPlayer = Players.LocalPlayer

-- 2. Configuración Global (se almacena en getgenv para persistir entre Server Hops)
getgenv().BlobConfig = getgenv().BlobConfig or {
    TreeType = "Spooky",
    TreeSize = "Small",
    FindSpookyNeon = false,
    WebhookURL = "",
    SendWebhooks = false,
    StopHopping = true,
    LoadBlobHub = false,
    TeleportToTree = true,
    IsSearching = false
}

local BlobConfig = getgenv().BlobConfig

-- Definición adelantada de funciones
local realizarServerHop, buscarArbol, iniciarBusqueda

-- 3. Función para realizar Server Hop Inmediato
realizarServerHop = function()
    Rayfield:Notify({
        Title = "Server Hop Inmediato",
        Content = "Cambiando de servidor...",
        Duration = 2,
        Image = 4483362458,
    })

    -- Se marca la bandera global para autoejecutar la búsqueda en el nuevo servidor
    getgenv().AutoStartFinder = true

    -- queue_on_teleport usando un script dinámico sin URLs fijas
    if queue_on_teleport then
        queue_on_teleport([[
            repeat task.wait() until game:IsLoaded()
            task.wait(3)
            if getgenv().AutoStartFinder and getgenv().IniciarBusquedaBlobHub then
                getgenv().IniciarBusquedaBlobHub()
            end
        ]])
    end

    local placeId = game.PlaceId
    local serversUrl = "https://games.roblox.com/v1/games/" .. placeId .. "/servers/0?sortOrder=Asc&limit=100"
    
    local success, result = pcall(function()
        return HttpService:JSONDecode(game:HttpGet(serversUrl))
    end)

    if success and result and result.data then
        for _, server in ipairs(result.data) do
            if server.playing < server.maxPlayers and server.id ~= game.JobId then
                TeleportService:TeleportToPlaceInstance(placeId, server.id, LocalPlayer)
                return
            end
        end
    end

    -- Si falla la API de servidores públicos, realizar teletransporte directo
    TeleportService:Teleport(placeId, LocalPlayer)
end

-- 4. Función de búsqueda de árboles
buscarArbol = function()
    local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    local rootPart = character:WaitForChild("HumanoidRootPart")

    for _, objeto in ipairs(workspace:GetChildren()) do
        if objeto.Name == "TreeRegion" then
            local modeloInterno = objeto:FindFirstChild("Model")
            if modeloInterno then
                local treeClassValue = modeloInterno:FindFirstChild("TreeClass")
                
                if treeClassValue and treeClassValue:IsA("StringValue") then
                    local claseActual = treeClassValue.Value
                    
                    local coincideTipo = (claseActual == BlobConfig.TreeType) 
                        or (BlobConfig.FindSpookyNeon and claseActual == "SpookyNeon")

                    if coincideTipo then
                        local seccionesMadera = {}
                        local troncoBase = nil

                        for _, elemento in ipairs(modeloInterno:GetChildren()) do
                            if elemento.Name == "WoodSection" and elemento:IsA("BasePart") then
                                table.insert(seccionesMadera, elemento)
                                local parentID = elemento:FindFirstChild("ParentID")
                                if parentID and parentID.Value == -1 then
                                    troncoBase = elemento
                                end
                            end
                        end

                        local cantidadPartes = #seccionesMadera
                        local coincideTamano = false

                        if BlobConfig.TreeSize == "Any" then
                            coincideTamano = true
                        elseif BlobConfig.TreeSize == "Small" and cantidadPartes <= 15 then
                            coincideTamano = true
                        elseif BlobConfig.TreeSize == "Medium" and (cantidadPartes > 15 and cantidadPartes <= 35) then
                            coincideTamano = true
                        elseif BlobConfig.TreeSize == "Large" and cantidadPartes > 35 then
                            coincideTamano = true
                        end

                        if troncoBase and coincideTamano then
                            troncoBase.Color = Color3.fromRGB(0, 255, 0)

                            if BlobConfig.TeleportToTree then
                                local destino = troncoBase.Position + Vector3.new(0, 4, 0)
                                rootPart.CFrame = CFrame.new(destino) * (rootPart.CFrame - rootPart.CFrame.Position)
                            end

                            return true, claseActual, troncoBase.Position
                        end
                    end
                end
            end
        end
    end

    return false, nil, nil
end

-- 5. Bucle de ejecución principal
iniciarBusqueda = function()
    BlobConfig.IsSearching = true

    Rayfield:Notify({
        Title = "Buscando Árbol...",
        Content = "Escaneando mapa del servidor...",
        Duration = 3,
        Image = 4483362458,
    })

    task.wait(3)

    local encontrado, tipoHallado, pos = buscarArbol()

    if encontrado then
        Rayfield:Notify({
            Title = "¡Árbol Encontrado!",
            Content = "Tipo: " .. tostring(tipoHallado) .. " en " .. tostring(pos),
            Duration = 10,
            Image = 4483362458,
        })
        BlobConfig.IsSearching = false
        getgenv().AutoStartFinder = false
    else
        -- Server Hop inmediato si no se encuentra en el mapa
        realizarServerHop()
    end
end

-- Guardar referencia global de la función para el reconector
getgenv().IniciarBusquedaBlobHub = iniciarBusqueda

-- =======================================================
-- VENTANA E INTERFAZ RAYFIELD
-- =======================================================

local Window = Rayfield:CreateWindow({
    Name = "Blob Hub - Tree Finder",
    LoadingTitle = "Cargando Interfaz...",
    LoadingSubtitle = "Por MblobFuck",
    ConfigurationSaving = { Enabled = false },
    KeySystem = false
})

local MainTab = Window:CreateTab("TreeFinder", "search")
local PlayerTab = Window:CreateTab("Jugador", 4483362458)

MainTab:CreateSection("Tree Option")

MainTab:CreateDropdown({
    Name = "Tree Type",
    Options = {"Spooky", "SpookyNeon", "CaveCrawler", "BlueSpruce", "LoneCave"},
    CurrentOption = {BlobConfig.TreeType},
    MultipleOptions = false,
    Flag = "TreeType",
    Callback = function(Option)
        BlobConfig.TreeType = Option[1]
    end,
})

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

MainTab:CreateToggle({
    Name = "Find SpookyNeon Too?",
    CurrentValue = BlobConfig.FindSpookyNeon,
    Flag = "ToggleSpookyNeon",
    Callback = function(Value)
        BlobConfig.FindSpookyNeon = Value
    end,
})

MainTab:CreateSection("Settings")

MainTab:CreateToggle({
    Name = "Teleport to tree when found",
    CurrentValue = BlobConfig.TeleportToTree,
    Flag = "ToggleTPWhenFound",
    Callback = function(Value)
        BlobConfig.TeleportToTree = Value
    end,
})

MainTab:CreateSection("Finder")

MainTab:CreateButton({
    Name = "Find Tree",
    Callback = function()
        -- Impresión detallada de opciones elegidas en la Consola del Desarrollador (F9)
        print("======== [ BLOB HUB CONFIGURACIÓN SELECCIONADA ] ========")
        print("Tipo de Árbol (TreeType):", BlobConfig.TreeType)
        print("Tamaño de Árbol (TreeSize):", BlobConfig.TreeSize)
        print("Buscar SpookyNeon También:", tostring(BlobConfig.FindSpookyNeon))
        print("Teletransportar al Encontrar:", tostring(BlobConfig.TeleportToTree))
        print("Webhook URL:", BlobConfig.WebhookURL ~= "" and BlobConfig.WebhookURL or "Ninguna")
        print("Enviar Webhooks:", tostring(BlobConfig.SendWebhooks))
        print("=========================================================")

        task.spawn(iniciarBusqueda)
    end,
})

PlayerTab:CreateSection("Modificadores de Personaje")

PlayerTab:CreateKeybind({
    Name = "Ocultar / Mostrar UI",
    CurrentKeybind = "K",
    HoldToInteract = false,
    Flag = "KeybindUI",
    Callback = function(Keybind)
    end,
})

-- Ejecución automática si venimos de un Server Hop previo
if getgenv().AutoStartFinder then
    task.spawn(iniciarBusqueda)
end
