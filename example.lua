local lib = syn.request({ Url = "https://raw.githubusercontent.com/sv3softworks/RWLibrary/main/main.lua" }).Body
local Library = loadstring(lib)()
local Window, Flags = Library.new({Size = Vector2.new(600,400)})
if getgenv().Window then
    table.clear(getgenv().Window)
end
getgenv().Window = Window

local Tabs = {
    Aimbot = function(Library)
        Library.With(Library:TabMenu({}), function(Library)
            Library.With(Library:Add({title = "aimbot"}), function(Library)
                Library:Button({Label = "A!"})
            end)
        end)
    end,
    Visuals = function(Library)
        Library.With(Library:TabMenu({}), function(Library)
            Library.With(Library:Add({title = "visuals"}), function(Library)
                Library:Button({Label = "B!"})
            end)
        end)
    end,
}

Library.With(Window, function(Library)
    --print(Library.__super and Library.__super.properties.title)
    Library.styles.WindowMinSize = Vector2.new(600,490)
    Library.styles.ScrollbarSize = 0
    Library.styles.ChildBorderSize = 3
    Library.styles.GrabMinSize = 0
    Library.colors.Border = {Color3.fromRGB(255,255,0), 1}
    Library.With(Library:SameLine({}), function(Library)
        Library.styles.ChildBorderSize = 3
        Library.styles.WindowBorderSize = 3
        local CheatWindow
        Library.With(Library:Child({Size = Vector2.new(200,440)}), function(Library)
            Library.styles.ScrollbarSize = 0
            Library.With(Library:Child({Size = Vector2.new(200,80)}), function(Library)
                Library:Label({title='defconhax', Size = Library.properties.Size})
            end)
            Library.With(Library:Child({Size = Vector2.new(200,280)}), function(Library)
                local Preset = {Size = Vector2.new(181,26), Toggles = true, OnUpdated = function(self, Val)
                    print'pressed'
                    if Val then
                        for i,v in pairs(Library.Children) do
                            if v ~= self then
                                v.Value = false
                            end
                        end
                    end
                    CheatWindow:Clear()
                    if Tabs[self.Label] then
                       Tabs[self.Label](CheatWindow) 
                    end
                end}
                Library:Selectable({Label="Aimbot"}, Preset)
                Library:Selectable({Label="Visuals"}, Preset)
                Library:Selectable({Label="Misc"}, Preset)
                Library:Selectable({Label="Credits"}, Preset)
            end)
            Library.With(Library:Child({Size = Vector2.new(200,40)}), function(Library)
                Library:Label({title='defconhax', Size = Library.properties.Size})
            end)
        end)
        CheatWindow = Library.With(Library:Child({}), function(Library)
            Library.With(Library:TabMenu({}), function(Library)
                Library.With(Library:Add({title = "testTab"}), function(Library)
                    Library:Button({Label = "Works!"})
                end)
            end)
        end)
    end)
end)

task.wait(35)
table.clear(getgenv().Window)
Window = nil
getgenv().Window = nil
