-- ==========================================================
-- 🇧🇷 RD4X HUB - PARTE 4/4 (OUTROS + PROTEÇÃO + CONFIG + SCRIPTS + VIP)
-- ⚠️ Execute a Parte 1 antes
-- ==========================================================

if not _G.RD4X_UI then error("[RD4X] Execute a Parte 1/4 primeiro!") end

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local Lighting = game:GetService("Lighting")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local SoundService = game:GetService("SoundService")
local HttpService = game:GetService("HttpService")
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

local ScreenGui     = _G.RD4X_ScreenGui
local MainFrame     = _G.RD4X_MainFrame
local NotifHolder   = _G.RD4X_NotifHolder
local BolhasContainer = _G.RD4X_BolhasContainer
local strokeMain    = _G.RD4X_strokeMain
local criarBolha    = _G.RD4X_criarBolha
local UI            = _G.RD4X_UI
local Notify        = _G.RD4X_Notify
local Tabs          = _G.RD4X_Tabs

local COR_FUNDO      = _G.RD4X_COR_FUNDO
local COR_SIDEBAR    = _G.RD4X_COR_SIDEBAR
local COR_SECUNDARIA = _G.RD4X_COR_SECUNDARIA
local COR_TEXTO      = _G.RD4X_COR_TEXTO
local COR_TEXTO_CINZA= _G.RD4X_COR_TEXTO_CINZA
local COR_VERDE      = _G.RD4X_COR_VERDE
local COR_BORDA      = _G.RD4X_COR_BORDA
local COR_VERMELHO   = _G.RD4X_COR_VERMELHO
local TRANSP_FUNDO       = _G.RD4X_TRANSP_FUNDO
local TRANSP_SIDEBAR     = _G.RD4X_TRANSP_SIDEBAR
local TRANSP_CARDS       = _G.RD4X_TRANSP_CARDS
local TRANSP_INPUT       = _G.RD4X_TRANSP_INPUT
local TRANSP_BOTAO_VERDE = _G.RD4X_TRANSP_BOTAO_VERDE

--------------------------------------------------------------------------------
-- ABA OUTROS
--------------------------------------------------------------------------------
UI.Button(Tabs.Outros, {
    Name = "⚡ Otimizar Hub (Irreversível)",
    Description = "Deixa o mapa mais leve",
    Callback = function()
        pcall(function()
            for _, v in ipairs(Workspace:GetDescendants()) do
                if v:IsA("BasePart") then
                    v.CastShadow = false
                    v.Material = Enum.Material.SmoothPlastic
                end
            end
        end)
    end
})

UI.Button(Tabs.Outros, { Name = "📉 Reduzir Lag (Irreversível)", Description = "Desativa partículas e efeitos", Callback = function()
    pcall(function()
        settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
        for _, v in ipairs(Workspace:GetDescendants()) do
            if v:IsA("ParticleEmitter") or v:IsA("Trail") or v:IsA("Fire") or v:IsA("Smoke") then v:Destroy() end
        end
    end)
    Notify("Outros", "Lag reduzido!", 2)
end})

UI.Button(Tabs.Outros, { Name = "💡 Desativar Brilho (Irreversível)", Description = "Remove o brilho", Callback = function()
    pcall(function()
        Lighting.Brightness = 0
        for _, v in ipairs(Lighting:GetChildren()) do
            if v:IsA("PostEffect") or v:IsA("Atmosphere") or v:IsA("Sky") then v:Destroy() end
        end
    end)
    Notify("Outros", "Brilho desativado!", 2)
end})

UI.Button(Tabs.Outros, { Name = "🌑 Desativar Sombras (Irreversível)", Description = "Desliga as sombras do mapa", Callback = function()
    Lighting.GlobalShadows = false
    Notify("Outros", "Sombras desativadas!", 2)
end})

UI.Button(Tabs.Outros, { Name = "🌳 Excluir Árvores (Irreversível)", Description = "Apaga as árvores do mapa", Callback = function()
    pcall(function()
        for _, v in ipairs(Workspace:GetDescendants()) do
            if v:IsA("Model") and (v.Name:lower():find("tree") or v.Name:lower():find("arvore") or v.Name:lower():find("plant")) then
                v:Destroy()
            elseif v:IsA("BasePart") and (v.Name:lower():find("tree") or v.Name:lower():find("arvore")) then
                v:Destroy()
            end
        end
    end)
    Notify("Outros", "Árvores excluídas!", 2)
end})

UI.Button(Tabs.Outros, { Name = "🎨 Simplificar Gráficos (Irreversível)", Description = "Deixa os gráficos simples", Callback = function()
    pcall(function()
        for _, v in ipairs(Workspace:GetDescendants()) do
            if v:IsA("BasePart") then
                v.Material = Enum.Material.SmoothPlastic
                v.Color = Color3.fromRGB(150, 150, 150)
            end
        end
    end)
    Notify("Outros", "Gráficos simplificados!", 2)
end})

--------------------------------------------------------------------------------
-- ABA PROTEÇÃO
--------------------------------------------------------------------------------
UI.Button(Tabs.Protecao, {
    Name = "⚡ Ativar Anti-AFK (Evita Desconexão)",
    Description = "Evita desconexão por inatividade",
    Callback = function()
        pcall(function()
            local vu = game:GetService("VirtualUser")
            LocalPlayer.Idled:Connect(function()
                vu:Button2Down(Vector2.new(0, 0), Workspace.CurrentCamera.CFrame)
                task.wait(1)
                vu:Button2Up(Vector2.new(0, 0), Workspace.CurrentCamera.CFrame)
            end)
        end)
        Notify("Proteção", "Anti-AFK ativado!", 3)
    end
})

local invisivelAtivo = false
UI.Toggle(Tabs.Player, {
    Name = "Personagem Invisível",
    CurrentValue = false,
    Callback = function(state)
        invisivelAtivo = state
        local char = LocalPlayer.Character
        if not char then return end
        pcall(function()
            for _, part in ipairs(char:GetDescendants()) do
                if part:IsA("BasePart") or part:IsA("Decal") then
                    part.Transparency = invisivelAtivo and 1 or 0
                elseif part:IsA("Accessory") and part:FindFirstChild("Handle") then
                    part.Handle.Transparency = invisivelAtivo and 1 or 0
                end
            end
        end)
        Notify("Player", invisivelAtivo and "Você está invisível!" or "Visibilidade restaurada!", 2)
    end
})

local antiSitAtivo, antiLagAtivo, antiFlingAtivo, noclipAtivo, espAtivo = false, false, false, false, false

UI.Toggle(Tabs.Protecao, { Name = "Anti-Sit (Impede de sentar)", CurrentValue = false, Callback = function(v) antiSitAtivo = v end })
RunService.Stepped:Connect(function()
    if antiSitAtivo and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.Sit = false
    end
end)

UI.Toggle(Tabs.Protecao, { Name = "Anti-Lag (Desativa texturas pesadas)", CurrentValue = false, Callback = function(v)
    antiLagAtivo = v
    if antiLagAtivo then
        for _, obj in ipairs(Workspace:GetDescendants()) do
            if obj:IsA("BasePart") then obj.Material = Enum.Material.SmoothPlastic end
        end
    end
end})

UI.Toggle(Tabs.Protecao, { Name = "Anti-Fling", CurrentValue = false, Callback = function(v) antiFlingAtivo = v end })
RunService.Stepped:Connect(function()
    if antiFlingAtivo and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        LocalPlayer.Character.HumanoidRootPart.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
    end
end)

UI.Toggle(Tabs.Protecao, { Name = "Noclip (Atravessar paredes)", CurrentValue = false, Callback = function(v) noclipAtivo = v end })
RunService.Stepped:Connect(function()
    if noclipAtivo and LocalPlayer.Character then
        for _, part in ipairs(LocalPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") then part.CanCollide = false end
        end
    end
end)

UI.Toggle(Tabs.Protecao, { Name = "ESP (Ver jogadores)", CurrentValue = false, Callback = function(state)
    espAtivo = state
    if espAtivo then
        task.spawn(function()
            while espAtivo do
                for _, p in ipairs(Players:GetPlayers()) do
                    if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("Head") and not p.Character.Head:FindFirstChild("RD4X_ESP") then
                        local bg = Instance.new("BillboardGui", p.Character.Head)
                        bg.Name = "RD4X_ESP"
                        bg.Size = UDim2.new(0, 100, 0, 40)
                        bg.StudsOffset = Vector3.new(0, 3, 0)
                        bg.AlwaysOnTop = true
                        local tl = Instance.new("TextLabel", bg)
                        tl.Size = UDim2.new(1, 0, 1, 0)
                        tl.BackgroundTransparency = 1
                        tl.TextColor3 = COR_VERMELHO
                        tl.TextStrokeTransparency = 0
                        tl.TextSize = 14
                        tl.Text = p.Name
                    end
                end
                task.wait(1)
            end
        end)
    else
        for _, p in ipairs(Players:GetPlayers()) do
            if p.Character and p.Character:FindFirstChild("Head") then
                local esp = p.Character.Head:FindFirstChild("RD4X_ESP")
                if esp then esp:Destroy() end
            end
        end
    end
end})

--------------------------------------------------------------------------------
-- ABA CONFIG
--------------------------------------------------------------------------------
UI.Paragraph(Tabs.Config, { Title = "🎨 Visual", Content = "Controle os efeitos visuais do hub.", Height = 42 })

UI.Toggle(Tabs.Config, {
    Name = "🫧 Bolhas Coloridas",
    CurrentValue = true,
    Callback = function(v)
        _G.RD4X_BolhasAtivas = v
        if v then
            task.spawn(function()
                while _G.RD4X_BolhasAtivas and BolhasContainer.Parent do
                    criarBolha()
                    task.wait(math.random(8, 30) / 100)
                end
            end)
        end
    end
})

UI.Toggle(Tabs.Config, {
    Name = "💚 Borda Pulsante",
    CurrentValue = true,
    Callback = function(v)
        _G.RD4X_BordaPulsando = v
        if not v then
            strokeMain.Transparency = 0.3
            strokeMain.Thickness = 1.2
        end
    end
})

UI.Paragraph(Tabs.Config, { Title = " Cor Notify", Content = "Escolha a cor das Notificações.", Height = 42 })

local function trocarCorHub(novaCor)
    COR_VERDE = novaCor
    for _, gui in ipairs(ScreenGui:GetDescendants()) do
        pcall(function()
            if gui:IsA("UIStroke") and (gui.Color == Color3.fromRGB(46, 204, 113) or gui.Color == Color3.fromRGB(240, 240, 245)) then
                gui.Color = novaCor
            end
            if gui:IsA("TextLabel") and gui.TextColor3 == Color3.fromRGB(46, 204, 113) then
                gui.TextColor3 = novaCor
            end
            if gui:IsA("TextButton") and gui.BackgroundColor3 == Color3.fromRGB(46, 204, 113) then
                gui.BackgroundColor3 = novaCor
            end
            if gui:IsA("Frame") and gui.BackgroundColor3 == Color3.fromRGB(46, 204, 113) then
                gui.BackgroundColor3 = novaCor
            end
        end)
    end
    Notify("Config", "Cor aplicada!", 2)
end

UI.Button(Tabs.Config, { Name = "🟢 Verde (padrão)", Description = "Aplica a cor Verde no hub", Callback = function() trocarCorHub(Color3.fromRGB(46, 204, 113)) end })
UI.Button(Tabs.Config, { Name = "🔵 Azul",           Description = "Aplica a cor Azul no hub", Callback = function() trocarCorHub(Color3.fromRGB(52, 152, 219)) end })
UI.Button(Tabs.Config, { Name = "🟣 Roxo",           Description = "Aplica a cor Roxo no hub", Callback = function() trocarCorHub(Color3.fromRGB(155, 89, 182)) end })
UI.Button(Tabs.Config, { Name = "🔴 Vermelho",       Description = "Aplica a cor Vermelho no hub", Callback = function() trocarCorHub(Color3.fromRGB(231, 76, 60)) end })
UI.Button(Tabs.Config, { Name = "🟡 Amarelo",        Description = "Aplica a cor Amarelo no hub", Callback = function() trocarCorHub(Color3.fromRGB(241, 196, 15)) end })
UI.Button(Tabs.Config, { Name = "🟠 Laranja",        Description = "Aplica a cor Laranja no hub", Callback = function() trocarCorHub(Color3.fromRGB(230, 126, 34)) end })
UI.Button(Tabs.Config, { Name = "🩷 Rosa",           Description = "Aplica a cor Rosa no hub", Callback = function() trocarCorHub(Color3.fromRGB(255, 105, 180)) end })
UI.Button(Tabs.Config, { Name = "💠 Turquesa",       Description = "Aplica a cor Turquesa no hub", Callback = function() trocarCorHub(Color3.fromRGB(26, 188, 156)) end })

UI.Paragraph(Tabs.Config, { Title = "🔔 Notificações & Sons", Content = "Controle os avisos e sons do hub.", Height = 42 })

UI.Toggle(Tabs.Config, {
    Name = "🔔 Notificações", CurrentValue = true,
    Callback = function(v) _G.RD4X_NotifAtivas = v; if v then Notify("Config", "Notificações ativadas", 2) end end
})

UI.Toggle(Tabs.Config, {
    Name = "🔊 Som de Clique", CurrentValue = true,
    Callback = function(v) _G.RD4X_SomAtivo = v; if v then Notify("Config", "Som ativado", 2) end end
})

UI.Toggle(Tabs.Config, {
    Name = "🎵 Música de Fundo", CurrentValue = true,
    Callback = function(v)
        pcall(function()
            if _G.RD4X_MusicaFundo then
                if v then _G.RD4X_MusicaFundo:Resume() else _G.RD4X_MusicaFundo:Pause() end
            end
        end)
    end
})

UI.Input(Tabs.Config, {
    Name = "Volume da Música", CurrentValue = "0.15", PlaceholderText = "0 a 1",
    Callback = function(v)
        local n = tonumber(v) or 0.15
        pcall(function() if _G.RD4X_MusicaFundo then _G.RD4X_MusicaFundo.Volume = n end end)
    end,
})

UI.Paragraph(Tabs.Config, { Title = "🌫️ Transparência", Content = "Ajuste a transparência do hub.", Height = 42 })

UI.Input(Tabs.Config, {
    Name = "Transparência (0-1)", CurrentValue = "0.25", PlaceholderText = "0 = sólido",
    Callback = function(v)
        local n = tonumber(v) or 0.25
        MainFrame.BackgroundTransparency = n
        Notify("Config", "Transparência: " .. n, 2)
    end,
})

UI.Paragraph(Tabs.Config, { Title = "⚡ Performance", Content = "Reduza efeitos pra melhorar o FPS.", Height = 42 })

UI.Toggle(Tabs.Config, {
    Name = "⚡ Modo Leve (desativa efeitos)", CurrentValue = false,
    Callback = function(v)
        if v then
            _G.RD4X_BolhasAtivas = false
            _G.RD4X_BordaPulsando = false
            strokeMain.Transparency = 0.5
            Notify("Config", "Modo leve ativado", 2)
        else
            _G.RD4X_BolhasAtivas = true
            _G.RD4X_BordaPulsando = true
            task.spawn(function()
                while _G.RD4X_BolhasAtivas and BolhasContainer.Parent do
                    criarBolha()
                    task.wait(math.random(8, 30) / 100)
                end
            end)
            Notify("Config", "Modo normal", 2)
        end
    end,
})

UI.Button(Tabs.Config, {
    Name = "🗑️ Limpar Notificações",
    Description = "Remove as notificações da tela",
    Callback = function()
        for _, notif in ipairs(NotifHolder:GetChildren()) do
            if notif:IsA("Frame") then notif:Destroy() end
        end
    end,
})

UI.Paragraph(Tabs.Config, { Title = "🛠️ Sistema", Content = "Controles gerais do hub.", Height = 42 })

UI.Button(Tabs.Config, {
    Name = "❌ Minimizar",
    Description = "Fecha a interface do hub",
    Callback = function()
        MainFrame.Visible = false
    end,
})

UI.Paragraph(Tabs.Config, {
    Title = "ℹ️ Sobre",
    Content = "Rd4X Hub v1.0\nBy Rd4X Team Oficial\nhttps://discord.gg/kZzuySatK9",
    Height = 70
})

-- Borda pulsante (usa _G para refletir mudanças da aba Config)
task.spawn(function()
    while MainFrame.Parent do
        if _G.RD4X_BordaPulsando then
            TweenService:Create(strokeMain, TweenInfo.new(1.5), {Transparency = 0.8, Thickness = 2.5}):Play()
            task.wait(1.5)
            TweenService:Create(strokeMain, TweenInfo.new(1.5), {Transparency = 0.2, Thickness = 1.2}):Play()
            task.wait(1.5)
        else
            task.wait(0.5)
        end
    end
end)

--------------------------------------------------------------------------------
-- ABA SCRIPTS
--------------------------------------------------------------------------------
UI.Button(Tabs.Scripts, { Name = "Rd4X EMOTES", Description = "Carrega o script de emotes", Callback = function() Notify("Scripts", "Aguarde loadstring...", 2) end })
UI.Button(Tabs.Scripts, { Name = "Rd4X Chat", Description = "Carrega o script de chat", Callback = function() Notify("Scripts", "Aguarde loadstring...", 2) end })
UI.Button(Tabs.Scripts, { Name = "Rd4X Universal", Description = "Carrega o script universal", Callback = function() Notify("Scripts", "Aguarde loadstring...", 2) end })

UI.Button(Tabs.Scripts, { Name = "Fly gui", Description = "Abre o menu de voar", Callback = function()
    task.spawn(function() pcall(function() loadstring(game:HttpGet("https://raw.githubusercontent.com/XNEOFF/FlyGuiV3/main/FlyGuiV3.txt"))() end) end)
    Notify("Scripts", "Fly GUI carregado!", 2)
end})

UI.Button(Tabs.Scripts, { Name = "Fly car", Description = "Abre o menu de fly car", Callback = function()
    task.spawn(function() pcall(function() loadstring(game:HttpGet("https://raw.githubusercontent.com/willthingVN/script-lua/refs/heads/main/Vehicle%20Fly%20Gui.lua"))() end) end)
    Notify("Scripts", "Fly Car carregado!", 2)
end})

--------------------------------------------------------------------------------
-- ATIVAÇÃO NOME E COR RP
--------------------------------------------------------------------------------
task.spawn(function()
    pcall(function()
        local RE = ReplicatedStorage:WaitForChild("RE", 10)
        if RE then
            local remoteColor = RE:FindFirstChild("1RPNam1eColo1r") or RE:FindFirstChild("RPNameColor")
            local remoteName = RE:FindFirstChild("1RPNam1eTex1t") or RE:FindFirstChild("RPNameText")
            if remoteColor then remoteColor:FireServer("PickingRPNameColor", COR_VERMELHO) end
            task.wait(0.3)
            local MEU_ID_CREATOR = 4200878493
            if LocalPlayer.UserId == MEU_ID_CREATOR then
                if remoteName then remoteName:FireServer("RolePlayName", "👑 Rd4X Creator◾") end
            else
                if remoteName then remoteName:FireServer("RolePlayName", "🇧🇷 Rd4X Hub◾") end
            end
        end
    end)
end)

--------------------------------------------------------------------------------
-- POPUP DE ANÚNCIO
--------------------------------------------------------------------------------
task.spawn(function()
    task.wait(1)
    local oldAd = CoreGui:FindFirstChild("Rd4X_Ad_Anuncio")
    if oldAd then oldAd:Destroy() end

    local AdGui = Instance.new("ScreenGui")
    AdGui.Name = "Rd4X_Ad_Anuncio"
    AdGui.ResetOnSpawn = false
    AdGui.DisplayOrder = 9999
    AdGui.IgnoreGuiInset = true
    AdGui.Parent = CoreGui

    local anuncio = Instance.new("Frame", AdGui)
    anuncio.Size = UDim2.new(0, 0, 0, 0)
    anuncio.Position = UDim2.new(0.5, 0, 0.5, 0)
    anuncio.BackgroundColor3 = COR_FUNDO
    anuncio.BackgroundTransparency = 0
    anuncio.BorderSizePixel = 0
    anuncio.ClipsDescendants = true
    anuncio.ZIndex = 1

    local cAd = Instance.new("UICorner", anuncio)
    cAd.CornerRadius = UDim.new(0, 10)
    local sAd = Instance.new("UIStroke", anuncio)
    sAd.Color = COR_VERDE
    sAd.Thickness = 2
    sAd.ZIndex = 2

    local bolhasAd = Instance.new("Frame", anuncio)
    bolhasAd.Size = UDim2.new(1, 0, 1, 0)
    bolhasAd.BackgroundTransparency = 1
    bolhasAd.ClipsDescendants = true
    bolhasAd.ZIndex = 0

    local adAberto = true
    task.spawn(function()
        while adAberto and bolhasAd.Parent do
            local tam = math.random(5, 12)
            local b = Instance.new("Frame", bolhasAd)
            b.Size = UDim2.new(0, tam, 0, tam)
            b.Position = UDim2.new(math.random(), 0, 1, 5)
            local cores = {
                Color3.fromRGB(46, 204, 113),
                Color3.fromRGB(52, 152, 219),
                Color3.fromRGB(155, 89, 182),
                Color3.fromRGB(241, 196, 15),
                Color3.fromRGB(231, 76, 60),
            }
            b.BackgroundColor3 = cores[math.random(1, #cores)]
            b.BackgroundTransparency = math.random(20, 45) / 100
            b.BorderSizePixel = 0
            b.ZIndex = 0
            local cc = Instance.new("UICorner", b)
            cc.CornerRadius = UDim.new(1, 0)
            local tw = TweenService:Create(b, TweenInfo.new(math.random(4, 8), Enum.EasingStyle.Linear), {
                Position = UDim2.new(b.Position.X.Scale, 0, 0, -15),
                BackgroundTransparency = 1
            })
            tw:Play()
            tw.Completed:Connect(function() if b and b.Parent then b:Destroy() end end)
            task.wait(math.random(12, 35) / 100)
        end
    end)

    local adHeader = Instance.new("Frame", anuncio)
    adHeader.Size = UDim2.new(1, 0, 0, 40)
    adHeader.BackgroundColor3 = COR_SECUNDARIA
    adHeader.BackgroundTransparency = 0.1
    adHeader.BorderSizePixel = 0
    adHeader.ZIndex = 2
    local cH = Instance.new("UICorner", adHeader)
    cH.CornerRadius = UDim.new(0, 10)

    local adIcon = Instance.new("TextLabel", adHeader)
    adIcon.Size = UDim2.new(0, 24, 0, 24)
    adIcon.Position = UDim2.new(0, 10, 0.5, -12)
    adIcon.BackgroundTransparency = 1
    adIcon.Text = "📢"
    adIcon.TextSize = 15
    adIcon.ZIndex = 3

    local adTitle = Instance.new("TextLabel", adHeader)
    adTitle.Size = UDim2.new(1, -70, 1, 0)
    adTitle.Position = UDim2.new(0, 40, 0, 0)
    adTitle.BackgroundTransparency = 1
    adTitle.Text = "Updates!"
    adTitle.TextColor3 = COR_VERDE
    adTitle.TextSize = 13
    adTitle.Font = Enum.Font.GothamBold
    adTitle.TextXAlignment = Enum.TextXAlignment.Left
    adTitle.ZIndex = 3

    local adClose = Instance.new("TextButton", adHeader)
    adClose.Size = UDim2.new(0, 24, 0, 24)
    adClose.Position = UDim2.new(1, -32, 0.5, -12)
    adClose.BackgroundTransparency = 1
    adClose.Text = "✕"
    adClose.TextColor3 = COR_TEXTO_CINZA
    adClose.TextSize = 14
    adClose.Font = Enum.Font.GothamBold
    adClose.AutoButtonColor = false
    adClose.ZIndex = 3

    adClose.MouseEnter:Connect(function() adClose.TextColor3 = COR_VERMELHO end)
    adClose.MouseLeave:Connect(function() adClose.TextColor3 = COR_TEXTO_CINZA end)

    local adText = Instance.new("TextLabel", anuncio)
    adText.Size = UDim2.new(1, -20, 1, -80)
    adText.Position = UDim2.new(0, 10, 0, 48)
    adText.BackgroundTransparency = 1
    adText.Text = "🎉 Bem-vindo ao Rd4X Hub!\n\nEste hub foi lançado a pouco tempo e já está com diversas funções!... Mas, essa é a primeira versão de muitas, por isso, se achar bugs/falhas nos conte no Discord!\n\nPara Desativar a Música de Fundo, vá até a Aba Config-Música de Fundo."
    adText.TextColor3 = COR_TEXTO
    adText.TextSize = 11
    adText.Font = Enum.Font.Gotham
    adText.TextXAlignment = Enum.TextXAlignment.Left
    adText.TextYAlignment = Enum.TextYAlignment.Top
    adText.TextWrapped = true
    adText.ZIndex = 3

    local adOk = Instance.new("TextButton", anuncio)
    adOk.Size = UDim2.new(1, -20, 0, 32)
    adOk.Position = UDim2.new(0, 10, 1, -42)
    adOk.BackgroundColor3 = COR_VERDE
    adOk.BackgroundTransparency = 0
    adOk.BorderSizePixel = 0
    adOk.Text = "Entendi!"
    adOk.TextColor3 = Color3.fromRGB(255, 255, 255)
    adOk.TextSize = 12
    adOk.Font = Enum.Font.GothamBold
    adOk.AutoButtonColor = false
    adOk.ZIndex = 3
    local cOk = Instance.new("UICorner", adOk)
    cOk.CornerRadius = UDim.new(0, 6)

    local function fecharAd()
        adAberto = false
        TweenService:Create(anuncio, TweenInfo.new(0.3), {
            Size = UDim2.new(0, 0, 0, 0),
            Position = UDim2.new(0.5, 0, 0.5, 0),
            BackgroundTransparency = 1
        }):Play()
        for _, obj in ipairs(anuncio:GetDescendants()) do
            pcall(function()
                if obj:IsA("TextLabel") or obj:IsA("TextButton") then
                    TweenService:Create(obj, TweenInfo.new(0.3), {TextTransparency = 1}):Play()
                elseif obj:IsA("Frame") then
                    TweenService:Create(obj, TweenInfo.new(0.3), {BackgroundTransparency = 1}):Play()
                elseif obj:IsA("UIStroke") then
                    TweenService:Create(obj, TweenInfo.new(0.3), {Transparency = 1}):Play()
                end
            end)
        end
        task.wait(0.35)
        AdGui:Destroy()
    end

    adClose.MouseButton1Click:Connect(fecharAd)
    adOk.MouseButton1Click:Connect(fecharAd)

    TweenService:Create(anuncio, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Size = UDim2.new(0, 340, 0, 220),
        Position = UDim2.new(0.5, -170, 0.5, -110)
    }):Play()
end)

Notify("RD4X Hub", "Interface carregada com sucesso!", 4)

--------------------------------------------------------------------------------
-- MÚSICA DE FUNDO
--------------------------------------------------------------------------------
_G.RD4X_MusicaFundo = Instance.new("Sound", SoundService)
_G.RD4X_MusicaFundo.SoundId = "rbxassetid://"
_G.RD4X_MusicaFundo.Volume = 0.15
_G.RD4X_MusicaFundo.Looped = true
_G.RD4X_MusicaFundo:Play()

UI.Button(Tabs.Outros, {
    Name = "🎵 Play/Pause Música",
    Description = "Liga ou desliga a música de fundo",
    Callback = function()
        if _G.RD4X_MusicaFundo.IsPlaying then
            _G.RD4X_MusicaFundo:Pause()
            Notify("Música", "Música pausada", 2)
        else
            _G.RD4X_MusicaFundo:Resume()
            Notify("Música", "Música tocando", 2)
        end
    end
})

--------------------------------------------------------------------------------
-- EFEITO DE CONFETE (definido, mantido igual ao original)
--------------------------------------------------------------------------------
local function soltarConfete()
    local cores = {
        Color3.fromRGB(46, 204, 113),
        Color3.fromRGB(52, 152, 219),
        Color3.fromRGB(241, 196, 15),
        Color3.fromRGB(231, 76, 60),
        Color3.fromRGB(155, 89, 182),
    }
    for i = 1, 30 do
        task.spawn(function()
            local p = Instance.new("Frame", ScreenGui)
            p.Size = UDim2.new(0, 8, 0, 8)
            p.Position = UDim2.new(math.random(), 0, 0, -20)
            p.BackgroundColor3 = cores[math.random(1, #cores)]
            p.BorderSizePixel = 0
            p.ZIndex = 9998
            local c = Instance.new("UICorner", p)
            c.CornerRadius = UDim.new(1, 0)
            local duracao = math.random(15, 25) / 10
            TweenService:Create(p, TweenInfo.new(duracao, Enum.EasingStyle.Linear), {
                Position = UDim2.new(p.Position.X.Scale, 0, 1.2, 0),
                Rotation = math.random(-360, 360)
            }):Play()
            task.delay(duracao, function() p:Destroy() end)
        end)
        task.wait(0.03)
    end
end
_G.RD4X_SoltarConfete = soltarConfete

--------------------------------------------------------------------------------
-- BIO WELCOME
--------------------------------------------------------------------------------
UI.Button(Tabs.Player, {
    Name = "📝 Aplicar Bio (Welcome)",
    Description = "Aplica a bio automática",
    Callback = function()
        local textoBio = "Welcome, " .. LocalPlayer.Name
        pcall(function()
            local remote = game:GetService("ReplicatedStorage").RE["1RPNam1eTex1t"]
            if remote then
                remote:FireServer("RolePlayBio", textoBio)
                Notify("Bio", "Alterada: " .. textoBio, 3)
            end
        end)
    end
})

task.spawn(function()
    task.wait(2)
    local RE = ReplicatedStorage:FindFirstChild("RE")
    local RPNameText = RE and RE:FindFirstChild("1RPNam1eTex1t")
    if not RPNameText then
        task.wait(2)
        RE = ReplicatedStorage:FindFirstChild("RE")
        RPNameText = RE and RE:FindFirstChild("1RPNam1eTex1t")
    end
    if RPNameText then
        local textoBio = "Welcome, " .. LocalPlayer.Name
        pcall(function() RPNameText:FireServer("RolePlayBio", textoBio) end)
    end
end)
--[[
--------------------------------------------------------------------------------
-- SEGUNDO MENU VIP/ADMIN
--------------------------------------------------------------------------------
if UsuarioAutorizado or _G.RD4X_Autorizado == nil then
    -- por padrão habilitado (whitelist comentada). Ajuste se quiser validar.
    local MEU_ID_CREATOR = 4200878493
    local API_URL = "https://rd4x-api.onrender.com"

    local oldVIPGui = CoreGui:FindFirstChild("Rd4XHubVIP")
    if oldVIPGui then oldVIPGui:Destroy() end

    local ScreenGuiVIP = Instance.new("ScreenGui")
    ScreenGuiVIP.Name = "Rd4XHubVIP"
    ScreenGuiVIP.ResetOnSpawn = false
    ScreenGuiVIP.DisplayOrder = 1000
    ScreenGuiVIP.Parent = CoreGui

    local MainFrameVIP = Instance.new("Frame", ScreenGuiVIP)
    MainFrameVIP.Name = "MainFrameVIP"
    MainFrameVIP.Size = UDim2.new(0, 480, 0, 340)
    MainFrameVIP.Position = UDim2.new(0.5, -240, 0.5, -170)
    MainFrameVIP.BackgroundColor3 = COR_FUNDO
    MainFrameVIP.BackgroundTransparency = TRANSP_FUNDO
    MainFrameVIP.BorderSizePixel = 0
    MainFrameVIP.ClipsDescendants = true
    MainFrameVIP.ZIndex = 1
    MainFrameVIP.Visible = false
    MainFrameVIP.Active = false

    local cornerVIP = Instance.new("UICorner", MainFrameVIP)
    cornerVIP.CornerRadius = UDim.new(0, 10)

    local BolhasVIP = Instance.new("Frame", MainFrameVIP)
    BolhasVIP.Name = "BolhasVIP"
    BolhasVIP.Size = UDim2.new(1, 0, 1, 0)
    BolhasVIP.BackgroundTransparency = 1
    BolhasVIP.ClipsDescendants = true
    BolhasVIP.ZIndex = 0
    BolhasVIP.Active = false

    task.spawn(function()
        while BolhasVIP.Parent do
            local tam = math.random(6, 14)
            local b = Instance.new("Frame", BolhasVIP)
            b.Size = UDim2.new(0, tam, 0, tam)
            b.Position = UDim2.new(math.random() * 0.95, 0, 1, 10)
            local cores = {
                Color3.fromRGB(46, 204, 113),
                Color3.fromRGB(52, 152, 219),
                Color3.fromRGB(155, 89, 182),
                Color3.fromRGB(241, 196, 15),
                Color3.fromRGB(231, 76, 60),
            }
            b.BackgroundColor3 = cores[math.random(1, #cores)]
            b.BackgroundTransparency = math.random(15, 40) / 100
            b.BorderSizePixel = 0
            b.ZIndex = 0
            local c = Instance.new("UICorner", b)
            c.CornerRadius = UDim.new(1, 0)
            local strokeB = Instance.new("UIStroke", b)
            strokeB.Color = Color3.fromRGB(255, 255, 255)
            strokeB.Thickness = 1.5
            strokeB.Transparency = 0.3
            local tween = TweenService:Create(b, TweenInfo.new(math.random(6, 12), Enum.EasingStyle.Linear), {
                Position = UDim2.new(b.Position.X.Scale, math.random(-60, 60), 0, -20),
                BackgroundTransparency = 1
            })
            tween:Play()
            tween.Completed:Connect(function() if b and b.Parent then b:Destroy() end end)
            task.wait(math.random(8, 30) / 100)
        end
    end)

    local HeaderVIP = Instance.new("Frame", MainFrameVIP)
    HeaderVIP.Size = UDim2.new(1, 0, 0, 38)
    HeaderVIP.BackgroundTransparency = 1
    HeaderVIP.ZIndex = 5

    local IconVIP = Instance.new("ImageLabel", HeaderVIP)
    IconVIP.Size = UDim2.new(0, 24, 0, 24)
    IconVIP.Position = UDim2.new(0, 10, 0, 7)
    IconVIP.BackgroundTransparency = 1
    IconVIP.Image = "rbxassetid://109276734890323"
    IconVIP.ScaleType = Enum.ScaleType.Crop
    IconVIP.ZIndex = 6
    local cIVIP = Instance.new("UICorner", IconVIP)
    cIVIP.CornerRadius = UDim.new(1, 0)

    local TitleVIP = Instance.new("TextLabel", HeaderVIP)
    TitleVIP.Size = UDim2.new(0, 300, 0, 38)
    TitleVIP.Position = UDim2.new(0, 34, 0, 0)
    TitleVIP.BackgroundTransparency = 1
    TitleVIP.Text = "🔒 Rd4X Hub VIP $ 「 Exclusivo 」"
    TitleVIP.TextColor3 = COR_VERDE
    TitleVIP.TextSize = 11
    TitleVIP.Font = Enum.Font.GothamBold
    TitleVIP.TextXAlignment = Enum.TextXAlignment.Left
    TitleVIP.ZIndex = 6

    local BadgeVIP = Instance.new("TextLabel", HeaderVIP)
    BadgeVIP.Size = UDim2.new(0, 60, 0, 38)
    BadgeVIP.Position = UDim2.new(1, -90, 0, 0)
    BadgeVIP.BackgroundTransparency = 1
    BadgeVIP.Text = "⭐ VIP"
    BadgeVIP.TextColor3 = COR_VERDE
    BadgeVIP.TextSize = 10
    BadgeVIP.Font = Enum.Font.GothamBold
    BadgeVIP.TextXAlignment = Enum.TextXAlignment.Right
    BadgeVIP.ZIndex = 6

    local MinimizeVIP = Instance.new("TextButton", HeaderVIP)
    MinimizeVIP.Size = UDim2.new(0, 20, 0, 20)
    MinimizeVIP.Position = UDim2.new(1, -26, 0, 9)
    MinimizeVIP.BackgroundTransparency = 1
    MinimizeVIP.Text = "—"
    MinimizeVIP.TextColor3 = COR_TEXTO_CINZA
    MinimizeVIP.TextSize = 14
    MinimizeVIP.Font = Enum.Font.GothamBold
    MinimizeVIP.ZIndex = 6
    MinimizeVIP.AutoButtonColor = false

    MinimizeVIP.MouseEnter:Connect(function() MinimizeVIP.TextColor3 = COR_TEXTO end)
    MinimizeVIP.MouseLeave:Connect(function() MinimizeVIP.TextColor3 = COR_TEXTO_CINZA end)

    local SidebarVIP = Instance.new("ScrollingFrame", MainFrameVIP)
    SidebarVIP.Size = UDim2.new(0, 130, 1, -38)
    SidebarVIP.Position = UDim2.new(0, 0, 0, 38)
    SidebarVIP.BackgroundColor3 = COR_SIDEBAR
    SidebarVIP.BackgroundTransparency = TRANSP_SIDEBAR
    SidebarVIP.BorderSizePixel = 0
    SidebarVIP.ScrollBarThickness = 2
    SidebarVIP.CanvasSize = UDim2.new(0, 0, 0, 0)
    SidebarVIP.AutomaticCanvasSize = Enum.AutomaticSize.Y
    SidebarVIP.ZIndex = 5

    local layoutVIP = Instance.new("UIListLayout", SidebarVIP)
    layoutVIP.Padding = UDim.new(0, 3)
    layoutVIP.SortOrder = Enum.SortOrder.LayoutOrder

    local padVIP = Instance.new("UIPadding", SidebarVIP)
    padVIP.PaddingTop = UDim.new(0, 6)
    padVIP.PaddingBottom = UDim.new(0, 6)
    padVIP.PaddingLeft = UDim.new(0, 6)
    padVIP.PaddingRight = UDim.new(0, 6)

    local TabFramesVIP = {}
    local TabButtonsVIP = {}

    local function ShowTabVIP(name)
        for n, f in pairs(TabFramesVIP) do f.Visible = (n == name) end
        for n, b in pairs(TabButtonsVIP) do
            if n == name then
                b.BackgroundTransparency = TRANSP_CARDS
                b.TextColor3 = COR_TEXTO
            else
                b.BackgroundTransparency = 1
                b.TextColor3 = COR_TEXTO_CINZA
            end
        end
    end

    local function CreateTabVIP(name)
        local btn = Instance.new("TextButton", SidebarVIP)
        btn.Size = UDim2.new(1, 0, 0, 26)
        btn.BackgroundColor3 = COR_SECUNDARIA
        btn.BackgroundTransparency = 1
        btn.BorderSizePixel = 0
        btn.Text = "   " .. name
        btn.TextColor3 = COR_TEXTO_CINZA
        btn.TextSize = 10
        btn.Font = Enum.Font.GothamMedium
        btn.TextXAlignment = Enum.TextXAlignment.Left
        btn.AutoButtonColor = false
        btn.ZIndex = 6
        local c = Instance.new("UICorner", btn)
        c.CornerRadius = UDim.new(0, 6)

        local content = Instance.new("ScrollingFrame", MainFrameVIP)
        content.Size = UDim2.new(1, -142, 1, -50)
        content.Position = UDim2.new(0, 136, 0, 44)
        content.BackgroundTransparency = 1
        content.BorderSizePixel = 0
        content.ScrollBarThickness = 3
        content.ScrollBarImageColor3 = COR_BORDA
        content.CanvasSize = UDim2.new(0, 0, 0, 0)
        content.AutomaticCanvasSize = Enum.AutomaticSize.Y
        content.Visible = false
        content.ZIndex = 5

        local layout = Instance.new("UIListLayout", content)
        layout.Padding = UDim.new(0, 6)
        layout.SortOrder = Enum.SortOrder.LayoutOrder

        TabFramesVIP[name] = content
        TabButtonsVIP[name] = btn

        btn.MouseButton1Click:Connect(function() ShowTabVIP(name) end)
        return content
    end

    local TabsVIP = {
        Admin = CreateTabVIP("👑 Admin"),
        VIP = CreateTabVIP("VIP"),
        Jumpscare = CreateTabVIP("Jumpscare"),
    }
    ShowTabVIP("👑 Admin")

    local dragVIP = false
    local startVIP = nil
    local posVIP = nil

    MainFrameVIP.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragVIP = true
            startVIP = input.Position
            posVIP = MainFrameVIP.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then dragVIP = false end
            end)
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if dragVIP and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - startVIP
            MainFrameVIP.Position = UDim2.new(posVIP.X.Scale, posVIP.X.Offset + delta.X, posVIP.Y.Scale, posVIP.Y.Offset + delta.Y)
        end
    end)

    local vipMinimizado = false
    local alturaVIPNormal = 340
    local alturaVIPMinimizada = 38

    MinimizeVIP.MouseButton1Click:Connect(function()
        vipMinimizado = not vipMinimizado
        if vipMinimizado then
            TweenService:Create(MainFrameVIP, TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                Size = UDim2.new(0, 480, 0, alturaVIPMinimizada)
            }):Play()
            SidebarVIP.Visible = false
            for _, c in pairs(TabFramesVIP) do c.Visible = false end
            MinimizeVIP.Text = "▢"
            MinimizeVIP.TextColor3 = COR_VERDE
        else
            TweenService:Create(MainFrameVIP, TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                Size = UDim2.new(0, 480, 0, alturaVIPNormal)
            }):Play()
            task.wait(0.35)
            SidebarVIP.Visible = true
            for n, c in pairs(TabFramesVIP) do
                if TabButtonsVIP[n].TextColor3 == COR_TEXTO then c.Visible = true end
            end
            MinimizeVIP.Text = "—"
            MinimizeVIP.TextColor3 = COR_TEXTO_CINZA
        end
    end)

    local AlvoSelecionado = LocalPlayer.Name
    local JaulaModelo = nil
    local conexaoSpam = nil

    local function obterUsuariosDoHub()
        local lista = {}
        for _, p in ipairs(Players:GetPlayers()) do
            if p.UserId == MEU_ID_CREATOR then
                table.insert(lista, p.Name)
            else
                local ok, res = pcall(function()
                    local r = game:HttpGet(API_URL .. "/api/v2/whitelist?nick=" .. tostring(p.Name))
                    return HttpService:JSONDecode(r)
                end)
                if ok and res and (res.success == true or res.whitelisted == true) then
                    table.insert(lista, p.Name)
                end
            end
        end
        if #lista == 0 then table.insert(lista, LocalPlayer.Name) end
        return lista
    end

    local DropdownAdmin = UI.Dropdown(TabsVIP.Admin, {
        Name = "Lista de Usuários do Hub",
        Options = obterUsuariosDoHub(),
        CurrentOption = {LocalPlayer.Name},
        Callback = function(Option) AlvoSelecionado = Option[1] end,
    })

    UI.Button(TabsVIP.Admin, { Name = "🔄 Atualizar Hub (Lista)", Description = "Atualiza a lista de usuários", Callback = function()
        DropdownAdmin:Refresh(obterUsuariosDoHub())
        Notify("Admin", "Lista atualizada!", 3)
    end})

    local cameraOriginalCFrame = nil
    UI.Button(TabsVIP.Admin, { Name = "Cam (ver câmera)", Description = "Espia o jogador selecionado", Callback = function()
        local alvo = Players:FindFirstChild(AlvoSelecionado)
        if alvo and alvo.Character and alvo.Character:FindFirstChild("Head") then
            cameraOriginalCFrame = Camera.CFrame
            Camera.CameraSubject = alvo.Character.Humanoid
            Notify("Admin", "Assistindo " .. alvo.Name, 2)
        end
    end})
    UI.Button(TabsVIP.Admin, { Name = "Voltar Cam", Description = "Volta a câmera para você", Callback = function()
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            Camera.CameraSubject = LocalPlayer.Character.Humanoid
            if cameraOriginalCFrame then Camera.CFrame = cameraOriginalCFrame end
            Notify("Admin", "Câmera restaurada.", 2)
        end
    end})
    UI.Button(TabsVIP.Admin, { Name = "Kick", Description = "Expulsa o jogador do servidor", Callback = function()
        local alvo = Players:FindFirstChild(AlvoSelecionado)
        if alvo == LocalPlayer then LocalPlayer:Kick("Kickado") end
        Notify("Admin", "Kick enviado.", 2)
    end})
    UI.Button(TabsVIP.Admin, { Name = "Kill", Description = "Mata o jogador", Callback = function()
        local alvo = Players:FindFirstChild(AlvoSelecionado)
        if alvo and alvo.Character and alvo.Character:FindFirstChild("Humanoid") then
            alvo.Character.Humanoid.Health = 0
            Notify("Admin", "Kill executado.", 2)
        end
    end})
    UI.Button(TabsVIP.Admin, { Name = "Freeze", Description = "Congela o jogador", Callback = function()
        local alvo = Players:FindFirstChild(AlvoSelecionado)
        if alvo and alvo.Character and alvo.Character:FindFirstChild("HumanoidRootPart") then
            alvo.Character.HumanoidRootPart.Anchored = true
            Notify("Admin", "Congelado.", 2)
        end
    end})
    UI.Button(TabsVIP.Admin, { Name = "Unfreeze", Description = "Descongela o jogador", Callback = function()
        local alvo = Players:FindFirstChild(AlvoSelecionado)
        if alvo and alvo.Character and alvo.Character:FindFirstChild("HumanoidRootPart") then
            alvo.Character.HumanoidRootPart.Anchored = false
            Notify("Admin", "Descongelado.", 2)
        end
    end})
    UI.Button(TabsVIP.Admin, { Name = "Jail", Description = "Prende o jogador em uma jaula", Callback = function()
        local alvo = Players:FindFirstChild(AlvoSelecionado)
        if alvo and alvo.Character and alvo.Character:FindFirstChild("HumanoidRootPart") then
            if JaulaModelo then JaulaModelo:Destroy() end
            JaulaModelo = Instance.new("Model", Workspace)
            JaulaModelo.Name = "RD4X_JailBox"
            local pos = alvo.Character.HumanoidRootPart.Position
            local function criarParede(tam, pst)
                local p = Instance.new("Part", JaulaModelo)
                p.Size = tam; p.Position = pst; p.Anchored = true
                p.CanCollide = true; p.Transparency = 0.4; p.Color = COR_VERMELHO
            end
            criarParede(Vector3.new(8, 1, 8), pos + Vector3.new(0, -4, 0))
            criarParede(Vector3.new(8, 1, 8), pos + Vector3.new(0, 4, 0))
            criarParede(Vector3.new(8, 8, 1), pos + Vector3.new(0, 0, -4))
            criarParede(Vector3.new(8, 8, 1), pos + Vector3.new(0, 0, 4))
            criarParede(Vector3.new(1, 8, 8), pos + Vector3.new(-4, 0, 0))
            criarParede(Vector3.new(1, 8, 8), pos + Vector3.new(4, 0, 0))
            Notify("Admin", "Jaula aplicada!", 2)
        end
    end})
    UI.Button(TabsVIP.Admin, { Name = "UnJail", Description = "Remove a jaula", Callback = function()
        if JaulaModelo then JaulaModelo:Destroy(); JaulaModelo = nil end
        Notify("Admin", "Jaula removida!", 2)
    end})
    UI.Button(TabsVIP.Admin, { Name = "Bring", Description = "Traz o jogador até você", Callback = function()
        local alvo = Players:FindFirstChild(AlvoSelecionado)
        if alvo and alvo.Character and alvo.Character:FindFirstChild("HumanoidRootPart") and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            alvo.Character.HumanoidRootPart.CFrame = LocalPlayer.Character.HumanoidRootPart.CFrame + Vector3.new(0, 3, 0)
            Notify("Admin", "Jogador trazido.", 2)
        end
    end})
    UI.Button(TabsVIP.Admin, { Name = "Teleport", Description = "Vai até o jogador", Callback = function()
        local alvo = Players:FindFirstChild(AlvoSelecionado)
        if alvo and alvo.Character and alvo.Character:FindFirstChild("HumanoidRootPart") and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            LocalPlayer.Character.HumanoidRootPart.CFrame = alvo.Character.HumanoidRootPart.CFrame + Vector3.new(0, 3, 0)
            Notify("Admin", "Teleportado.", 2)
        end
    end})
    UI.Button(TabsVIP.Admin, { Name = "Fling", Description = "Arremessa o jogador", Callback = function()
        local alvo = Players:FindFirstChild(AlvoSelecionado)
        if alvo and alvo.Character and alvo.Character:FindFirstChild("HumanoidRootPart") then
            alvo.Character.HumanoidRootPart.AssemblyLinearVelocity = Vector3.new(99999, 99999, 99999)
            Notify("Admin", "Fling aplicado!", 2)
        end
    end})
    UI.Button(TabsVIP.Admin, { Name = "Spam", Description = "Ativa o spam de chat", Callback = function()
        if conexaoSpam then task.cancel(conexaoSpam) end
        conexaoSpam = task.spawn(function()
            while true do
                pcall(function()
                    local targs = ReplicatedStorage:FindFirstChild("DefaultChatSystemChatEvents")
                    if targs then
                        local say = targs:FindFirstChild("SayMessageRequest")
                        if say then say:FireServer("RD4X HAHAHA", "All") end
                    end
                end)
                task.wait(1)
            end
        end)
        Notify("Admin", "Spam ativado!", 2)
    end})
    UI.Button(TabsVIP.Admin, { Name = "UnSpam", Description = "Desativa o spam de chat", Callback = function()
        if conexaoSpam then task.cancel(conexaoSpam); conexaoSpam = nil end
        Notify("Admin", "Spam desativado.", 2)
    end})

    -- JUMPSCARE
    local LISTA_JUMPSCARES = {
        ["Jumpscare 1"] = { imagem = "rbxassetid://83706098778583", som = "rbxassetid://130586258888902" },
        ["😱 Jumpscare 2"] = { imagem = "rbxassetid://125557150437761", som = "rbxassetid://133973334152130" },
        ["Jumpscare 3"] = { imagem = "rbxassetid://117625655704744", som = "rbxassetid://140558918020400" },
        ["🔴 Jumpscare 4"] = { imagem = "rbxassetid://106883295632038", som = "rbxassetid://130586258888902" },
        ["🔴 Jumpscare 5"] = { imagem = "rbxassetid://105916553275189", som = "rbxassetid://140558918020400" },
    }
    local function obterNomesJumpscare()
        local nomes = {}
        for nome, _ in pairs(LISTA_JUMPSCARES) do table.insert(nomes, nome) end
        table.sort(nomes)
        return nomes
    end
    local function executarJumpscare(nomeAlvo, nomeJumpscare)
        local alvo = Players:FindFirstChild(nomeAlvo)
        if not alvo then Notify("Jumpscare", "Alvo não encontrado!", 2); return end
        local pg = alvo:FindFirstChild("PlayerGui")
        if not pg then return end
        local dados = LISTA_JUMPSCARES[nomeJumpscare]
        if not dados then Notify("Jumpscare", "Jumpscare inválido!", 2); return end
        pcall(function()
            local som = Instance.new("Sound", SoundService)
            som.SoundId = dados.som; som.Volume = 5; som:Play()
            task.delay(3, function() som:Destroy() end)
        end)
        local sgJump = Instance.new("ScreenGui", pg)
        sgJump.Name = "RD4X_JumpScare"; sgJump.IgnoreGuiInset = true; sgJump.DisplayOrder = 99999
        local flash = Instance.new("Frame", sgJump)
        flash.Size = UDim2.new(1, 0, 1, 0)
        flash.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
        flash.BackgroundTransparency = 0; flash.BorderSizePixel = 0
        local cara = Instance.new("ImageLabel", sgJump)
        cara.Size = UDim2.new(0.3, 0, 0.3, 0)
        cara.Position = UDim2.new(0.35, 0, 0.35, 0)
        cara.BackgroundTransparency = 1; cara.Image = dados.imagem
        cara.ScaleType = Enum.ScaleType.Fit; cara.ImageTransparency = 0
        task.spawn(function()
            TweenService:Create(cara, TweenInfo.new(0.15, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {
                Size = UDim2.new(1.5, 0, 1.5, 0), Position = UDim2.new(-0.25, 0, -0.25, 0)
            }):Play()
            local blur = Instance.new("BlurEffect", Lighting)
            blur.Size = 0
            TweenService:Create(blur, TweenInfo.new(0.1), {Size = 24}):Play()
            for i = 1, 6 do
                TweenService:Create(flash, TweenInfo.new(0.05), {BackgroundTransparency = 0}):Play()
                task.wait(0.05)
                TweenService:Create(flash, TweenInfo.new(0.05), {BackgroundTransparency = 0.6}):Play()
                task.wait(0.05)
            end
            if alvo.Character and alvo.Character:FindFirstChild("HumanoidRootPart") then
                local hrp = alvo.Character.HumanoidRootPart
                local offsetOriginal = hrp.CFrame
                task.spawn(function()
                    for i = 1, 10 do
                        hrp.CFrame = offsetOriginal * CFrame.new(math.random(-30, 30) / 100, math.random(-30, 30) / 100, 0)
                        task.wait(0.02)
                    end
                    hrp.CFrame = offsetOriginal
                end)
            end
            task.wait(2.5)
            TweenService:Create(cara, TweenInfo.new(0.3), {ImageTransparency = 1}):Play()
            TweenService:Create(blur, TweenInfo.new(0.3), {Size = 0}):Play()
            TweenService:Create(flash, TweenInfo.new(0.3), {BackgroundTransparency = 1}):Play()
            task.wait(0.4); blur:Destroy(); sgJump:Destroy()
        end)
    end

    UI.Paragraph(TabsVIP.Jumpscare, { Title = "😱 Sistema de Jumpscare", Content = "Escolha um jumpscare da lista e envie pro alvo.", Height = 42 })
    local jumpscareSelecionado = nil
    local nomesJumpscare = obterNomesJumpscare()
    if #nomesJumpscare > 0 then jumpscareSelecionado = nomesJumpscare[1] end
    UI.Dropdown(TabsVIP.Jumpscare, {
        Name = "😱 Escolha o Jumpscare",
        Options = nomesJumpscare,
        CurrentOption = {jumpscareSelecionado or "Nenhum"},
        Callback = function(opt) if opt and opt[1] then jumpscareSelecionado = opt[1] end end,
    })
    UI.Button(TabsVIP.Jumpscare, { Name = "😱 Ativar Jumpscare no Alvo", Description = "Assusta o jogador selecionado", Callback = function()
        if not AlvoSelecionado then Notify("Jumpscare", "Selecione um alvo na aba Admin!", 2); return end
        if not jumpscareSelecionado then Notify("Jumpscare", "Escolha um jumpscare!", 2); return end
        executarJumpscare(AlvoSelecionado, jumpscareSelecionado)
        Notify("😱 Jumpscare", "Susto em " .. AlvoSelecionado, 3)
    end})
    UI.Button(TabsVIP.Jumpscare, { Name = "😱 Jumpscare em TODOS os Jogadores", Description = "Assusta todos no servidor", Callback = function()
        if not jumpscareSelecionado then Notify("Jumpscare", "Escolha um jumpscare!", 2); return end
        local enviados = 0
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LocalPlayer then
                executarJumpscare(p.Name, jumpscareSelecionado)
                enviados = enviados + 1
                task.wait(0.3)
            end
        end
        Notify("😱 Jumpscare", "Susto em " .. enviados .. " jogadores!", 3)
    end})

    task.spawn(function()
        while not _G.RD4X_Loading_Completo do task.wait(0.1) end
        task.wait(0.3)
        MainFrameVIP.Visible = true
        MainFrameVIP.Size = UDim2.new(0, 0, 0, 0)
        MainFrameVIP.Position = UDim2.new(0.5, 0, 0.5, 0)
        MainFrameVIP.BackgroundTransparency = 1
        TweenService:Create(MainFrameVIP, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
            Size = UDim2.new(0, 480, 0, 340),
            Position = UDim2.new(0.5, -240, 0.5, -170),
            BackgroundTransparency = TRANSP_FUNDO
        }):Play()
    end)
end

print("[RD4X] ✅ Parte 4/4 carregada.")
--]]
-- ==========================================================
-- 🏷️ SISTEMA DE ASSINATURA (NAME TAGS DO HUB)
-- ==========================================================
local tagsAtivas = false

local function criarTag(player)
    local head = player.Character and player.Character:FindFirstChild("Head")
    if not head then return end

    -- Se já existe a tag, não cria outra
    if head:FindFirstChild("RD4X_NameTag") then return end

    -- 🎨 Cria a Tag Base (BillboardGui)
    local bg = Instance.new("BillboardGui")
    bg.Name = "RD4X_NameTag"
    bg.Size = UDim2.new(0, 160, 0, 32) -- Largura e altura da pílula
    bg.StudsOffset = Vector3.new(0, 2.5, 0) -- Fica um pouco acima da cabeça
    bg.AlwaysOnTop = true -- Aparece através das paredes
    bg.Parent = head

    -- Fundo da Tag (Pílula)
    local frame = Instance.new("Frame", bg)
    frame.Size = UDim2.new(1, 0, 1, 0)
    frame.BackgroundTransparency = 0.2 -- Efeito de vidro/neon
    frame.BorderSizePixel = 0

    -- Deixa totalmente arredondado (Pílula)
    local corner = Instance.new("UICorner", frame)
    corner.CornerRadius = UDim.new(1, 0)

    -- Borda (UIStroke)
    local stroke = Instance.new("UIStroke", frame)
    stroke.Thickness = 2
    stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

    -- Texto
    local text = Instance.new("TextLabel", frame)
    text.Size = UDim2.new(1, 0, 1, 0)
    text.BackgroundTransparency = 1
    text.Font = Enum.Font.GothamBold
    text.TextSize = 12
    text.TextColor3 = Color3.fromRGB(255, 255, 255) -- Branco para dar leitura

    -- 🎨 Lógica de Cores (Criador vs Usuário Normal)
    if player.UserId == 4200878493 then
        -- 👑 SEU ID: Preto/Cinza claro dentro, Preto puro na borda
        frame.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
        stroke.Color = Color3.fromRGB(0, 0, 0)
        text.Text = "👑 Rd4X Owner"
    else
        -- 👤 USUÁRIO NORMAL: Vermelho claro dentro, Vermelho escuro na borda
        frame.BackgroundColor3 = Color3.fromRGB(255, 90, 90)
        stroke.Color = Color3.fromRGB(120, 0, 0)
        text.Text = "🇧🇷 Rd4X User"
    end
end

-- Função para limpar as tags se a pessoa desativar
local function limparTodasAsTags()
    for _, p in ipairs(Players:GetPlayers()) do
        if p.Character and p.Character:FindFirstChild("Head") then
            local tag = p.Character.Head:FindFirstChild("RD4X_NameTag")
            if tag then tag:Destroy() end
        end
    end
end

-- 🎛️ BOTÃO NA ABA PLAYER
UI.Toggle(Tabs.Player, {
    Name = "🏷️ Assinatura Rd4X (Ver Tags)",
    CurrentValue = false,
    Callback = function(state)
        tagsAtivas = state
        
        if tagsAtivas then
            Notify("Tags", "Assinaturas ativadas! Você agora vê quem usa o hub.", 3)
            
            -- Loop para manter as tags atualizadas
            task.spawn(function()
                while tagsAtivas do
                    for _, p in ipairs(Players:GetPlayers()) do
                        if p.Character and p.Character:FindFirstChild("Head") then
                            criarTag(p)
                        end
                    end
                    task.wait(2) -- Atualiza a cada 2 segundos (caso alguém entre no jogo)
                end
            end)
        else
            -- Se desativar, remove todas as tags da tela
            limparTodasAsTags()
            Notify("Tags", "Assinaturas desativadas!", 2)
        end
    end
})

-- 🔄 Sistema para recriar a tag se o jogador morrer e der respawn
LocalPlayer.CharacterAdded:Connect(function(char)
    task.wait(1.5)
    if tagsAtivas then
        for _, p in ipairs(Players:GetPlayers()) do
            if p.Character and p.Character:FindFirstChild("Head") then
                criarTag(p)
            end
        end
    end
end)

-- 🔄 Sistema para criar a tag em jogadores que entrarem no servidor depois de você
Players.PlayerAdded:Connect(function(novoPlayer)
    novoPlayer.CharacterAdded:Connect(function(char)
        task.wait(1.5)
        if tagsAtivas then
            criarTag(novoPlayer)
        end
    end)
end)
