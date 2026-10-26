-- ==========================================================
-- 🇧🇷 RD4X HUB - PARTE 2/4 (TELEPORTES + PLAYER + SERVIDOR + CARROS)
-- ⚠️ Execute a Parte 1 antes
-- ==========================================================

local R = _G
if not _G.RD4X_UI then error("[RD4X] Execute a Parte 1/4 primeiro!") end

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local Camera = Workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

local ScreenGui        = _G.RD4X_ScreenGui
local UI               = _G.RD4X_UI
local Notify           = _G.RD4X_Notify
local Tabs             = _G.RD4X_Tabs
local COR_FUNDO        = _G.RD4X_COR_FUNDO
local COR_SECUNDARIA   = _G.RD4X_COR_SECUNDARIA
local COR_TEXTO        = _G.RD4X_COR_TEXTO
local COR_TEXTO_CINZA  = _G.RD4X_COR_TEXTO_CINZA
local COR_VERMELHO     = _G.RD4X_COR_VERMELHO

-- ==========================================================
-- 🌍 ABA TELEPORTES
-- ==========================================================
local function teleportar(x, y, z, nomeLocal)
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(x, y, z)
        Notify("🌍 Teleporte", "Você foi para: " .. nomeLocal, 2)
    else
        Notify("⚠️ Aviso", "Personagem não carregado", 2)
    end
end

UI.Button(Tabs.Teleportes, { Name = "🏛️ Praça", Description = "Teleporta para a Praça principal", Callback = function() teleportar(-26, 7, 1, "Praça") end })
UI.Button(Tabs.Teleportes, { Name = "🏥 Hospital", Description = "Teleporta para o Hospital", Callback = function() teleportar(-317, 5, 21, "Hospital") end })
UI.Button(Tabs.Teleportes, { Name = "⛰️ Morro", Description = "Teleporta para o Morro", Callback = function() teleportar(-349, 66, -458, "Morro") end })
UI.Button(Tabs.Teleportes, { Name = "🌲 Floresta", Description = "Teleporta para a Floresta", Callback = function() teleportar(-254, 7, 1089, "Floresta") end })
UI.Button(Tabs.Teleportes, { Name = "🩳 Praia", Description = "Teleporta para a Praia", Callback = function() teleportar(-231, 0, 742, "Praia") end })
UI.Button(Tabs.Teleportes, { Name = "🩳 Praia 2", Description = "Teleporta para a segunda Praia", Callback = function() teleportar(63, 4, 1477, "Praia2") end })
UI.Button(Tabs.Teleportes, { Name = "🐥 Fazenda", Description = "Teleporta para a Fazenda", Callback = function() teleportar(-852, 3, -84, "Fazenda") end })
UI.Button(Tabs.Teleportes, { Name = "🐴 Celeiro", Description = "Teleporta para o Celeiro", Callback = function() teleportar(-831, 3, -287, "Celeiro") end })
UI.Button(Tabs.Teleportes, { Name = "🛏️ Hotel", Description = "Teleporta para o Hotel", Callback = function() teleportar(168, 4, 161, "Hotel") end })
UI.Button(Tabs.Teleportes, { Name = "⛽ Posto", Description = "Teleporta para o Posto de Gasolina", Callback = function() teleportar(157, 4, -301, "Posto") end })
UI.Button(Tabs.Teleportes, { Name = "🚁 Heli + Drone", Description = "Teleporta para a área do Heli + Drone", Callback = function() teleportar(-695, 260, 790, "Drone") end })
UI.Button(Tabs.Teleportes, { Name = "🏠 Casa Abandonada", Description = "Teleporta para a Casa Abandonada", Callback = function() teleportar(1036, 6, 54, "Casa Abandonada") end })
UI.Button(Tabs.Teleportes, { Name = "⛵ Iate", Description = "Teleporta para o Iate", Callback = function() teleportar(-128, 32, 850, "Iate") end })
UI.Button(Tabs.Teleportes, { Name = "🔌 Energia", Description = "Teleporta para a Usina de Energia", Callback = function() teleportar(228, 4, 813, "Energia") end })

--------------------------------------------------------------------------------
-- ABA PLAYER
--------------------------------------------------------------------------------
local valorSpeedInput, valorJumpInput = 16, 50

UI.Input(Tabs.Player, { Name = "Selecione Speed", CurrentValue = "16", PlaceholderText = "Velocidade...", Callback = function(v) valorSpeedInput = tonumber(v) or 16 end })
UI.Button(Tabs.Player, { Name = "Definir Speed", Description = "Aplica a speed", Callback = function()
    pcall(function() LocalPlayer.Character.Humanoid.WalkSpeed = valorSpeedInput end)
    Notify("Player", "Speed: " .. valorSpeedInput, 2)
end})

UI.Input(Tabs.Player, { Name = "Selecione Jump", CurrentValue = "50", PlaceholderText = "Pulo...", Callback = function(v) valorJumpInput = tonumber(v) or 50 end })
UI.Button(Tabs.Player, { Name = "Definir Jump", Description = "Aplica o jump", Callback = function()
    pcall(function() LocalPlayer.Character.Humanoid.JumpPower = valorJumpInput end)
    Notify("Player", "Jump: " .. valorJumpInput, 2)
end})

UI.Button(Tabs.Player, { Name = "Reset Personagem", Description = "respawn", Callback = function()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.Health = 0
    end
end})
UI.Button(Tabs.Outros, {
    Name = " Câmera livre com noclip",
    Description = "free cam",
    Callback = function()
        pcall(function() LocalPlayer.DevCameraOcclusionMode = Enum.DevCameraOcclusionMode.Invisicam end)
    end
})

-- ROLEPLAY BIO
local RPNameText = nil
local function atualizarBioRemote()
    local RE = ReplicatedStorage:FindFirstChild("RE")
    RPNameText = RE and RE:FindFirstChild("1RPNam1eTex1t")
end
atualizarBioRemote()

UI.Button(Tabs.Player, {
    Name = "▪️◾ set Bio: Welcome, " .. LocalPlayer.Name,
    Description = "sla",
    Callback = function()
        atualizarBioRemote()
        if RPNameText then
            local texto = "Welcome, " .. LocalPlayer.Name
            RPNameText:FireServer("RolePlayBio", texto)
        end
    end
})

local bioCustom = ""
UI.Input(Tabs.Player, { Name = "Bio Personalizada", CurrentValue = "", PlaceholderText = "Digite seu texto...", Callback = function(t) bioCustom = t end })
UI.Button(Tabs.Player, { Name = "📝 Aplicar Bio Personalizada", Description = "Forma mais fácil de aplicar", Callback = function()
    atualizarBioRemote()
    if RPNameText and bioCustom ~= "" then
        RPNameText:FireServer("RolePlayBio", bioCustom)
    end
end})
UI.Button(Tabs.Player, { Name = "👻 Limpar Bio", Description = "Remove a sua bio atual", Callback = function()
    atualizarBioRemote()
    if RPNameText then
        RPNameText:FireServer("RolePlayBio", "")
        Notify("Bio", "Bio removida", 2)
    end
end})

--------------------------------------------------------------------------------
-- ABA SERVIDOR
--------------------------------------------------------------------------------
local listaJogadoresServidor = {LocalPlayer.Name}
for _, p in ipairs(Players:GetPlayers()) do
    if p.Name ~= LocalPlayer.Name then table.insert(listaJogadoresServidor, p.Name) end
end
local alvoServidorSelecionado = LocalPlayer.Name
local conexaoSentarCabeca = nil
local camOriginalServidor = nil

local dropdownServidorList = UI.Dropdown(Tabs.Servidor, {
    Name = "Lista de Jogadores",
    Options = listaJogadoresServidor,
    CurrentOption = {LocalPlayer.Name},
    Callback = function(Option) alvoServidorSelecionado = Option[1] end,
})

UI.Button(Tabs.Servidor, { Name = "🔄 Atualizar Lista", Description = "Atualiza a lista de jogadores", Callback = function()
    local novaLista = {}
    for _, p in ipairs(Players:GetPlayers()) do table.insert(novaLista, p.Name) end
    listaJogadoresServidor = novaLista
    dropdownServidorList:Refresh(listaJogadoresServidor)
end})

UI.Button(Tabs.Servidor, { Name = "👁️ View Cam", Description = "ver câmera do jogador selecionado", Callback = function()
    local alvo = Players:FindFirstChild(alvoServidorSelecionado)
    if alvo and alvo.Character and alvo.Character:FindFirstChild("Head") then
        camOriginalServidor = Camera.CFrame
        Camera.CameraSubject = alvo.Character.Humanoid
    end
end})

UI.Button(Tabs.Servidor, { Name = "↩️ Voltar Câmera", Description = "Volta a câmera para você", Callback = function()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        Camera.CameraSubject = LocalPlayer.Character.Humanoid
        if camOriginalServidor then Camera.CFrame = camOriginalServidor end
        Notify("Servidor", "Restaurada.", 2)
    end
end})

UI.Button(Tabs.Servidor, { Name = "📍 Teleportar para Jogador", Description = "Teleporta até o jogador", Callback = function()
    local alvo = Players:FindFirstChild(alvoServidorSelecionado)
    if alvo and alvo.Character and alvo.Character:FindFirstChild("HumanoidRootPart") and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        LocalPlayer.Character.HumanoidRootPart.CFrame = alvo.Character.HumanoidRootPart.CFrame + Vector3.new(0, 3, 0)
        Notify("Servidor", "Teleportado!", 2)
    end
end})

UI.Button(Tabs.Servidor, { Name = "HeadSit", Description = "Senta na cabeça do jogador", Callback = function()
    local alvo = Players:FindFirstChild(alvoServidorSelecionado)
    if alvo and alvo.Character and alvo.Character:FindFirstChild("Head") and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        if conexaoSentarCabeca then conexaoSentarCabeca:Disconnect() end
        conexaoSentarCabeca = RunService.Stepped:Connect(function()
            pcall(function()
                if alvo and alvo.Character and alvo.Character:FindFirstChild("Head") and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                    LocalPlayer.Character.HumanoidRootPart.CFrame = alvo.Character.Head.CFrame + Vector3.new(0, 1.5, 0)
                    LocalPlayer.Character.Humanoid.Sit = true
                end
            end)
        end)
    end
end})

UI.Button(Tabs.Servidor, { Name = "Sair da cabeça", Description = "Sai da cabeça do jogador", Callback = function()
    if conexaoSentarCabeca then conexaoSentarCabeca:Disconnect(); conexaoSentarCabeca = nil end
    pcall(function() LocalPlayer.Character.Humanoid.Sit = false end)
end})

UI.Button(Tabs.Servidor, { Name = "🚪 Disconnect", Description = "Desconecta do servidor atual", Callback = function()
    LocalPlayer:Kick("Disconnected by Rd4X.")
end})

UI.Button(Tabs.Servidor, {
    Name = "🎯 Menu TP rápido",
    Description = "Teleport",
    Callback = function()
        local menu = Instance.new("Frame", ScreenGui)
        menu.Size = UDim2.new(0, 220, 0, 300)
        menu.Position = UDim2.new(0.5, -110, 0.5, -150)
        menu.BackgroundColor3 = COR_SECUNDARIA
        menu.BackgroundTransparency = 0.1
        menu.BorderSizePixel = 0
        menu.ZIndex = 2000

        local cM = Instance.new("UICorner", menu)
        cM.CornerRadius = UDim.new(0, 8)

        local titulo = Instance.new("TextLabel", menu)
        titulo.Size = UDim2.new(1, 0, 0, 30)
        titulo.BackgroundTransparency = 1
        titulo.Text = "🎯 Teleportar para..."
        titulo.TextColor3 = COR_TEXTO
        titulo.TextSize = 12
        titulo.Font = Enum.Font.GothamBold
        titulo.ZIndex = 2001

        local scroll = Instance.new("ScrollingFrame", menu)
        scroll.Size = UDim2.new(1, -10, 1, -40)
        scroll.Position = UDim2.new(0, 5, 0, 35)
        scroll.BackgroundTransparency = 1
        scroll.BorderSizePixel = 0
        scroll.ScrollBarThickness = 2
        scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
        scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
        scroll.ZIndex = 2001

        local layout = Instance.new("UIListLayout", scroll)
        layout.Padding = UDim.new(0, 4)

        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LocalPlayer then
                local b = Instance.new("TextButton", scroll)
                b.Size = UDim2.new(1, -4, 0, 26)
                b.BackgroundColor3 = COR_FUNDO
                b.BackgroundTransparency = 0.3
                b.BorderSizePixel = 0
                b.Text = p.Name
                b.TextColor3 = COR_TEXTO
                b.TextSize = 10
                b.Font = Enum.Font.Gotham
                b.ZIndex = 2002

                local cB = Instance.new("UICorner", b)
                cB.CornerRadius = UDim.new(0, 6)

                b.MouseButton1Click:Connect(function()
                    if p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                        LocalPlayer.Character.HumanoidRootPart.CFrame = p.Character.HumanoidRootPart.CFrame + Vector3.new(0, 3, 0)
                    end
                    menu:Destroy()
                end)
            end
        end

        local x = Instance.new("TextButton", menu)
        x.Size = UDim2.new(0, 20, 0, 20)
        x.Position = UDim2.new(1, -24, 0, 5)
        x.BackgroundTransparency = 1
        x.Text = "❌"
        x.TextColor3 = COR_VERMELHO
        x.TextSize = 12
        x.Font = Enum.Font.GothamBold
        x.ZIndex = 2002
        x.MouseButton1Click:Connect(function() menu:Destroy() end)
    end
})

local waypoints = {}
UI.Button(Tabs.Servidor, {
    Name = "📍 Save",
    Description = "Salva a sua posição",
    Callback = function()
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            local pos = LocalPlayer.Character.HumanoidRootPart.CFrame
            table.insert(waypoints, {nome = "Local " .. #waypoints + 1, pos = pos})
            Notify("Waypoint", "Salvo local " .. #waypoints, 2)
        end
    end
})
UI.Button(Tabs.Servidor, {
    Name = "📍 TP posição salva",
    Description = "Volta para a última posição salva",
    Callback = function()
        if #waypoints > 0 then
            local wp = waypoints[#waypoints]
            LocalPlayer.Character.HumanoidRootPart.CFrame = wp.pos
            Notify("Waypoint", "Voltou: " .. wp.nome, 2)
        end
    end
})
UI.Button(Tabs.Servidor, {
    Name = "📍 Limpar waypoints",
    Description = "Apaga todas as posições salvas",
    Callback = function() waypoints = {}; Notify("Waypoint", "Limpos!", 2) end
})

--------------------------------------------------------------------------------
-- ABA CARROS
--------------------------------------------------------------------------------
local velocidadeCarroInput, forcaArrancadaInput = 50, 100

UI.Input(Tabs.Carros, { Name = "Velocidade do Carro", CurrentValue = "50", PlaceholderText = "Velocidade...", Callback = function(v) velocidadeCarroInput = tonumber(v) or 50 end })
UI.Button(Tabs.Carros, { Name = "Inserir Velocidade", Description = "aplicar car speed < Pode ter falhas >", Callback = function()
    pcall(function() LocalPlayer.Character.Humanoid.SeatPart.MaxSpeed = velocidadeCarroInput end)
end})

UI.Input(Tabs.Carros, { Name = "Força de Arrancada", CurrentValue = "100", PlaceholderText = "Força...", Callback = function(v) forcaArrancadaInput = tonumber(v) or 100 end })
UI.Button(Tabs.Carros, { Name = "Definir Arrancada", Description = "Aplica a força de arrancada no carro", Callback = function()
    pcall(function() LocalPlayer.Character.Humanoid.SeatPart.Torque = forcaArrancadaInput end)
end})

UI.Button(Tabs.Carros, { Name = "Desbloquear carros", Description = "Permite dirigir qualquer carro", Callback = function()
    pcall(function()
        for _, v in ipairs(Workspace:GetDescendants()) do
            if v:IsA("VehicleSeat") then v.Disabled = false; v.Locked = false end
        end
    end)
end})

UI.Button(Tabs.Carros, { Name = "Fly Car", Description = "Carrega o script de carro voador", Callback = function()
    Notify("Carros", "Carregando Fly Car...", 2)
    task.spawn(function()
        pcall(function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/willthingVN/script-lua/refs/heads/main/Vehicle%20Fly%20Gui.lua"))()
        end)
    end)
end})

local rainbowCarAtivo = false
UI.Toggle(Tabs.Carros, {
    Name = "RGB Car",
    CurrentValue = false,
    Callback = function(state)
        rainbowCarAtivo = state
        if rainbowCarAtivo then
            task.spawn(function()
                local RE = ReplicatedStorage:FindFirstChild("RE")
                local carColorRemote = RE and RE:FindFirstChild("1Ca1rColo1r")
                local hue = 0
                while rainbowCarAtivo do
                    local char = LocalPlayer.Character
                    local hum = char and char:FindFirstChildOfClass("Humanoid")
                    if hum and hum.SeatPart and hum.SeatPart:IsA("VehicleSeat") then
                        hue = (hue + 0.01) % 1
                        local corRGB = Color3.fromHSV(hue, 1, 1)
                        if carColorRemote then
                            pcall(function() carColorRemote:FireServer("PickingCarColor", corRGB) end)
                        end
                        local veiculo = hum.SeatPart:FindFirstAncestorOfClass("Model")
                        if veiculo then
                            for _, part in ipairs(veiculo:GetDescendants()) do
                                if part:IsA("BasePart") and part.Name ~= "Seat" then
                                    pcall(function() part.Color = corRGB end)
                                end
                            end
                        end
                    end
                    task.wait(0.1)
                end
            end)
        end
    end
})

local autoDriveAtivo = false
local destinoSelecionado = "🏛️ Praça"
local LOCAIS_BROOKHAVEN = {
    ["🏛️ Praça"]            = Vector3.new(-26, 7, 1),
    ["🏥 Hospital"]         = Vector3.new(-317, 5, 21),
    ["⛰️ Morro"]            = Vector3.new(-349, 66, -458),
    ["🌲 Floresta"]         = Vector3.new(-254, 7, 1089),
    ["🩳 Praia"]            = Vector3.new(-231, 0, 742),
    ["🐥 Fazenda"]          = Vector3.new(-852, 3, -84),
    ["🐴 Celeiro"]          = Vector3.new(-831, 3, -287),
    ["🛏️ Hotel"]            = Vector3.new(168, 4, 161),
    ["⛽ Posto de Gasolina"] = Vector3.new(157, 4, -301),
    ["🚁 Heli + Drone"]     = Vector3.new(-695, 260, 790),
    ["🏠 Casa Abandonada"]  = Vector3.new(1036, 6, 54),
    ["⛵ Iate"]             = Vector3.new(-128, 32, 850),
    ["🔌 Usina de Energia"] = Vector3.new(228, 4, 813),
}

local function obterListaPiloto()
    local lista = {}
    for nomeLocal, _ in pairs(LOCAIS_BROOKHAVEN) do table.insert(lista, nomeLocal) end
    for _, p in ipairs(Players:GetPlayers()) do table.insert(lista, "👤 " .. p.Name) end
    return lista
end

local dropdownPiloto = UI.Dropdown(Tabs.Carros, {
    Name = "🎯 Selecione o Destino (Local ou Player)",
    Options = obterListaPiloto(),
    CurrentOption = {"🏛️ Praça"},
    Callback = function(opt) if opt and opt[1] then destinoSelecionado = opt[1] end end
})

UI.Button(Tabs.Carros, {
    Name = "ERROR",
    Description = "ERROR",
    Callback = function()
        dropdownPiloto:Refresh(obterListaPiloto())
        Notify("Carros", INDISPONÍVEL", 2)
    end
})

UI.Toggle(Tabs.Carros, {
    Name = "Piloto Automático < Em Breve >",
    CurrentValue = false,
    Callback = function(state)
        autoDriveAtivo = state
        if autoDriveAtivo then
            Notify("Carros", "Piloto Automático ligado! Destino: " .. destinoSelecionado, 3)
            task.spawn(function()
                while autoDriveAtivo do
                    local char = LocalPlayer.Character
                    local hum = char and char:FindFirstChildOfClass("Humanoid")
                    local seat = hum and hum.SeatPart
                    if seat and seat:IsA("VehicleSeat") then
                        local veiculo = seat:FindFirstAncestorOfClass("Model") or seat.Parent
                        local posAlvo = nil
                        if LOCAIS_BROOKHAVEN[destinoSelecionado] then
                            posAlvo = LOCAIS_BROOKHAVEN[destinoSelecionado]
                        else
                            local nomeLimpo = destinoSelecionado:gsub("👤 ", "")
                            local alvo = Players:FindFirstChild(nomeLimpo)
                            if alvo and alvo.Character and alvo.Character:FindFirstChild("HumanoidRootPart") then
                                posAlvo = alvo.Character.HumanoidRootPart.Position
                            end
                        end
                        if veiculo and posAlvo then
                            local posCarro = seat.Position
                            local direcao = (Vector3.new(posAlvo.X, posCarro.Y, posAlvo.Z) - posCarro).Unit
                            if (Vector3.new(posAlvo.X, posCarro.Y, posAlvo.Z) - posCarro).Magnitude > 8 then
                                pcall(function()
                                    seat.AssemblyLinearVelocity = direcao * 50
                                    veiculo:PivotTo(CFrame.new(posCarro, Vector3.new(posAlvo.X, posCarro.Y, posAlvo.Z)))
                                end)
                            else
                                pcall(function() seat.AssemblyLinearVelocity = Vector3.new(0, 0, 0) end)
                                Notify("Carros", "🏁 Você chegou ao destino!", 2)
                                autoDriveAtivo = false
                                break
                            end
                        end
                    else
                        Notify("Carros", "Entre no banco do motorista!", 3)
                        autoDriveAtivo = false
                        break
                    end
                    task.wait(0.05)
                end
            end)
        else
            Notify("Carros", "Piloto Automático Desativado", 2)
        end
    end
})

UI.Button(Tabs.Carros, {
    Name = "🧲 Bring All Vehicles (Indisponível no momento)",
    Description = "Puxa todos os carros do srv",
    Callback = function()
        local char = LocalPlayer.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        if not hrp then Notify("Carros", "Seu personagem não foi encontrado!", 2); return end
        local posicaoFrente = hrp.CFrame + (hrp.CFrame.LookVector * 10)
        local quantidadePuxada = 0
        pcall(function()
            for _, obj in ipairs(Workspace:GetDescendants()) do
                if obj:IsA("VehicleSeat") and not obj.Occupant then
                    local veiculo = obj:FindFirstAncestorOfClass("Model") or obj.Parent
                    if veiculo and veiculo:IsA("Model") then
                        veiculo:PivotTo(posicaoFrente + Vector3.new(0, quantidadePuxada * 3, 0))
                        quantidadePuxada = quantidadePuxada + 1
                    end
                end
            end
        end)
        if quantidadePuxada > 0 then
            Notify("Carros", "🧲 " .. quantidadePuxada .. " carros puxados até você!", 3)
        else
            Notify("Carros", "Nenhum carro desocupado encontrado.", 2)
        end
    end
})

--------------------------------------------------------------------------------
-- ABA CASAS (aviso)
--------------------------------------------------------------------------------
UI.Paragraph(Tabs.Casas, {
    Title = "⚠️ Aviso do RD4X!",
    Content = "Aguarde atualizações, em breve estará disponível!",
    Height = 55
})

print("[RD4X] ✅ Parte 2/4 carregada.")
