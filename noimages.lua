local colors = {
    Blue = Color3.fromRGB(70, 119, 255),
    Background = Color3.fromRGB(4, 7, 10),
    White = Color3.fromRGB(255, 255, 255),
    Red = Color3.fromRGB(252, 65, 48),
    Green = Color3.fromRGB(77, 172, 104),
    tboff = Color3.fromRGB(115, 115, 115),
    tpoff = Color3.fromRGB(255, 255, 255),  
    tbon = Color3.fromRGB(91, 116, 185),
    tpon = Color3.fromRGB(70, 119, 255),  
    
}

local TweenService = game:GetService("TweenService")
local uis = game:GetService("UserInputService")

local liquidbounce = {}
liquidbounce.__index = liquidbounce

local props = game:GetObjects("rbxassetid://17901186362")[1]:Clone()

local function p(f, t)
    for i, v in pairs(f:GetChildren()) do
        if not v:IsA("UIComponent") then
            v:Clone().Parent = t
        end
    end
    t.Name = f.Name
    t.Size = f.Size
    t.Position = f.Position
    t.AnchorPoint = f.AnchorPoint
    -- t.BackgroundColor3 = f.BackgroundColor3
    -- t.BackgroundTransparency = f.BackgroundTransparency
    t.BorderColor3 = f.BorderColor3
    t.BorderSizePixel = 0
    t.Rotation = f.Rotation
    t.LayoutOrder = f.LayoutOrder
    t.ZIndex = f.ZIndex
    t.Visible = f.Visible
    t.Active = f.Active
    t.ClipsDescendants = f.ClipsDescendants
end

local descendants = props:GetDescendants()
for i, v in pairs(descendants) do
    if v:IsA("ImageButton") then
        local textbutton = Instance.new("TextButton")
        p(v, textbutton)
        textbutton.Text = ""
        textbutton.Parent = v.Parent
        v:Destroy()
    elseif v:IsA("ImageLabel") then
        local textlabel = Instance.new("TextLabel")
        p(v, textlabel)
        textlabel.Text = ""
        textlabel.Parent = v.Parent
        v:Destroy()
    end
end

local modulesfolder;
local bg = Instance.new("BlurEffect")
local guiscale = Instance.new("UIScale")
function liquidbounce.new()
    local self = setmetatable({}, liquidbounce)
    self.objects = {}
    self.root = Instance.new("ScreenGui")
    self.root.IgnoreGuiInset = true
    self.root.Name = "liquidbounce"
    self.root.ResetOnSpawn = false
    guiscale.Scale = 1
    guiscale.Parent = self.root
    bg.Size = 50 
    bg.Parent = game:GetService("Lighting")
    local background = props.Background:Clone()
    -- local bruh = props:Clone()
    -- bruh.Parent = self.root
    local notification = props.NotificationContainer and  props.NotificationContainer:Clone()
    notification.Position = UDim2.new(0.78399986, 0, 0.304609954, 0)
    notification.Parent = self.root
    modulesfolder = Instance.new("Folder")
    modulesfolder.Name = "Modules"
    modulesfolder.Parent = self.root
    background.Parent = self.root
    background.BackgroundColor3 = Color3.fromRGB(0,0,0)
    self.root.Parent = (gethui and gethui()) or game:GetService("CoreGui"):FindFirstChild("RobloxGui")


    local function showmodules()
        local ti = TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut)

        for i, v in pairs(modulesfolder:GetChildren()) do
            if v:IsA("Frame") or v:IsA("GuiObject") then
                v.Visible = not v.Visible
                local bgsize = v.Visible and 50 or 0
                local guis = v.Visible and 1 or 0
                game:GetService("TweenService"):Create(bg, TweenInfo.new(0.25), {Size = bgsize}):Play()
                game:GetService("TweenService"):Create(guiscale, TweenInfo.new(0.25), {Scale = guis}):Play()
                
                background.Visible = not background.Visible
            end
        end
    end
	
	uis.InputBegan:Connect(function(input)
		if input.KeyCode == Enum.KeyCode.LeftControl then
			showmodules()
		end
	end)

    return self
end

function liquidbounce:CreateCategory(title, icon)
    local category = props.Category:Clone()
    category.Name = title or "Category"
    category.Parent = modulesfolder
    category.BackgroundTransparency = 0.3

    local selfobj = #self.objects
    local xoffset = selfobj * (category.AbsoluteSize.X + 10) 
    
    category.Position = UDim2.new(0, 10 + xoffset, 0, 80) 
    
    local topbar = category.TopBar
    local categorytitle = topbar.CategoryTitle
    local categoryicon = topbar.CategoryIcon

    category.DropShadowHolder.DropShadow.BackgroundTransparency = 1
    
    topbar.Minimize.Position = UDim2.new(0.837349415, 0, 0.49000001, 0)
    topbar.Minimize.Size = UDim2.new(0, 30, 0, 5)
    topbar.Minimize.BackgroundColor3 = colors.White

    local uICorner = Instance.new("UICorner")
    uICorner.Name = "UICorner"
    uICorner.CornerRadius = UDim.new(10, 50)
    uICorner.Parent = categoryicon
    categoryicon.BackgroundColor3 = colors.White

    local gui = category

    local dragging
    local dragInput
    local dragStart
    local startPos

    local function update(input)
        local delta = input.Position - dragStart
        gui.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end

    gui.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = gui.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    gui.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)

    uis.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            update(input)
        end
    end)

    categorytitle.Text = title or tostring(math.random(1, 3584))
    -- categoryicon.Image = icon or ""
    
    table.insert(self.objects, category)
    return category
end

function liquidbounce:CreateModule(root, text, callback)
    local container = root:FindFirstChild("Container")

    if not container then
        container = props.Objects.Container:Clone()
        container.Name = "Container"
        container.Parent = root
    end

    local ti = TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut)
    
    local module = props.Objects.Module:Clone()
    module.BackgroundColor3 = colors.Background
    module.Parent = container
    module.Text = text or "test"
    
    local sc = props.Objects.SettingsContainer:Clone()
    sc.Name = "SettingsContainer"
    sc.Parent = module
    sc.Visible = false
    sc.Size = UDim2.new(0, 250, 1, 33297)
    
    local arrow = module.Arrow
    arrow.BackgroundTransparency = 1

    local Frame = Instance.new("Frame")
    local Frame_2 = Instance.new("Frame")

    Frame.Parent = arrow
    Frame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Frame.BorderColor3 = Color3.fromRGB(0, 0, 0)
    Frame.BorderSizePixel = 0
    Frame.Position = UDim2.new(0.330000012, 0, 0.379999995, 0)
    Frame.Rotation = 45.000
    Frame.Size = UDim2.new(0, 12, 0, 3)

    Frame_2.Parent = arrow
    Frame_2.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Frame_2.BorderColor3 = Color3.fromRGB(0, 0, 0)
    Frame_2.BorderSizePixel = 0
    Frame_2.Position = UDim2.new(0.330000012, 0, 0.589999974, 0)
    Frame_2.Rotation = -45.000
    Frame_2.Size = UDim2.new(0, 12, 0, 3)
    
    local opened = false
    arrow.MouseButton1Click:Connect(function()
        opened = not opened
        module.SettingsContainer.Visible = opened
        arrow.Rotation = opened and 90 or 0
    end)
    
    local toggled = false
    module.MouseButton1Click:Connect(function()
        toggled = not toggled
        if toggled then
            module.TextColor3 = colors.Blue
        else
            module.TextColor3 = colors.White
        end
        if callback then
            callback(toggled)
        end
    end)
    
    module.MouseEnter:Connect(function()
        if not toggled then
            local tween = TweenService:Create(module, ti, {
                TextColor3 = colors.Blue,
                BackgroundTransparency = 0
            })
            tween:Play()
        end
    end)
    
    module.MouseLeave:Connect(function()
        if not toggled then
            local tween = TweenService:Create(module, ti, {
                TextColor3 = colors.White,
                BackgroundTransparency = 1
            })
            tween:Play()
        end
    end)
    
    return module
end

function liquidbounce:CreateToggle(module, title, callback)
    local toggle = props.Objects.ToggleOff:Clone()
    toggle.Parent = module.SettingsContainer.Settings
    
    toggle.Title.Text = title or "Toggle"
    toggle.ToggleContainer.Body.BackgroundColor3 = colors.tboff
    toggle.ToggleContainer.Pinhead.BackgroundColor3 = colors.tpoff
    local uICorner = Instance.new("UICorner")
    uICorner.Name = "UICorner"
    uICorner.CornerRadius = UDim.new(10, 50)
    uICorner.Parent = toggle.ToggleContainer.Pinhead
    local uicorner2 = uICorner:Clone()
    uicorner2.Parent = toggle.ToggleContainer.Body
    
    toggle.ToggleContainer.Pinhead.Position = UDim2.new(0.237, 0, 0.5, -0)
    
    local toggled = false
    toggle.MouseButton1Click:Connect(function()
        toggled = not toggled
        local endpos = toggled and UDim2.new(0.487, 0, 0.5, -0) or UDim2.new(0.237, 0, 0.5, -0)
        toggle.ToggleContainer.Pinhead:TweenPosition(endpos, "Out", "Quad", 0.25, true)
        toggle.ToggleContainer.Pinhead.BackgroundColor3 = toggled and colors.tpon or colors.tpoff
        toggle.ToggleContainer.Body.BackgroundColor3 = toggled and colors.tbon or colors.tboff
        if callback then
            callback(toggled)
        end
    end)
    
    return toggle
end

function liquidbounce:CreateSlider(module, title, min, max, default, callback)
    local slider = props.Objects.Slider:Clone()
    slider.Parent = module.SettingsContainer.Settings
    
    slider.Title.Text = title or "Slider"
    slider.Value.Text = tostring(default or 0)
    
    local bg = slider.BG
    local filled = bg.Filled
    local pinhead = bg.PinHead
    pinhead["PinHead_Roundify_12px"].BackgroundColor3 = colors.Blue
    local uICorner = Instance.new("UICorner")
    uICorner.Name = "UICorner"
    uICorner.CornerRadius = UDim.new(10, 50)
    uICorner.Parent = pinhead["PinHead_Roundify_12px"]
    
    local currentvalue = default or 0
    
    local function updatepercent()
        local percentage = (currentvalue - min) / (max - min)
        filled.Size = UDim2.new(percentage, 0, 1, 0)
        pinhead.Position = UDim2.new(0, percentage * bg.AbsoluteSize.X, 0, 0)
    end
    
    pinhead.MouseButton1Down:Connect(function()
        local startx = pinhead.AbsolutePosition.X
        local iv = currentvalue
        
        local function updateslider(x)
            local percentage = (x - startx) / bg.AbsoluteSize.X
            local nv = iv + (max - min) * percentage
            currentvalue = math.clamp(nv, min, max)
            slider.Value.Text = tostring(math.floor(currentvalue))
            updatepercent()
            if callback then callback(currentvalue) end
        end
        
        local connection
        connection = uis.InputChanged:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseMovement then
                updateslider(input.Position.X)
            end
        end)
        
        uis.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                connection:Disconnect()
            end
        end)
    end)
    
    updatepercent()
    
    return slider
end

function liquidbounce:CreateDropdown(module, title, options, callback)
    local dropdown = props.Objects.Dropdown:Clone()
    dropdown.Parent = module.SettingsContainer.Settings

    dropdown.Text = title or "Dropdown"
    local arrow = dropdown.Arrow
    local dropdownFrame = dropdown.DropdownFrame
    arrow.BackgroundTransparency = 1

    local Frame = Instance.new("Frame")
    local Frame_2 = Instance.new("Frame")

    Frame.Parent = arrow
    Frame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Frame.BorderColor3 = Color3.fromRGB(0, 0, 0)
    Frame.BorderSizePixel = 0
    Frame.Position = UDim2.new(0.330000012, 0, 0.379999995, 0)
    Frame.Rotation = 45.000
    Frame.Size = UDim2.new(0, 12, 0, 3)
    Frame.ZIndex = 4

    Frame_2.Parent = arrow
    Frame_2.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Frame_2.BorderColor3 = Color3.fromRGB(0, 0, 0)
    Frame_2.BorderSizePixel = 0
    Frame_2.ZIndex = 4
    Frame_2.Position = UDim2.new(0.330000012, 0, 0.589999974, 0)
    Frame_2.Rotation = -45.000
    Frame_2.Size = UDim2.new(0, 12, 0, 3)

    dropdownFrame.Visible = false
    arrow.Rotation = 0

    for i, v in pairs(options) do
        local selection = dropdownFrame:FindFirstChild("Selection" .. i) or dropdownFrame.Selection1:Clone()
        selection.Name = "Selection" .. i
        selection.Text = v
        selection.Visible = true
        selection.Parent = dropdownFrame

        selection.MouseButton1Click:Connect(function()
            dropdown.Text = "MagnetType · " .. v
            dropdownFrame.Visible = false
            arrow.Rotation = 0
            if callback then
                callback(v)
            end
        end)
    end

    for i = #options + 1, 3 do
        local selection = dropdownFrame:FindFirstChild("Selection" .. i)
        if selection then
            selection.Visible = false
        end
    end

    local function toggleDropdown()
        dropdownFrame.Visible = not dropdownFrame.Visible
        arrow.Rotation = dropdownFrame.Visible and 90 or 0
    end

    dropdown.MouseButton1Click:Connect(toggleDropdown)
    arrow.MouseButton1Click:Connect(toggleDropdown)

    return dropdown
end

function liquidbounce:CreateNotification(title, description, time, icon, color)

    local notif = props.Objects.notif:Clone()
    notif.BackgroundTransparency = 1
    notif.Title.TextTransparency = 1
    notif.Description.TextTransparency = 1
    notif.Parent = self.root:FindFirstChild("NotificationContainer")

    -- notif.ImageLabel.Image = icon or "http://www.roblox.com/asset/?id=6026568227"
    notif.ImageLabel.BackgroundColor3 = color or colors.Blue
    -- notif.ImageLabel.ImageTransparency = 1

    notif.Title.Text = title or "Notification"
    notif.Title.Size = UDim2.new(0, 285, 0, 46)
    notif.Description.Text = description or "..."
    notif.Description.Size = UDim2.new(0, 285, 0, 37)
    local ti = TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.InOut)

    TweenService:Create(notif, ti, {BackgroundTransparency = 0}):Play()
    TweenService:Create(notif.Title, ti, {TextTransparency = 0}):Play()
    TweenService:Create(notif.Description, ti, {TextTransparency = 0}):Play()
    -- TweenService:Create(notif.ImageLabel, ti, {ImageTransparency = 0}):Play()
    task.delay(time or 5, function()
        TweenService:Create(notif, ti, {BackgroundTransparency = 1}):Play()
        TweenService:Create(notif.Title, ti, {TextTransparency = 1}):Play()
        TweenService:Create(notif.Description, ti, {TextTransparency = 1}):Play()
        -- TweenService:Create(notif.ImageLabel, ti, {ImageTransparency = 1}):Play()
        task.wait(0.5)
        notif:Destroy()
    end)

end

return liquidbounce
