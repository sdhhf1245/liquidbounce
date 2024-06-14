# liquidbounce
a roblox ui library for the popular hacked client, liquidbounce

# documentation
## create the ui
```lua
local ui = liquidbounce.new()
```

## making a category
```lua
local category1 = ui:CreateCategory("Misc", "http://www.roblox.com/asset/?id=6026568227")
ui:CreateCategory(title, icon)
```

## making a module
```lua
local antibot = ui:CreateModule(category1, "antibot", function(v)
    print(v)
end)
ui:CreateModule(category, text, callback)
```

# making settings inside a module
## making a toggle
```lua
local toggle1 = ui:CreateToggle(antibot, "Hitbox", function(v)
    print(v)
end)
ui:CreateToggle(module, title, callback)
```

## making a slider
```lua
local slider1 = ui:CreateSlider(antibot, "Slider 1", 0, 100, 50, function(value)
    print(value)
end)
ui:CreateSlider(module, title, min, max, default, callback)
```

## making a dropdown
```lua
local dropdown1 = ui:CreateDropdown(antibot, "Choose Option", {"Option 1", "Option 2", "Option 3", "Option 4"}, function(v)
    print(v)
end)
ui:CreateDropdown(module, title, options (inside a table), callback)
```

## making a notification
```lua
 local notif1 = ui:CreateNotification("hi", "cool!", 2, "http://www.roblox.com/asset/?id=6031068421", colors.Green)
 ui:CreateNotification(title, description, time, icon, imagecolor)
 ```

# by sdhhf (also by the way, there are different types of the ui, one of them uses 0 images for some games that detect images.
