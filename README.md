# liquidbounce
a roblox ui library for the popular hacked client, liquidbounce

![example image of the liquidbounce ui library](https://raw.githubusercontent.com/sdhhf1245/liquidbounce/main/example.png)


# documentation
## create the ui
```lua
local liquidbounce = loadstring(game:HttpGet("https://raw.githubusercontent.com/sdhhf1245/liquidbounce/main/noimages.lua", true))()

local ui = liquidbounce.new()
```

## create a category
```lua
local category1 = ui:CreateCategory("Misc", "http://www.roblox.com/asset/?id=6026568227")
-- ui:CreateCategory(title, icon)
```

## create a module
```lua
local antibot = ui:CreateModule(category1, "antibot", function(v)
    print(v)
end)
-- ui:CreateModule(category, text, callback)
```

# create settings inside a module
## create a toggle
```lua
local toggle1 = ui:CreateToggle(antibot, "Hitbox", function(v)
    print(v)
end)
-- ui:CreateToggle(module, title, callback)
```

## create a slider
```lua
local slider1 = ui:CreateSlider(antibot, "Slider 1", 0, 100, 50, function(value)
    print(value)
end)
-- ui:CreateSlider(module, title, min, max, default, callback)
```

## making a dropdown
```lua
local dropdown1 = ui:CreateDropdown(antibot, "Choose Option", {"Option 1", "Option 2", "Option 3", "Option 4"}, function(v)
    print(v)
end)
-- ui:CreateDropdown(module, title, options (inside a table), callback)
```

## create a notification
```lua
 local notif1 = ui:CreateNotification("hi", "cool!", 2, "http://www.roblox.com/asset/?id=6031068421", colors.Green)
 -- ui:CreateNotification(title, description, time, icon, imagecolor)
```
![example image of a notification](https://raw.githubusercontent.com/sdhhf1245/liquidbounce/main/notification.png)

## the full script
```lua
local liquidbounce = loadstring(game:HttpGet("https://raw.githubusercontent.com/sdhhf1245/liquidbounce/main/noimages.lua", true))()

local ui = liquidbounce.new()

local category1 = ui:CreateCategory("Misc", "http://www.roblox.com/asset/?id=6026568227")

local antibot = ui:CreateModule(category1, "antibot", function(v)
    print(v)
    local notif1 = ui:CreateNotification("skibidi", "please help me I am going insane fadsadfs ;ljadfs jl;kadfs jkl;adfs l;jkaf dsljk;adfs jkl;adfs jkl;adfs j som e more text to make it longer...", 2, "http://www.roblox.com/asset/?id=6031068421", colors.Green)
end)

local toggle1 = ui:CreateToggle(antibot, "Hitbox", function(v)
    print(v)
end)

local slider1 = ui:CreateSlider(antibot, "Slider 1", 0, 100, 50, function(value)
    print(value)
end)

local dropdown1 = ui:CreateDropdown(antibot, "Choose Option", {"Option 1", "Option 2", "Option 3", "Option 4"}, function(v)
    print(v)
end)
```

# by sdhhf (also by the way, there are different types of the ui, one of them uses 0 images for some games that detect images.)
