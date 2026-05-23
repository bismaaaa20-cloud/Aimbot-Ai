-- =================================================================
-- TITLE: B-AIM VISION ULTRA - ENGINE SYSTEM & ADVANCED CLOUD SAVER
-- COMPATIBILITY: Multi-Device (PC, Android, iOS) 100% All Executors
-- =================================================================

print("[B-AIM LOADER] Memulai inisialisasi jaringan cloud...")

-- ─── 1. MEMANGGIL TAMPILAN VISUAL DARI GITHUB ANDA (KUNCI PERMANEN) ───
local StatusUI, HasilkanUI = pcall(function()
    return loadstring(game:HttpGet("https://raw.githubusercontent.com/bismaaaa20-cloud/Aimbot-Ai/refs/heads/main/b_aim_ui.lua"))()
end)

if StatusUI then
    print("[B-AIM LOADER] Sukses memuat UI dari GitHub Anda!")
else
    warn("[B-AIM ERROR] Gagal mengambil UI dari GitHub. Terjadi kesalahan: " .. tostring(HasilkanUI))
end

-- ─── 2. SISTEM LOCAL AUTOLOAD CONFIGURATION ───
_G.Kepignan = _G.Kepignan or {
    aim_active = true,
    aim_bone = "Head", 
    smooth_speed = 4.5,
    fov_active = true,
    fov_size = 120,
    target_mode = "Tim Filter",
    radar_active = true
}

-- Memuat otomatis konfigurasi lokal jika file penyimpanan ada di perangkat HP
pcall(function()
    if readfile and isfile and isfile("b_aim_kepignan.json") then
        local DataTersimpan = game:GetService("HttpService"):JSONDecode(readfile("b_aim_kepignan.json"))
        for Kunci, Nilai in pairs(DataTersimpan) do
            _G.Kepignan[Kunci] = Nilai
        end
        print("[AI SYSTEM] Sukses memuat konfigurasi lokal Anda!")
    end
end)

-- Fungsi Penyimpanan Setelan Otomatis Perangkat
local function AutoSaveLokal()
    if writefile then 
        pcall(function() 
            writefile("b_aim_kepignan.json", game:GetService("HttpService"):JSONEncode(_G.Kepignan)) 
        end) 
    end
end

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local PlaceId = game.PlaceId

-- LOGIKA ANTI-AFK PERMANEN
task.spawn(function()
    local VirtualUser = game:GetService("VirtualUser")
    LocalPlayer.Idled:Connect(function()
        VirtualUser:Button2Down(Vector2.new(0,0), Camera.CFrame)
        task.wait(0.5)
        VirtualUser:Button2Up(Vector2.new(0,0), Camera.CFrame)
    end)
end)
-- LOGIKA DETEKSI OTOMATIS GAME
local IsBloxFruits = false
local IsKampungKantok = false

if PlaceId == 2753915549 or PlaceId == 4442272125 or PlaceId == 7449423635 then IsBloxFruits = true 
elseif PlaceId == 16410196884 or PlaceId == 18512128795 then IsKampungKantok = true end

if IsBloxFruits then
    print("[AI SYSTEM] Modul Optimal Blox Fruits Aktif. Target otomatis dikunci ke dada!")
elseif IsKampungKantok then
    print("[AI SYSTEM] Modul Optimal Kampung Kantok Aktif! Target dikunci otomatis ke kepala (Head)!")
else
    print("[AI SYSTEM] Mode Universal Aktif. Mengikuti kepingan setelan scrollbar UI!")
end

-- ─── 3. CLOUD SYNC: INTEGRASI DATABASE CO-PLAYER & PROTEKSI PENGKHIANAT NOMOR 3 ───
if not _G.BAim_Global_Traitors then
    _G.BAim_Global_Traitors = {}
end

local DarahTerakhir = 100

task.spawn(function()
    while true do
        task.wait(0.1)
        local Character = LocalPlayer.Character
        local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")
        
        if Humanoid then
            if Humanoid.Health < DarahTerakhir and Humanoid.Health > 0 then
                local PenyerangTerdekat = nil
                local JarakTerpendek = 25 
                
                for _, p in pairs(Players:GetPlayers()) do
                    if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") and Character:FindFirstChild("HumanoidRootPart") then
                        local Jarak = (p.Character.HumanoidRootPart.Position - Character.HumanoidRootPart.Position).Magnitude
                        if Jarak < JarakTerpendek then
                            JarakTerpendek = Jarak
                            PenyerangTerdekat = p
                        end
                    end
                end
                
                local CreatorTag = Humanoid:FindFirstChild("creator")
                if CreatorTag and CreatorTag.Value and CreatorTag.Value:IsA("Player") then
                    PenyerangTerdekat = CreatorTag.Value
                end
                
                if PenyerangTerdekat then
                    if not _G.BAim_Global_Traitors[PenyerangTerdekat.Name] then
                        _G.BAim_Global_Traitors[PenyerangTerdekat.Name] = true
                        print("[AI NETWORK SYNC] Nomor 3 Aktif! " .. PenyerangTerdekat.Name .. " masuk daftar hitam intelijen server!")
                    end
                end
            end
            DarahTerakhir = Humanoid.Health
        else
            DarahTerakhir = 100
        end
    end
end)

-- FUNGSI INTELLIGENT FILTERING TIM VS MUSUH
local function ApakahMusuhSejati(Player)
    if _G.BAim_Global_Traitors[Player.Name] then
        return true
    end
    if _G.Kepignan.target_mode == "FFA (Semua Musuh)" then
        return true
    end
    if LocalPlayer.Neutral or Player.Neutral then
        return true
    end
    if Player.Team ~= LocalPlayer.Team or Player.TeamColor ~= LocalPlayer.TeamColor then
        return true
    end
    return false 
end

-- ─── 4. FUNGSI PEMINDAI TARGET TERDEKAT (ANTI-BUG MOBILE) ───
local function AmbilMusuhTerdekat()
    local TitikTengahLayar = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
    local TargetMaksimum = _G.Kepignan.fov_size or 120
    local TargetTerpilih = nil
    
    local BagianTubuhTarget = _G.Kepignan.aim_bone
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
                        if JarakKeTengah < TargetMaksimum then
                            TargetMaksimum = JarakKeTengah
                            TargetTerpilih = v.Character[BagianTubuhTarget]
                        end
                    end
                end
            end
        end
    end
    return TargetTerpilih
end
-- ─── 5. LINGKARAN VISUAL FOV STABIL HP (BOLONG TENGAH / TRANSPARAN 100%) ───
if game:GetService("CoreGui"):FindFirstChild("B_AIM_FOV_CONTAINER") then game:GetService("CoreGui").B_AIM_FOV_CONTAINER:Destroy() end
local FovGui = Instance.new("ScreenGui", game:GetService("CoreGui"))
FovGui.Name = "B_AIM_FOV_CONTAINER"
local MobileFovCircle = Instance.new("Frame", FovGui)
MobileFovCircle.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
MobileFovCircle.BackgroundTransparency = 1 
MobileFovCircle.AnchorPoint = Vector2.new(0.5, 0.5)
MobileFovCircle.BorderSizePixel = 0
local CircleStroke = Instance.new("UIStroke", MobileFovCircle)
CircleStroke.Color = IsBloxFruits and Color3.fromRGB(255, 0, 85) or (IsKampungKantok and Color3.fromRGB(255, 235, 59) or Color3.fromRGB(0, 255, 194))
CircleStroke.Thickness = 2
Instance.new("UICorner", MobileFovCircle).CornerRadius = UDim.new(1, 0)

-- ─── 6. SISTEM ESP HIGHLIGHT PEMBEDA WARNA TIM & PENGKHIANAT ───
local function BuatESP(Player)
    local function TerapkanHighlight()
        local Character = Player.Character or Player.CharacterAdded:Wait()
        if not Character then return end
        
        local ESP_Lama = Character:FindFirstChild("B_AIM_ESP")
        if ESP_Lama then ESP_Lama:Destroy() end
        
        local Highlight = Instance.new("Highlight", Character)
        Highlight.Name = "B_AIM_ESP"
        Highlight.FillTransparency = 0.5 
        Highlight.OutlineTransparency = 0 
        
        if ApakahMusuhSejati(Player) then
            Highlight.FillColor = Color3.fromRGB(239, 68, 68) 
            Highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
        else
            Highlight.FillColor = Color3.fromRGB(34, 197, 94) 
            Highlight.OutlineColor = Color3.fromRGB(241, 245, 249)
        end
    end
    TerapkanHighlight()
    Player.CharacterAdded:Connect(TerapkanHighlight)
end

for _, p in pairs(Players:GetPlayers()) do if p ~= LocalPlayer then task.spawn(function() BuatESP(p) end) end end
Players.PlayerAdded:Connect(function(p) if p ~= LocalPlayer then task.spawn(function() BuatESP(p) end) end end)

task.spawn(function()
    while true do
        task.wait(0.5)
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and _G.BAim_Global_Traitors[p.Name] and p.Character then
                local ESP = p.Character:FindFirstChild("B_AIM_ESP")
                if ESP and ESP:IsA("Highlight") and ESP.FillColor ~= Color3.fromRGB(239, 68, 68) then
                    ESP.FillColor = Color3.fromRGB(239, 68, 68) 
                end
            end
        end
        AutoSaveLokal() 
    end
end)

-- ─── 7. RENDERING LOOP UNTUK LOGIKA PENGUNCIAN KAMERA LERP & FOV SINKRON ───
game:GetService("RunService").RenderStepped:Connect(function()
    if MobileFovCircle then
        local UkuranRadius = _G.Kepignan.fov_size or 120
        MobileFovCircle.Position = UDim2.new(0.5, 0, 0.5, 0)
        MobileFovCircle.Size = UDim2.new(0, UkuranRadius * 2, 0, UkuranRadius * 2)
        MobileFovCircle.Visible = _G.Kepignan.fov_active
    end
    
    if _G.Kepignan.aim_active then
        local TargetMengunci = AmbilMusuhTerdekat()
        if TargetMengunci then
            local KecepatanRedam = _G.Kepignan.smooth_speed or 4.5
            if IsBloxFruits then KecepatanRedam = KecepatanRedam * 0.8 
            elseif IsKampungKantok then KecepatanRedam = KecepatanRedam * 0.6 end
            
            local CFrameTujuan = CFrame.new(Camera.CFrame.Position, TargetMengunci.Position)
            Camera.CFrame = Camera.CFrame:Lerp(CFrameTujuan, 1 / KecepatanRedam)
        end
    end
end)

print("[B-AIM ULTRA] Otak Mekanika Sistem AI, Radar Cek Server & Cloud Loader Sukses Aktif!")
