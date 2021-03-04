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
Menu.GetCurrent = Menu.Current
Menu.CurrentMenu = Menu.GetCurrent
Menu.GetCurrentMenu = Menu.CurrentMenu
Menu.Parent = function(id)
    if not Menu[id] then return end 
    return Menu[Menu[id].parent]
end 
Menu.Set = function(id,property,value)
    if Datas[id] == nil then  Datas[id] = {} end
    if Datas[id][property] == nil then Datas[id][property] = {} end 
    Datas[id][property] = value
end 
Menu.Create = function (id,title,header,cb)
    Menu.Set(id,'id',id)
    Menu.Set(id,'title',title)
    Menu.Set(id,'header',header)
    local elements = {}
    elements.option = function (...) Menu.AddOption(id,...) end 
    elements.submenu = function (...) 
        local tbl = {...} Menu.CreateSub(tbl[1],tbl[2],tbl[3],id,tbl[4]) 
        Menu.AddOption(id,tbl[2],"<img height='18' width = '20'  src='img://commonmenu/arrowright'>","Open Sub Menu:"..tbl[1],{},tbl[1])
    end 
    cb(elements)
    Menu.Set(id,'loaded',true)
end 
Menu.CreateSub = function (id,title,header,parent,cb)
    Menu.Set(id,'id',id)
    Menu.Set(id,'title',title)
    Menu.Set(id,'header',header)
    if not parent then error('parent not set') end 
    Menu.Set(id,'parent',parent)
    Menu.Set(parent,'sub',id)
    local elements = {}
    elements.option = function (...) Menu.AddOption(id,...) end 
    elements.submenu = function (...) 
        local tbl = {...} Menu.CreateSub(tbl[1],tbl[2],tbl[3],id,tbl[4]) 
        Menu.AddOption(id,tbl[2],"<img height='18' width = '20'  src='img://commonmenu/arrowright'>","Open Sub Menu:"..tbl[1],{},tbl[1])
    end 
    cb(elements)
    Menu.Set(id,'loaded',true)
end 
Menu.IsLoaded = function(id)
    if Menu[id] and Menu[id].loaded then 
        return true 
    else 
        return false 
    end 
end 
Menu.Open = function (id,cb)
    CreateThread(function() 
    RequestStreamedTextureDict( "commonmenu" )
    while not HasStreamedTextureDictLoaded("commonmenu")  do 
        Wait(0)
    end 
    while not Menu.IsLoaded(id) do 
        Wait(0)
    end 
    if not Menu or not Menu[id] then  error("Menu:".. id .." not created"); end 
    if CurrentMenu and not Menu[id] then return end 
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
        for kk,kv in pairs(ov) do 
            if type(kv) ~= 'function' then 
                print('option:'..o , 'values('..kk..'):'..json.encode(kv))
            end 
        end 
    end 
    if Menu.OnAction then Menu.OnAction("OPEN",CurrentMenu) end 
    if cb then cb(CurrentMenu) end 

    end)
end 
Menu.Close = function (id,cb)
    if Menu.OnAction then Menu.OnAction("CLOSE",CurrentMenu) end 
    Menu.Release(id)
end 
Menu.Back = function (id,cb)
    if Menu.Parent(id) then 
        Menu.Open(Menu.Parent(id).id,cb)
    else 
        Menu.Close(id,cb)
    end 
end 
Menu.AddOption = function(id, textL, textR, desc, data , targetMenuID)
    if not textL then 
        textL = ""
    end 
    if not data then 
        data = {}
    end 
    
    if Datas[id] == nil then  Datas[id] = {} end
    if type(textR) == 'string' then 
        if Datas[id]['options'] == nil then Datas[id]['options'] = {} end 
        table.insert(Datas[id]['options'],{textL = textL,data = data ,textR = textR, desc = desc,targetMenuID = targetMenuID,style = "normal"})
    elseif type(textR) == 'table' then  
        if Datas[id]['options'] == nil then Datas[id]['options'] = {} end 
        table.insert(Datas[id]['options'],{textL = textL,data = data ,textR = textR, desc = desc,targetMenuID = targetMenuID,style = "slide",nowsidx = 1,maxsidx = #textR})
    end 
end
Menu.Release = function(id)
    Datas[id] = nil 
    CurrentMenu = nil 
    collectgarbage()
end 
Menu.Delete = Menu.Release
local keys = { down = 187, up = 188, left = 189, right = 190, select = 191, back = 194 }
CreateThread(function()
Threads.CreateLoopOnce(function()
    if CurrentMenu then 
        if IsControlPressed(0, keys.down) then
        
            if Menu.OnKey then 
            Menu.OnKey("DOWN",CurrentMenu,function(cbidx)
                if cbidx > 0 then 
                if Menu.OnAction then Menu.OnAction('CHANGE',CurrentMenu,cbidx) end 
                else error("menu options idx = 0 not for lua table")
                end 
            end)
            end
            Citizen.Wait(175)
        elseif IsControlPressed(0, keys.up) then
            if Menu.OnKey then 
            Menu.OnKey("UP",CurrentMenu,function(cbidx)
                if cbidx > 0 then 
                if Menu.OnAction then Menu.OnAction('CHANGE',CurrentMenu,cbidx) end 
                else error("menu options idx = 0 not for lua table")
                end 
            end)
            end
            Citizen.Wait(175)
        elseif IsControlPressed(0, keys.left) then
            if Menu.OnKey then
            Menu.OnKey("LEFT",CurrentMenu,function(cbidx,cbsidx)
                if cbidx > 0 then 
                    if CurrentMenu.options[cbidx].style == "slide" then 
                        if cbsidx and cbsidx > 0 then 
                            if Menu.OnAction then Menu.OnAction('SLIDE',CurrentMenu,cbidx,cbsidx) end 
                        end 
                    end
                else error("menu options idx = 0 not for lua table")
                end 
            end)
            end 
            Citizen.Wait(175)
        elseif IsControlPressed(0, keys.right) then
            if Menu.OnKey then
            Menu.OnKey("RIGHT",CurrentMenu,function(cbidx,cbsidx)
                if cbidx > 0 then 
                    if CurrentMenu.options[cbidx].style == "slide" then 
                        if cbsidx and cbsidx > 0 then 
                        if Menu.OnAction then Menu.OnAction('SLIDE',CurrentMenu,cbidx,cbsidx) end 
                        end 
                    end
                else error("menu options idx = 0 not for lua table")
                end 
            end)
            end 
            Citizen.Wait(175)
        elseif IsControlPressed(0, keys.select) then
            if Menu.OnKey then
            Menu.OnKey("SELECT",CurrentMenu,function(cbidx,cbsidx)
                if cbidx > 0 then 
                 if Menu.OnAction then Menu.OnAction('SELECT',CurrentMenu,cbidx,cbsidx) end 
                else error("menu options idx = 0 not for lua table")
                end 
            end)
            end 
            Citizen.Wait(175)
        elseif IsControlPressed(0, keys.back) then
            if Menu.OnAction then
            Menu.OnAction("BACK",CurrentMenu)
            end 
            Citizen.Wait(175)
        end
    end 
end)
end)