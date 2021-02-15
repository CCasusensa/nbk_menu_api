Datas = {}
Menu = {} 


switch = function(data,cb) --setmetatable(
    --{
        --reset = function(s) s = switch;end 
    --},
    --{
        --__call = function(tbl, data)
            
            cb(setmetatable(
                {},
                {__newindex = function(t, k, v) 
                        
                        if data == k then
                            v()
                            --switch.reset(switch)
                        end
                end}
            ))
        --end
    --}
--)
end

setmetatable(Menu,{__index = Datas})

CurrentMenu = nil 

Menu.Current = function()
    return CurrentMenu
end 

Menu.Parent = function(id)
    
    return Menu[Menu[id].parent]
end 

Menu.Set = function(id,property,value)
    if Datas[id] == nil then  Datas[id] = {} end
    if Datas[id][property] == nil then Datas[id][property] = {} end 
    Datas[id][property] = value
end 

Menu.Create = function (id,title,description,cb)
    Menu.Set(id,'id',id)
    Menu.Set(id,'title',title)
    Menu.Set(id,'description',description)
    local elements = {}
    elements.option = function (...) Menu.AddOption(id,...) end 
    elements.sub = function (...) local tbl = {...} Menu.CreateSub(tbl[1],tbl[2],tbl[3],id,tbl[4]) end 
    cb(elements)
end 

Menu.CreateSub = function (id,title,description,parent,cb)
    Menu.Set(id,'id',id)
    Menu.Set(id,'title',title)
    Menu.Set(id,'description',description)
    if not parent then error('parent not set') end 
    Menu.Set(id,'parent',parent)
    local elements = {}
    elements.option = function (...) Menu.AddOption(id,...) end 
    elements.sub = function (...) local tbl = {...} Menu.CreateSub(tbl[1],tbl[2],tbl[3],id,tbl[4]) end 
    cb(elements)
end 

Menu.Open = function (id,cb)
    print(id)
    if not CurrentMenu then 
        CurrentMenu = Menu[id]
    elseif CurrentMenu ~= Menu[id] then 
        CurrentMenu = Menu[id]
    end 
    local options = {}
    for i,v in pairs(CurrentMenu) do 
        if i ~= 'options' then 
            print(i,v)
        else 
            options = v 
        end 
    end 
    print("Options:")
    for o,ov in pairs(options) do 
        print(o,json.encode(ov))
    end 
    TriggerEvent('Menu:OnOpen',CurrentMenu)
    if cb then cb(CurrentMenu) end 
    return CurrentMenu
end 

Menu.Close = function (id,cb)
    TriggerEvent('Menu:OnClose',CurrentMenu)
    if Menu.Parent(id) then 
        Menu.Open(Menu.Parent(id).id,cb)
    end 
end 

Menu.AddOption = function(id, text, data, desc, onChange, onSelect )
    if not text then 
        text = ""
    end 
    if not data then 
        data = {}
    end 
    if Datas[id] == nil then  Datas[id] = {} end
    if Datas[id]['options'] == nil then Datas[id]['options'] = {} end 
    table.insert(Datas[id]['options'],{text = text,data = data ,desc = desc, onSelect = onSelect, onChange = onChange})
end

Menu.Release = function(id)
    Datas[id] = nil 
    collectgarbage()
end 
Menu.Delete = Menu.Release

local keys = { down = 187, up = 188, left = 189, right = 190, select = 191, back = 194 }
Threads.CreateLoopOnce(function()
    if IsControlJustReleased(0, keys.down) then
        TriggerEvent('Menu:OnKeyDown',CurrentMenu)
	elseif IsControlJustReleased(0, keys.up) then
        TriggerEvent('Menu:OnKeyUp',CurrentMenu)
	elseif IsControlJustReleased(0, keys.left) then
        TriggerEvent('Menu:OnKeyLeft',CurrentMenu)
	elseif IsControlJustReleased(0, keys.right) then
		TriggerEvent('Menu:OnKeyRight',CurrentMenu)
	elseif IsControlJustReleased(0, keys.select) then
        TriggerEvent('Menu:OnKeySelect',CurrentMenu)
	elseif IsControlJustReleased(0, keys.back) then
		TriggerEvent('Menu:OnKeyBack',CurrentMenu)
	end
end)


