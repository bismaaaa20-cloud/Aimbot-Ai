-- =================================================================
-- TITLE: B-AIM VISION ULTRA V3.0 - CORE SYSTEM ENGINE (PART 1 OF 2)
-- CONFIG: CLOUD LINK LOADER, SHARED MEMORY & PREDICTIVE AI CACHE
-- STATUS: TERPISAH (JANGAN DIGABUNG DENGAN SKRIP UI UTAMA!)
-- =================================================================

print("[B-AIM ENGINE] Memulai inisialisasi modul sistem bagian 1...")

-- ─── 0. AUTOMATIC LOADER SINKRONISASI UI CLOUD GITHUB ───
local StatusUI, HasilkanUI = pcall(function()
    return loadstring(game:HttpGet("https://raw.githubusercontent.com/bismaaaa20-cloud/Aimbot-Ai/refs/heads/main/b_aim_ui.lua"))()
end)

if StatusUI then
    print("[B-AIM LOADER] Sukses sinkronisasi UI Cloud dari GitHub Anda!")
else
    warn("[B-AIM ERROR] Gagal mengambil UI dari GitHub. Menggunakan fallback lokal: " .. tostring(HasilkanUI))
end

-- ─── 1. SINKRONISASI MEMORI STATE GLOBAL (DIBACA OLEH UI DAN ENGINE) ───
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

-- Roblox Engine Services
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local RunService = game:GetService("RunService")
local Stats = game:GetService("Stats")

-- Cache Pendeteksi Game Adaptif
local PlaceId = game.PlaceId
local IsGameSenjata = (PlaceId == 17625359962 or PlaceId == 286090424)
local IsBloxFruits = (PlaceId == 2753915549 or PlaceId == 4442272125 or PlaceId == 7449423635)
local IsKampungKantok = (PlaceId == 16410196884 or PlaceId == 18512128795)

-- 🌟 SINGLE CENTRAL CACHE POINTER (Variabel Penampung Sinkronisasi)
_G.B_Aim_TargetGlobalSekarang = nil
_G.B_Aim_JarakGlobalKeTengah = 99999
_G.B_Aim_CFramePrediksiAIGlobal = nil
-- =================================================================
-- TITLE: B-AIM VISION ULTRA V3.0 - PURE CORE ENGINE (PART 2 OF 2)
-- CONFIG: FPS RESOLVER, SMOOTH LERP, LIGHTWEIGHT BYPASS & SHOT
-- STATUS: FIX ANTI-FREEZE (AMBARAAN FUNGSI BERAT CHECKCALLER)
-- =================================================================

-- ─── 5. TARGET RESOLVER LOOP (30 FPS Stabil - Hemat CPU & Anti-Freeze) ───
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

-- ─── 7. BYPASS METATABLE MOUSE HOOK (LIGHTWEIGHT & ANTI-CRASH SYSTEM) ───
local MetaTableRoblox = getrawmetatable(game)
local IndexLama = MetaTableRoblox.__index
setreadonly(MetaTableRoblox, false)

-- Menggunakan C Closure murni yang super ringan tanpa fungsi checkcaller penyedot RAM
MetaTableRoblox.__index = newcclosure(function(Objek, Kunci)
    if _G.Kepignan.aim_active and _G.B_Aim_TargetGlobalSekarang then
        -- Validasi string instan agar CPU tidak dipaksa melakukan kalkulasi berat
        if Kunci == "Hit" or Kunci == "target" or Kunci == "Target" then
            if tostring(Objek) == "Mouse" then
                if IsGameSenjata then
                    if Kunci == "Hit" then return _G.B_Aim_TargetGlobalSekarang.CFrame
                    else return _G.B_Aim_TargetGlobalSekarang end
                else
                    if _G.B_Aim_CFramePrediksiAIGlobal then
                        if Kunci == "Hit" then return _G.B_Aim_CFramePrediksiAIGlobal
                        else return _G.B_Aim_TargetGlobalSekarang end
                    end
                end
            end
        end
    end
    return IndexLama(Objek, Kunci)
end)
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

print("[B-AIM ENGINE] Skrip Sistem Inti Sukses Diperbarui. Jalur Anti-Freeze Aktif! 🔓")
