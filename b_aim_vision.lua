-- =================================================================
-- TITLE: B-AIM VISION ULTRA - MAIN LOADER HUB (PERMANENT CLOUD LINK)
-- CREDITS: Dual-Save, Pusat Kepignan, & Loader Logic oleh Kamu 😎
-- COMPATIBILITY: Multi-Device (PC, Android, iOS) 100% All Executors
-- =================================================================

print("[B-AIM LOADER] Memulai inisialisasi jaringan cloud...")

-- ─── 1. MEMANGGIL TAMPILAN VISUAL (LINK GITHUB DIKUNCI PERMANEN) ───
local StatusUI, HasilkanUI = pcall(function()
    return loadstring(game:HttpGet("https://raw.githubusercontent.com/bismaaaa20-cloud/Aimbot-Ai/refs/heads/main/b_aim_ui.lua"))()
end)

if StatusUI then
    print("[B-AIM LOADER] Sukses memuat UI dari GitHub Anda!")
else
    warn("[B-AIM ERROR] Gagal mengambil UI dari GitHub. Terjadi kesalahan: " .. tostring(HasilkanUI))
end

-- ─── 2. MENYUNTIKKAN INTEGRASI SISTEM AI & ANTI-AFK ───
_G.Kepignan = _G.Kepignan or {
    aim_active = true,
    aim_bone = "Head", 
    smooth_speed = 4.5,
    fov_active = true,
    fov_size = 120
}

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local UserInputService = game:GetService("UserInputService")
local PlaceId = game.PlaceId

-- LOGIKA ANTI-AFK PERMANEN
task.spawn(function()
    local VirtualUser = game:GetService("VirtualUser")
    LocalPlayer.Idled:Connect(function()
        VirtualUser:Button2Down(Vector2.new(0,0), Camera.CFrame)
        task.wait(0.5)
        VirtualUser:Button2Up(Vector2.new(0,0), Camera.CFrame)
        print("[AI SYSTEM] Anti-AFK Aktif: Berhasil mencegah pemutusan server!")
    end)
    print("[AI SYSTEM] Proteksi Anti-AFK dinyalakan secara permanen!")
end)

-- LOGIKA DETEKSI OTOMATIS GAME
local IsBloxFruits = false
local IsKampungKantok = false

local BloxFruitsIDs = {2753915549, 4442272125, 7449423635}
for _, id in pairs(BloxFruitsIDs) do
    if PlaceId == id then IsBloxFruits = true break end
end

local KampungKantokIDs = {16410196884, 18512128795} 
for _, id in pairs(KampungKantokIDs) do
    if PlaceId == id then IsKampungKantok = true break end
end

if IsBloxFruits then
    print("[AI SYSTEM] Modul Optimal Blox Fruits Aktif. Target otomatis dikunci ke dada!")
elseif IsKampungKantok then
    print("[AI SYSTEM] Modul Optimal Kampung Kantok Aktif! Target dikunci otomatis ke kepala (Head)!")
else
    print("[AI SYSTEM] Mode Universal Aktif. Mengikuti kepingan setelan scrollbar UI!")
end

-- Mengaktifkan Gambar Lingkaran FOV
local FOVCircle = nil
pcall(function()
    if Drawing then
        FOVCircle = Drawing.new("Circle")
        if IsBloxFruits then
            FOVCircle.Color = Color3.fromRGB(255, 0, 85)
        elseif IsKampungKantok then
            FOVCircle.Color = Color3.fromRGB(255, 235, 59)
        else
            FOVCircle.Color = Color3.fromRGB(0, 255, 194)
        end
        FOVCircle.Thickness = 1.5
        FOVCircle.Filled = false
        FOVCircle.Transparency = 0.7
    end
end)

-- JANTUNG UTAMA AI: Pemindai Radar Jarak Musuh Terdekat
local function AmbilMusuhTerdekat()
    local TargetMaksimum = _G.Kepignan.fov_size or 120
    local TargetTerpilih = nil
    
    local BagianTubuhTarget = _G.Kepignan.aim_bone
    if IsBloxFruits then
        BagianTubuhTarget = "HumanoidRootPart"
    elseif IsKampungKantok then
        BagianTubuhTarget = "Head"
    end
    
    for _, v in pairs(Players:GetPlayers()) do
        if v ~= LocalPlayer and v.Character and v.Character:FindFirstChild(BagianTubuhTarget) and v.Character:FindFirstChildOfClass("Humanoid") and v.Character:FindFirstChildOfClass("Humanoid").Health > 0 then
            local PosisiLayar, BeradaDiLayar = Camera:WorldToViewportPoint(v.Character[BagianTubuhTarget].Position)
            if BeradaDiLayar then
                local JarakKursor = (Vector2.new(PosisiLayar.X, PosisiLayar.Y) - UserInputService:GetMouseLocation()).Magnitude
                if JarakKursor < TargetMaksimum then
                    TargetMaksimum = JarakKursor
                    TargetTerpilih = v.Character[BagianTubuhTarget]
                end
            end
        end
    end
    return TargetTerpilih
end

-- RENDERING LOOP: Sistem Pelacak Target Otomatis Menggunakan Kamera CFrame
game:GetService("RunService").RenderStepped:Connect(function()
    local MousePos = UserInputService:GetMouseLocation()
    if FOVCircle then 
        FOVCircle.Position = MousePos 
        FOVCircle.Radius = _G.Kepignan.fov_size or 120
        FOVCircle.Visible = _G.Kepignan.fov_active
    end
    
    if _G.Kepignan.aim_active then
        local TargetMengunci = AmbilMusuhTerdekat()
        
        if TargetMengunci then
            local KecepatanRedam = _G.Kepignan.smooth_speed or 4.5
            
            if IsBloxFruits then 
                KecepatanRedam = KecepatanRedam * 0.8 
            elseif IsKampungKantok then
                KecepatanRedam = KecepatanRedam * 0.6 
            end
            
            local PosisiKameraSekarang = Camera.CFrame.Position
            local CFrameTujuan = CFrame.new(PosisiKameraSekarang, TargetMengunci.Position)
            Camera.CFrame = Camera.CFrame:Lerp(CFrameTujuan, 1 / KecepatanRedam)
        end
    end
end)

print("[B-AIM ULTRA] Seluruh skrip sistem cloud sukses berjalan. Selamat bertarung! 🔥")
