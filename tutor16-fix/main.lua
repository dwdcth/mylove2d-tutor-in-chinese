require('ime')

local lg=love.graphics
function love.load()
	--设置中文字体 请自行修改字体设置
	font=lg.newFont("YaHeiConsolas.ttf",20) 
	lg.setFont(font)
	testIme=ime:new()
	testIme:show(true) --打开显示
end

function love.update()
	testIme:update()
end

function love.draw()
	testIme:draw()

end

function love.keypressed(key, unicode)
	testIme:keyDetect(key)
	
end
