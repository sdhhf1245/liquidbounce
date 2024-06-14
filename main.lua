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

local props = game:GetObjects("rbxassetid://17844772578")[1]:Clone()
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
    categoryicon.Image = icon or ""
    
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
    
    local arrow = module.Arrow
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
    toggle.ToggleContainer.Body.ImageColor3 = colors.tboff
    toggle.ToggleContainer.Pinhead.ImageColor3 = colors.tpoff
    
    toggle.ToggleContainer.Pinhead.Position = UDim2.new(0.237, 0, 0.5, -0)
    
    local toggled = false
    toggle.MouseButton1Click:Connect(function()
        toggled = not toggled
        local endpos = toggled and UDim2.new(0.487, 0, 0.5, -0) or UDim2.new(0.237, 0, 0.5, -0)
        toggle.ToggleContainer.Pinhead:TweenPosition(endpos, "Out", "Quad", 0.25, true)
        toggle.ToggleContainer.Pinhead.ImageColor3 = toggled and colors.tpon or colors.tpoff
        toggle.ToggleContainer.Body.ImageColor3 = toggled and colors.tbon or colors.tboff
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

    notif.ImageLabel.Image = icon or "http://www.roblox.com/asset/?id=6026568227"
    notif.ImageLabel.ImageColor3 = color or colors.Blue
    notif.ImageLabel.ImageTransparency = 1

    notif.Title.Text = title or "Notification"
    notif.Description.Text = description or "..."
    notif.Description.Size = UDim2.new(0, 285, 0, 37)
    local ti = TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.InOut)

    TweenService:Create(notif, ti, {BackgroundTransparency = 0}):Play()
    TweenService:Create(notif.Title, ti, {TextTransparency = 0}):Play()
    TweenService:Create(notif.Description, ti, {TextTransparency = 0}):Play()
    TweenService:Create(notif.ImageLabel, ti, {ImageTransparency = 0}):Play()
    task.delay(time or 5, function()
        TweenService:Create(notif, ti, {BackgroundTransparency = 1}):Play()
        TweenService:Create(notif.Title, ti, {TextTransparency = 1}):Play()
        TweenService:Create(notif.Description, ti, {TextTransparency = 1}):Play()
        TweenService:Create(notif.ImageLabel, ti, {ImageTransparency = 1}):Play()
        task.wait(0.5)
        notif:Destroy()
    end)

end

local ui = liquidbounce.new()

local category1 = ui:CreateCategory("Misc", "http://www.roblox.com/asset/?id=6026568227")

local antibot = ui:CreateModule(category1, "antibot", function(v)
    print(v)
    local notif1 = ui:CreateNotification("skibidi", "please help me I am going insane fadsadfs ;ljadfs jl;kadfs jkl;adfs l;jkaf dsljk;adfs jkl;adfs jkl;adfs j som e more text to make it longer...", 2, "http://www.roblox.com/asset/?id=6031068421", colors.Green)
end)

local toggle1 = ui:CreateToggle(antibot, "Hitbox", function(v)
    print(v)
end)
local toggle2 = ui:CreateToggle(antibot, "Rainbow", function(v)
    print(v)
end)

local slider1 = ui:CreateSlider(antibot, "Slider 1", 0, 100, 50, function(value)
    print("Slider 1 value:", value)
end)
local slider2 = ui:CreateSlider(antibot, "Slider 2", 0, 10, 5, function(value)
    print("Slider 2 value:", value)
end)

local dropdown1 = ui:CreateDropdown(antibot, "Choose Option", {"Option 1", "Option 2", "Option 3", "Option 4"}, function(selectedOption)
    print("Selected Option:", selectedOption)
end)

return liquidbounce

