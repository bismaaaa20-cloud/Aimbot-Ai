_G.Kepignan = _G.Kepignan or {
    aim_active = true,
    aim_bone = "Head", 
    smooth_speed = 4.5,
    fov_active = true,
    fov_size = 120,
    target_mode = "Tim Filter",
    radar_active = true
}

local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")

if CoreGui:FindFirstChild("BAimVision_Ultra") then
    CoreGui.BAimVision_Ultra:Destroy()
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "BAimVision_Ultra"
ScreenGui.Parent = CoreGui
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local function AutoSave()
    if writefile then 
        pcall(function() 
            writefile("b_aim_kepignan.json", game:GetService("HttpService"):JSONEncode(_G.Kepignan)) 
        end) 
    end
end

local LogoBtn = Instance.new("TextButton")
LogoBtn.Name = "LogoToggle"
LogoBtn.Parent = ScreenGui
LogoBtn.Size = UDim2.new(0, 44, 0, 44)
LogoBtn.Position = UDim2.new(0, 20, 0, 40)
LogoBtn.BackgroundColor3 = Color3.fromRGB(15, 23, 42)
LogoBtn.Text = "B"
LogoBtn.Font = Enum.Font.FredokaOne
LogoBtn.TextSize = 20
LogoBtn.TextColor3 = Color3.fromRGB(239, 68, 68) 
LogoBtn.AutoButtonColor = false
Instance.new("UICorner", LogoBtn).CornerRadius = UDim.new(1, 0) 

local LogoStroke = Instance.new("UIStroke")
LogoStroke.Color = Color3.fromRGB(239, 68, 68) 
LogoStroke.Thickness = 2
LogoStroke.Parent = LogoBtn
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainPanel"
MainFrame.Parent = ScreenGui
MainFrame.Size = UDim2.new(0, 340, 0, 190) 
MainFrame.Position = UDim2.new(0.5, -170, 0.5, -95)
MainFrame.BackgroundColor3 = Color3.fromRGB(11, 17, 33)
MainFrame.ClipsDescendants = true
MainFrame.Visible = true 
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 8)

local MainStroke = Instance.new("UIStroke")
MainStroke.Color = Color3.fromRGB(30, 41, 59)
MainStroke.Thickness = 1.5
MainStroke.Parent = MainFrame

local HeaderBar = Instance.new("Frame")
HeaderBar.Size = UDim2.new(1, 0, 0, 32)
HeaderBar.BackgroundColor3 = Color3.fromRGB(20, 30, 54)
HeaderBar.Parent = MainFrame
Instance.new("UICorner", HeaderBar).CornerRadius = UDim.new(0, 8)

local HeaderLabel = Instance.new("TextLabel")
HeaderLabel.Size = UDim2.new(0.75, 0, 1, 0)
HeaderLabel.Position = UDim2.new(0, 12, 0, 0)
HeaderLabel.BackgroundTransparency = 1
HeaderLabel.Text = "⚡ B-AIM CONTROL PANEL V2.5"
HeaderLabel.Font = Enum.Font.GothamBold
HeaderLabel.TextSize = 10
HeaderLabel.TextColor3 = Color3.fromRGB(241, 245, 249)
HeaderLabel.TextXAlignment = Enum.TextXAlignment.Left
HeaderLabel.Parent = HeaderBar

local CloseBtn = Instance.new("TextButton")
CloseBtn.Name = "CloseMenu"
CloseBtn.Parent = HeaderBar
CloseBtn.Size = UDim2.new(0, 24, 0, 24)
CloseBtn.Position = UDim2.new(1, -30, 0, 4)
CloseBtn.BackgroundColor3 = Color3.fromRGB(30, 41, 59)
CloseBtn.Text = "×"
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 14
CloseBtn.TextColor3 = Color3.fromRGB(241, 245, 249)
CloseBtn.AutoButtonColor = false
Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(0, 5)

local ToggleAimBtn = Instance.new("TextButton")
ToggleAimBtn.Name = "ToggleAimButton"
ToggleAimBtn.Size = UDim2.new(0.43, 0, 0.17, 0)
ToggleAimBtn.Position = UDim2.new(0.04, 0, 0.23, 0)
ToggleAimBtn.BackgroundColor3 = Color3.fromRGB(20, 30, 54)
ToggleAimBtn.Text = "  AIMBOT: ACTIVE"
ToggleAimBtn.Font = Enum.Font.GothamBold
ToggleAimBtn.TextSize = 9
ToggleAimBtn.TextColor3 = Color3.fromRGB(34, 197, 94)
ToggleAimBtn.TextXAlignment = Enum.TextXAlignment.Left
ToggleAimBtn.AutoButtonColor = false
ToggleAimBtn.Parent = MainFrame
Instance.new("UICorner", ToggleAimBtn).CornerRadius = UDim.new(0, 5)

local ToggleStroke = Instance.new("UIStroke")
ToggleStroke.Color = Color3.fromRGB(51, 65, 85)
ToggleStroke.Parent = ToggleAimBtn

local IndicatorDot = Instance.new("Frame")
IndicatorDot.Size = UDim2.new(0, 6, 0, 6)
IndicatorDot.Position = UDim2.new(1, -12, 0.5, -3)
IndicatorDot.BackgroundColor3 = Color3.fromRGB(34, 197, 94)
IndicatorDot.Parent = ToggleAimBtn
Instance.new("UICorner", IndicatorDot).CornerRadius = UDim.new(1, 0)

local FovLabel = Instance.new("TextLabel")
FovLabel.Size = UDim2.new(0.43, 0, 0.1, 0)
FovLabel.Position = UDim2.new(0.04, 0, 0.46, 0)
FovLabel.BackgroundTransparency = 1
FovLabel.Text = "🎯 FOV SIZE: 120PX"
FovLabel.Font = Enum.Font.GothamBold
FovLabel.TextSize = 9
FovLabel.TextColor3 = Color3.fromRGB(148, 163, 184)
FovLabel.TextXAlignment = Enum.TextXAlignment.Left
FovLabel.Parent = MainFrame

local SliderFrame = Instance.new("TextButton")
SliderFrame.Size = UDim2.new(0.43, 0, 0.04, 0)
SliderFrame.Position = UDim2.new(0.04, 0, 0.60, 0)
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
local TaktikLabel = Instance.new("TextLabel")
TaktikLabel.Size = UDim2.new(0.48, 0, 0.1, 0)
TaktikLabel.Position = UDim2.new(0.5, 0, 0.23, 0)
TaktikLabel.BackgroundTransparency = 1
TaktikLabel.Text = "⚙️ RADAR SERVER & TAKTIK"
TaktikLabel.Font = Enum.Font.GothamBold
TaktikLabel.TextSize = 9
TaktikLabel.TextColor3 = Color3.fromRGB(14, 165, 233)
TaktikLabel.TextXAlignment = Enum.TextXAlignment.Left
TaktikLabel.Parent = MainFrame

local TaktikScroll = Instance.new("ScrollingFrame")
TaktikScroll.Size = UDim2.new(0.48, 0, 0.52, 0)
TaktikScroll.Position = UDim2.new(0.5, 0, 0.36, 0)
TaktikScroll.BackgroundColor3 = Color3.fromRGB(20, 30, 54)
TaktikScroll.CanvasSize = UDim2.new(0, 0, 0, 150) 
TaktikScroll.ScrollBarThickness = 4
TaktikScroll.ScrollBarImageColor3 = Color3.fromRGB(14, 165, 233)
TaktikScroll.BorderSizePixel = 0
TaktikScroll.Parent = MainFrame
Instance.new("UICorner", TaktikScroll).CornerRadius = UDim.new(0, 5)

local ScrollStroke = Instance.new("UIStroke")
ScrollStroke.Color = Color3.fromRGB(51, 65, 85)
ScrollStroke.Parent = TaktikScroll

local ModeBtn = Instance.new("TextButton")
ModeBtn.Size = UDim2.new(0.9, 0, 0, 25)
ModeBtn.Position = UDim2.new(0.05, 0, 0, 5)
ModeBtn.BackgroundColor3 = Color3.fromRGB(11, 17, 33)
ModeBtn.Text = "MODE: TIM FILTER"
ModeBtn.Font = Enum.Font.GothamBold
ModeBtn.TextSize = 8
ModeBtn.TextColor3 = Color3.fromRGB(148, 163, 184)
ModeBtn.Parent = TaktikScroll
Instance.new("UICorner", ModeBtn).CornerRadius = UDim.new(0, 4)

ModeBtn.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        if _G.Kepignan.target_mode == "Tim Filter" then
            _G.Kepignan.target_mode = "FFA (Semua Musuh)"
            ModeBtn.Text = "MODE: FFA (SEMUA LAWAN)"
            ModeBtn.TextColor3 = Color3.fromRGB(239, 68, 68)
        else
            _G.Kepignan.target_mode = "Tim Filter"
            ModeBtn.Text = "MODE: TIM FILTER"
            ModeBtn.TextColor3 = Color3.fromRGB(34, 197, 94)
        end
        AutoSave()
    end
end)

local RadarListFrame = Instance.new("Frame")
RadarListFrame.Size = UDim2.new(0.9, 0, 0, 80)
RadarListFrame.Position = UDim2.new(0.05, 0, 0, 35)
RadarListFrame.BackgroundColor3 = Color3.fromRGB(11, 17, 33)
RadarListFrame.Parent = TaktikScroll
Instance.new("UICorner", RadarListFrame).CornerRadius = UDim.new(0, 4)

local RadarText = Instance.new("TextLabel")
RadarText.Size = UDim2.new(1, -10, 1, -10)
RadarText.Position = UDim2.new(0, 5, 0, 5)
RadarText.BackgroundTransparency = 1
RadarText.Text = "Memindai radar server..."
RadarText.Font = Enum.Font.GothamMedium
RadarText.TextSize = 7
RadarText.TextColor3 = Color3.fromRGB(148, 163, 184)
RadarText.TextWrapped = true
RadarText.TextYAlignment = Enum.TextYAlignment.Top
RadarText.TextXAlignment = Enum.TextXAlignment.Left
RadarText.Parent = RadarListFrame

task.spawn(function()
    while true do
        task.wait(2)
        local ListPemain = "RADAR SERVER SEKARANG:\n"
        local Counter = 0
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= Players.LocalPlayer and Counter < 5 then
                ListPemain = ListPemain .. "- " .. p.Name .. "\n"
                Counter = Counter + 1
            end
        end
        RadarText.Text = ListPemain
    end
end)

local CreditLabel = Instance.new("TextLabel")
CreditLabel.Size = UDim2.new(1, -10, 0, 10)
CreditLabel.Position = UDim2.new(0, 0, 0.93, 0)
CreditLabel.BackgroundTransparency = 1
CreditLabel.Text = "B-AIM SMART AI PROJECT"
CreditLabel.Font = Enum.Font.GothamMedium
CreditLabel.TextSize = 7
CreditLabel.TextColor3 = Color3.fromRGB(71, 85, 105)
CreditLabel.TextXAlignment = Enum.TextXAlignment.Right
CreditLabel.Parent = MainFrame
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
                if not MainFrame.Visible then
                    IsMinimized = false
                    CloseBtn.Text = "×"
                    MainFrame.Size = UDim2.new(0, 340, 0, 190)
                    MainFrame.Visible = true
                else
                    MainFrame.Visible = false
                end
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
            TweenService:Create(MainFrame, TweenInfo.new(0.2, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Size = UDim2.new(0, 340, 0, 32)}):Play()
        else
            IsMinimized = false
            CloseBtn.Text = "×"
            TweenService:Create(MainFrame, TweenInfo.new(0.2, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Size = UDim2.new(0, 340, 0, 190)}):Play()
        end
    end
end)

ToggleAimBtn.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        _G.Kepignan.aim_active = not _G.Kepignan.aim_active
        if _G.Kepignan.aim_active then
            ToggleAimBtn.Text = "  AIMBOT: ACTIVE"
            ToggleAimBtn.TextColor3 = Color3.fromRGB(34, 197, 94)
        else
            ToggleAimBtn.Text = "  AIMBOT: DISABLED"
            ToggleAimBtn.TextColor3 = Color3.fromRGB(239, 68, 68)
        end
        AutoSave()
    end
end)

local MenggeserSlider = false
local function UpdateSlider()
    local MousePos = UserInputService:GetMouseLocation().X
    local RelativeX = MousePos - SliderFrame.AbsolutePosition.X
    local Persentase = math.clamp(RelativeX / SliderFrame.AbsoluteSize.X, 0, 1)
    SliderProgress.Size = UDim2.new(Persentase, 0, 1, 0)
    _G.Kepignan.fov_size = math.round(10 + (Persentase * 290))
    FovLabel.Text = "🎯 FOV SIZE: " .. tostring(_G.Kepignan.fov_size) .. "PX"
end

SliderFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        MenggeserSlider = true
        UpdateSlider()
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if MenggeserSlider and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        UpdateSlider()
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

print("[B-AIM] UI Skala Taktik & Radar Server Sukses Diperbarui!")
