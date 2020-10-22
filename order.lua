alarmCommand	= getScriptPath() .. "\\alarm.mp3"

is_run 			= true


function OnOrder( order)
	if order.trans_id > 0 and order.balance < order.qty then
        os.execute(alarmCommand)
        OnStop()
	end
end


function OnStop()
	is_run = false
end


function main()
	message("watch: on order")

	while is_run do
		sleep(500)
	end
end