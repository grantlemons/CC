local authPath = "./disk/auth.txt"
local accountValues = "./accountValues.txt"
accounts = {}
frozenAccounts = {}
accounts["1"] = {}
accounts["1"]["cvv"] = "712"
accounts["1"]["pin"] = "3699"
accounts["1"]["bal"] = "1000"

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
    accountNum = receive[1]
    func = receive[2]
    cvv = receive[3]
    pin = receive[4]
    val = receive[5]

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
        if cvv == accounts[accountNum]["cvv"] and pin == accounts[accountNum]["pin"] then
            if func == "verify" then
                rednet.send(id, "verified")
            end

            if func == "get" then
                rednet.send(id, accounts[accountNum]["bal"])
            end

            if func == "add" then
                accounts[accountNum]["bal"] = accounts[accountNum]["bal"] + val
            end
        end
    end
end