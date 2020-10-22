volumeLimit = 0

if defaultVolume == nil then
    defaultVolume = 10000
end

is_run          = true
interfaceTable  = nil




function setLimit( vol )
    volumeLimit = vol
end

function volumeStop(index)
    if ds:V(index) > volumeLimit then
        os.execute(alarmCommand)
        OnStop()
    end
end;


------------------------------------

function OnInit()
    interfaceTable	= interface:new(defaultVolume, setLimit)
    ds 				= CreateDataSource (assets.class, assets.sec, INTERVAL_M1 );
end

function OnStop()
    interfaceTable:close()
    is_run = false
    ds:Close();
end


function main()
    interfaceTable:init()

    while is_run and volumeLimit == 0 do
        sleep(100)
    end

    interfaceTable:close()
    message(string.format("watch: volume=%f ",volumeLimit))
    ds:SetUpdateCallback(volumeStop)

    while is_run do
        sleep(500)
    end
end
