

_G.Kepignan = _G.Kepignan or {
    aim_active = true,
    aim_bone = "Head", 
    smooth_speed = 4.5,
    fov_active = true,
    fov_size = 120
}

local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")

if CoreGui:FindFirstChild("BAimVision_Ultra") then
    CoreGui.BAimVision_Ultra:Destroy()
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "BAimVision_Ultra"
ScreenGui.Parent = CoreGui

-- ─── TOMBOL LOGO [B] MELAYANG MINI ───
local LogoBtn = Instance.new("TextButton")
LogoBtn.Name = "LogoToggle"
LogoBtn.Parent = ScreenGui
LogoBtn.Size = UDim2.new(0, 45, 0, 45)
LogoBtn.Position = UDim2.new(0, 30, 0, 80)
LogoBtn.BackgroundColor3 = Color3.fromRGB(26, 28, 38)
LogoBtn.Text = "B"
LogoBtn.Font = Enum.Font.SegoeUIBlk
LogoBtn.TextSize = 18
LogoBtn.TextColor3 = Color3.fromRGB(0, 255, 194)
Instance.new("UICorner", LogoBtn).CornerRadius = UDim.new(0, 4)
local LogoStroke = Instance.new("UIStroke")
LogoStroke.Color = Color3.fromRGB(0, 255, 194)
LogoStroke.Thickness = 1.5
LogoStroke.Parent = LogoBtn

-- ─── KOTAK BESAR UI UTAMA (Slate Dark Blue) ───
local MainFrame = Instance.new("Frame")
MainFrame.Parent = ScreenGui
MainFrame.Size = UDim2.new(0, 440, 0, 300)
MainFrame.Position = UDim2.new(0.5, -220, 0.5, -150)
MainFrame.BackgroundColor3 = Color3.fromRGB(18, 19, 28)
MainFrame.Visible = false
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 6)
local MainStroke = Instance.new("UIStroke")
MainStroke.Color = Color3.fromRGB(42, 45, 61)
MainStroke.Parent = MainFrame

-- Header Menu
local HeaderLabel = Instance.new("TextLabel")
HeaderLabel.Size = UDim2.new(1, 0, 0, 35)
HeaderLabel.BackgroundColor3 = Color3.fromRGB(26, 28, 38)
HeaderLabel.Text = "  [ B-AIM CONTROL PANEL | VISUAL UI ]"
HeaderLabel.Font = Enum.Font.Code
HeaderLabel.TextSize = 12
HeaderLabel.TextColor3 = Color3.fromRGB(160, 165, 192)
HeaderLabel.TextXAlignment = Enum.TextXAlignment.Left
HeaderLabel.Parent = MainFrame
Instance.new("UICorner", HeaderLabel).CornerRadius = UDim.new(0, 6)

-- Tombol On/Off Aimbot
local ToggleAimBtn = Instance.new("TextButton")
ToggleAimBtn.Size = UDim2.new(0, 170, 0, 35)
ToggleAimBtn.Position = UDim2.new(0, 20, 0, 55)
ToggleAimBtn.BackgroundColor3 = Color3.fromRGB(26, 28, 38)
ToggleAimBtn.Text = "AIMBOT: ACTIVE"
ToggleAimBtn.Font = Enum.Font.SegoeUIBold
ToggleAimBtn.TextColor3 = Color3.fromRGB(0, 255, 194)
ToggleAimBtn.Parent = MainFrame
Instance.new("UICorner", ToggleAimBtn).CornerRadius = UDim.new(0, 4)

-- ─── SCROLLBAR TEMPAT PILIHAN TARGET (Atas, Tengah, Bawah) ───
local ScrollLabel = Instance.new("TextLabel")
ScrollLabel.Size = UDim2.new(0, 210, 0, 20)
ScrollLabel.Position = UDim2.new(0, 210, 0, 55)
ScrollLabel.BackgroundTransparency = 1
ScrollLabel.Text = "🎯 [ TARGET: KEPALA (ATAS) ]"
ScrollLabel.Font = Enum.Font.Code
ScrollLabel.TextSize = 11
ScrollLabel.TextColor3 = Color3.fromRGB(255, 0, 85)
ScrollLabel.Parent = MainFrame

local ScrollingFrame = Instance.new("ScrollingFrame")
ScrollingFrame.Size = UDim2.new(0, 210, 0, 100)
ScrollingFrame.Position = UDim2.new(0, 210, 0, 80)
ScrollingFrame.BackgroundColor3 = Color3.fromRGB(26, 28, 38)
ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 135)
ScrollingFrame.ScrollBarThickness = 6
ScrollingFrame.ScrollBarImageColor3 = Color3.fromRGB(0, 255, 194)
ScrollingFrame.Parent = MainFrame
Instance.new("UICorner", ScrollingFrame).CornerRadius = UDim.new(0, 4)
local ScrollStroke = Instance.new("UIStroke")
ScrollStroke.Color = Color3.fromRGB(42, 45, 61)
ScrollStroke.Parent = ScrollingFrame

local function BuatPilihanTarget(nama_tombol, teks_layar, bone_roblox, posisi_y)
    local Btn = Instance.new("TextButton")
    Btn.Size = UDim2.new(1, -10, 0, 35)
    Btn.Position = UDim2.new(0, 5, 0, posisi_y)
    Btn.BackgroundColor3 = Color3.fromRGB(18, 19, 28)
    Btn.Text = teks_layar
    Btn.Font = Enum.Font.SegoeUIBold
    Btn.TextSize = 11
    Btn.TextColor3 = Color3.fromRGB(160, 165, 192)
    Btn.Parent = ScrollingFrame
    Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 4)

    Btn.MouseButton1Click:Connect(function()
        _G.Kepignan.aim_bone = bone_roblox
        ScrollLabel.Text = "🎯 [ TARGET: " .. teks_layar .. " ]"
        Btn.TextColor3 = Color3.fromRGB(0, 255, 194)
        task.wait(0.3)
        Btn.TextColor3 = Color3.fromRGB(160, 165, 192)
    end)
end

BuatPilihanTarget("Atas", "KEPALA (ATAS)", "Head", 5)
BuatPilihanTarget("Tengah", "BADAN / DADA (TENGAH)", "HumanoidRootPart", 45)
BuatPilihanTarget("Bawah", "KAKI (BAWAH)", "LeftFoot", 85)

-- ─── PUSAT KEPIGNAN FOV SLIDER ───
local FovLabel = Instance.new("TextLabel")
FovLabel.Size = UDim2.new(0, 170, 0, 20)
FovLabel.Position = UDim2.new(0, 20, 0, 105)
FovLabel.BackgroundTransparency = 1
FovLabel.Text = "[ PUSAT KEPIGNAN FOV: 120px ]"
FovLabel.Font = Enum.Font.Code
FovLabel.TextColor3 = Color3.fromRGB(0, 255, 194)
FovLabel.TextXAlignment = Enum.TextXAlignment.Left
FovLabel.Parent = MainFrame

local SliderFrame = Instance.new("TextButton")
SliderFrame.Size = UDim2.new(0, 170, 0, 8)
SliderFrame.Position = UDim2.new(0, 20, 0, 130)
SliderFrame.BackgroundColor3 = Color3.fromRGB(42, 45, 61)
SliderFrame.Text = ""
SliderFrame.Parent = MainFrame
Instance.new("UICorner", SliderFrame).CornerRadius = UDim.new(0, 4)

local SliderProgress = Instance.new("Frame")
SliderProgress.Size = UDim2.new(0.4, 0, 1, 0)
SliderProgress.BackgroundColor3 = Color3.fromRGB(0, 255, 194)
SliderProgress.Parent = SliderFrame
Instance.new("UICorner", SliderProgress).CornerRadius = UDim.new(0, 4)

-- Tombol Save Kepignan (Dual-Save Manual)
local SaveBtn = Instance.new("TextButton")
SaveBtn.Size = UDim2.new(1, -40, 0, 40)
SaveBtn.Position = UDim2.new(0, 20, 1, -60)
SaveBtn.BackgroundColor3 = Color3.fromRGB(26, 28, 38)
SaveBtn.Text = "⚡ SYNC & SAVE KEPIGNAN"
SaveBtn.Font = Enum.Font.SegoeUIBold
SaveBtn.TextColor3 = Color3.fromRGB(0, 255, 194)
SaveBtn.Parent = MainFrame
Instance.new("UICorner", SaveBtn).CornerRadius = UDim.new(0, 4)
Instance.new("UIStroke", SaveBtn).Color = Color3.fromRGB(0, 255, 194)

-- Teks Credit Kamu
local CreditLabel = Instance.new("TextLabel")
CreditLabel.Size = UDim2.new(1, -40, 0, 15)
CreditLabel.Position = UDim2.new(0, 20, 1, -18)
CreditLabel.BackgroundTransparency = 1
CreditLabel.Text = "Dual-Save Core System dirancang oleh: Kamu 😎"
CreditLabel.Font = Enum.Font.SourceSansItalic
CreditLabel.TextColor3 = Color3.fromRGB(101, 106, 138)
CreditLabel.TextXAlignment = Enum.TextXAlignment.Right
CreditLabel.Parent = MainFrame

-- ─── INTERAKSI LOGIKA UI ───
local dragging, dragInput, dragStart, startPos
LogoBtn.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = LogoBtn.Position
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        LogoBtn.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

LogoBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
    LogoBtn.TextColor3 = MainFrame.Visible and Color3.fromRGB(255, 0, 85) or Color3.fromRGB(0, 255, 194)
    LogoStroke.Color = MainFrame.Visible and Color3.fromRGB(255, 0, 85) or Color3.fromRGB(0, 255, 194)
end)

ToggleAimBtn.MouseButton1Click:Connect(function()
    _G.Kepignan.aim_active = not _G.Kepignan.aim_active
    ToggleAimBtn.Text = _G.Kepignan.aim_active and "AIMBOT: ACTIVE" or "AIMBOT: DISABLED"
    ToggleAimBtn.TextColor3 = _G.Kepignan.aim_active and Color3.fromRGB(0, 255, 194) or Color3.fromRGB(255, 0, 85)
end)

SliderFrame.MouseButton1Down:Connect(function()
    local koneksi
    koneksi = UserInputService.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            local relativeX = UserInputService:GetMouseLocation().X - SliderFrame.AbsolutePosition.X
            local persentase = math.clamp(relativeX / SliderFrame.AbsoluteSize.X, 0, 1)
            SliderProgress.Size = UDim2.new(persentase, 0, 1, 0)
            _G.Kepignan.fov_size = math.round(10 + (persentase * 290))
            FovLabel.Text = "[ PUSAT KEPIGNAN FOV: " .. tostring(_G.Kepignan.fov_size) .. "px ]"
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            if koneksi then koneksi:Disconnect() end
        end
    end)
end)

SaveBtn.MouseButton1Click:Connect(function()
    SaveBtn.Text = "✓ SYNCED SUCCESS"
    SaveBtn.BackgroundColor3 = Color3.fromRGB(0, 255, 194)
    SaveBtn.TextColor3 = Color3.fromRGB(18, 19, 28)
    if writefile then pcall(function() writefile("b_aim_kepignan.json", game:GetService("HttpService"):JSONEncode(_G.Kepignan)) end) end
    task.wait(1)
    SaveBtn.Text = "⚡ SYNC & SAVE KEPIGNAN"
    SaveBtn.BackgroundColor3 = Color3.fromRGB(26, 28, 38)
    SaveBtn.TextColor3 = Color3.fromRGB(0, 255, 194)
end)

print("[B-AIM UI] Berkas Tempat Visual Sukses Dimuat!")
