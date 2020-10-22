maxPrice     	= 0
minPrice     	= 0



is_run          = true
interfaceTable 	= nil


function setLimits( min,max )
	minPrice 	= min
	maxPrice 	= max
end

function corridorStop(index)
    if (ds:H(index) >= maxPrice) or (ds:L(index) <= minPrice) then
        os.execute(alarmCommand)
        OnStop()
    end
end;


------------------------------------

function OnInit()
	interfaceTable 	= interface:new(setLimits)
    ds 				= CreateDataSource (assets.class, assets.sec, INTERVAL_M1 );
end

function OnStop()
	interfaceTable:close()
    ds:Close();
    is_run = false
end


function main()
	interfaceTable:init()

	while is_run and maxPrice == 0 and minPrice == 0 do
		sleep(100)
	end

	interfaceTable:close()
	ds:SetUpdateCallback(corridorStop);
	message(string.format("watch: min=%f max=%f",minPrice,maxPrice))

    while is_run do
        sleep(500)
    end
end
