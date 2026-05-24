-- =================================================================
-- TITLE: B-AIM VISION ULTRA - EXPANDED UI SYSTEM (PART 1 OF 3)
-- CONFIG: INITIALIZATION, SAKLAR MEMORI BARU & ANTI-DUPLIKASI PANEL
-- STATUS: TERPISAH (JANGAN DIGABUNG DENGAN SKRIP SISTEM CORE!)
-- =================================================================

_G.Kepignan = _G.Kepignan or {
    aim_active = true,
    aim_bone = "Head", 
    smooth_speed = 4.5,
    fov_active = true,
    fov_size = 120,
    target_mode = "Tim Filter", 
    target_spesifik_nama = "",   
    radar_active = true,
    esp_active = true -- VARIABEL BARU: Saklar pengontrol ON/OFF untuk Garis & HP % ESP
}

local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")

-- Menghapus UI lama agar tidak menumpuk di layar saat dijalankan ulang
if CoreGui:FindFirstChild("BAimVision_Ultra") then
    CoreGui.BAimVision_Ultra:Destroy()
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "BAimVision_Ultra"
ScreenGui.Parent = CoreGui
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- Fungsi AutoSave hemat RAM (Membatasi penulisan file ke HP agar tidak patah-patah)
local TerakhirMenyimpan = 0
local function AutoSave()
    if writefile then 
        local WaktuSekarang = tick()
        if WaktuSekarang - TerakhirMenyimpan > 0.5 then 
            TerakhirMenyimpan = WaktuSekarang
            pcall(function() 
                writefile("b_aim_kepignan.json", game:GetService("HttpService"):JSONEncode(_G.Kepignan)) 
            end) 
        end
    end
end
-- =================================================================
-- TITLE: B-AIM VISION ULTRA - EXPANDED UI SYSTEM (PART 2 OF 3)
-- CONFIG: DEKLARASI BOX UTAMA, SLIDER FOV & PENEMPATAN TOMBOL BARU ESP
-- STATUS: TERPISAH (JANGAN DIGABUNG DENGAN SKRIP SISTEM CORE!)
-- =================================================================

local LogoBtn = Instance.new("TextButton")
LogoBtn.Name = "LogoToggle"
LogoBtn.Parent = ScreenGui
LogoBtn.Size = UDim2.new(0, 48, 0, 48)
LogoBtn.Position = UDim2.new(0, 20, 0, 40)
LogoBtn.BackgroundColor3 = Color3.fromRGB(15, 23, 42)
LogoBtn.Text = "B"
LogoBtn.Font = Enum.Font.FredokaOne
LogoBtn.TextSize = 22
LogoBtn.TextColor3 = Color3.fromRGB(239, 68, 68) 
LogoBtn.AutoButtonColor = false
Instance.new("UICorner", LogoBtn).CornerRadius = UDim.new(1, 0) 

local LogoStroke = Instance.new("UIStroke", LogoBtn)
LogoStroke.Color = Color3.fromRGB(239, 68, 68) 
LogoStroke.Thickness = 2

-- PANEL UTAMA UTUH DIPERBESAR (Muat untuk menaruh Tombol Tambahan ESP Baru)
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainPanel"
MainFrame.Parent = ScreenGui
MainFrame.Size = UDim2.new(0, 420, 0, 280) 
MainFrame.Position = UDim2.new(0.5, -210, 0.5, -140)
MainFrame.BackgroundColor3 = Color3.fromRGB(11, 17, 33)
MainFrame.ClipsDescendants = true
MainFrame.Visible = true 
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 10)

local MainStroke = Instance.new("UIStroke", MainFrame)
MainStroke.Color = Color3.fromRGB(30, 41, 59)
MainStroke.Thickness = 1.5

local HeaderBar = Instance.new("Frame")
HeaderBar.Size = UDim2.new(1, 0, 0, 36)
HeaderBar.BackgroundColor3 = Color3.fromRGB(20, 30, 54)
HeaderBar.Parent = MainFrame
Instance.new("UICorner", HeaderBar).CornerRadius = UDim.new(0, 10)

local HeaderLabel = Instance.new("TextLabel")
HeaderLabel.Size = UDim2.new(0.75, 0, 1, 0)
HeaderLabel.Position = UDim2.new(0, 14, 0, 0)
HeaderLabel.BackgroundTransparency = 1
HeaderLabel.Text = "⚡ B-AIM CONTROL PANEL V3.0 (PREDICTION & AI ENGINE)"
HeaderLabel.Font = Enum.Font.GothamBold
HeaderLabel.TextSize = 10
HeaderLabel.TextColor3 = Color3.fromRGB(241, 245, 249)
HeaderLabel.TextXAlignment = Enum.TextXAlignment.Left
HeaderLabel.Parent = HeaderBar

local CloseBtn = Instance.new("TextButton")
CloseBtn.Name = "CloseMenu"
CloseBtn.Parent = HeaderBar
CloseBtn.Size = UDim2.new(0, 26, 0, 26)
CloseBtn.Position = UDim2.new(1, -34, 0, 5)
CloseBtn.BackgroundColor3 = Color3.fromRGB(30, 41, 59)
CloseBtn.Text = "×"
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 16
CloseBtn.TextColor3 = Color3.fromRGB(241, 245, 249)
CloseBtn.AutoButtonColor = false
Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(0, 6)

-- ─── FITUR KIRI: CONTROL INTERACTION SETTING ───
local ToggleAimBtn = Instance.new("TextButton")
ToggleAimBtn.Name = "ToggleAimButton"
ToggleAimBtn.Size = UDim2.new(0.42, 0, 0.14, 0)
ToggleAimBtn.Position = UDim2.new(0.04, 0, 0.18, 0)
ToggleAimBtn.BackgroundColor3 = Color3.fromRGB(20, 30, 54)
ToggleAimBtn.Text = "  AIMBOT: ACTIVE"
ToggleAimBtn.Font = Enum.Font.GothamBold
ToggleAimBtn.TextSize = 9
ToggleAimBtn.TextColor3 = Color3.fromRGB(34, 197, 94)
ToggleAimBtn.TextXAlignment = Enum.TextXAlignment.Left
ToggleAimBtn.AutoButtonColor = false
ToggleAimBtn.Parent = MainFrame
Instance.new("UICorner", ToggleAimBtn).CornerRadius = UDim.new(0, 5)

local ToggleStroke = Instance.new("UIStroke", ToggleAimBtn)
ToggleStroke.Color = Color3.fromRGB(51, 65, 85)

local IndicatorDot = Instance.new("Frame")
IndicatorDot.Size = UDim2.new(0, 8, 0, 8)
IndicatorDot.Position = UDim2.new(1, -14, 0.5, -4)
IndicatorDot.BackgroundColor3 = Color3.fromRGB(34, 197, 94)
IndicatorDot.Parent = ToggleAimBtn
Instance.new("UICorner", IndicatorDot).CornerRadius = UDim.new(1, 0)

-- VARIABEL BARU: TOMBOL SAKLAR ON/OFF ESP VISUAL & SNAPLINES
local ToggleEspBtn = Instance.new("TextButton")
ToggleEspBtn.Name = "ToggleEspButton"
ToggleEspBtn.Size = UDim2.new(0.42, 0, 0.14, 0)
ToggleEspBtn.Position = UDim2.new(0.04, 0, 0.35, 0) -- Ditaruh tepat di bawah tombol Aimbot
ToggleEspBtn.BackgroundColor3 = Color3.fromRGB(20, 30, 54)
ToggleEspBtn.Text = "  ESP SYSTEM: ACTIVE"
ToggleEspBtn.Font = Enum.Font.GothamBold
ToggleEspBtn.TextSize = 9
ToggleEspBtn.TextColor3 = Color3.fromRGB(34, 197, 94)
ToggleEspBtn.TextXAlignment = Enum.TextXAlignment.Left
ToggleEspBtn.AutoButtonColor = false
ToggleEspBtn.Parent = MainFrame
Instance.new("UICorner", ToggleEspBtn).CornerRadius = UDim.new(0, 5)

local EspStroke = Instance.new("UIStroke", ToggleEspBtn)
EspStroke.Color = Color3.fromRGB(51, 65, 85)

local EspIndicatorDot = Instance.new("Frame")
EspIndicatorDot.Size = UDim2.new(0, 8, 0, 8)
EspIndicatorDot.Position = UDim2.new(1, -14, 0.5, -4)
EspIndicatorDot.BackgroundColor3 = Color3.fromRGB(34, 197, 94)
EspIndicatorDot.Parent = ToggleEspBtn
Instance.new("UICorner", EspIndicatorDot).CornerRadius = UDim.new(1, 0)

local FovLabel = Instance.new("TextLabel")
FovLabel.Size = UDim2.new(0.42, 0, 0.1, 0)
FovLabel.Position = UDim2.new(0.04, 0, 0.54, 0)
FovLabel.BackgroundTransparency = 1
FovLabel.Text = "🎯 FOV SIZE: 120PX"
FovLabel.Font = Enum.Font.GothamBold
FovLabel.TextSize = 9
FovLabel.TextColor3 = Color3.fromRGB(148, 163, 184)
FovLabel.TextXAlignment = Enum.TextXAlignment.Left
FovLabel.Parent = MainFrame

local SliderFrame = Instance.new("TextButton")
SliderFrame.Size = UDim2.new(0.42, 0, 0.04, 0)
SliderFrame.Position = UDim2.new(0.04, 0, 0.66, 0)
SliderFrame.BackgroundColor3 = Color3.fromRGB(20, 30, 54)
SliderFrame.Text = ""
SliderFrame.AutoButtonColor = false
SliderFrame.Parent = MainFrame
Instance.new("UICorner", SliderFrame).CornerRadius = UDim.new(0, 3)

local SliderProgress = Instance.new("Frame")
SliderProgress.Size = UDim2.new(0.4, 0, 1, 0)
SliderProgress.BackgroundColor3 = Color3.fromRGB(14, 165, 233)
SliderProgress.BorderSizePixel = 0
SliderProgress.Parent = SliderFrame
Instance.new("UICorner", SliderProgress).CornerRadius = UDim.new(0, 3)

-- ─── FITUR KANAN: LIST STRATEGI SCROLL BAR DAFTAR NAMA TARGET ───
local TaktikLabel = Instance.new("TextLabel")
TaktikLabel.Size = UDim2.new(0.48, 0, 0.08, 0)
TaktikLabel.Position = UDim2.new(0.49, 0, 0.18, 0)
TaktikLabel.BackgroundTransparency = 1
TaktikLabel.Text = "⚙️ STRATEGI RADAR & TARGET INTEL"
TaktikLabel.Font = Enum.Font.GothamBold
TaktikLabel.TextSize = 9
TaktikLabel.TextColor3 = Color3.fromRGB(14, 165, 233)
TaktikLabel.TextXAlignment = Enum.TextXAlignment.Left
TaktikLabel.Parent = MainFrame

local TaktikScroll = Instance.new("ScrollingFrame")
TaktikScroll.Size = UDim2.new(0.48, 0, 0.64, 0)
TaktikScroll.Position = UDim2.new(0.49, 0, 0.28, 0)
TaktikScroll.BackgroundColor3 = Color3.fromRGB(20, 30, 54)
TaktikScroll.CanvasSize = UDim2.new(0, 0, 0, 350) 
TaktikScroll.ScrollBarThickness = 5
TaktikScroll.ScrollBarImageColor3 = Color3.fromRGB(14, 165, 233)
TaktikScroll.BorderSizePixel = 0
TaktikScroll.Parent = MainFrame
Instance.new("UICorner", TaktikScroll).CornerRadius = UDim.new(0, 6)

local ScrollStroke = Instance.new("UIStroke", TaktikScroll)
ScrollStroke.Color = Color3.fromRGB(51, 65, 85)

local ModeBtn = Instance.new("TextButton")
ModeBtn.Size = UDim2.new(0.92, 0, 0, 30)
ModeBtn.Position = UDim2.new(0.04, 0, 0, 6)
ModeBtn.BackgroundColor3 = Color3.fromRGB(11, 17, 33)
ModeBtn.Text = "STRATEGI: TIM FILTER"
ModeBtn.Font = Enum.Font.GothamBold
ModeBtn.TextSize = 8
ModeBtn.TextColor3 = Color3.fromRGB(34, 197, 94)
ModeBtn.TextWrapped = true
ModeBtn.Parent = TaktikScroll
Instance.new("UICorner", ModeBtn).CornerRadius = UDim.new(0, 5)

local ModeStroke = Instance.new("UIStroke", ModeBtn)
ModeStroke.Color = Color3.fromRGB(30, 41, 59)
-- =================================================================
-- TITLE: B-AIM VISION ULTRA - EXPANDED UI SYSTEM (PART 3 OF 3)
-- CONFIG: DETEKSI KLIK RADAR PEMAIN, SERET LOGO B & SINKRONISASI SLIDER HP
-- STATUS: TERPISAH (JANGAN DIGABUNG DENGAN SKRIP UI!)
-- =================================================================

local RadarListFrame = Instance.new("Frame")
RadarListFrame.Size = UDim2.new(0.92, 0, 0, 290)
RadarListFrame.Position = UDim2.new(0.04, 0, 0, 42)
RadarListFrame.BackgroundColor3 = Color3.fromRGB(11, 17, 33)
RadarListFrame.Parent = TaktikScroll
Instance.new("UICorner", RadarListFrame).CornerRadius = UDim.new(0, 5)

local UIListLayout = Instance.new("UIListLayout", RadarListFrame)
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Padding = UDim.new(0, 4)

local CreditLabel = Instance.new("TextLabel")
CreditLabel.Size = UDim2.new(1, -14, 0, 12)
CreditLabel.Position = UDim2.new(0, 0, 0.94, 0)
CreditLabel.BackgroundTransparency = 1
CreditLabel.Text = "B-AIM AI CORE PROJECT • 2026"
CreditLabel.Font = Enum.Font.GothamMedium
CreditLabel.TextSize = 7
CreditLabel.TextColor3 = Color3.fromRGB(71, 85, 105)
CreditLabel.TextXAlignment = Enum.TextXAlignment.Right
CreditLabel.Parent = MainFrame

-- ─── SAKLAR SIKLUS 3 PILIHAN MODUL TAKTIK TARGET ───
ModeBtn.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        if _G.Kepignan.target_mode == "Tim Filter" then
            _G.Kepignan.target_mode = "Semua Terdekat (FFA)"
            ModeBtn.Text = "STRATEGI: SEMUA TERDEKAT (FFA)"
            ModeBtn.TextColor3 = Color3.fromRGB(249, 115, 22) -- Oranye Neon
        elseif _G.Kepignan.target_mode == "Semua Terdekat (FFA)" then
            _G.Kepignan.target_mode = "Spesifik Target (5s)"
            if _G.Kepignan.target_spesifik_nama ~= "" then
                ModeBtn.Text = "LOCK: " .. _G.Kepignan.target_spesifik_nama:sub(1,12)
            else
                ModeBtn.Text = "STRATEGI: KLIK NAMA DI BAWAH"
            end
            ModeBtn.TextColor3 = Color3.fromRGB(239, 68, 68) -- Merah Target
        else
            _G.Kepignan.target_mode = "Tim Filter"
            ModeBtn.Text = "STRATEGI: TIM FILTER"
            ModeBtn.TextColor3 = Color3.fromRGB(34, 197, 94) -- Hijau Kawan
        end
        AutoSave()
    end
end)

-- ─── PENGECEKAN KLIK DAFTAR NAMA PEMAIN SERVER (PILIHAN 1) ───
local function PerbaruiDaftarRadar()
    for _, child in pairs(RadarListFrame:GetChildren()) do
        if child:IsA("TextButton") then child:Destroy() end
    end
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= Players.LocalPlayer then
            local PlayerRow = Instance.new("TextButton")
            PlayerRow.Size = UDim2.new(1, 0, 0, 22)
            PlayerRow.BackgroundColor3 = Color3.fromRGB(20, 30, 54)
            PlayerRow.Text = "  " .. p.DisplayName .. " (@" .. p.Name .. ")"
            PlayerRow.Font = Enum.Font.GothamMedium
            PlayerRow.TextSize = 8
            PlayerRow.TextColor3 = (_G.Kepignan.target_spesifik_nama == p.Name) and Color3.fromRGB(239, 68, 68) or Color3.fromRGB(148, 163, 184)
            PlayerRow.TextXAlignment = Enum.TextXAlignment.Left
            PlayerRow.Parent = RadarListFrame
            Instance.new("UICorner", PlayerRow).CornerRadius = UDim.new(0, 4)
            
            PlayerRow.InputBegan:Connect(function(rowInput)
                if rowInput.UserInputType == Enum.UserInputType.MouseButton1 or rowInput.UserInputType == Enum.UserInputType.Touch then
                    _G.Kepignan.target_spesifik_nama = p.Name
                    _G.Kepignan.target_mode = "Spesifik Target (5s)"
                    ModeBtn.Text = "LOCK: " .. p.Name:sub(1,12)
                    ModeBtn.TextColor3 = Color3.fromRGB(239, 68, 68)
                    PerbaruiDaftarRadar()
                    AutoSave()
                end
            end)
        end
    end
end

task.spawn(function()
    while true do
        PerbaruiDaftarRadar()
        task.wait(5) -- Sinkronisasi melacak target baru di server setiap 5 detik
    end
end)

-- ─── SAKLAR TOMBOL INTERAKSI ESP ON/OFF UTAMA ───
ToggleEspBtn.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        _G.Kepignan.esp_active = not _G.Kepignan.esp_active
        if _G.Kepignan.esp_active then
            ToggleEspBtn.Text = "  ESP SYSTEM: ACTIVE"
            ToggleEspBtn.TextColor3 = Color3.fromRGB(34, 197, 94)
            EspIndicatorDot.BackgroundColor3 = Color3.fromRGB(34, 197, 94)
        else
            ToggleEspBtn.Text = "  ESP SYSTEM: DISABLED"
            ToggleEspBtn.TextColor3 = Color3.fromRGB(239, 68, 68)
            EspIndicatorDot.BackgroundColor3 = Color3.fromRGB(239, 68, 68)
        end
        AutoSave()
    end
end)

-- ─── LOGIKA SAKLAR TEMPUR: ON/OFF AIMBOT ───
ToggleAimBtn.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        _G.Kepignan.aim_active = not _G.Kepignan.aim_active
        if _G.Kepignan.aim_active then
            ToggleAimBtn.Text = "  AIMBOT: ACTIVE"
            ToggleAimBtn.TextColor3 = Color3.fromRGB(34, 197, 94)
            IndicatorDot.BackgroundColor3 = Color3.fromRGB(34, 197, 94)
        else
            ToggleAimBtn.Text = "  AIMBOT: DISABLED"
            ToggleAimBtn.TextColor3 = Color3.fromRGB(239, 68, 68)
            IndicatorDot.BackgroundColor3 = Color3.fromRGB(239, 68, 68)
        end
        AutoSave()
    end
end)

-- ─── FIXED SLIDER SINKRONISASI LUAS FOV ANTI-LAG DI HP ───
local MenggeserSlider = false
local function UpdateSlider(InputObject)
    local RelativeX = InputObject.Position.X - SliderFrame.AbsolutePosition.X
    local Persentase = math.clamp(RelativeX / SliderFrame.AbsoluteSize.X, 0, 1)
    SliderProgress.Size = UDim2.new(Persentase, 0, 1, 0)
    _G.Kepignan.fov_size = math.round(10 + (Persentase * 290))
    FovLabel.Text = "🎯 FOV SIZE: " .. tostring(_G.Kepignan.fov_size) .. "PX"
end

SliderFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        MenggeserSlider = true
        UpdateSlider(input)
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if MenggeserSlider and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        UpdateSlider(input)
    end
end)

SliderFrame.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        if MenggeserSlider then
            MenggeserSlider = false
            AutoSave()
        end
    end
end)

-- ─── SENSOR GERAKAN SERET (DRAG MENU & LOGO B) ───
local IsMinimized = false
local function AktifkanFiturDrag(GuiObject, IsLogo)
    local dragging, dragInput, dragStart, startPos
    local IsMoving = false
    local TouchStartTime = 0

    GuiObject.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            IsMoving = false
            TouchStartTime = tick()
            dragStart = input.Position
            startPos = GuiObject.Position
        end
    end)

    GuiObject.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            if delta.Magnitude > 10 then IsMoving = true end
            GuiObject.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)

    GuiObject.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
            local TouchDuration = tick() - TouchStartTime
            if IsLogo and not IsMoving and TouchDuration < 0.4 then
                MainFrame.Visible = not MainFrame.Visible
            end
        end
    end)
end

AktifkanFiturDrag(LogoBtn, true)
AktifkanFiturDrag(MainFrame, false)

CloseBtn.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        if not IsMinimized then
            IsMinimized = true
            CloseBtn.Text = "+"
            TweenService:Create(MainFrame, TweenInfo.new(0.2, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Size = UDim2.new(0, 420, 0, 36)}):Play()
        else
            IsMinimized = false
            CloseBtn.Text = "×"
            TweenService:Create(MainFrame, TweenInfo.new(0.2, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Size = UDim2.new(0, 420, 0, 280)}):Play()
        end
    end
end)

print("[B-AIM ULTRA] Seluruh Kode Antarmuka UI Komplet Terpasang! 🔥")
