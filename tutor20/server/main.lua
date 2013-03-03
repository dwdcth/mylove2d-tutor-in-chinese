--加载socket网络库
local socket = require "socket"

-- 创建udp连接
local udp = socket.udp()

-- socket按块来读取数据，直到数据里有信息为止，或者等待一段时间
-- 这显然不符合游戏的要求，所以把等待时间设为0

udp:settimeout(0)

-- 和客户端不同，服务器必须知道它绑定的端口，否则客户号将永远找不到它。
--绑定主机地址和端口
--“×”则表示所有地址；端口为数字（0----65535）。
--由于0----1024是某些系统保留端口，请使用大于1024的端口。

udp:setsockname('*', 12345)

local world = {} -- the empty world-state


-- 下面这些变量会用在主循环里
local data, msg_or_ip, port_or_nil
local entity, cmd, parms
--下面开始一个无限循环，因为服务端要一直等带客户端的连接
local running = true

-- 循环开始
print "Beginning server loop."
while running do
    --从客户端接受消息	
    data, msg_or_ip, port_or_nil = udp:receivefrom()
    if data then
       
        entity, cmd, parms = data:match("^(%S*) (%S*) (.*)")
        if cmd == 'move' then
            local x, y = parms:match("^(%-?[%d.e]*) (%-?[%d.e]*)$")
            assert(x and y) -- 验证x，y是否都不为nil
			--记得x,y还是字符串，要转换为数字
            x, y = tonumber(x), tonumber(y)
            -- 
            local ent = world[entity] or {x=0, y=0}
            world[entity] = {x=ent.x+x, y=ent.y+y}
        elseif cmd == 'at' then
            local x, y = parms:match("^(%-?[%d.e]*) (%-?[%d.e]*)$")
            assert(x and y) 
            x, y = tonumber(x), tonumber(y)
            world[entity] = {x=x, y=y}
        elseif cmd == 'update' then
            for k, v in pairs(world) do
			--发送给客户端
                udp:sendto(string.format("%s %s %d %d", k, 'at', v.x, v.y), msg_or_ip,  port_or_nil)
            end
        elseif cmd == 'quit' then
            running = false;
        else
            print("unrecognised command:", cmd)
        end
    elseif msg_or_ip ~= 'timeout' then
        error("Unknown network error: "..tostring(msg))
    end
   
    socket.sleep(0.01)
end

print "Thank you."

