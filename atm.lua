databaseID = 12
cardNumFile = "./disk/accountNumber.txt"
cvvFile = "./disk/cvv.txt"

function getResponse(message)
    rednet.send(databaseID, message)
    while(true)
    do
        id,response = rednet.receive()
        if id == databaseID then
            break
        end
    end
    return response
end

function getBal(accountID)
    message = accountID,"get",nul,pinInput,nul
    return getResponse(message)
end

function takeBal(accountID, val)
    message = accountID,"add",cvv,pinInput,-val
    repeat
        answer = getResponse(message)
    until(answer)
end

function dispense(val)
    for i=0,val,1 do
        redstone.setOutput("back", true)
        redstone.setOutput("back", false)
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
    if file_exists(cardNumFile) and file_exists(cvvFile) then
        accountNum = lines_from(cardNumFile)[1]
        cardcvv = lines_from(cvvFile)[1]
        io.write("PIN: ")
        pinInput = io.read()

        message = accountNum,"verify",cardcvv,pinInput,nul

        if getResponse(message) == "verified" then
            io.write("Verified\n")
            io.write("Balance: "..getBal.."\n")
            io.write("Withdraw [Y | N] ")
            if io.read() then
                io.write("Withdraw Value: ")
                val = io.read()
                takeBal(accountNum, val)
                dispense(val)
            end
        end
    end
end

while(true)
    verify()
end