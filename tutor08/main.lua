require('animation')
function love.load()
     font=love.graphics.newFont(16)
     love.graphics.setFont(font)
     imgW=love.graphics.newImage("assets/walk.png")
     roleW=newAnimation(imgW,8,8,0,0,84,108)
     roleW.debug=true
     roleW:setPos(400,300)
end

function love.update(dt)
    roleW:Update(dt)
end
local count=0
function love.draw()
     roleW:Play()
     count=count+1
     --简单的测试Stop和Resume函数
     love.graphics.print("count" .. count, 10,25)
     if (count>100 and count<300 ) then
         roleW:Stop()
     end

     if(count>300) then
     roleW:Resume()
     end
end


