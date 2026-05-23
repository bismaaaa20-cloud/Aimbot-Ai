-- 1. Tabel Setelan Global (Data State)
_G.Kepignan = _G.Kepignan or {
    aim_active = true,
    aim_bone = "Head", 
    smooth_speed = 4.5,
    fov_active = true,
    fov_size = 120
}

-- 2. Pemanggilan Roblox Service & Pembersihan UI Lama
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

if CoreGui:FindFirstChild("BAimVision_Ultra") then
    CoreGui.BAimVision_Ultra:Destroy()
end

-- 3. Wadah Utama UI ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "BAimVision_Ultra"
ScreenGui.Parent = CoreGui
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- 4. Fungsi Sistem Auto-Save Berkas JSON
local function AutoSave()
    if writefile then 
        pcall(function() 
            writefile("b_aim_kepignan.json", game:GetService("HttpService"):JSONEncode(_G.Kepignan)) 
        end) 
    end
end
-- 1. TOMBOL LOGO MINI [B] BULAT GLOW
local LogoBtn = Instance.new("TextButton")
LogoBtn.Name = "LogoToggle"
LogoBtn.Parent = ScreenGui
LogoBtn.Size = UDim2.new(0, 52, 0, 52)
LogoBtn.Position = UDim2.new(0, 30, 0, 80)
LogoBtn.BackgroundColor3 = Color3.fromRGB(15, 23, 42)
LogoBtn.Text = "B"
LogoBtn.Font = Enum.Font.FredokaOne
LogoBtn.TextSize = 24
LogoBtn.TextColor3 = Color3.fromRGB(34, 197, 94)
LogoBtn.AutoButtonColor = false
Instance.new("UICorner", LogoBtn).CornerRadius = UDim.new(1, 0) 

local LogoStroke = Instance.new("UIStroke")
LogoStroke.Color = Color3.fromRGB(14, 165, 233)
LogoStroke.Thickness = 2.5
LogoStroke.Parent = LogoBtn

-- 2. KOTAK UI UTAMA (DI-PERPANJANG KE SAMPING)
local MainFrame = Instance.new("Frame")
MainFrame.Parent = ScreenGui
MainFrame.Size = UDim2.new(0, 540, 0, 260)
MainFrame.Position = UDim2.new(0.5, -270, 0.5, -130)
MainFrame.BackgroundColor3 = Color3.fromRGB(11, 17, 33)
MainFrame.ClipsDescendants = true
MainFrame.Visible = false
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 12)

local MainStroke = Instance.new("UIStroke")
MainStroke.Color = Color3.fromRGB(30, 41, 59)
MainStroke.Thickness = 1.8
MainStroke.Parent = MainFrame

-- 3. BAR HEADER ATAS & JUDUL MENU
local HeaderBar = Instance.new("Frame")
HeaderBar.Size = UDim2.new(1, 0, 0, 45)
HeaderBar.BackgroundColor3 = Color3.fromRGB(20, 30, 54)
HeaderBar.Parent = MainFrame
Instance.new("UICorner", HeaderBar).CornerRadius = UDim.new(0, 12)

local HeaderFix = Instance.new("Frame")
HeaderFix.Size = UDim2.new(1, 0, 0, 12)
HeaderFix.Position = UDim2.new(0, 0, 1, -12)
HeaderFix.BackgroundColor3 = Color3.fromRGB(20, 30, 54)
HeaderFix.BorderSizePixel = 0
HeaderFix.Parent = HeaderBar

local HeaderLabel = Instance.new("TextLabel")
HeaderLabel.Size = UDim2.new(1, -50, 1, 0)
HeaderLabel.Position = UDim2.new(0, 18, 0, 0)
HeaderLabel.BackgroundTransparency = 1
HeaderLabel.Text = "⚡ B-AIM CONTROL PANEL // PREMIUM VISUAL INTERFACE"
HeaderLabel.Font = Enum.Font.GothamBold
HeaderLabel.TextSize = 12
HeaderLabel.TextColor3 = Color3.fromRGB(241, 245, 249)
HeaderLabel.TextXAlignment = Enum.TextXAlignment.Left
HeaderLabel.Parent = HeaderBar

-- 4. TOMBOL SILANG UTK MENUTUP [X]
local CloseBtn = Instance.new("TextButton")
CloseBtn.Name = "CloseMenu"
CloseBtn.Parent = HeaderBar
CloseBtn.Size = UDim2.new(0, 32, 0, 32)
CloseBtn.Position = UDim2.new(1, -42, 0, 6)
CloseBtn.BackgroundColor3 = Color3.fromRGB(30, 41, 59)
CloseBtn.Text = "×"
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 20
CloseBtn.TextColor3 = Color3.fromRGB(241, 245, 249)
CloseBtn.AutoButtonColor = false
Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(0, 8)
local CloseStroke = Instance.new("UIStroke")
CloseStroke.Color = Color3.fromRGB(51, 65, 85)
CloseStroke.Parent = CloseBtn

-- 5. CONTAINER KIRI (TOMBOL INDIKATOR & SLIDER)
local LeftContainer = Instance.new("Frame")
LeftContainer.Size = UDim2.new(0, 240, 1, -65)
LeftContainer.Position = UDim2.new(0, 18, 0, 60)
LeftContainer.BackgroundTransparency = 1
LeftContainer.Parent = MainFrame

local LeftLayout = Instance.new("UIListLayout")
LeftLayout.Spacing = UDim.new(0, 18)
LeftLayout.Parent = LeftContainer

local ToggleAimBtn = Instance.new("TextButton")
ToggleAimBtn.Size = UDim2.new(1, 0, 0, 42)
ToggleAimBtn.BackgroundColor3 = Color3.fromRGB(20, 30, 54)
ToggleAimBtn.Text = "   AIMBOT STATUS: ACTIVE"
ToggleAimBtn.Font = Enum.Font.GothamBold
ToggleAimBtn.TextSize = 11
ToggleAimBtn.TextColor3 = Color3.fromRGB(34, 197, 94)
ToggleAimBtn.TextXAlignment = Enum.TextXAlignment.Left
ToggleAimBtn.AutoButtonColor = false
ToggleAimBtn.Parent = LeftContainer
Instance.new("UICorner", ToggleAimBtn).CornerRadius = UDim.new(0, 8)
local ToggleStroke = Instance.new("UIStroke")
ToggleStroke.Color = Color3.fromRGB(51, 65, 85)
ToggleStroke.Parent = ToggleAimBtn

local IndicatorDot = Instance.new("Frame")
IndicatorDot.Size = UDim2.new(0, 10, 0, 10)
IndicatorDot.Position = UDim2.new(1, -24, 0.5, -5)
IndicatorDot.BackgroundColor3 = Color3.fromRGB(34, 197, 94)
IndicatorDot.Parent = ToggleAimBtn
Instance.new("UICorner", IndicatorDot).CornerRadius = UDim.new(1, 0)

local FovWrapper = Instance.new("Frame")
FovWrapper.Size = UDim2.new(1, 0, 0, 60)
FovWrapper.BackgroundTransparency = 1
FovWrapper.Parent = LeftContainer

local FovLabel = Instance.new("TextLabel")
FovLabel.Size = UDim2.new(1, 0, 0, 22)
FovLabel.BackgroundTransparency = 1
FovLabel.Text = "🎯 INTERACTIVE FIELD OF VIEW: 120PX"
FovLabel.Font = Enum.Font.GothamBold
FovLabel.TextSize = 11
FovLabel.TextColor3 = Color3.fromRGB(148, 163, 184)
FovLabel.TextXAlignment = Enum.TextXAlignment.Left
FovLabel.Parent = FovWrapper

local SliderFrame = Instance.new("TextButton")
SliderFrame.Size = UDim2.new(1, 0, 0, 10)
SliderFrame.Position = UDim2.new(0, 0, 0, 32)
SliderFrame.BackgroundColor3 = Color3.fromRGB(20, 30, 54)
SliderFrame.Text = ""
SliderFrame.AutoButtonColor = false
SliderFrame.Parent = FovWrapper
Instance.new("UICorner", SliderFrame).CornerRadius = UDim.new(0, 5)

local SliderProgress = Instance.new("Frame")
SliderProgress.Size = UDim2.new(0.4, 0, 1, 0)
SliderProgress.BackgroundColor3 = Color3.fromRGB(14, 165, 233)
SliderProgress.Parent = SliderFrame
Instance.new("UICorner", SliderProgress).CornerRadius = UDim.new(0, 5)

-- 6. CONTAINER KANAN (DAFTAR SCROLL TARGET BONE musuh)
local RightContainer = Instance.new("Frame")
RightContainer.Size = UDim2.new(0, 245, 1, -75)
RightContainer.Position = UDim2.new(1, -263, 0, 60)
RightContainer.BackgroundTransparency = 1
RightContainer.Parent = MainFrame

local ScrollLabel = Instance.new("TextLabel")
ScrollLabel.Size = UDim2.new(1, 0, 0, 22)
ScrollLabel.BackgroundTransparency = 1
ScrollLabel.Text = "🛡️ SELECTED TARGET BONE: HEAD"
ScrollLabel.Font = Enum.Font.GothamBold
ScrollLabel.TextSize = 11
ScrollLabel.TextColor3 = Color3.fromRGB(14, 165, 233)
ScrollLabel.TextXAlignment = Enum.TextXAlignment.Left
ScrollLabel.Parent = RightContainer

local ScrollingFrame = Instance.new("ScrollingFrame")
ScrollingFrame.Size = UDim2.new(1, 0, 1, -25)
ScrollingFrame.Position = UDim2.new(0, 0, 0, 25)
ScrollingFrame.BackgroundColor3 = Color3.fromRGB(20, 30, 54)
ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 140)
ScrollingFrame.ScrollBarThickness = 4
ScrollingFrame.ScrollBarImageColor3 = Color3.fromRGB(14, 165, 233)
ScrollingFrame.BorderSizePixel = 0
ScrollingFrame.Parent = RightContainer
Instance.new("UICorner", ScrollingFrame).CornerRadius = UDim.new(0, 8)
local ScrollStroke = Instance.new("UIStroke")
ScrollStroke.Color = Color3.fromRGB(51, 65, 85)
ScrollStroke.Parent = ScrollingFrame

local ScrollPadding = Instance.new("UIPadding")
ScrollPadding.PaddingTop = UDim.new(0, 8)
ScrollPadding.PaddingLeft = UDim.new(0, 8)
ScrollPadding.PaddingRight = UDim.new(0, 8)
ScrollPadding.Parent = ScrollingFrame

local ScrollList = Instance.new("UIListLayout")
ScrollList.Spacing = UDim.new(0, 6)
ScrollList.Parent = ScrollingFrame

local function BuatPilihanTarget(teks_layar, bone_roblox)
    local Btn = Instance.new("TextButton")
    Btn.Size = UDim2.new(1, 0, 0, 36)
    Btn.BackgroundColor3 = Color3.fromRGB(11, 17, 33)
    Btn.Text = teks_layar
    Btn.Font = Enum.Font.GothamBold
    Btn.TextSize = 11
    Btn.TextColor3 = Color3.fromRGB(148, 163, 184)
    Btn.AutoButtonColor = false
    Btn.Parent = ScrollingFrame
    Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 6)
    local BtnStroke = Instance.new("UIStroke")
    BtnStroke.Color = Color3.fromRGB(30, 41, 59)
    BtnStroke.Parent = Btn

    Btn.MouseEnter:Connect(function()
        TweenService:Create(Btn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(20, 30, 54), TextColor3 = Color3.fromRGB(241, 245, 249)}):Play()
        TweenService:Create(BtnStroke, TweenInfo.new(0.15), {Color = Color3.fromRGB(14, 165, 233)}):Play()
    end)
    Btn.MouseLeave:Connect(function()
        TweenService:Create(Btn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(11, 17, 33), TextColor3 = Color3.fromRGB(148, 163, 184)}):Play()
        TweenService:Create(BtnStroke, TweenInfo.new(0.15), {Color = Color3.fromRGB(30, 41, 59)}):Play()
    end)

    Btn.MouseButton1Click:Connect(function()
        _G.Kepignan.aim_bone = bone_roblox
        ScrollLabel.Text = "🛡️ SELECTED TARGET BONE: " .. string.upper(bone_roblox)
        AutoSave()
        TweenService:Create(Btn, TweenInfo.new(0.05), {TextColor3 = Color3.fromRGB(34, 197, 94)}):Play()
        task.wait(0.1)
        TweenService:Create(Btn, TweenInfo.new(0.2), {TextColor3 = Color3.fromRGB(241, 245, 249)}):Play()
    end)
end

BuatPilihanTarget("HEAD (KEPALA ATAS)", "Head")
BuatPilihanTarget("TORSO (DADA TENGAH)", "HumanoidRootPart")
BuatPilihanTarget("FEET (KAKI BAWAH)", "LeftFoot")

local CreditLabel = Instance.new("TextLabel")
CreditLabel.Size = UDim2.new(1, -18, 0, 15)
CreditLabel.Position = UDim2.new(0, 0, 1, -20)
CreditLabel.BackgroundTransparency = 1
CreditLabel.Text = "CORE VERSION: v2.4 // ENGINE STABLE"
CreditLabel.Font = Enum.Font.GothamMedium
CreditLabel.TextSize = 10
CreditLabel.TextColor3 = Color3.fromRGB(71, 85, 105)
CreditLabel.TextXAlignment = Enum.TextXAlignment.Right
CreditLabel.Parent = MainFrame
-- 1. SISTEM LOGIKA PINTAR DRAG & DROP (LOGO & FRAME UTAMA)
local function AktifkanFiturDrag(GuiObject, IsLogo)
    local dragging, dragInput, dragStart, startPos
    local IsMoving = false

    GuiObject.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            IsMoving = false
            dragStart = input.Position
            startPos = GuiObject.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then 
                    dragging = false 
                    if IsLogo and not IsMoving then
                        -- Animasi Muncul Melebar Kebawah (Smooth Tween)
                        MainFrame.Size = UDim2.new(0, 540, 0, 0)
                        MainFrame.Visible = true
                        TweenService:Create(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Size = UDim2.new(0, 540, 0, 260)}):Play()
                        
                        LogoBtn.TextColor3 = Color3.fromRGB(239, 68, 68) -- Berubah Merah saat menu terbuka
                        LogoStroke.Color = Color3.fromRGB(239, 68, 68)
                    end
                end
            end)
        end
    end)

    GuiObject.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            if delta.Magnitude > 5 then IsMoving = true end
            GuiObject.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end

AktifkanFiturDrag(LogoBtn, true)
AktifkanFiturDrag(MainFrame, false)

-- 2. LOGIKA TRANSISI & ANIMASI TOMBOL SILANG [X]
CloseBtn.MouseEnter:Connect(function() 
    TweenService:Create(CloseBtn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(239, 68, 68), TextColor3 = Color3.fromRGB(255, 255, 255)}):Play()
end)
CloseBtn.MouseLeave:Connect(function() 
    TweenService:Create(CloseBtn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(30, 41, 59), TextColor3 = Color3.fromRGB(241, 245, 249)}):Play()
end)

CloseBtn.MouseButton1Click:Connect(function()
    -- Animasi Menyusut saat ditutup
    local CloseTween = TweenService:Create(MainFrame, TweenInfo.new(0.2, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {Size = UDim2.new(0, 540, 0, 0)})
    CloseTween:Play()
    CloseTween.Completed:Connect(function()
        MainFrame.Visible = false
        MainFrame.Size = UDim2.new(0, 540, 0, 260)
    end)
    
    LogoBtn.TextColor3 = Color3.fromRGB(34, 197, 94) -- Kembali Hijau normal
    LogoStroke.Color = Color3.fromRGB(14, 165, 233)
end)

-- 3. LOGIKA INTERAKSI & HOVER SWITCH AIMBOT (ON/OFF)
ToggleAimBtn.MouseEnter:Connect(function()
    TweenService:Create(ToggleStroke, TweenInfo.new(0.15), {Color = Color3.fromRGB(14, 165, 233)}):Play()
end)
ToggleAimBtn.MouseLeave:Connect(function()
    TweenService:Create(ToggleStroke, TweenInfo.new(0.15), {Color = Color3.fromRGB(51, 65, 85)}):Play()
end)

ToggleAimBtn.MouseButton1Click:Connect(function()
    _G.Kepignan.aim_active = not _G.Kepignan.aim_active
    
    if _G.Kepignan.aim_active then
        ToggleAimBtn.Text = "   AIMBOT STATUS: ACTIVE"
        TweenService:Create(ToggleAimBtn, TweenInfo.new(0.2), {TextColor3 = Color3.fromRGB(34, 197, 94)}):Play()
        TweenService:Create(IndicatorDot, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(34, 197, 94), Size = UDim2.new(0, 10, 0, 10), Position = UDim2.new(1, -24, 0.5, -5)}):Play()
    else
        ToggleAimBtn.Text = "   AIMBOT STATUS: DISABLED"
        TweenService:Create(ToggleAimBtn, TweenInfo.new(0.2), {TextColor3 = Color3.fromRGB(239, 68, 68)}):Play()
        TweenService:Create(IndicatorDot, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(239, 68, 68), Size = UDim2.new(0, 8, 0, 8), Position = UDim2.new(1, -23, 0.5, -4)}):Play()
    end
    AutoSave()
end)

-- 4. LOGIKA SLIDER TAHAN & GESER INDEKS FOV
local MenggeserSlider = false

local function UpdateSlider()
    local MousePos = UserInputService:GetMouseLocation().X
    local RelativeX = MousePos - SliderFrame.AbsolutePosition.X
    local Persentase = math.clamp(RelativeX / SliderFrame.AbsoluteSize.X, 0, 1)
    
    SliderProgress.Size = UDim2.new(Persentase, 0, 1, 0)
    _G.Kepignan.fov_size = math.round(10 + (Persentase * 290))
    FovLabel.Text = "🎯 INTERACTIVE FIELD OF VIEW: " .. tostring(_G.Kepignan.fov_size) .. "PX"
end

SliderFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        MenggeserSlider = true
        TweenService:Create(SliderProgress, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(0, 245, 212)}):Play()
        UpdateSlider()
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if MenggeserSlider and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        UpdateSlider()
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        if MenggeserSlider then
            MenggeserSlider = false
            TweenService:Create(SliderProgress, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(14, 165, 233)}):Play()
            AutoSave()
        end
    end
end)

print("[B-AIM UI] Pemisahan Bagian Logika UI Selesai Dimuat!")
