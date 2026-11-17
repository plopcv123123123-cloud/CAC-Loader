-- CAC MASS EXPORTER | PUBLIC LOADER v1.6
-- Cargador publico. No contiene claves de administrador ni el exportador privado.
-- La activacion requiere que el servidor de Cloudflare este configurado.
local API_BASE = "https://cac-license-server.plopcv123123123.workers.dev"

local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local player = Players.LocalPlayer
if not player then error("CAC: ejecuta este loader dentro de Roblox") end

local function requestFn()
    local env = (type(getgenv) == "function" and getgenv()) or _G
    local candidates = {env.request, env.http_request, request, http_request}
    for _, fn in ipairs(candidates) do
        if type(fn) == "function" then return fn end
    end
    local synLib = env.syn or syn
    if type(synLib) == "table" and type(synLib.request) == "function" then
        return synLib.request
    end
    local xeno = env.Xeno
    if type(xeno) == "table" and type(xeno.request) == "function" then
        return xeno.request
    end
    return nil
end

local requestHTTP = requestFn()
local function api(path, payload)
    if not requestHTTP then
        error("El ejecutor no ofrece POST HTTPS; no se pudo conectar al servidor")
    end
    local response = requestHTTP({
        Url = API_BASE .. path,
        Method = "POST",
        Headers = {["Content-Type"] = "application/json", ["Cache-Control"] = "no-store"},
        Body = HttpService:JSONEncode(payload)
    })
    if not response then error("Sin respuesta del servidor") end
    local raw = response.Body or response.body
    if type(raw) ~= "string" then error("Respuesta sin contenido") end
    local ok, result = pcall(function() return HttpService:JSONDecode(raw) end)
    if not ok or type(result) ~= "table" then
        error("El servidor aun no tiene instalada la API de licencias")
    end
    if result.ok ~= true then error(tostring(result.error or "Acceso rechazado")) end
    return result
end

local ROOT = "CAC_Premium"
local CACHE = ROOT .. "/device_session.json"
local function loadCache()
    if type(isfile) ~= "function" or type(readfile) ~= "function" then return {} end
    local ok, result = pcall(function()
        if not isfile(CACHE) then return {} end
        return HttpService:JSONDecode(readfile(CACHE))
    end)
    return (ok and type(result) == "table") and result or {}
end
local function saveCache(data)
    if type(writefile) ~= "function" then return false end
    return pcall(function()
        if type(makefolder) == "function" then pcall(makefolder, ROOT) end
        writefile(CACHE, HttpService:JSONEncode(data))
    end)
end

local cache = loadCache()
local deviceId = cache.deviceId
if type(deviceId) ~= "string" or #deviceId < 12 then
    deviceId = "cac-device-" .. HttpService:GenerateGUID(false)
    cache = {deviceId = deviceId}
    if not saveCache(cache) then
        warn("CAC: no se pudo guardar la sesion local en este ejecutor")
    end
end

local parent = player:WaitForChild("PlayerGui")
local okH, hui = pcall(function()
    if type(gethui) == "function" then return gethui() end
end)
if okH and hui then parent = hui end
local previous = parent:FindFirstChild("CAC_GitHub_Loader")
if previous then previous:Destroy() end
local gui = Instance.new("ScreenGui")
gui.Name = "CAC_GitHub_Loader"
gui.ResetOnSpawn = false
gui.Parent = parent

local frame = Instance.new("Frame")
frame.Name = "Main"
frame.Size = UDim2.fromOffset(440, 252)
frame.Position = UDim2.new(.5, -220, .5, -126)
frame.BackgroundColor3 = Color3.fromRGB(19, 20, 25)
frame.BorderSizePixel = 0
frame.Parent = gui
Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 13)

local function makeText(value, y, fontSize)
    local label = Instance.new("TextLabel")
    label.Size = UDim2.fromOffset(404, 35)
    label.Position = UDim2.fromOffset(18, y)
    label.BackgroundTransparency = 1
    label.Text = value
    label.TextWrapped = true
    label.Font = Enum.Font.GothamBold
    label.TextSize = fontSize or 13
    label.TextColor3 = Color3.fromRGB(231, 233, 239)
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame
    return label
end
makeText("CAC MASS EXPORTER  |  PREMIUM", 15, 19)
makeText("Activa tu licencia una vez; luego se reanuda tu sesion.", 49, 11)
local field = Instance.new("TextBox")
field.Size = UDim2.fromOffset(400, 43)
field.Position = UDim2.fromOffset(19, 96)
field.Text = ""
field.PlaceholderText = "CAC-XXXX-XXXX-XXXX-XXXX"
field.ClearTextOnFocus = false
field.Font = Enum.Font.Code
field.TextSize = 13
field.BackgroundColor3 = Color3.fromRGB(47, 48, 55)
field.TextColor3 = Color3.new(1, 1, 1)
field.Parent = frame
Instance.new("UICorner", field).CornerRadius = UDim.new(0, 8)

local button = Instance.new("TextButton")
button.Size = UDim2.fromOffset(400, 42)
button.Position = UDim2.fromOffset(19, 153)
button.Text = "ACTIVAR / ABRIR"
button.Font = Enum.Font.GothamBold
button.TextSize = 14
button.BackgroundColor3 = Color3.fromRGB(174, 54, 55)
button.TextColor3 = Color3.new(1, 1, 1)
button.Parent = frame
Instance.new("UICorner", button).CornerRadius = UDim.new(0, 8)
local status = makeText("Esperando autorizacion...", 207, 11)
local busy = false

local function openModule(token)
    status.Text = "Descargando modulo autorizado..."
    local response = api("/load", {sessionToken = token, deviceId = deviceId})
    if type(response.code) ~= "string" or #response.code < 100 then
        error("El modulo privado aun no se publico")
    end
    local chunk, compileError = loadstring(response.code)
    if not chunk then error("No se pudo cargar el modulo: " .. tostring(compileError)) end
    local env = (type(getgenv) == "function" and getgenv()) or _G
    env.CAC_SESSION_TOKEN = token
    env.CAC_DEVICE_ID = deviceId
    env.CAC_API_URL = API_BASE
    gui:Destroy()
    chunk()
end
local function activate(key)
    local response = api("/activate", {
        key = key,
        deviceId = deviceId,
        robloxUserId = tostring(player.UserId)
    })
    cache.deviceId = deviceId
    cache.sessionToken = response.sessionToken
    saveCache(cache)
    openModule(response.sessionToken)
end
local function resume()
    if type(cache.sessionToken) ~= "string" or #cache.sessionToken < 20 then return false end
    local response = api("/session/resume", {
        sessionToken = cache.sessionToken,
        deviceId = deviceId
    })
    cache.sessionToken = response.sessionToken
    saveCache(cache)
    openModule(response.sessionToken)
    return true
end
local function run(auto)
    if busy then return end
    busy = true
    button.Text = "VERIFICANDO..."
    task.spawn(function()
        local ok, err = pcall(function()
            if auto then
                if not resume() then status.Text = "Introduce tu key para activar." end
            else
                local key = field.Text:gsub("%s+", ""):upper()
                if #key < 15 then error("Introduce una key valida") end
                field.Text = ""
                activate(key)
            end
        end)
        busy = false
        button.Text = "ACTIVAR / ABRIR"
        if not ok and gui.Parent then
            status.Text = auto and "No se pudo reanudar. Revisa tu licencia." or tostring(err):sub(1, 135)
        end
    end)
end
button.MouseButton1Click:Connect(function() run(false) end)
if cache.sessionToken then
    status.Text = "Reanudando licencia guardada..."
    run(true)
else
    status.Text = "Introduce tu key para iniciar."
end
