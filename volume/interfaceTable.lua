

interface = {}
function interface:new(defaultVolume, callback)
    newObj = {
        defaultVolume   = defaultVolume,
        focusedInput    = 0,
        callback        = callback,
        tableId         = nil
    }

    self.__index = self
    return setmetatable(newObj, self)
end



function interface:input( char,row,col )
    local text = GetCell(self.tableId ,row,col).image

    if char == 8 then                           -- return
        text    = text:sub(0, text:len()-1 )
    else
        text    = text..string.char(char)
    end

    SetCell(self.tableId ,row,col, text )
end

function interface:get(row, col)
    return tonumber(GetCell(self.tableId ,row,col).image)
end

function interface:handleEvent(t_id, msg, row, col)
    if      msg == QTABLE_LBUTTONDOWN then

        self.focusedInput   = 0

        if col ==2 then

            if      row == 1 then
                SetCell(self.tableId, row, col, '' )
                self.focusedInput   = row
            elseif  row == 2 then
                self.callback(self:get(1,2))
            end
        end

    elseif  msg == QTABLE_CHAR then
        if self.focusedInput > 0 then
            self:input( col,self.focusedInput,2)
        end

    end
end

function interface:init()
    self.tableId    = AllocTable()
    AddColumn(self.tableId, 1, " ", true, QTABLE_CACHED_STRING_TYPE, 12)
    AddColumn(self.tableId, 2, " ", true, QTABLE_CACHED_STRING_TYPE, 17)
    CreateWindow(self.tableId)

    data = {
        {"Объем",    tostring(self.defaultVolume) },
        {" ",           "Установить"}
    }

    for k, v in pairs(data) do
        row = InsertRow(self.tableId, -1)
        SetCell(self.tableId, row, 1, v[1])
        SetCell(self.tableId, row, 2, v[2])
    end

    SetWindowCaption(self.tableId, "Объем")

    SetTableNotificationCallback(self.tableId, 
        function (t_id, msg, row, col)
            self:handleEvent(t_id, msg, row, col)
        end
    )



    SetWindowPos(self.tableId,
        750,    -- left
        400,    -- top
        210,    -- width
        90)     -- height
end

function interface:close()
    if self.tableId ~= nil then
        DestroyTable(self.tableId)
    end
end