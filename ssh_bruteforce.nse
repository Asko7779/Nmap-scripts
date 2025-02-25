-- this script is still in development

description = [[
    attempts to brute force SSH credentials with a list of usernames and passwords
]]

author = "Asko7779"
license = "Same as Nmap"
categories = {"brute", "intrusive"}

portrule = function(host, port)
    return port.number == 22 and port.state == "open"
end


action = function(host, port)

    -- adjustable credentials

    local usernames = {
    "admin", "root", "guest", "user", "ssh", "test", "ubuntu", "pi", "admin1", "oracle", 
    "user1", "support", "ftp", "webmaster", "linux", "sysadmin", "operator", "superuser", 
    "remote", "default", "guestuser", "admin123", "developer", "adminadmin" }
    
    local passwords = {
    "admin", "toor", "guest", "1234", "ssh", "root", "password", "12345", "123456", 
    "welcome", "letmein", "admin123", "qwerty", "password1", "123123", "abc123", "letmein123", 
    "root123", "123qwe", "123qweasd", "changeme", "password123", "test123", "guest123", 
    "user123", "superuser", "default", "password1", "hello123", "1234root"}


    local ssh = nmap.new_ssh_client()

    for _, user in ipairs(usernames) do
        for _, pass in ipairs(passwords) do

            local success, err = ssh:connect(host.ip, port.number, user, pass)

            if success then
                return "Valid credentials found: " .. user .. " / " .. pass
            end
        end
    end


    return "[-] Brute force attempt unsuccessful"
end
