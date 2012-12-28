require('Anim')
function love.load()
     font=love.graphics.newFont(16)
     love.graphics.setFont(font)
     imgW=love.graphics.newImage("assets/walk.png")
     --参数:图片,总帧数,每秒播放帧数,图块左顶点在大图里的坐标,图块宽和高
     roleW=Anim:new(imgW,8,8,0,0,84,108)
     roleW.debug=true
    roleW:play()
    print("hhh")
end

function love.update(dt)
    roleW:update(dt)
end
local count=0
function love.draw()
     roleW:render(300,400)
     count=count+1
     --简单的测试stop和resume函数
     love.graphics.print("count" .. count, 10,25)
     if (count>100 and count<300 ) then
         roleW:stop()
     end

     if(count>300) then
     roleW:resume()
     end
end


