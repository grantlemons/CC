databaseID = 12
cardNumFile = "./disk/accountNumber.txt"
cvvFile = "./disk/cvv.txt"
dispenseDelay = 0.1
shell.run("clear")

function getResponse(message)
    rednet.send(databaseID, message)
    repeat
        id,response = rednet.receive()
    until(id == databaseID)
    return response
end

function getBal(accountID)
    message = {accountID,"get",nul,pinInput,nul}
    return getResponse(message)
end

function takeBal(accountID, val)
    message = {accountID,"add",cvv,pinInput,-val}
    repeat
        answer = getResponse(message)
    until(answer)
end

function dispense(val)
    for i=0,val,1 do
        redstone.setOutput("back", true)
        sleep(dispenseDelay)
        redstone.setOutput("back", false)
        sleep(dispenseDelay)
    end
end

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

function verify()
    repeat
        sleep(2)
    until (file_exists(cardNumFile) and file_exists(cvvFile))
    if file_exists(cardNumFile) and file_exists(cvvFile) then
        accountNum = lines_from(cardNumFile)[1]
        cardcvv = lines_from(cvvFile)[1]
        io.write("PIN: ")
        pinInput = io.read()
        shell.run("clear")

        message = {accountNum,"verify",cardcvv,pinInput,nul}

        if getResponse(message) == "verified" then
            io.write("Verified\n")
            bal = getBal(accountNum)
            io.write("Balance: "..bal.."\n")
            io.write("Withdraw [Y | N]: ")
            if io.read() then
                io.write("Withdraw Value: ")
                val = math.abs(io.read())
                takeBal(accountNum, val)
                io.write(val.." Diamonds...")
                dispense(val)
                io.write("New Balance: "..bal-val.."\n")
            end
            shell.run("clear")
        end
    end
end

while(true)
do
    verify()
end