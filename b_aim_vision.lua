-- =================================================================
-- TITLE: B-AIM VISION ULTRA - MAIN LOADER HUB
-- CREDITS: Dual-Save, Pusat Kepignan, & Loader Logic oleh Kamu 😎
-- COMPATIBILITY: Multi-Device (PC, Android, iOS) 100% All Executors
-- =================================================================

print("[B-AIM LOADER] Memulai inisialisasi jaringan cloud...")

-- ─── 1. MEMANGGIL TAMPILAN VISUAL DARI LINK GITHUB ANDA ───
local StatusUI, HasilkanUI = pcall(function()
    return loadstring(game:HttpGet("https://raw.githubusercontent.com/bismaaaa20-cloud/Aimbot-Ai/refs/heads/main/b_aim_ui.lua"))()
end)

if StatusUI then
    print("[B-AIM LOADER] Sukses memuat UI dari GitHub Anda!")
else
    warn("[B-AIM ERROR] Gagal mengambil UI dari GitHub. Terjadi kesalahan: " .. tostring(HasilkanUI))
end

-- ─── 2. MENYUNTIKKAN INTEGRASI SISTEM AI & ANTI-AFK (SELALU NYALA) ───
-- Inisialisasi database global kepignan agar tersambung penuh dengan UI Anda
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

-- LOGIKA ANTI-AFK PERMANEN (Nyala terus otomatis di latar belakang)
task.spawn(function()
    local VirtualUser = game:GetService("VirtualUser")
    LocalPlayer.Idled:Connect(function()
        VirtualUser:Button2Down(Vector2.new(0,0), Camera.CFrame)
        task.wait(0.5)
        VirtualUser:Button2Up(Vector2.new(0,0), Camera.CFrame)
        print("[AI SYSTEM] Anti-AFK Aktif: Berhasil mencegah pemutusan server (Disconnect)!")
    end)
    print("[AI SYSTEM] Proteksi Anti-AFK dinyalakan secara permanen!")
end)

-- LOGIKA DETEKSI OTOMATIS GAME (Spesialis Blox Fruits)
local IsBloxFruits = false
local BloxFruitsIDs = {2753915549, 4442272125, 7449423635} -- ID Sea 1, Sea 2, Sea 3
for _, id in pairs(BloxFruitsIDs) do
    if PlaceId == id then IsBloxFruits = true break end
end

if IsBloxFruits then
    print("[AI SYSTEM] Modul Optimal Blox Fruits Aktif. Target otomatis dikunci ke tengah badan!")
else
    print("[AI SYSTEM] Mode Universal Aktif. Mengikuti kepingan setelan scrollbar UI!")
end

-- Mengaktifkan Gambar Lingkaran FOV Mengikuti Ukuran di UI Anda
local FOVCircle = nil
pcall(function()
    if Drawing then
        FOVCircle = Drawing.new("Circle")
        FOVCircle.Color = IsBloxFruits and Color3.fromRGB(255, 0, 85) or Color3.fromRGB(0, 255, 194)
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
        BagianTubuhTarget = "HumanoidRootPart" -- Dikunci ke dada agar tebasan pedang & pukulan mili 100% masuk
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

-- RENDERING LOOP: Menjalankan eksekusi tarikan bidikan secara halus (0% Lag)
game:GetService("RunService").RenderStepped:Connect(function()
    local MousePos = UserInputService:GetMouseLocation()
    if FOVCircle then 
        FOVCircle.Position = MousePos 
        FOVCircle.Radius = _G.Kepignan.fov_size or 120
        FOVCircle.Visible = _G.Kepignan.fov_active
    end
    
    if _G.Kepignan.aim_active then
        local TargetMengunci = AmbilMusuhTerdekat()
        -- Berfungsi otomatis baik ditekan (Klik Kanan PC / Shift) maupun otomatis melacak (Layar Sentuh HP)
        if TargetMengunci and (UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) or UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) or UserInputService.TouchEnabled) then
            local PosisiKameraTarget, _ = Camera:WorldToViewportPoint(TargetMengunci.Position)
            local VektorTujuan = (Vector2.new(PosisiKameraTarget.X, PosisiKameraTarget.Y) - MousePos)
            
            local KecepatanRedam = _G.Kepignan.smooth_speed or 4.5
            if IsBloxFruits then KecepatanRedam = KecepatanRedam * 0.8 end -- Dibuat lebih lincah khusus Blox Fruits
            
            mousemoverel(VektorTujuan.X / KecepatanRedam, VektorTujuan.Y / KecepatanRedam)
        end
    end
end)

print("[B-AIM ULTRA] Seluruh sistem gabungan sukses berjalan. Selamat bertarung! 🔥")
