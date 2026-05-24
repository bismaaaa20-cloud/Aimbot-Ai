-- =================================================================
-- TITLE: B-AIM VISION ULTRA V3.0 - EXCLUSIVE UI SYSTEM (PART 1 OF 4)
-- CONFIG: MEMORY AUTO-LOAD, SCREEN LAYER & LOGO TOGGLE SETUP
-- STATUS: TERPISAH (JANGAN DIGABUNG DENGAN SCRIPT SISTEM CORE!)
-- =================================================================

print("[B-AIM UI] Memulai pemuatan visual antarmuka bagian 1...")

-- ─── 1. SINKRONISASI KONFIGURASI MEMORI DATA GLOBAL ───
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

local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")

-- Pembersihan Instan (Mencegah Duplikasi Tampilan Panel)
if CoreGui:FindFirstChild("BAimVision_Ultra") then
    CoreGui.BAimVision_Ultra:Destroy()
end

-- Membuat Objek Layer Utama ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "BAimVision_Ultra"
ScreenGui.Parent = CoreGui
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- Fungsi Simpan Otomatis Konfigurasi ke Storage Luar
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

-- ─── 2. SAKLAR LAYAR LOGO TOGGLE "B" MOBILE & PC ───
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
-- =================================================================
-- TITLE: B-AIM VISION ULTRA V3.0 - EXCLUSIVE UI SYSTEM (PART 2 OF 4)
-- CONFIG: CONTROL PANEL FRAME, AIMBOT SWITCH & NEW ESP TOGGLE BUTTON
-- STATUS: TERPISAH (JANGAN DIGABUNG DENGAN SCRIPT SISTEM CORE!)
-- =================================================================

-- ─── 3. DEKLARASI BINGKAI UTAMA CONTROL PANEL (420 X 280) ───
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

-- ─── 4. TOMBOL INTERAKSI PANEL SEBELAH KIRI ───
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

-- SAKLAR ON/OFF FITUR VISUAL ESP & SNAPLINES
local ToggleEspBtn = Instance.new("TextButton")
ToggleEspBtn.Name = "ToggleEspButton"
ToggleEspBtn.Size = UDim2.new(0.42, 0, 0.14, 0)
ToggleEspBtn.Position = UDim2.new(0.04, 0, 0.35, 0) 
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
-- =================================================================
-- TITLE: B-AIM VISION ULTRA V3.0 - EXCLUSIVE UI SYSTEM (PART 3 OF 4)
-- CONFIG: FOV SLIDER MOUNT, TACTICAL SCROLL RADAR & CREDIT TAG
-- STATUS: TERPISAH (JANGAN DIGABUNG DENGAN SCRIPT SISTEM CORE!)
-- =================================================================

-- ─── 5. PENYUSUNAN SLIDER UKURAN AREA LUAS FOV ───
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

-- ─── 6. DESAIN STRATEGI BOX RADAR SEBELAH KANAN ───
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
-- =================================================================
-- TITLE: B-AIM VISION ULTRA V3.0 - EXCLUSIVE UI SYSTEM (PART 4 OF 4)
-- CONFIG: 5s PASSIVE SYNCHRONIZER, INPUT SLIDER, DRAG & SNAPLINES
-- STATUS: TERPISAH (JANGAN DIGABUNG DENGAN SCRIPT SISTEM CORE!)
-- =================================================================

-- ─── 7. SAKLAR SIKLUS PILIHAN MODUL TAKTIK TARGET ───
ModeBtn.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        if _G.Kepignan.target_mode == "Tim Filter" then
            _G.Kepignan.target_mode = "Semua Terdekat (FFA)"
            ModeBtn.Text = "STRATEGI: SEMUA TERDEKAT (FFA)"
            ModeBtn.TextColor3 = Color3.fromRGB(249, 115, 22)
        elseif _G.Kepignan.target_mode == "Semua Terdekat (FFA)" then
            _G.Kepignan.target_mode = "Spesifik Target (5s)"
            ModeBtn.Text = (_G.Kepignan.target_spesifik_nama ~= "") and "LOCK: " .. _G.Kepignan.target_spesifik_nama:sub(1,12) or "STRATEGI: KLIK NAMA DI BAWAH"
            ModeBtn.TextColor3 = Color3.fromRGB(239, 68, 68)
        else
            _G.Kepignan.target_mode = "Tim Filter"
            ModeBtn.Text = "STRATEGI: TIM FILTER"
            ModeBtn.TextColor3 = Color3.fromRGB(34, 197, 94)
        end
        AutoSave()
    end
end)

-- ─── 8. SYSTEM RADAR SINKRONISASI PINTAR LIMA DETIK (ANTI-LAG) ───
local RowPemainCache = {}

local function RefreshRowVisuals()
    for pName, row in pairs(RowPemainCache) do
        if row and row.Parent then
            row.TextColor3 = (_G.Kepignan.target_spesifik_nama == pName) and Color3.fromRGB(239, 68, 68) or Color3.fromRGB(148, 163, 184)
        end
    end
end

local function SinkronisasiRadarLimaDetik()
    local PemainAktifLayar = {}
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= Players.LocalPlayer then
            PemainAktifLayar[p.Name] = true
            if not RowPemainCache[p.Name] then
                local PlayerRow = Instance.new("TextButton", RadarListFrame)
                PlayerRow.Size = UDim2.new(1, 0, 0, 22) PlayerRow.BackgroundColor3 = Color3.fromRGB(20, 30, 54)
                PlayerRow.Text = "  " .. p.DisplayName .. " (@" .. p.Name .. ")" PlayerRow.Font = Enum.Font.GothamMedium PlayerRow.TextSize = 8 PlayerRow.TextXAlignment = Enum.TextXAlignment.Left
                Instance.new("UICorner", PlayerRow).CornerRadius = UDim.new(0, 4)
                
                PlayerRow.InputBegan:Connect(function(rowInput)
                    if rowInput.UserInputType == Enum.UserInputType.MouseButton1 or rowInput.UserInputType == Enum.UserInputType.Touch then
                        _G.Kepignan.target_spesifik_nama = p.Name
                        _G.Kepignan.target_mode = "Spesifik Target (5s)"
                        ModeBtn.Text = "LOCK: " .. p.Name:sub(1,12)
                        ModeBtn.TextColor3 = Color3.fromRGB(239, 68, 68)
                        RefreshRowVisuals() AutoSave()
                    end
                end)
                RowPemainCache[p.Name] = PlayerRow
            end
        end
    end
    for pName, row in pairs(RowPemainCache) do
        if not PemainAktifLayar[pName] then
            if row then row:Destroy() end RowPemainCache[pName] = nil
            if _G.Kepignan.target_spesifik_nama == pName then
                _G.Kepignan.target_spesifik_nama = "" _G.Kepignan.target_mode = "Tim Filter"
                ModeBtn.Text = "STRATEGI: TIM FILTER" ModeBtn.TextColor3 = Color3.fromRGB(34, 197, 94)
            end
        end
    end
    RefreshRowVisuals()
end
task.spawn(function() while true do pcall(SinkronisasiRadarLimaDetik) task.wait(5) end end)

-- ─── 9. INTEGRASI UTAMA KLIK SAKLAR BUTTON INTERACTIVE ───
ToggleEspBtn.InputBegan:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
        _G.Kepignan.esp_active = not _G.Kepignan.esp_active
        ToggleEspBtn.Text = _G.Kepignan.esp_active and "  ESP SYSTEM: ACTIVE" or "  ESP SYSTEM: DISABLED"
        ToggleEspBtn.TextColor3 = _G.Kepignan.esp_active and Color3.fromRGB(34, 197, 94) or Color3.fromRGB(239, 68, 68)
        EspIndicatorDot.BackgroundColor3 = _G.Kepignan.esp_active and Color3.fromRGB(34, 197, 94) or Color3.fromRGB(239, 68, 68) AutoSave()
    end
end)

ToggleAimBtn.InputBegan:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
        _G.Kepignan.aim_active = not _G.Kepignan.aim_active
        ToggleAimBtn.Text = _G.Kepignan.aim_active and "  AIMBOT: ACTIVE" or "  AIMBOT: DISABLED"
        ToggleAimBtn.TextColor3 = _G.Kepignan.aim_active and Color3.fromRGB(34, 197, 94) or Color3.fromRGB(239, 68, 68)
        IndicatorDot.BackgroundColor3 = _G.Kepignan.aim_active and Color3.fromRGB(34, 197, 94) or Color3.fromRGB(239, 68, 68) AutoSave()
    end
end)

-- FOV REGULATION INDEPENDENT SLIDER
local MenggeserSlider = false
local function UpdateSlider(InputObject)
    local Persentase = math.clamp((InputObject.Position.X - SliderFrame.AbsolutePosition.X) / SliderFrame.AbsoluteSize.X, 0, 1)
    SliderProgress.Size = UDim2.new(Persentase, 0, 1, 0) _G.Kepignan.fov_size = math.round(10 + (Persentase * 290))
    FovLabel.Text = "🎯 FOV SIZE: " .. tostring(_G.Kepignan.fov_size) .. "PX"
end
SliderFrame.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then MenggeserSlider = true UpdateSlider(i) end end)
UserInputService.InputChanged:Connect(function(i) if MenggeserSlider and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then UpdateSlider(i) end end)
SliderFrame.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then if MenggeserSlider then MenggeserSlider = false AutoSave() end end end)

-- ─── 10. SYSTEM GESTURE DRAG CONTROL PANEL PANEL (PC / MOBILE TOUCH) ───
local function AktifkanFiturDrag(GuiObject, IsLogo)
    local dragging, dragStart, startPos, IsMoving, TouchStartTime = false, nil, nil, false, 0
    GuiObject.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then dragging, IsMoving, TouchStartTime, dragStart, startPos = true, false, tick(), i.Position, GuiObject.Position end end)
    GuiObject.InputChanged:Connect(function(i) if dragging and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then local delta = i.Position - dragStart if delta.Magnitude > 10 then IsMoving = true end GuiObject.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y) end end)
    GuiObject.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then dragging = false if IsLogo and not IsMoving and (tick() - TouchStartTime) < 0.4 then MainFrame.Visible = not MainFrame.Visible end end end)
end
AktifkanFiturDrag(LogoBtn, true) AktifkanFiturDrag(MainFrame, false)

CloseBtn.InputBegan:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
        IsMinimized = not IsMinimized CloseBtn.Text = IsMinimized and "+" or "×"
        TweenService:Create(MainFrame, TweenInfo.new(0.2, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Size = IsMinimized and UDim2.new(0, 420, 0, 36) or UDim2.new(0, 420, 0, 280)}):Play()
    end
end)

-- ─── 11. SISTEM DRAWING ENGINE SNAPLINES VISUAL ESP ───
local Camera = workspace.CurrentCamera
local MemoriGarisPemain = {}

local function BuatGarisPelacak()
    local GarapLine = Drawing.new("Line")
    GarapLine.Thickness = 1 GarapLine.Transparency = 0.8 GarapLine.Visible = false return GarapLine
end

local function AmbilWarnaESP(Player)
    local ModeSaatIni = _G.Kepignan.target_mode or "Tim Filter"
    if ModeSaatIni == "Spesifik Target (5s)" then
        if Player.Name == _G.Kepignan.target_spesifik_nama then return Color3.fromRGB(239, 68, 68) end
        return Color3.fromRGB(148, 163, 184)
    end
    if ModeSaatIni == "Semua Terdekat (FFA)" then return Color3.fromRGB(249, 115, 22) end
    if _G.BAim_Global_Traitors[Player.Name] then return Color3.fromRGB(239, 68, 68) end
    if Players.LocalPlayer.Neutral or Player.Neutral or (Player.Team ~= Players.LocalPlayer.Team) then return Color3.fromRGB(239, 68, 68) end
    return Color3.fromRGB(34, 197, 94)
end

RunService.RenderStepped:Connect(function()
    local TitikBawahLayar = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y)
    for _, p in pairs(Players:GetPlayers()) do
        local Garis = MemoriGarisPemain[p.Name]
        if _G.Kepignan.esp_active and p ~= Players.LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            local Humanoid = p.Character:FindFirstChildOfClass("Humanoid")
            if Humanoid and Humanoid.Health > 0 then
                local PosisiLayar, BeradaDiLayar = Camera:WorldToViewportPoint(p.Character.HumanoidRootPart.Position)
                if BeradaDiLayar then
                    if not Garis then Garis = BuatGarisPelacak() MemoriGarisPemain[p.Name] = Garis end
                    Garis.From = TitikBawahLayar Garis.To = Vector2.new(PosisiLayar.X, PosisiLayar.Y)
                    Garis.Color = AmbilWarnaESP(p) Garis.Visible = true
                    continue
                end
            end
        end
        if Garis then Garis.Visible = false end
    end
end)

-- GANTI BAGIAN PALING BAWAH DI SKRIP UI PART 4 DENGAN KODE RAPI INI:

-- ─── 12. CLEANUP MEMORI OTOMATIS SAAT PEMAIN KELUAR SERVER ───
Players.PlayerRemoving:Connect(function(p) 
    if MemoriGarisPemain[p.Name] then 
        MemoriGarisPemain[p.Name]:Destroy() 
        MemoriGarisPemain[p.Name] = nil 
    end
    print("[B-AIM UI] Pembersihan memori untuk @" .. p.Name .. " selesai.")
end)

print("[B-AIM UI] Seluruh Modul Antarmuka Panel Komplet Terpasang Mandiri! 🔥")
