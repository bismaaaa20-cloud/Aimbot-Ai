_G.Kepignan = _G.Kepignan or {
    aim_active = true,
    aim_bone = "Head", 
    smooth_speed = 4.5,
    fov_active = true,
    fov_size = 120
}

local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

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
LogoBtn.Size = UDim2.new(0, 42, 0, 42)
LogoBtn.Position = UDim2.new(0, 20, 0, 40)
LogoBtn.BackgroundColor3 = Color3.fromRGB(15, 23, 42)
LogoBtn.Text = "B"
LogoBtn.Font = Enum.Font.FredokaOne
LogoBtn.TextSize = 18
LogoBtn.TextColor3 = Color3.fromRGB(239, 68, 68) 
LogoBtn.AutoButtonColor = false
Instance.new("UICorner", LogoBtn).CornerRadius = UDim.new(1, 0) 

local LogoStroke = Instance.new("UIStroke")
LogoStroke.Color = Color3.fromRGB(239, 68, 68) 
LogoStroke.Thickness = 1.8
LogoStroke.Parent = LogoBtn

local MainFrame = Instance.new("Frame")
MainFrame.Parent = ScreenGui
MainFrame.Size = UDim2.new(0, 288, 0, 168)
MainFrame.Position = UDim2.new(0.5, -144, 0.5, -84)
MainFrame.BackgroundColor3 = Color3.fromRGB(11, 17, 33)
MainFrame.ClipsDescendants = true
MainFrame.Visible = true
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 8)

local MainStroke = Instance.new("UIStroke")
MainStroke.Color = Color3.fromRGB(30, 41, 59)
MainStroke.Thickness = 1.5
MainStroke.Parent = MainFrame

local HeaderBar = Instance.new("Frame")
HeaderBar.Size = UDim2.new(1, 0, 0, 30)
HeaderBar.BackgroundColor3 = Color3.fromRGB(20, 30, 54)
HeaderBar.Parent = MainFrame
Instance.new("UICorner", HeaderBar).CornerRadius = UDim.new(0, 8)

local HeaderFix = Instance.new("Frame")
HeaderFix.Size = UDim2.new(1, 0, 0, 8)
HeaderFix.Position = UDim2.new(0, 0, 1, -8)
HeaderFix.BackgroundColor3 = Color3.fromRGB(20, 30, 54)
HeaderFix.BorderSizePixel = 0
HeaderFix.Parent = HeaderBar

local HeaderLabel = Instance.new("TextLabel")
HeaderLabel.Size = UDim2.new(1, -45, 1, 0)
HeaderLabel.Position = UDim2.new(0, 10, 0, 0)
HeaderLabel.BackgroundTransparency = 1
HeaderLabel.Text = "⚡ B-AIM PANEL"
HeaderLabel.Font = Enum.Font.GothamBold
HeaderLabel.TextSize = 10
HeaderLabel.TextColor3 = Color3.fromRGB(241, 245, 249)
HeaderLabel.TextXAlignment = Enum.TextXAlignment.Left
HeaderLabel.Parent = HeaderBar

local CloseBtn = Instance.new("TextButton")
CloseBtn.Name = "CloseMenu"
CloseBtn.Parent = HeaderBar
CloseBtn.Size = UDim2.new(0, 22, 0, 22)
CloseBtn.Position = UDim2.new(1, -26, 0, 4)
CloseBtn.BackgroundColor3 = Color3.fromRGB(30, 41, 59)
CloseBtn.Text = "×"
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 14
CloseBtn.TextColor3 = Color3.fromRGB(241, 245, 249)
CloseBtn.AutoButtonColor = false
Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(0, 5)
local CloseStroke = Instance.new("UIStroke")
CloseStroke.Color = Color3.fromRGB(51, 65, 85)
CloseStroke.Parent = CloseBtn

local LeftContainer = Instance.new("Frame")
LeftContainer.Size = UDim2.new(0, 128, 1, -42)
LeftContainer.Position = UDim2.new(0, 10, 0, 38)
LeftContainer.BackgroundTransparency = 1
LeftContainer.Parent = MainFrame

local LeftLayout = Instance.new("UIListLayout")
LeftLayout.Spacing = UDim.new(0, 10)
LeftLayout.Parent = LeftContainer

local ToggleAimBtn = Instance.new("TextButton")
ToggleAimBtn.Size = UDim2.new(1, 0, 0, 28)
ToggleAimBtn.BackgroundColor3 = Color3.fromRGB(20, 30, 54)
ToggleAimBtn.Text = "  AIMBOT: ACTIVE"
ToggleAimBtn.Font = Enum.Font.GothamBold
ToggleAimBtn.TextSize = 9
ToggleAimBtn.TextColor3 = Color3.fromRGB(34, 197, 94)
ToggleAimBtn.TextXAlignment = Enum.TextXAlignment.Left
ToggleAimBtn.AutoButtonColor = false
ToggleAimBtn.Parent = LeftContainer
Instance.new("UICorner", ToggleAimBtn).CornerRadius = UDim.new(0, 5)
local ToggleStroke = Instance.new("UIStroke")
ToggleStroke.Color = Color3.fromRGB(51, 65, 85)
ToggleStroke.Parent = ToggleAimBtn

local IndicatorDot = Instance.new("Frame")
IndicatorDot.Size = UDim2.new(0, 6, 0, 6)
IndicatorDot.Position = UDim2.new(1, -14, 0.5, -3)
IndicatorDot.BackgroundColor3 = Color3.fromRGB(34, 197, 94)
IndicatorDot.Parent = ToggleAimBtn
Instance.new("UICorner", IndicatorDot).CornerRadius = UDim.new(1, 0)

local FovWrapper = Instance.new("Frame")
FovWrapper.Size = UDim2.new(1, 0, 0, 42)
FovWrapper.BackgroundTransparency = 1
FovWrapper.Parent = LeftContainer

local FovLabel = Instance.new("TextLabel")
FovLabel.Size = UDim2.new(1, 0, 0, 14)
FovLabel.BackgroundTransparency = 1
FovLabel.Text = "🎯 FOV SIZE: 120PX"
FovLabel.Font = Enum.Font.GothamBold
FovLabel.TextSize = 9
FovLabel.TextColor3 = Color3.fromRGB(148, 163, 184)
FovLabel.TextXAlignment = Enum.TextXAlignment.Left
FovLabel.Parent = FovWrapper

local SliderFrame = Instance.new("TextButton")
SliderFrame.Size = UDim2.new(1, 0, 0, 6)
SliderFrame.Position = UDim2.new(0, 0, 0, 18)
SliderFrame.BackgroundColor3 = Color3.fromRGB(20, 30, 54)
SliderFrame.Text = ""
SliderFrame.AutoButtonColor = false
SliderFrame.Parent = FovWrapper
Instance.new("UICorner", SliderFrame).CornerRadius = UDim.new(0, 3)

local SliderProgress = Instance.new("Frame")
SliderProgress.Size = UDim2.new(0.4, 0, 1, 0)
SliderProgress.BackgroundColor3 = Color3.fromRGB(14, 165, 233)
SliderProgress.Parent = SliderFrame
Instance.new("UICorner", SliderProgress).CornerRadius = UDim.new(0, 3)

local RightContainer = Instance.new("Frame")
RightContainer.Size = UDim2.new(0, 132, 1, -50)
RightContainer.Position = UDim2.new(1, -142, 0, 38)
RightContainer.BackgroundTransparency = 1
RightContainer.Parent = MainFrame

local ScrollLabel = Instance.new("TextLabel")
ScrollLabel.Size = UDim2.new(1, 0, 0, 14)
ScrollLabel.BackgroundTransparency = 1
ScrollLabel.Text = "🛡️ TARGET: HEAD"
ScrollLabel.Font = Enum.Font.GothamBold
ScrollLabel.TextSize = 9
ScrollLabel.TextColor3 = Color3.fromRGB(14, 165, 233)
ScrollLabel.TextXAlignment = Enum.TextXAlignment.Left
ScrollLabel.Parent = RightContainer

local ScrollingFrame = Instance.new("ScrollingFrame")
ScrollingFrame.Size = UDim2.new(1, 0, 1, -16)
ScrollingFrame.Position = UDim2.new(0, 0, 0, 16)
ScrollingFrame.BackgroundColor3 = Color3.fromRGB(20, 30, 54)
ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 100)
ScrollingFrame.ScrollBarThickness = 2
ScrollingFrame.ScrollBarImageColor3 = Color3.fromRGB(14, 165, 233)
ScrollingFrame.BorderSizePixel = 0
ScrollingFrame.Parent = RightContainer
Instance.new("UICorner", ScrollingFrame).CornerRadius = UDim.new(0, 5)
local ScrollStroke = Instance.new("UIStroke")
ScrollStroke.Color = Color3.fromRGB(51, 65, 85)
ScrollStroke.Parent = ScrollingFrame

local ScrollPadding = Instance.new("UIPadding")
ScrollPadding.PaddingTop = UDim.new(0, 4)
ScrollPadding.PaddingLeft = UDim.new(0, 4)
ScrollPadding.PaddingRight = UDim.new(0, 4)
ScrollPadding.Parent = ScrollingFrame

local ScrollList = Instance.new("UIListLayout")
ScrollList.Spacing = UDim.new(0, 4)
ScrollList.Parent = ScrollingFrame

local function BuatPilihanTarget(teks_layar, bone_roblox)
    local Btn = Instance.new("TextButton")
    Btn.Size = UDim2.new(1, 0, 0, 24)
    Btn.BackgroundColor3 = Color3.fromRGB(11, 17, 33)
    Btn.Text = teks_layar
    Btn.Font = Enum.Font.GothamBold
    Btn.TextSize = 8
    Btn.TextColor3 = Color3.fromRGB(148, 163, 184)
    Btn.AutoButtonColor = false
    Btn.Parent = ScrollingFrame
    Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 4)
    local BtnStroke = Instance.new("UIStroke")
    BtnStroke.Color = Color3.fromRGB(30, 41, 59)
    BtnStroke.Parent = Btn

    Btn.MouseButton1Click:Connect(function()
        _G.Kepignan.aim_bone = bone_roblox
        ScrollLabel.Text = "🛡️ TARGET: " .. string.upper(bone_roblox)
        AutoSave()
        TweenService:Create(Btn, TweenInfo.new(0.05), {TextColor3 = Color3.fromRGB(34, 197, 94)}):Play()
        task.wait(0.1)
        TweenService:Create(Btn, TweenInfo.new(0.2), {TextColor3 = Color3.fromRGB(241, 245, 249)}):Play()
    end)
end

BuatPilihanTarget("HEAD (KEPALA)", "Head")
BuatPilihanTarget("TORSO (DADA)", "HumanoidRootPart")
BuatPilihanTarget("FEET (KAKI)", "LeftFoot")

local CreditLabel = Instance.new("TextLabel")
CreditLabel.Size = UDim2.new(1, -10, 0, 10)
CreditLabel.Position = UDim2.new(0, 0, 1, -12)
CreditLabel.BackgroundTransparency = 1
CreditLabel.Text = "B-AIM 80% SCALE"
CreditLabel.Font = Enum.Font.GothamMedium
CreditLabel.TextSize = 7
CreditLabel.TextColor3 = Color3.fromRGB(71, 85, 105)
CreditLabel.TextXAlignment = Enum.TextXAlignment.Right
CreditLabel.Parent = MainFrame
local IsMinimized = false

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
                end
            end)
        end
    end)

    GuiObject.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            if delta.Magnitude > 10 then 
                IsMoving = true 
            end
            GuiObject.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)

    if IsLogo then
        GuiObject.MouseButton1Click:Connect(function()
            if not IsMoving then
                if not MainFrame.Visible then
                    IsMinimized = false
                    CloseBtn.Text = "×"
                    MainFrame.Size = UDim2.new(0, 288, 0, 168)
                    MainFrame.Visible = true
                    
                    LogoBtn.TextColor3 = Color3.fromRGB(239, 68, 68) 
                    LogoStroke.Color = Color3.fromRGB(239, 68, 68)
                else
                    MainFrame.Visible = false
                    LogoBtn.TextColor3 = Color3.fromRGB(34, 197, 94) 
                    LogoStroke.Color = Color3.fromRGB(14, 165, 233)
                end
            end
        end)
    end
end

AktifkanFiturDrag(LogoBtn, true)
AktifkanFiturDrag(MainFrame, false)

CloseBtn.MouseButton1Click:Connect(function()
    if not IsMinimized then
        IsMinimized = true
        CloseBtn.Text = "+"
        TweenService:Create(MainFrame, TweenInfo.new(0.2, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Size = UDim2.new(0, 288, 0, 30)}):Play()
        LogoBtn.TextColor3 = Color3.fromRGB(14, 165, 233)
        LogoStroke.Color = Color3.fromRGB(14, 165, 233)
    else
        IsMinimized = false
        CloseBtn.Text = "×"
        TweenService:Create(MainFrame, TweenInfo.new(0.2, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Size = UDim2.new(0, 288, 0, 168)}):Play()
        LogoBtn.TextColor3 = Color3.fromRGB(239, 68, 68) 
        LogoStroke.Color = Color3.fromRGB(239, 68, 68)
    end
end)

ToggleAimBtn.MouseButton1Click:Connect(function()
    _G.Kepignan.aim_active = not _G.Kepignan.aim_active
    
    if _G.Kepignan.aim_active then
        ToggleAimBtn.Text = "  AIMBOT: ACTIVE"
        TweenService:Create(ToggleAimBtn, TweenInfo.new(0.2), {TextColor3 = Color3.fromRGB(34, 197, 94)}):Play()
        TweenService:Create(IndicatorDot, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(34, 197, 94), Size = UDim2.new(0, 6, 0, 6), Position = UDim2.new(1, -14, 0.5, -3)}):Play()
    else
        ToggleAimBtn.Text = "  AIMBOT: DISABLED"
        TweenService:Create(ToggleAimBtn, TweenInfo.new(0.2), {TextColor3 = Color3.fromRGB(239, 68, 68)}):Play()
        TweenService:Create(IndicatorDot, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(239, 68, 68), Size = UDim2.new(0, 5, 0, 5), Position = UDim2.new(1, -13, 0.5, -2)}):Play()
    end
    AutoSave()
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

print("[B-AIM UI] Bagian Logika Kompak Sukses Dimuat!")
