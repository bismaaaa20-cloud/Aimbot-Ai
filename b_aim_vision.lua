-- =================================================================
-- TITLE: B-AIM VISION ULTRA V3.0 - PURE CORE ENGINE (PART 1 OF 2)
-- CONFIG: MEMORY STATE SYNCHRONIZER, AUTO DETECTOR & AI PREDICTION
-- STATUS: MURNI SISTEM (TIDAK ADA KODE UI / TAMPILAN SAMA SEKALI!)
-- =================================================================

print("[B-AIM SYSTEM] Memulai inisialisasi mesin tempur utama...")

-- ─── 1. STRUKTUR DATA STATE GLOBAL (REFERENSI UNTUK SCRIPT UI NANTI) ───
_G.BAim_Global_Traitors = _G.BAim_Global_Traitors or {}
_G.Kepignan = _G.Kepignan or {
    aim_active = true,
    aim_bone = "Head", 
    smooth_speed = 4.5,
    fov_active = true,
    fov_size = 120,
    target_mode = "Tim Filter", 
    target_spesifik_nama = "",   
    radar_active = true,
    esp_active = true
}

-- Game Services API Bawaan Roblox
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local RunService = game:GetService("RunService")
local Stats = game:GetService("Stats")

-- Smart Game Detector Cache (Berdasarkan PlaceId)
local PlaceId = game.PlaceId
local IsGameSenjata = (PlaceId == 17625359962 or PlaceId == 286090424)
local IsBloxFruits = (PlaceId == 2753915549 or PlaceId == 4442272125 or PlaceId == 7449423635)
local IsKampungKantok = (PlaceId == 16410196884 or PlaceId == 18512128795)

-- 🌟 GLOBAL REFERENCE CACHE PUSAT (Supaya Script UI Terpisah Bisa Membaca Data Musuh)
_G.B_Aim_TargetGlobalSekarang = nil
_G.B_Aim_JarakGlobalKeTengah = 99999
_G.B_Aim_CFramePrediksiAIGlobal = nil

-- Memori Internal Kalkulasi Vektor
local PosisiMusuhTerakhir = nil
local WaktuDeteksiTerakhir = tick()

-- ─── 2. KALKULATOR PREDIKSI TARGET BERBASIS PING & VELOSITAS NYATA ───
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

-- ─── 3. INTERPRETER FILTER TARGET MUSUH SEJATI ───
local function ApakahMusuhSejati(Player)
    local ModeSaatIni = _G.Kepignan.target_mode or "Tim Filter"
    if ModeSaatIni == "Spesifik Target (5s)" then return Player.Name == _G.Kepignan.target_spesifik_nama end
    if ModeSaatIni == "Semua Terdekat (FFA)" then return true end
    if ModeSaatIni == "Tim Filter" then
        if _G.BAim_Global_Traitors[Player.Name] then return true end
        if LocalPlayer.Neutral or Player.Neutral then return true end
        if Player.Team ~= LocalPlayer.Team or Player.TeamColor ~= LocalPlayer.TeamColor then return true end
    end
    return false 
end

-- ─── 4. SENSOR ANTI-TEMBUS TEMBOK (WALL CHECK RAYCAST FILTER) ───
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
-- =================================================================
-- TITLE: B-AIM VISION ULTRA V3.0 - PURE CORE ENGINE (PART 2 OF 2)
-- CONFIG: FPS RESOLVER, SMOOTH LERP, ANTI-CHEAT PROTECTION & SHOT
-- STATUS: MURNI SISTEM (TIDAK ADA KODE UI / TAMPILAN SAMA SEKALI!)
-- =================================================================

-- ─── 5. TARGET RESOLVER LOOP (Dibatasi 30 FPS Stabil - Hemat CPU & Anti-Freeze) ───
task.spawn(function()
    while true do
        task.wait(0.033)
        if _G.Kepignan.aim_active then
            local TitikTengahLayar = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
            local TargetMaksimum = _G.Kepignan.fov_size or 120
            local TargetTerpilih = nil
            local JarakViewportTerpendek = TargetMaksimum
            local BagianTubuhTarget = _G.Kepignan.aim_bone or "Head"
            
            if IsBloxFruits then BagianTubuhTarget = "HumanoidRootPart"
            elseif IsKampungKantok then BagianTubuhTarget = "Head" end
            
            for _, v in pairs(Players:GetPlayers()) do
                if v ~= LocalPlayer and v.Character and ApakahMusuhSejati(v) then
                    local Part = v.Character:FindFirstChild(BagianTubuhTarget)
                    local Humanoid = v.Character:FindFirstChildOfClass("Humanoid")
                    if Part and Humanoid and Humanoid.Health > 0 then
                        local PosisiLayar, BeradaDiLayar = Camera:WorldToViewportPoint(Part.Position)
                        if BeradaDiLayar then
                            local JarakKeTengah = (Vector2.new(PosisiLayar.X, PosisiLayar.Y) - TitikTengahLayar).Magnitude
                            if JarakKeTengah < JarakViewportTerpendek then
                                if ApakahTargetTerlihat(Part) then
                                    JarakViewportTerpendek = JarakKeTengah
                                    TargetTerpilih = Part
                                end
                            end
                        end
                    end
                end
            end
            
            _G.B_Aim_TargetGlobalSekarang = TargetTerpilih
            _G.B_Aim_JarakGlobalKeTengah = JarakViewportTerpendek
            _G.B_Aim_CFramePrediksiAIGlobal = TargetTerpilih and HitungKoordinatPrediksiAI(TargetTerpilih) or nil
        else
            _G.B_Aim_TargetGlobalSekarang = nil
        end
    end
end)

-- ─── 6. INTERPOLASI GERAK KAMERA HALUS & PERPUTARAN AKAR TUBUH LERP ───
RunService.RenderStepped:Connect(function()
    if _G.Kepignan.aim_active and _G.B_Aim_TargetGlobalSekarang then
        local SetelanSmooth = _G.Kepignan.smooth_speed or 4.5
        local JarakMaks = _G.Kepignan.fov_size or 120
        local FaktorDinamis = math.clamp(_G.B_Aim_JarakGlobalKeTengah / JarakMaks, 0.1, 1)
        local PembagiDinamis = SetelanSmooth * (10 + (FaktorDinamis * 5))
        local AlphaAI = math.clamp((1 / PembagiDinamis) + (math.random(-5, 5) / 1000), 0.005, 0.2)
        
        Camera.CFrame = Camera.CFrame:Lerp(CFrame.new(Camera.CFrame.Position, _G.B_Aim_TargetGlobalSekarang.Position), AlphaAI)
        local AkarTubuh = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if AkarTubuh then
            local TargetMendatar = Vector3.new(_G.B_Aim_TargetGlobalSekarang.Position.X, AkarTubuh.Position.Y, _G.B_Aim_TargetGlobalSekarang.Position.Z)
            AkarTubuh.CFrame = AkarTubuh.CFrame:Lerp(CFrame.new(AkarTubuh.Position, TargetMendatar), AlphaAI)
        end
    end
end)

-- ─── 7. BYPASS METATABLE MOUSE HOOK & PERISAI PROTEKSI ANTI-CHEAT (STEALTH) ───
local MetaTableRoblox = getrawmetatable(game)
local IndexLama = MetaTableRoblox.__index
setreadonly(MetaTableRoblox, false)

MetaTableRoblox.__index = newcclosure(function(Objek, Kunci)
    -- Fitur Proteksi Keamanan: Hanya eksekusi jika dipanggil oleh script eksternal pengeksekusi
    if checkcaller and checkcaller() then
        if _G.Kepignan.aim_active and _G.B_Aim_TargetGlobalSekarang then
            if tostring(Objek) == "Mouse" and (Kunci == "Hit" or Kunci == "target" or Kunci == "Target") then
                if IsGameSenjata then
                    if Kunci == "Hit" then return _G.B_Aim_TargetGlobalSekarang.CFrame
                    elseif Kunci == "target" or Kunci == "Target" then return _G.B_Aim_TargetGlobalSekarang end
                else
                    if _G.B_Aim_CFramePrediksiAIGlobal then
                        if Kunci == "Hit" then return _G.B_Aim_CFramePrediksiAIGlobal
                        elseif Kunci == "target" or Kunci == "Target" then return _G.B_Aim_TargetGlobalSekarang end
                    end
                end
            end
        end
    end
    return IndexLama(Objek, Kunci)
end)

-- Menyembunyikan perubahan fungsi agar tidak dilacak oleh pemindai memori game lokal
if hookfunction then
    pcall(function()
        hookfunction(MetaTableRoblox.__index, newcclosure(function(...)
            return IndexLama(...)
        end))
    end)
end
setreadonly(MetaTableRoblox, true)

-- ─── 8. AUTOMATIC DETEKSI TIM KHIANAT (TRAITOR RADAR DETECTION) ───
local DarahTerakhir = 100
task.spawn(function()
    while true do
        task.wait(0.1)
        local Humanoid = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if Humanoid then
            if Humanoid.Health < DarahTerakhir and Humanoid.Health > 0 then
                local PenyerangTerdekat = nil local JarakTerpendek = 35 
                for _, p in pairs(Players:GetPlayers()) do
                    if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                        local Jarak = (p.Character.HumanoidRootPart.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
                        if Jarak < JarakTerpendek then JarakTerpendek = Jarak PenyerangTerdekat = p end
                    end
                end
                if PenyerangTerdekat and not _G.BAim_Global_Traitors[PenyerangTerdekat.Name] then
                    _G.BAim_Global_Traitors[PenyerangTerdekat.Name] = true
                    print("[SISTEM ENGINE] @" .. PenyerangTerdekat.Name .. " masuk daftar target karena berkhianat!")
                end
            end
            DarahTerakhir = Humanoid.Health
        else DarahTerakhir = 100 end
    end
end)

-- ─── 9. HIGH PERFORMANCE AUTO TRIGGER SHOT ───
local VirtualUser = game:GetService("VirtualUser")
task.spawn(function()
    while true do
        task.wait(0.05)
        if _G.Kepignan.aim_active and _G.B_Aim_TargetGlobalSekarang and _G.B_Aim_JarakGlobalKeTengah <= 32 then
            pcall(function()
                VirtualUser:Button1Down(Vector2.new(0, 0), Camera.CFrame) 
                task.wait(0.01) 
                VirtualUser:Button1Up(Vector2.new(0, 0), Camera.CFrame)
            end)
        end
    end
end)

print("[B-AIM ENGINE] Skrip Sistem Inti Selesai Terpasang Sempurna + Proteksi Anti-Cheat Aktif! 🔓")
