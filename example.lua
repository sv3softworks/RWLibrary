local lib = syn.request({ Url = "https://raw.githubusercontent.com/sv3softworks/RWLibrary/main/main.lua" }).Body
local Library = loadstring(lib)()
local Window = Library.new({Size = Vector2.new(600,400)})
if getgenv().Window then
    table.clear(getgenv().Window)
end
getgenv().Window = Window

Library.With(Window, function(Library)
    Library.colors.WindowBg = {Color3.new(0,0,0), 0.5}
    Library:Button({Label = "test"})
    Library.With(Library:TabMenu({}), function(Library)
        Library.With(Library:Add({title = "testTab"}), function(Library)
            Library:Button({Label = "Works!"})
        end)
    end)
end)

task.wait(15)
Window = nil
getgenv().Window = nil
