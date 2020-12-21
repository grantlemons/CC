local authPath = "./disk/auth.txt"
local accountValues = "./accountValues.txt"
accounts = {}
frozenAccounts = {}

-- see if the file exists
function file_exists(file)
    local f = io.open(file, "rb")
    if f then f:close() end
    return f ~= nil
end
  
  -- get all lines from a file, returns an empty 
  -- list/table if the file does not exist
function lines_from(file)
    if not file_exists(file) then return {} end
    lines = {}
    for line in io.lines(file) do 
        lines[#lines + 1] = line
    end
    return lines
end

while(file_exists(authPath))
do
    id,receive = rednet.receive()

    --[[if id in lines_from(authPath) then
        if receive = "%d+ get" then

        end

        if receive = "%d+ add" then

        end

        if receive = "%d+ suspend" then

        end

        if receive = "%d+ unsuspend" then

        end

        if receive = "%d+ create" then

        end
    else--]]
    if true then
        accountNum,func,cvv,pin,val = receive

        if func == "verify" then
            if cvv == accounts[accountNum]["cvv"] and pin == accounts[accountNum]["pin"] then
                rednet.send(id, "verified")
            end
        end

        if func == "get" then
            if pin == accounts[accountNum]["pin"] then
                rednet.send(id, accounts[accountNum]["bal"])
            end
        end

        if func == "add" then
            if cvv == accounts[accountNum]["cvv"] and pin == accounts[accountNum]["pin"] then
                accounts[accountNum]["bal"] = accounts[accountNum]["bal"] + val
            end
        end
    end
end