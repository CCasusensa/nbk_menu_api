CreateThread(function()
    Menu.Create("menu1","HELLO","WORLD",function(add)
        add.option("MENU1 ITEM1",{1,2,3},"WTF1",{onChange = function(idx) print('onChange idx :'..idx)  end , onSelect = function(idx) print('onSelect idx :'..idx) end} )
        add.option("MENU1 ITEM2",{1,2,3},"WTF2",{onChange = function(idx) print('onChange idx :'..idx)  end , onSelect = function(idx) print('onSelect idx :'..idx) end} )
        add.option("MENU1 ITEM3",{1,2,3},"WTF3",{onChange = function(idx) print('onChange idx :'..idx)  end , onSelect = function(idx) print('onSelect idx :'..idx) end} )
        add.option("MENU1 ITEM4",{1,2,3},"WTF4",{onChange = function(idx) print('onChange idx :'..idx)  end , onSelect = function(idx) print('onSelect idx :'..idx) end} )
        add.sub("menu2","HELLO2","WORLD2",function(add)
            add.option("MENU2 ITEM1",{1,2,3},"WTF1",{onChange = function(idx) print('onChange idx :'..idx)  end , onSelect = function(idx) print('onSelect idx :'..idx) end} )
            add.option("MENU2 ITEM2",{1,2,3},"WTF2",{onChange = function(idx) print('onChange idx :'..idx)  end , onSelect = function(idx) print('onSelect idx :'..idx) end} )
            add.option("MENU2 ITEM3",{1,2,3},"WTF3",{onChange = function(idx) print('onChange idx :'..idx)  end , onSelect = function(idx) print('onSelect idx :'..idx) end} )
            add.option("MENU2 ITEM4",{1,2,3},"WTF4",{onChange = function(idx) print('onChange idx :'..idx)  end , onSelect = function(idx) print('onSelect idx :'..idx) end} )
            add.sub("menu3","HELLO3","WORLD3",function(add)
                add.option("MENU3 ITEM1",{1,2,3},"WTF1",{onChange = function(idx) print('onChange idx :'..idx)  end , onSelect = function(idx) print('onSelect idx :'..idx) end} )
                add.option("MENU3 ITEM2",{1,2,3},"WTF2",{onChange = function(idx) print('onChange idx :'..idx)  end , onSelect = function(idx) print('onSelect idx :'..idx) end} )
                add.option("MENU3 ITEM3",{1,2,3},"WTF3",{onChange = function(idx) print('onChange idx :'..idx)  end , onSelect = function(idx) print('onSelect idx :'..idx) end} )
                add.option("MENU3 ITEM4",{1,2,3},"WTF4",{onChange = function(idx) print('onChange idx :'..idx)  end , onSelect = function(idx) print('onSelect idx :'..idx) end} )
            end)
        end)
    end )
    Menu.Open("menu3" ,function(data) 
            local options = data.options 
            
    end )
    Wait(1000)
    Menu.Close("menu3")
end)


AddEventHandler('Menu:OnOpen', function(menu) 

    switch(menu.id,function(case) 
        case['menu1'] = function() 
            SetTitle(menu.title)
            SetHeader(menu.id)
            SetPopup(menu.description,45000)
            SetDescription(menu.description)
            for i=1,#(menu.options) do 
                SetDataSlot(i,menu.options[i].text,menu.options[i].desc)
            end 
            DrawMenuList()
        end ;
      
        case['menu2'] = function() 
            SetTitle(menu.title)
            SetHeader(menu.id)
            SetPopup(menu.description,45000)
            SetDescription(menu.description)
            for i=1,#(menu.options) do 
                SetDataSlot(i,menu.options[i].text,menu.options[i].desc)
            end 
            DrawMenuList()
        end ;

        case['menu3'] = function() 
            SetTitle(menu.title)
            SetHeader(menu.id)
            SetPopup(menu.description,45000)
            SetDescription(menu.description)
            for i=1,#(menu.options) do 
                SetDataSlot(i,menu.options[i].text,menu.options[i].desc)
            end 
            DrawMenuList()
        end ;
    end)
end)

AddEventHandler('Menu:OnClose', function(menu) 
    print('onclose'..menu.id)
end)



Citizen.CreateThread(function()

   TriggerEvent('DrawScaleformMovie','nbk_menu',0.45,0.42,0.8,0.8,255,255,255,0)
            
end)



function SetDataSlot(index,item,price)
	local _index = index - 1
    TriggerEvent('CallScaleformMovie',"nbk_menu",function(run,send,stop,handle)
            run("SET_DATA_SLOT")
            send(0,_index,0,0,0,price,item)
            stop()
    end)
end 

function LoadDict(dict)
    RequestStreamedTextureDict(dict)
    while not HasStreamedTextureDictLoaded(dict) do Wait(0) end
end

function SetDataSlotEmpty()
    SetDescription(" ",45000)
    TriggerEvent('CallScaleformMovie',"nbk_menu",function(run,send,stop,handle)
            run("SET_DATA_SLOT_EMPTY")
            send(0)
            stop()
    end)
end 	

function SetTitle(title)
	if title then 

        TriggerEvent('CallScaleformMovie',"nbk_menu",function(run,send,stop,handle)
            run("SET_TITLE")
            send(title)
            stop()
        end)
    end 
end 	

function SetHeader(header)
	if header then 

        TriggerEvent('CallScaleformMovie',"nbk_menu",function(run,send,stop,handle)
            run("SET_HEADER")
            send(header)
            stop()
        end)
	end 
end 	
function SetPopup(desc,delay)

    TriggerEvent('CallScaleformMovie',"nbk_menu",function(run,send,stop,handle)
        run("SET_POPUP")
        send(desc,delay//1000)
        stop()
    end)
	 
end 

function SetDescription(desc)
    TriggerEvent('CallScaleformMovie',"nbk_menu",function(run,send,stop,handle)
        run("SET_DESC")
        send(desc)
        stop()
    end)
	 
end 	
	

function DrawMenuList()
	TriggerEvent('CallScaleformMovie',"nbk_menu",function(run,send,stop,handle)
        run("DRAW_MENU_LIST")
        stop()
    end)
end 

function FadeShow()
	TriggerEvent('CallScaleformMovie',"nbk_menu",function(run,send,stop,handle)
        run("FADE_SHOW")
        stop()

    end)

end 
	
AddEventHandler('Menu:OnKeySelect', function(menu,cbidx) 
    TriggerEvent('RequestScaleformCallbackInt','nbk_menu','GET_CURRENT_SELECTION',function(_idx)
        local idx = _idx + 1
        cbidx(idx)
    end)
end) 	

AddEventHandler('Menu:OnKeyDown', function(menu,cbidx) 
    
    TriggerEvent('CallScaleformMovie',"nbk_menu",function(run,send,stop,handle)
        run("SET_INPUT_EVENT")
        send(9)
        stop()
        PlaySoundFrontend(-1, "NAV_UP_DOWN", "HUD_FRONTEND_DEFAULT_SOUNDSET", true)
        TriggerEvent('RequestScaleformCallbackInt','nbk_menu','GET_CURRENT_SELECTION',function(_idx)
            local idx = _idx + 1
            cbidx(idx)
        end)
    end)

end) 

AddEventHandler('Menu:OnKeyUp', function(menu,cbidx) 

	TriggerEvent('CallScaleformMovie',"nbk_menu",function(run,send,stop,handle)
        run("SET_INPUT_EVENT")
        send(8)
        stop()
        PlaySoundFrontend(-1, "NAV_UP_DOWN", "HUD_FRONTEND_DEFAULT_SOUNDSET", true)
        TriggerEvent('RequestScaleformCallbackInt','nbk_menu','GET_CURRENT_SELECTION',function(_idx)
            local idx = _idx + 1
            cbidx(idx)
        end)
    end)
end) 

AddEventHandler('Menu:OnKeyBack', function(menu) 
	print('back? or close?')
end) 





