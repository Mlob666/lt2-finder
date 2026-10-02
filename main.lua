-- Código que estará alojado en tu servidor / GitHub
local CoreGui = game:GetService("CoreGui")

-- Crear contenedor
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "MiGuiRemota"

-- Prevenir duplicados si se ejecuta varias veces
if CoreGui:FindFirstChild("MiGuiRemota") then
    CoreGui.MiGuiRemota:Destroy()
end

screenGui.Parent = CoreGui

-- Crear ventana principal
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 250, 0, 150)
frame.Position = UDim2.new(0.5, -125, 0.5, -75)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.Parent = screenGui

-- Título
local titulo = Instance.new("TextLabel")
titulo.Size = UDim2.new(1, 0, 0, 35)
titulo.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
titulo.Text = "Mi Hub Remoto"
titulo.TextColor3 = Color3.fromRGB(255, 255, 255)
titulo.TextSize = 16
titulo.Parent = frame

-- Botón de acción
local boton = Instance.new("TextButton")
boton.Size = UDim2.new(0, 100, 0, 30)
boton.Position = UDim2.new(0.5, -50, 0.6, 0)
boton.Text = "Hola Mundo"
boton.Parent = frame

boton.MouseButton1Click:Connect(function()
    print("¡Botón presionado desde el script remoto!")
end)
