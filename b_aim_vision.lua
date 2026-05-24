-- =================================================================
-- TITLE: B-AIM VISION ULTRA - ENGINE SYSTEM INTEGRASI (PART 1 OF 3)
-- CONFIG: AUTOMATIC LOADER, GAME DETECTOR & DATA TRACKING PING
-- STATUS: TERPISAH (JANGAN DIGABUNG DENGAN SKRIP UI MANUAl!)
-- =================================================================

print("[B-AIM LOADER] Memulai inisialisasi jaringan cloud...")

-- ─── 1. INTEGRASI TAUTAN CLOUD GITHUB PENGHUBUNG INDONESIA ───
local StatusUI, HasilkanUI = pcall(function()
    return loadstring(game:HttpGet("https://raw.githubusercontent.com/bismaaaa20-cloud/Aimbot-Ai/refs/heads/main/b_aim_ui.lua"))()
end)

if StatusUI then
    print("[B-AIM LOADER] Sukses sinkronisasi UI Cloud dari GitHub Anda!")
else
    warn("[B-AIM ERROR] Gagal mengambil UI dari GitHub. Menggunakan fallback UI lokal: " .. tostring(HasilkanUI))
end

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local RunService = game:GetService("RunService")
local Stats = game:GetService("Stats")

if not _G.BAim_Global_Traitors then _G.BAim_Global_Traitors = {} end
_G.Kepignan = _G.Kepignan or {}
if _G.Kepignan.esp_active == nil then _G.Kepignan.esp_active = true end

-- ─── 2. STRUKTUR UTAMA SMART GAME DETECTOR (ADAPTIF) ───
local PlaceId = game.PlaceId
local IsGameSenjata = (PlaceId == 17625359962 or PlaceId == 286090424)
local IsBloxFruits = (PlaceId == 2753915549 or PlaceId == 4442272125 or PlaceId == 7449423635)
local IsKampungKantok = (PlaceId == 16410196884 or PlaceId == 18512128795)

-- ─── 3. KALKULATOR PREDIKSI BERBASIS PING & AKSELERASI KECEPATAN AI ───
local PosisiMusuhTerakhir = nil
local WaktuDeteksiTerakhir = tick()

local function HitungKoordinatPrediksiAI(TargetPart)
    if not TargetPart then return nil end
    local WaktuSekarang = tick()
    local DeltaTime = WaktuSekarang - WaktuDeteksiTerakhir
    local PosisiAsliMusuh = TargetPart.Position
    local PosisiMasaDepan = PosisiAsliMusuh
    
    if PosisiMusuhTerakhir and DeltaTime > 0 and DeltaTime < 0.1 then
        local VelositasNyata = (PosisiAsliMusuh - PosisiMusuhTerakhir) / DeltaTime
        local NetworkPing = 0.06
        if Stats:FindFirstChild("Network") and Stats.Network:FindFirstChild("ServerToClientPing") then
            NetworkPing = Stats.Network.ServerToClientPing:GetValue() / 1000
        end
        local JarakPrediksiAI = math.clamp(0.12 + (NetworkPing * 1.1), 0.1, 0.45)
        PosisiMasaDepan = PosisiAsliMusuh + (VelositasNyata * JarakPrediksiAI)
    end
    
    PosisiMusuhTerakhir = PosisiAsliMusuh
    WaktuDeteksiTerakhir = WaktuSekarang
    return CFrame.new(PosisiMasaDepan)
end
-- =================================================================
-- TITLE: B-AIM VISION ULTRA - ENGINE SYSTEM INTEGRASI (PART 2 OF 3)
-- CONFIG: FILTER SINKRONISASI UI, SENSOR WALLCHECK & BYPASS MOUSE HOOK
-- STATUS: TERPISAH (JANGAN DIGABUNG DENGAN SKRIP UI MANUAl!)
-- =================================================================

-- ─── 4. INTERPRETER FILTER TARGET SINKRONISASI 3 PILIHAN MODUL UI ───
local function ApakahMusuhSejati(Player)
    local ModeSaatIni = _G.Kepignan and _G.Kepignan.target_mode or "Tim Filter"
    if ModeSaatIni == "Spesifik Target (5s)" then return Player.Name == _G.Kepignan.target_spesifik_nama end
    if ModeSaatIni == "Semua Terdekat (FFA)" then return true end
    if ModeSaatIni == "Tim Filter" then
        if _G.BAim_Global_Traitors and _G.BAim_Global_Traitors[Player.Name] then return true end
        if LocalPlayer.Neutral or Player.Neutral then return true end
        if Player.Team ~= LocalPlayer.Team or Player.TeamColor ~= LocalPlayer.TeamColor then return true end
    end
    return false 
end

-- ─── 5. LOGIKA INTEGRASI SENSOR ANTI-TEMBUS TEMBOK (WALL CHECK) ───
local function ApakahTargetTerlihat(BagianTubuh)
    local KarakterSaya = LocalPlayer.Character
    if not KarakterSaya then return false end
    local ParameterRaycast = RaycastParams.new()
    ParameterRaycast.FilterType = Enum.RaycastFilterType.Exclude
    ParameterRaycast.FilterDescendantsInstances = {KarakterSaya, Camera}
    ParameterRaycast.IgnoreWater = true
    local HasilRaycast = workspace:Raycast(Camera.CFrame.Position, (BagianTubuh.Position - Camera.CFrame.Position), ParameterRaycast)
    if HasilRaycast then return HasilRaycast.Instance:IsDescendantOf(BagianTubuh.Parent) end
    return true
end

-- ─── 6. SCANNER UTAMA PELACAK TARGET TERDEKAT RADAR ───
local function AmbilMusuhTerdekat()
    local TitikTengahLayar = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
    local TargetMaksimum = _G.Kepignan and _G.Kepignan.fov_size or 120
    local TargetTerpilih = nil
    local JarakViewportTerpendek = TargetMaksimum
    local BagianTubuhTarget = _G.Kepignan and _G.Kepignan.aim_bone or "Head"
    if IsBloxFruits then BagianTubuhTarget = "HumanoidRootPart"
    elseif IsKampungKantok then BagianTubuhTarget = "Head" end
    
    for _, v in pairs(Players:GetPlayers()) do
        if v ~= LocalPlayer and v.Character and ApakahMusuhSejati(v) then
            if v.Character:FindFirstChild(BagianTubuhTarget) then
                local Humanoid = v.Character:FindFirstChildOfClass("Humanoid")
                if Humanoid and Humanoid.Health > 0 then
                    local PosisiLayar, BeradaDiLayar = Camera:WorldToViewportPoint(v.Character[BagianTubuhTarget].Position)
                    if BeradaDiLayar then
                        local JarakKeTengah = (Vector2.new(PosisiLayar.X, PosisiLayar.Y) - TitikTengahLayar).Magnitude
                        if JarakKeTengah < JarakViewportTerpendek then
                            if ApakahTargetTerlihat(v.Character[BagianTubuhTarget]) then
                                JarakViewportTerpendek = JarakKeTengah
                                TargetTerpilih = v.Character[BagianTubuhTarget]
                            end
                        end
                    end
                end
            end
        end
    end
    return TargetTerpilih, JarakViewportTerpendek
end

-- ─── 7. SMART HOOKING MOUSE (OTOMATIS SAKLAR SESUAI GAME SENJATA VS GAME SKILL) ───
local MetaTableRoblox = getrawmetatable(game)
local IndexLama = MetaTableRoblox.__index
setreadonly(MetaTableRoblox, false)

MetaTableRoblox.__index = newcclosure(function(Objek, Kunci)
    if _G.Kepignan and _G.Kepignan.aim_active and not checkcaller() then
        if tostring(Objek) == "Mouse" and (Kunci == "Hit" or Kunci == "target" or Kunci == "Target") then
            local PartMusuh = AmbilMusuhTerdekat()
            if PartMusuh then
                if IsGameSenjata then
                    if Kunci == "Hit" then return PartMusuh.CFrame
                    elseif Kunci == "target" or Kunci == "Target" then return PartMusuh end
                else
                    local CFramePrediksiAI = HitungKoordinatPrediksiAI(PartMusuh)
                    if CFramePrediksiAI then
                        if Kunci == "Hit" then return CFramePrediksiAI
                        elseif Kunci == "target" or Kunci == "Target" then return PartMusuh end
                    end
                end
            end
        end
    end
    return IndexLama(Objek, Kunci)
end)
setreadonly(MetaTableRoblox, true)
-- =================================================================
-- TITLE: B-AIM VISION ULTRA - ENGINE SYSTEM INTEGRASI (PART 3 OF 3)
-- CONFIG: HUMANIZED LERP, SNAPLINES DRAWING & CLEANUP AUTO TRIGGER
-- STATUS: TERPISAH (JANGAN DIGABUNG DENGAN SKRIP UI MANUAl!)
-- =================================================================

-- ─── 8. INTERPOLASI KAMERA & TUBUH BERBASIS HUMANISASI GERAKAN (ANTI-GOYANG) ───
pcall(function() RunService:UnbindFromRenderStep("BAimEngineCoreUpdate") end)
RunService:BindToRenderStep("BAimEngineCoreUpdate", Enum.RenderPriority.Camera.Value + 1, function()
    if _G.Kepignan and _G.Kepignan.aim_active then
        local TargetMengunci, JarakKeTengah = AmbilMusuhTerdekat()
        if TargetMengunci and JarakKeTengah <= (_G.Kepignan.fov_size or 120) then
            local SetelanSmooth = _G.Kepignan.smooth_speed or 4.5
            local JarakMaks = _G.Kepignan.fov_size or 120
            local FaktorDinamis = math.clamp(JarakKeTengah / JarakMaks, 0.1, 1)
            local PembagiDinamis = SetelanSmooth * (10 + (FaktorDinamis * 5))
            local JitterMikro = (math.random(-5, 5) / 1000)
            local AlphaAI = math.clamp((1 / PembagiDinamis) + JitterMikro, 0.005, 0.2)
            
            Camera.CFrame = Camera.CFrame:Lerp(CFrame.new(Camera.CFrame.Position, TargetMengunci.Position), AlphaAI)
            local KarakterSaya = LocalPlayer.Character
            local AkarTubuh = KarakterSaya and KarakterSaya:FindFirstChild("HumanoidRootPart")
            if AkarTubuh then
                local TargetMendatar = Vector3.new(TargetMengunci.Position.X, AkarTubuh.Position.Y, TargetMengunci.Position.Z)
                AkarTubuh.CFrame = AkarTubuh.CFrame:Lerp(CFrame.new(AkarTubuh.Position, TargetMendatar), AlphaAI)
            end
        end
    end
end)

-- ─── 9. SISTEM SNAPLINES (GARIS PELACAK LUAS) ───
local MemoriGarisPemain = {}
local function BuatGarisPelacak()
    local GarapLine = Drawing.new("Line")
    GarapLine.Thickness = 1 GarapLine.Transparency = 0.8 GarapLine.Visible = false return GarapLine
end

local function AmbilWarnaESP(Player)
    local ModeSaatIni = _G.Kepignan and _G.Kepignan.target_mode or "Tim Filter"
    if ModeSaatIni == "Spesifik Target (5s)" then
        if Player.Name == _G.Kepignan.target_spesifik_nama then return Color3.fromRGB(239, 68, 68), "TARGET" end
        return Color3.fromRGB(148, 163, 184), "NETRAL"
    end
    if ModeSaatIni == "Semua Terdekat (FFA)" then return Color3.fromRGB(249, 115, 22), "MUSUH (FFA)" end
    if ModeSaatIni == "Tim Filter" then
        if _G.BAim_Global_Traitors and _G.BAim_Global_Traitors[Player.Name] then return Color3.fromRGB(239, 68, 68), "PENGKHIANAT!" end
        if LocalPlayer.Neutral or Player.Neutral then return Color3.fromRGB(239, 68, 68), "MUSUH" end
        if Player.Team ~= LocalPlayer.Team or Player.TeamColor ~= LocalPlayer.TeamColor then return Color3.fromRGB(239, 68, 68), "MUSUH" end
        return Color3.fromRGB(34, 197, 94), "TIM"
    end
    return Color3.fromRGB(255, 255, 255), "USER"
end

RunService.RenderStepped:Connect(function()
    if not _G.Kepignan or not _G.Kepignan.esp_active then
        for _, Garis in pairs(MemoriGarisPemain) do Garis.Visible = false end return
    end
    local TitikBawahLayar = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y)
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            local Humanoid = p.Character:FindFirstChildOfClass("Humanoid")
            if Humanoid and Humanoid.Health > 0 then
                local PosisiLayar, BeradaDiLayar = Camera:WorldToViewportPoint(p.Character.HumanoidRootPart.Position)
                if BeradaDiLayar then
                    if not MemoriGarisPemain[p.Name] then MemoriGarisPemain[p.Name] = BuatGarisPelacak() end
                    local Garis = MemoriGarisPemain[p.Name]
                    local Warna, _ = AmbilWarnaESP(p)
                    Garis.From = TitikBawahLayar Garis.To = Vector2.new(PosisiLayar.X, PosisiLayar.Y) Garis.Color = Warna Garis.Visible = true
                else if MemoriGarisPemain[p.Name] then MemoriGarisPemain[p.Name].Visible = false end end
            else if MemoriGarisPemain[p.Name] then MemoriGarisPemain[p.Name].Visible = false end end
        else if MemoriGarisPemain[p.Name] then MemoriGarisPemain[p.Name].Visible = false end end
    end
end)

-- ─── 10. REAL-TIME PERSENTASE DARAH (HP %) HIGH-PERFORMANCE ───
local function TerapkanSmartESP(Player)
    local function RenderUlang()
        local Character = Player.Character or Player.CharacterAdded:Wait()
        if not Character then return end
        local ESP_Highlight = Character:FindFirstChild("B_AIM_HIGHLIGHT_ESP") or Instance.new("Highlight", Character)
        ESP_Highlight.Name = "B_AIM_HIGHLIGHT_ESP"
        local Head = Character:WaitForChild("Head", 5)
        if not Head then return end
        local ESP_Tag = Head:FindFirstChild("B_AIM_TAG_ESP") or Instance.new("BillboardGui", Head)
        ESP_Tag.Name = "B_AIM_TAG_ESP" ESP_Tag.Size = UDim2.new(0, 120, 0, 35) ESP_Tag.StudsOffset = Vector3.new(0, 2.8, 0) ESP_Tag.AlwaysOnTop = true
        local LabelTeks = ESP_Tag:FindFirstChildOfClass("TextLabel") or Instance.new("TextLabel", ESP_Tag)
        LabelTeks.Size = UDim2.new(1, 0, 1, 0) LabelTeks.BackgroundTransparency = 1 LabelTeks.Font = Enum.Font.GothamBold LabelTeks.TextSize = 8 LabelTeks.TextStrokeTransparency = 0.2
        task.spawn(function()
            while Character and Character.Parent and Player.Parent do
                if _G.Kepignan and _G.Kepignan.esp_active then
                    local Humanoid = Character:FindFirstChildOfClass("Humanoid")
                    if LabelTeks and ESP_Highlight and Humanoid then
                        local Warna, Status = AmbilWarnaESP(Player)
                        local PersenHP = math.clamp(math.round((Humanoid.Health / Humanoid.MaxHealth) * 100), 0, 100)
                        ESP_Highlight.Enabled = true ESP_Highlight.FillColor = Warna ESP_Highlight.FillTransparency = 0.5
                        LabelTeks.Text = Player.DisplayName .. "\n[" .. Status .. "] " .. tostring(PersenHP) .. "% HP"
                        LabelTeks.TextColor3 = Warna LabelTeks.Visible = true
                    end
                else
                    if ESP_Highlight then ESP_Highlight.Enabled = false end if LabelTeks then LabelTeks.Visible = false end
                end
                task.wait(0.2)
            end
        end)
    end
    RenderUlang() Player.CharacterAdded:Connect(RenderUlang)
end

-- ─── 11. DETEKSI OTOMATIS KERUSAKAN TIM (PENGKHIANAT) & TERMINASI ───
local DarahTerakhir = 100
task.spawn(function()
    while true do
        task.wait(0.05)
        local Character = LocalPlayer.Character
        local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")
        if Humanoid then
            if Humanoid.Health < DarahTerakhir and Humanoid.Health > 0 then
                local PenyerangTerdekat = nil local JarakTerpendek = 35 
                for _, p in pairs(Players:GetPlayers()) do
                    if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") and Character:FindFirstChild("HumanoidRootPart") then
                        local Jarak = (p.Character.HumanoidRootPart.Position - Character.HumanoidRootPart.Position).Magnitude
                        if Jarak < JarakTerpendek then JarakTerpendek = Jarak PenyerangTerdekat = p end
                    end
                end
                local CreatorTag = Humanoid:FindFirstChild("creator")
                if CreatorTag and CreatorTag.Value and CreatorTag.Value:IsA("Player") then PenyerangTerdekat = CreatorTag.Value end
                if PenyerangTerdekat and not _G.BAim_Global_Traitors[PenyerangTerdekat.Name] then
                    _G.BAim_Global_Traitors[PenyerangTerdekat.Name] = true
                    print("[AI ENGINE] @" .. PenyerangTerdekat.Name .. " dipindahkan ke status MUSUH karena menyerang Anda!")
                end
            end
            DarahTerakhir = Humanoid.Health
        else DarahTerakhir = 100 end
    end
end)

-- AUTO TRIGGER SHOT
local VirtualUser = game:GetService("VirtualUser")
task.spawn(function()
    while true do
        task.wait(0.04)
        if _G.Kepignan and _G.Kepignan.aim_active then
            local TargetSekarang, _ = AmbilMusuhTerdekat()
            if TargetSekarang then
                local PosisiLayar, BeradaDiLayar = Camera:WorldToViewportPoint(TargetSekarang.Position)
                if BeradaDiLayar then
                    local JarakKeTengah = (Vector2.new(PosisiLayar.X, PosisiLayar.Y) - Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)).Magnitude
                    if JarakKeTengah <= 32 then
                        pcall(function()
                            VirtualUser:Button1Down(Vector2.new(0, 0), Camera.CFrame) task.wait(0.01) VirtualUser:Button1Up(Vector2.new(0, 0), Camera.CFrame)
                        end)
                    end
                end
            end
        end
    end
end)

for _, p in pairs(Players:GetPlayers()) do if p ~= LocalPlayer then task.spawn(function() TerapkanSmartESP(p) end) end end
Players.PlayerAdded:Connect(function(p) if p ~= LocalPlayer then task.spawn(function() TerapkanSmartESP(p) end) end end)
Players.PlayerRemoving:Connect(function(p)
    pcall(function()
        if MemoriGarisPemain[p.Name] then MemoriGarisPemain[p.Name]:Destroy() MemoriGarisPemain[p.Name] = nil end
        if p.Character then
            if p.Character:FindFirstChild("B_AIM_HIGHLIGHT_ESP") then p.Character.B_AIM_HIGHLIGHT_ESP:Destroy() end
            if p.Character.Head:FindFirstChild("B_AIM_TAG_ESP") then p.Character.Head.B_AIM_TAG_ESP:Destroy() end
        end
    end)
end)

