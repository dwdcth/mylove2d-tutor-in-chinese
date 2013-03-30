local socket = require "socket"

-- 服务端的ip地址和端口，localhost=127.0.0.1（本机）
local address, port = "localhost", 12345

local entity --一个随机数，标示每个客户端
local updaterate = 0.1 -- 更新速率0.1s一次

local world = {} --里面存放的是键值对 world[实体]={x,y}
local t --计时


function love.load()

 -- 创建一个没有连接的udp对象，失败则返回nil和错误消息

    udp = socket.udp()
   
-- socket按块来读取数据，直到数据里有信息为止，或者等待一段时间
-- 这显然不符合游戏的要求，所以把等待时间设为0
    udp:settimeout(0)
   
--不像服务端，客户端只需要连接服务端就可，使用setpeername来连接服务端
--address是地址，port端口
    udp:setpeername(address, port)
   
  --取随机数种子
    math.randomseed(os.time())
   
  --通过刚才的随机数种子生成0---99999之间的随机数
  --entity实际就是一个字符串
    entity = tostring(math.random(99999))

   --这里我们仅是产生一个字符串dg，并把它发送出去send 
   --此处发送的是 “entity at 320240”
    local dg = string.format("%s %s %d %d", entity, 'at', 320, 240)
    udp:send(dg) 
   
    -- 初始化t为0,t用来在love.update里计时
    t = 0 
end


function love.update(deltatime)

    t = t + deltatime 
   
    --为了防止网络堵塞，我们需要限制更新速率，对大多数游戏来说每秒10次已经足够
    --（包括很多大型在线网络游戏），更新速率不要超过每秒30次
    if t > updaterate then
       --可以每次更新都发送数据包，但为了减少带宽，我们把更新整合到一个数据包里，在
       --最后的更新里发送出去
        local x, y = 0, 0
        if love.keyboard.isDown('up') then  y=y-(20*t) end
        if love.keyboard.isDown('down') then    y=y+(20*t) end
        if love.keyboard.isDown('left') then    x=x-(20*t) end
        if love.keyboard.isDown('right') then   x=x+(20*t) end


        --把消息打包到dg，发送出去,这里发送的是 entity,move和坐标拼接的字符串
        local dg = string.format("%s %s %f %f", entity, 'move', x, y)
		
        udp:send(dg)   

     --服务器发送给我们世界更新请求
 
        --[[
        注意：大多数设计不需要更新世界状态，而是让服务器定期发送。
       这样做有很多原因，你需要仔细注意的一个是anti-griefing（反扰乱）。
       世界更新是游戏服务器最大的事，服务器会定期更新，使用整合的数据将会更有效。
        ]]
        local dg = string.format("%s %s $", entity, 'update')
        udp:send(dg)

        t=t-updaterate -- 复位t
    end

   
   --很可能有许多消息，因此循环来等待消息
    repeat
        --[[这里期望另一端的udp:send!
		udp:receive将返回等待数据包 （或为nil，或错误消息）。
		数据是一个字符串，承载远端udp:send的内容。我们可以使用lua的string库处理
        ]]
        data, msg = udp:receive()
		
        if data then 
  
           --这里的match是string.match,它使用参数中的模式来匹配
		   --下面匹配以空格分隔的字符串
            ent, cmd, parms = data:match("^(%S*) (%S*) (.*)")
            if cmd == 'at' then
                --匹配如下形式的"111 222"的数字
                local x, y = parms:match("^(%-?[%d.e]*) (%-?[%d.e]*)$")
                assert(x and y) -- 使用assert验证x，y是否都不为nil
           
                --不要忘记x,y还是字符串类型
                x, y = tonumber(x), tonumber(y)
                --把x,y存入world表里
                world[ent] = {x=x, y=y}
            else
                --[[
				打印日志,防止有人黑服务器，永远不要信任客户端
				]]
                print("unrecognised command:", cmd)
            end
       
        --[[
		打印错误，一般情况下错误是timeout，由于我们把timeout设为0了，
		]]
        elseif msg ~= 'timeout' then
            error("Network error: "..tostring(msg))
        end
    until not data

end

function love.draw()
--打印world里的信息
    for k, v in pairs(world) do
        love.graphics.print(k, v.x, v.y)
		print(k)
    end
end

