-- v0.1.0

-- 1. Cargar Rayfield
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- Servicios
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")

local LocalPlayer = Players.LocalPlayer

-- URL de tu script en GitHub con bypass de caché
local SCRIPT_URL = "https://raw.githubusercontent.com/Mlob666/lt2-finder/refs/heads/main/main.lua?v=" .. tick()

-- 2. Configuración Global Persistente en memoria de Luau
if not getgenv().BlobConfig then
    getgenv().BlobConfig = {
        TreeType = "CaveCrawler",
        TreeSize = "Any",
        FindSpookyNeon = false,
        WebhookURL = "",
        SendWebhooks = false,
        StopHopping = true,
        LoadBlobHub = false,
        TeleportToTree = true,
        IsSearching = false
    }
end

-- Definición adelantada de funciones
local realizarServerHop, buscarArbol, iniciarBusqueda

-- 3. Función para realizar Server Hop con Notificación Personalizada
realizarServerHop = function()
    local config = getgenv().BlobConfig
    getgenv().AutoStartFinder = true

    -- Notificación con el orden que pediste: Árbol + " Tree, not found"
    Rayfield:Notify({
        Title = "Server hop",
        Content = tostring(config.TreeType) .. " Tree, not found",
        Duration = 3,
        Image = 4483362458,
    })

    if queue_on_teleport then
        local codeToQueue = string.format([[
            repeat task.wait() until game:IsLoaded()
            task.wait(2)
            
            getgenv().AutoStartFinder = true
            getgenv().BlobConfig = {
                TreeType = "%s",
                TreeSize = "%s",
                FindSpookyNeon = %s,
                WebhookURL = "%s",
                SendWebhooks = %s,
                StopHopping = %s,
                LoadBlobHub = %s,
                TeleportToTree = %s,
                IsSearching = false
            }
            
            loadstring(game:HttpGet('%s'))()
        ]],
        config.TreeType, 
        config.TreeSize, 
        tostring(config.FindSpookyNeon), 
        config.WebhookURL or "", 
        tostring(config.SendWebhooks), 
        tostring(config.StopHopping), 
        tostring(config.LoadBlobHub), 
        tostring(config.TeleportToTree), 
        SCRIPT_URL)

        queue_on_teleport(codeToQueue)
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

    TeleportService:Teleport(placeId, LocalPlayer)
end

-- 4. Función de búsqueda de árboles
buscarArbol = function()
    local config = getgenv().BlobConfig
    local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    local rootPart = character:WaitForChild("HumanoidRootPart")

    for _, objeto in ipairs(workspace:GetChildren()) do
        if objeto.Name == "TreeRegion" then
            local modeloInterno = objeto:FindFirstChild("Model")
            if modeloInterno then
                local treeClassValue = modeloInterno:FindFirstChild("TreeClass")
                
                if treeClassValue and treeClassValue:IsA("StringValue") then
                    local claseActual = treeClassValue.Value
                    
                    local coincideTipo = (string.lower(claseActual) == string.lower(config.TreeType)) 
                        or (config.FindSpookyNeon and string.lower(claseActual) == "spookyneon")

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
                        local tamanoSeleccionado = string.lower(config.TreeSize)

                        if tamanoSeleccionado == "any" then
                            coincideTamano = true
                        elseif tamanoSeleccionado == "small" and cantidadPartes <= 15 then
                            coincideTamano = true
                        elseif tamanoSeleccionado == "medium" and (cantidadPartes > 15 and cantidadPartes <= 35) then
                            coincideTamano = true
                        elseif tamanoSeleccionado == "large" and cantidadPartes > 35 then
                            coincideTamano = true
                        end

                        if troncoBase and coincideTamano then
                            if config.TeleportToTree then
                                local destino = troncoBase.Position + Vector3.new(0, 4, 0)
                                rootPart.CFrame = CFrame.new(destino) * (rootPart.CFrame - rootPart.CFrame.Position)
                            end

                            return true, claseActual, troncoBase.Position, cantidadPartes
                        end
                    end
                end
            end
        end
    end

    return false, nil, nil, 0
end

-- 5. Bucle de ejecución principal
iniciarBusqueda = function()
    local config = getgenv().BlobConfig
    config.IsSearching = true

    Rayfield:Notify({
        Title = "Buscando Árbol...",
        Content = "Escaneando mapa (" .. tostring(config.TreeType) .. ")...",
        Duration = 3,
        Image = 4483362458,
    })

    task.wait(3)

    local encontrado, tipoHallado, pos, partes = buscarArbol()

    if encontrado then
        config.IsSearching = false
        getgenv().AutoStartFinder = false

        Rayfield:Notify({
            Title = "¡Árbol Encontrado!",
            Content = "Tipo: " .. tostring(tipoHallado) .. " (" .. tostring(partes) .. " partes)\n¿No sirve? Haz clic para Server Hop.",
            Duration = 12,
            Image = 4483362458,
            Actions = {
                ServerHop = {
                    Name = "Cambiar de Servidor",
                    Callback = function()
                        realizarServerHop()
                    end
                }
            }
        })
    else
        realizarServerHop()
    end
end

-- =======================================================
-- INTERFAZ RAYFIELD
-- =======================================================

local Window = Rayfield:CreateWindow({
    Name = "Blob Hub - Tree Finder v0.1.0",
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
    CurrentOption = {getgenv().BlobConfig.TreeType},
    MultipleOptions = false,
    Flag = "TreeType",
    Callback = function(Option)
        local valor = typeof(Option) == "table" and Option[1] or Option
        if getgenv().AutoStartFinder and getgenv().BlobConfig.TreeType ~= valor then
            return
        end
        getgenv().BlobConfig.TreeType = valor
    end,
})

MainTab:CreateDropdown({
    Name = "Tree Size",
    Options = {"Small", "Medium", "Large", "Any"},
    CurrentOption = {getgenv().BlobConfig.TreeSize},
    MultipleOptions = false,
    Flag = "TreeSize",
    Callback = function(Option)
        local valor = typeof(Option) == "table" and Option[1] or Option
        if getgenv().AutoStartFinder and getgenv().BlobConfig.TreeSize ~= valor then
            return
        end
        getgenv().BlobConfig.TreeSize = valor
    end,
})

MainTab:CreateToggle({
    Name = "Find SpookyNeon Too?",
    CurrentValue = getgenv().BlobConfig.FindSpookyNeon,
    Flag = "ToggleSpookyNeon",
    Callback = function(Value)
        getgenv().BlobConfig.FindSpookyNeon = Value
    end,
})

MainTab:CreateSection("Settings")

MainTab:CreateToggle({
    Name = "Teleport to tree when found",
    CurrentValue = getgenv().BlobConfig.TeleportToTree,
    Flag = "ToggleTPWhenFound",
    Callback = function(Value)
        getgenv().BlobConfig.TeleportToTree = Value
    end,
})

MainTab:CreateSection("Finder")

MainTab:CreateButton({
    Name = "Find Tree",
    Callback = function()
        local c = getgenv().BlobConfig
        print("======== [ BLOB HUB CONFIGURACIÓN SELECCIONADA ] ========")
        print("Tipo de Árbol (TreeType):", c.TreeType)
        print("Tamaño de Árbol (TreeSize):", c.TreeSize)
        print("Buscar SpookyNeon También:", tostring(c.FindSpookyNeon))
        print("Teletransportar al Encontrar:", tostring(c.TeleportToTree))
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

if getgenv().AutoStartFinder then
    task.spawn(iniciarBusqueda)
end
