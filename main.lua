local Signal = {}
Signal.__index = Signal
function Signal.new()
    local self = setmetatable({}, Signal)

    self.Bindable = Instance.new("BindableEvent")
    
    return self
end

function Signal:Connect(func)
    return self.Bindable:Connect(func)
end

function Signal:Fire(...)
    self.Bindable:Fire(...)
end

function Signal:Disconnect()
    self.Bindable:Destroy()
    self.Bindable = nil
end

local Library = {}
local Context = {}
local IgnoreStrings = {
    'Clear',
    'SetStyle',
    'SetColor',
    'SetTabStyle',
    'SetTabColor',
    'Show',
    'Emplace'
}
Library.__index = Library

function Library:new(properties)
    properties = properties or {}
    local Window = properties.__window or RenderWindow.new(properties.title or properties.tag or game.HttpService:GenerateGUID())
    for i,v in properties do
        local s = pcall(function()
            Window[i] = v
        end)
    end

    local parent = self
    local self = {}

    local colors = {} --real table, the one exposed is a proxy
    local styles = {} --real table, the one exposed is a proxy.
    self.title = ""
    self.tag = ""
    self.Window = Window
    self.SubLibrary = {}
    self.flags = {}
    self.Children = {}
    self.colors = setmetatable({}, {
        __newindex = function(tbl, index, value)
            assert(typeof(value) == "table" or value[1] == nil, "Value is not a dictionary!")
            assert(RenderColorOption[index], string.format("Invalid String Type! Got %s", index))
            colors[index] = value
            self.Window:SetColor(RenderColorOption[index], value[1], value[2])
        end, __index = colors
    })
    self.styles = setmetatable({}, {
        __newindex = function(tbl, index, value)
            assert(value, "Value is nil.")
            assert(RenderStyleOption[index], string.format("Invalid String Type! Got %s", index))
            styles[index] = value
            self.Window:SetStyle(RenderStyleOption[index], value)
        end, __index = styles
    })
    --object.OnFlagChanged = Signal.new()
    self.properties = properties
    if parent.Children then
        self.__super = parent
        self.flags = self.__super.flags
    end
    local object = setmetatable(self, {
        __newindex = function(tbl, index, value)
            if index == "colors" or index == "styles" then
                for i,v in pairs(value) do
                    self[index][i] = v
                end
            end
            rawset(tbl, index, value)
        end,
        __index = function(tbl, index)
        if Library[index] then
            return Library[index]
        end
        if tbl.Window[index] then
            if typeof(tbl.Window[index]) == 'function' and not table.find(IgnoreStrings, index) then
                return function(Library, ...)
                    local args = {...}
                    local properties = {}
                    for i,v in args do
                        if type(v) == 'table' then
                            for m,n in v do
                                properties[m] = n
                            end
                        end
                    end
                    properties.type = index
                    local new = Library:__Add(properties)
                    table.insert(self.Children, new)
                    return new
                end
            end
            return tbl.Window[index]
        end
    end})

    return object
end

function Library:__Add(properties)
    assert(properties.type, "Object Type not provided.")
    local object = self.Window[properties.type](self.Window, properties.title)
    
    for i,v in properties do
        pcall(function()
            if type(v) ~= "function" then
                object[i] = v
            else
                object[i]:Connect(function(...)
                    v(object, ...)
                end)
            end
        end)
    end
    pcall(function()
        local flagName = properties.tag or properties.title or properties.Label
        if Window.flags[flagName] == nil then
            Window.flags[flagName] = object.Value
        else
            object.Value = Window.flags[flagName]
        end
        object.OnUpdated:Connect(function(...)
            local args = {...}
            Window.flags[flagName] = #args > 1 and args or args[1]
            
        end)
    end)

    return object
end

function Library:Clear()
    self.Window:Clear()
end

function Library:Destroy()
    self:Clear()
    table.clear(self)
end

function Library.With(item, func)
    if not item.SubLibrary then
        item = Library:new({__window=item})
    end
    local s,e = pcall(func, item)
    if not s then
        warn(debug.traceback(e))
    end
    return item
end

return Library, Flags
