-- ==========================================================
-- 🇧🇷 RD4X HUB - PARTE 3/4 (MÚSICAS + TROLL)
-- ⚠️ Execute a Parte 1 antes
-- ==========================================================

if not _G.RD4X_UI then error("[RD4X] Execute a Parte 1/4 primeiro!") end

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

local UI        = _G.RD4X_UI
local Notify    = _G.RD4X_Notify
local Tabs      = _G.RD4X_Tabs

--------------------------------------------------------------------------------
-- MÚSICAS
--------------------------------------------------------------------------------
local PlayerToolEvent = nil
local function atualizarToolRemote()
    local RE = ReplicatedStorage:FindFirstChild("RE")
    PlayerToolEvent = RE and RE:FindFirstChild("PlayerToolEvent")
end
atualizarToolRemote()

local idMusicaCustom = ""
UI.Input(Tabs.Musicas, { Name = "Outro Audio ID", CurrentValue = "", PlaceholderText = "Ex: 9048375035", Callback = function(t) idMusicaCustom = t end })
UI.Button(Tabs.Musicas, {
    Name = "▶️ Tocar Audio ID Personalizado",
    Description = "Toca a música pelo ID inserido acima",
    Callback = function()
        atualizarToolRemote()
        if PlayerToolEvent and idMusicaCustom ~= "" then
            PlayerToolEvent:FireServer("ToolMusicText", idMusicaCustom)
            Notify("Música", "ID " .. idMusicaCustom .. " tocando!", 3)
        else
            Notify("Aviso", "Digite um ID primeiro", 2)
        end
    end
})

local LISTA_FUNK = {
    ["🔥 piranha"]               = "103811087853875",
    ["🔥 os menor"]              = "126719632721905",
    ["🔥 vai caindo com a bct"]  = "74967642581893",
    ["🔥 facada"]                = "81730477878065",
    ["🔥 Tipo nino"]             = "140336018782383",
    ["🔥 lacs"]                  = "121544291272731",
    ["🔥 Funk"]                  = "74206017407052",
    ["🔥 onda do birimbau"]      = "90728144562197",
    ["🔥 piseiro bahiano"]       = "111425053457342",
    ["🔥 cheiro"]                = "102430799050444",
    ["🔥 afrozada"]              = "116257708415048",
    ["🔥 sequência de papapey"]  = "127060465281063",
}
local LISTA_FORRO = {
    ["🪗 uma botadinha"]         = "84624301411909",
    ["🪗 eu me apaixonei"]       = "139414982330352",
    ["🪗 Pisada xl"]             = "70508008395270",
    ["🪗 notificação preferida"] = "90137280531474",
    ["🪗 só fé"]                 = "139128878060651",
    ["🪗 desça daí seu corno"]   = "1197388789221996",
}
local LISTA_PHONK = {
    ["🏎️ Phonk 1"]              = "COLE_O_ID_AQUI",
    ["🏎️ Phonk 2"]              = "COLE_O_ID_AQUI",
}

local function tocarMusicaPorNome(lista, nome)
    atualizarToolRemote()
    local id = lista[nome]
    if PlayerToolEvent and id and id ~= "COLE_O_ID_AQUI" then
        PlayerToolEvent:FireServer("ToolMusicText", id)
    end
end
local function obterNomes(lista)
    local nomes = {}
    for nome, _ in pairs(lista) do table.insert(nomes, nome) end
    table.sort(nomes)
    return nomes
end

UI.Dropdown(Tabs.Musicas, {
    Name = "🔥 Tocar Funk", Options = obterNomes(LISTA_FUNK),
    CurrentOption = {"Selecione um Funk..."},
    Callback = function(opt) if opt and opt[1] then tocarMusicaPorNome(LISTA_FUNK, opt[1]) end end
})
UI.Dropdown(Tabs.Musicas, {
    Name = "🪗 Tocar Forró", Options = obterNomes(LISTA_FORRO),
    CurrentOption = {"Selecione um Forró..."},
    Callback = function(opt) if opt and opt[1] then tocarMusicaPorNome(LISTA_FORRO, opt[1]) end end
})
UI.Dropdown(Tabs.Musicas, {
    Name = "🏎️ Tocar Phonk", Options = obterNomes(LISTA_PHONK),
    CurrentOption = {"Selecione um Phonk..."},
    Callback = function(opt) if opt and opt[1] then tocarMusicaPorNome(LISTA_PHONK, opt[1]) end end
})

--------------------------------------------------------------------------------
-- TROLL
--------------------------------------------------------------------------------
local alvoTrollSelecionado = LocalPlayer.Name
local function obterListaJogadoresTroll()
    local lista = {}
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer then table.insert(lista, p.Name) end
    end
    if #lista == 0 then table.insert(lista, LocalPlayer.Name) end
    return lista
end

UI.Paragraph(Tabs.Troll, {
    Title = "🎯 Select player",
    Content = "Escolha um jogador do servidor para aplicar as funções abaixo.",
    Height = 42
})

local dropdownAlvoTroll = UI.Dropdown(Tabs.Troll, {
    Name = "👤 Selecionar Vítima",
    Options = obterListaJogadoresTroll(),
    CurrentOption = {obterListaJogadoresTroll()[1]},
    Callback = function(opt)
        if opt and opt[1] then
            alvoTrollSelecionado = opt[1]
            Notify("Troll", "Alvo selecionado: " .. alvoTrollSelecionado, 2)
        end
    end,
})

UI.Button(Tabs.Troll, {
    Name = "🔄 Atualizar Lista",
    Description = "Atualiza a lista de jogadores",
    Callback = function()
        dropdownAlvoTroll:Refresh(obterListaJogadoresTroll())
        Notify("Troll", "Lista de jogadores atualizada!", 2)
    end,
})

-- BUS KILL
UI.Paragraph(Tabs.Troll, {
    Title = "🚌 Bus Void Kill",
    Content = "Mata o Alvo Usando um Ônibus. Após matar o player, você será teleportado para a praça.",
    Height = 42
})

local busAtivo = false

UI.Button(Tabs.Troll, {
    Name = "🌪️ Iniciar Bus Kill (Void Kill)",
    Description = "Mata o alvo usando um ônibus",
    Callback = function()
        if busAtivo then Notify("Troll", "Já tem um ônibus em perseguição!", 2); return end

        local RE = ReplicatedStorage:FindFirstChild("RE")
        local CarRemote = RE and RE:FindFirstChild("1Ca1r")
        if not CarRemote then Notify("Erro", "Tente Novamente!", 3); return end

        local alvo = Players:FindFirstChild(alvoTrollSelecionado)
        if not alvo or not alvo.Character then Notify("Troll", "Selecione uma vítima válida na lista!", 3); return end

        local rootAlvo = alvo.Character:FindFirstChild("HumanoidRootPart")
        local humanoidAlvo = alvo.Character:FindFirstChildOfClass("Humanoid")
        if not rootAlvo or not humanoidAlvo then Notify("Troll", "...!", 3); return end

        busAtivo = true
        CarRemote:FireServer("PickingCar", "SchoolBus")
        Notify("Bus Kill", "Gerando novo ônibus no servidor...", 3)

        task.spawn(function()
            local function encontrarNovoOnibus()
                local tInicio = tick()
                local ultimoOnibus = nil
                local ultimoSeat = nil
                while tick() - tInicio < 4 do
                    for _, obj in ipairs(workspace:GetDescendants()) do
                        if obj:IsA("Model") then
                            local nomeUpper = obj.Name:upper()
                            local playerUpper = LocalPlayer.Name:upper()
                            if (nomeUpper:find("BUS") or nomeUpper:find("SCHOOL") or nomeUpper:find(playerUpper)) then
                                local seat = obj:FindFirstChildOfClass("VehicleSeat") or obj:FindFirstChild("VehicleSeat", true)
                                if seat and seat.Position.Y > -50 then
                                    ultimoOnibus = obj
                                    ultimoSeat = seat
                                end
                            end
                        end
                    end
                    if ultimoOnibus and ultimoSeat then return ultimoOnibus, ultimoSeat end
                    task.wait(0.2)
                end
                return nil, nil
            end

            local onibus, seatMotorista = encontrarNovoOnibus()
            local myChar = LocalPlayer.Character
            local myHum = myChar and myChar:FindFirstChildOfClass("Humanoid")
            local myHrp = myChar and myChar:FindFirstChild("HumanoidRootPart")

            if onibus and seatMotorista and myHum then
                pcall(function() seatMotorista:Sit(myHum) end)
                task.wait(0.1)
                Notify("Bus Kill", "Perseguindo: " .. alvo.Name, 3)

                local girando = true
                local conexaoRender
                conexaoRender = RunService.RenderStepped:Connect(function()
                    if girando and rootAlvo and rootAlvo.Parent and onibus and onibus.Parent then
                        local tempo = tick() * 25
                        local rotX = math.rad(tempo * 50 % 360)
                        local rotY = math.rad(tempo * 80 % 360)
                        local rotZ = math.rad(tempo * 30 % 360)
                        local posicaoAlvo = rootAlvo.CFrame
                        onibus:PivotTo(posicaoAlvo * CFrame.Angles(rotX, rotY, rotZ))
                    else
                        if conexaoRender then conexaoRender:Disconnect() end
                    end
                end)

                local conexaoSentouBus
                conexaoSentouBus = humanoidAlvo.Seated:Connect(function(isSeated, seat)
                    if isSeated and seat and seat:IsDescendantOf(onibus) then
                        girando = false
                        if conexaoRender then conexaoRender:Disconnect() end
                        onibus:PivotTo(CFrame.new(rootAlvo.Position.X, -300, rootAlvo.Position.Z))
                        task.wait(0.2)
                        pcall(function()
                            if myHum then myHum.Sit = false end
                            if myHrp then myHrp.CFrame = CFrame.new(-26, 7, 1) end
                        end)
                        Notify("Bus Kill", " Você voltou para a superfície!", 3)
                        if conexaoSentouBus then conexaoSentouBus:Disconnect() end
                        busAtivo = false
                    end
                end)

                task.delay(30, function()
                    girando = false
                    busAtivo = false
                    if conexaoRender then conexaoRender:Disconnect() end
                    if conexaoSentouBus then conexaoSentouBus:Disconnect() end
                end)
            else
                Notify("Erro", "Falha ao gerar novo ônibus! Tente novamente.", 3)
                busAtivo = false
            end
        end)
    end,
})

UI.Button(Tabs.Troll, {
    Name = "⏹️ Parar Bus Fling 3D",
    Description = "Cancela o Bus Kill",
    Callback = function() busAtivo = false; Notify("Troll", "Bus Kill desativado!", 2) end,
})

-- HEAD SIT / DOG MODE
UI.Paragraph(Tabs.Troll, {
    Title = "Interaction",
    Content = "Interações.",
    Height = 42
})

local conexaoHeadSit = nil
UI.Toggle(Tabs.Troll, {
    Name = "Head Sit (Sentar na Cabeça do Alvo)",
    CurrentValue = false,
    Callback = function(state)
        if state then
            local alvo = Players:FindFirstChild(alvoTrollSelecionado)
            if not alvo or not alvo.Character then
                Notify("Troll", "Selecione uma vítima!", 2)
                return
            end
            Notify("Troll", "Sentado na cabeça de: " .. alvo.Name, 2)
            if conexaoHeadSit then conexaoHeadSit:Disconnect() end
            conexaoHeadSit = RunService.RenderStepped:Connect(function()
                pcall(function()
                    local meuChar = LocalPlayer.Character
                    local meuHrp = meuChar and meuChar:FindFirstChild("HumanoidRootPart")
                    local meuHum = meuChar and meuChar:FindFirstChildOfClass("Humanoid")
                    local cabecaAlvo = alvo.Character and alvo.Character:FindFirstChild("Head")
                    if meuHrp and meuHum and cabecaAlvo then
                        meuHum.Sit = true
                        meuHrp.CFrame = cabecaAlvo.CFrame * CFrame.new(0, 1.6, 0)
                    else
                        if conexaoHeadSit then conexaoHeadSit:Disconnect() end
                    end
                end)
            end)
        else
            if conexaoHeadSit then conexaoHeadSit:Disconnect(); conexaoHeadSit = nil end
            pcall(function()
                if LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
                    LocalPlayer.Character:FindFirstChildOfClass("Humanoid").Sit = false
                end
            end)
            Notify("Troll", "Saiu da cabeça do alvo", 2)
        end
    end
})

local conexaoAttach = nil
UI.Toggle(Tabs.Troll, {
    Name = "Mochila (Grudar nas Costas do Alvo)",
    CurrentValue = false,
    Callback = function(state)
        if state then
            local alvo = Players:FindFirstChild(alvoTrollSelecionado)
            if not alvo or not alvo.Character then
                Notify("Troll", "Selecione uma vítima válida!", 2)
                return
            end
            Notify("Troll", "Grudado nas costas de: " .. alvo.Name, 2)
            if conexaoAttach then conexaoAttach:Disconnect() end
            conexaoAttach = RunService.RenderStepped:Connect(function()
                pcall(function()
                    local meuHrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                    local hrpAlvo = alvo.Character and alvo.Character:FindFirstChild("HumanoidRootPart")
                    if meuHrp and hrpAlvo then
                        meuHrp.CFrame = hrpAlvo.CFrame * CFrame.new(0, 0, 1.5)
                    else
                        if conexaoAttach then conexaoAttach:Disconnect() end
                    end
                end)
            end)
        else
            if conexaoAttach then conexaoAttach:Disconnect(); conexaoAttach = nil end
            Notify("Troll", "Soltou do alvo", 2)
        end
    end
})

-- PROPS
local PROP_KILL_Y      = -300
local PROP_MOVE_SPEED  = 6
local PROP_MOVE_RANGE  = 3
local TEMPO_MAX_SIT    = 10
local PROP_TIPO        = "FurnitureBleachers"
local PROP_CATEGORIA   = "Furniture"
local alvoPropSelecionado = LocalPlayer.Name

local function obterListaProp()
    local lista = {}
    for _, p in ipairs(Players:GetPlayers()) do table.insert(lista, p.Name) end
    if #lista == 0 then table.insert(lista, LocalPlayer.Name) end
    return lista
end

local dropdownProp = UI.Dropdown(Tabs.Troll, {
    Name = "🎯 Alvo (Props)",
    Options = obterListaProp(),
    CurrentOption = {LocalPlayer.Name},
    Callback = function(opt) if opt and opt[1] then alvoPropSelecionado = opt[1] end end
})

UI.Button(Tabs.Troll, {
    Name = "🔄 Atualizar Lista (Props)",
    Description = "Atualiza a lista de jogadores",
    Callback = function()
        local novaLista = obterListaProp()
        dropdownProp:Refresh(novaLista)
        Notify("Props", "Lista atualizada!", 2)
    end,
})

local function pegarPropMaker()
    local RE = ReplicatedStorage:FindFirstChild("RE")
    if not RE then return nil end
    local char = LocalPlayer.Character
    local hum = char and char:FindFirstChild("Humanoid")
    if not char or not hum then return nil end
    local propMaker = char:FindFirstChild("PropMaker")
    if propMaker then return propMaker end
    local backpack = LocalPlayer:FindFirstChild("Backpack")
    propMaker = backpack and backpack:FindFirstChild("PropMaker")
    if not propMaker then
        local toolRemote = RE:FindFirstChild("1Too1l")
        if toolRemote then pcall(function() toolRemote:InvokeServer("PickingTools", "PropMaker") end) end
        task.wait(0.4)
        propMaker = char:FindFirstChild("PropMaker") or (backpack and backpack:FindFirstChild("PropMaker"))
    end
    if propMaker and propMaker.Parent ~= char then
        pcall(function() hum:EquipTool(propMaker) end)
        task.wait(0.3)
    end
    return char:FindFirstChild("PropMaker")
end

local function selecionarProp(nome, categoria)
    local RE = ReplicatedStorage:FindFirstChild("RE")
    if not RE then return end
    local clearRemote = RE:FindFirstChild("1Clea1rTool1s")
    if not clearRemote then return end
    task.wait(0.2)
    pcall(function() clearRemote:FireServer("OpenPropMenu") end)
    task.wait(0.3)
    pcall(function() clearRemote:FireServer("RequestingPropName", nome or PROP_TIPO, categoria or PROP_CATEGORIA) end)
    task.wait(0.3)
end

local function spawnarProp(posicao)
    local char = LocalPlayer.Character
    if not char then return false end
    local propMaker = char:FindFirstChild("PropMaker")
    if not propMaker then return false end
    local toolProp = propMaker:FindFirstChild("Tool_PropMake") or propMaker:FindFirstChildOfClass("RemoteEvent")
    local chao = Workspace:FindFirstChild("Model")
        and Workspace.Model:FindFirstChild("Street")
        and Workspace.Model.Street:FindFirstChild("Street")
        or Workspace
    if toolProp then pcall(function() toolProp:FireServer(chao, posicao) end) end
    pcall(function()
        local camera = Workspace.CurrentCamera
        local posTela, naTela = camera:WorldToViewportPoint(posicao)
        if naTela then
            local vu = game:GetService("VirtualUser")
            vu:CaptureController()
            vu:ClickButton1(Vector2.new(posTela.X, posTela.Y))
        end
    end)
    return true
end

local function encontrarMeusProps()
    local WorkspaceCom = Workspace:FindFirstChild("WorkspaceCom")
    if not WorkspaceCom then return {} end
    local props = {}
    local meuNome = LocalPlayer.Name
    for _, container in ipairs(WorkspaceCom:GetChildren()) do
        for _, prop in ipairs(container:GetChildren()) do
            if prop.Name:find(meuNome, 1, true) then
                if prop:FindFirstChild("SetCurrentCFrame") or prop:IsA("Model") then
                    table.insert(props, prop)
                end
            end
        end
    end
    return props
end

local function moverProp(prop, cf)
    if not prop or not prop.Parent then return end
    local remote = prop:FindFirstChild("SetCurrentCFrame")
    if remote then pcall(function() remote:InvokeServer(cf) end)
    elseif prop:IsA("Model") then pcall(function() prop:PivotTo(cf) end) end
end

local function deletarTodosProps()
    local RE = ReplicatedStorage:FindFirstChild("RE")
    if not RE then return end
    local clearRemote = RE:FindFirstChild("1Clea1rTool1s")
    if clearRemote then pcall(function() clearRemote:FireServer("ClearAllProps") end) end
end

local function executarKillProp(nomeAlvo)
    local alvo = Players:FindFirstChild(nomeAlvo)
    if not alvo or not alvo.Character then return false end
    local hum = alvo.Character:FindFirstChildOfClass("Humanoid")
    local hrp = alvo.Character:FindFirstChild("HumanoidRootPart")
    if not hum or not hrp then return false end
    local antes = #encontrarMeusProps()
    spawnarProp(hrp.Position)
    task.wait(0.5)
    local agora = encontrarMeusProps()
    local prop = agora[#agora]
    if not prop then
        Notify("Props", "Clique 1x no chão para liberar o Prop!", 3)
        local t0 = tick()
        while tick() - t0 < 6 do
            task.wait(0.3)
            agora = encontrarMeusProps()
            if #agora > antes then prop = agora[#agora]; break end
        end
    end
    if not prop then Notify("Props", "Prop não foi criado.", 2); return false end
    local sentou = false
    local tInicio = tick()
    local conexao
    conexao = RunService.Heartbeat:Connect(function()
        if sentou or (tick() - tInicio > TEMPO_MAX_SIT) then
            if conexao then conexao:Disconnect() end
            return
        end
        if not alvo.Character or not alvo.Character:FindFirstChild("HumanoidRootPart") then return end
        local hrpAtual = alvo.Character.HumanoidRootPart
        local t = tick() * PROP_MOVE_SPEED
        local offsetY = math.sin(t) * PROP_MOVE_RANGE
        local posPerseguicao = hrpAtual.Position + Vector3.new(0, offsetY, 0)
        moverProp(prop, CFrame.new(posPerseguicao))
        if hum.Sit then
            sentou = true
            if conexao then conexao:Disconnect() end
            task.wait(0.1)
            moverProp(prop, CFrame.new(hrpAtual.Position.X, PROP_KILL_Y, hrpAtual.Position.Z))
            task.wait(0.8)
            deletarTodosProps()
        end
    end)
    return true
end

local function executarBringProp(nomeAlvo)
    local alvo = Players:FindFirstChild(nomeAlvo)
    if not alvo or not alvo.Character then return false end
    local hum = alvo.Character:FindFirstChildOfClass("Humanoid")
    local hrp = alvo.Character:FindFirstChild("HumanoidRootPart")
    local meuHrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not hum or not hrp or not meuHrp then return false end
    local antes = #encontrarMeusProps()
    spawnarProp(meuHrp.Position + (meuHrp.CFrame.LookVector * 4))
    task.wait(0.5)
    local agora = encontrarMeusProps()
    local prop = agora[#agora]
    if not prop then
        Notify("Props", "Clique 1x no chão para liberar o Prop!", 3)
        local t0 = tick()
        while tick() - t0 < 6 do
            task.wait(0.3)
            agora = encontrarMeusProps()
            if #agora > antes then prop = agora[#agora]; break end
        end
    end
    if not prop then Notify("Props", "Prop não foi criado.", 2); return false end
    local sentou = false
    local tInicio = tick()
    local conexao
    conexao = RunService.Heartbeat:Connect(function()
        if sentou or (tick() - tInicio > TEMPO_MAX_SIT) then
            if conexao then conexao:Disconnect() end
            return
        end
        if not alvo.Character or not alvo.Character:FindFirstChild("HumanoidRootPart") then return end
        local hrpAtual = alvo.Character.HumanoidRootPart
        local t = tick() * PROP_MOVE_SPEED
        local offsetY = math.sin(t) * PROP_MOVE_RANGE
        moverProp(prop, CFrame.new(hrpAtual.Position + Vector3.new(0, offsetY, 0)))
        if hum.Sit then
            sentou = true
            if conexao then conexao:Disconnect() end
            task.wait(0.1)
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                moverProp(prop, LocalPlayer.Character.HumanoidRootPart.CFrame + Vector3.new(2, 0, 0))
            end
            task.wait(0.8)
            deletarTodosProps()
        end
    end)
    return true
end

UI.Button(Tabs.Troll, {
    Name = "💀 Kill Prop (Alvo)",
    Description = "TP prop: Void",
    Callback = function()
        if not alvoPropSelecionado then Notify("Props", "Selecione um alvo!", 2); return end
        if not pegarPropMaker() then Notify("Props", "Falha ao equipar caixa", 2); return end
        selecionarProp()
        Notify("Props", "Iniciando Kill Prop...", 2)
        task.spawn(function() executarKillProp(alvoPropSelecionado) end)
    end,
})

UI.Button(Tabs.Troll, {
    Name = "🎣 Bring Prop (Trazer Alvo)",
    Description = "Traz o player selecionado até vc",
    Callback = function()
        if not alvoPropSelecionado then Notify("Props", "Selecione um alvo!", 2); return end
        if not pegarPropMaker() then Notify("Props", "Falha ao equipar caixa", 2); return end
        selecionarProp()
        Notify("Props", "Iniciando Bring Prop...", 2)
        task.spawn(function() executarBringProp(alvoPropSelecionado) end)
    end,
})

UI.Button(Tabs.Troll, {
    Name = "🧹 Limpar TODOS os Props",
    Description = "Apaga todos os props do mapa",
    Callback = function() deletarTodosProps(); Notify("Props", "Props limpos!", 2) end,
})

print("[RD4X] ✅ Parte 3/4 carregada.")
