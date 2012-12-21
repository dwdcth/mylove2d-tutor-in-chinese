function drawGraphics()
    love.graphics.setBlendMode("alpha") --默认混合模式
    love.graphics.setColor(230, 44, 123)
    love.graphics.rectangle("fill", 50, 50, 100, 100)
    
    love.graphics.setColor(12, 100, 230)
    love.graphics.setBlendMode("multiplicative")
    love.graphics.rectangle("fill", 75, 75, 125, 125)

end
--你可以自己动手设置各种属性，看看效果
function useDefaultFont(text,x,y,size)
	 love.graphics.setColor(255,0,0)
	 love.graphics.setBlendMode("alpha")
	 --love.graphics.setColorMode("combine")
	love.graphics.print("default font size is 12",x,y)
	local font = love.graphics.newFont( size )
	love.graphics.setFont(font)
	love.graphics.print(text,x,y+size)
	
end

function useTTFFont(text,x,y,size)
	local font=love.graphics.newFont("assets/mona.ttf",size)
	love.graphics.setFont(font)
	love.graphics.print(text,x,y)
end
function useImgFont(text,x,y)
local font = love.graphics.newImageFont("assets/imagefont.png",
    " abcdefghijklmnopqrstuvwxyz" ..
    "ABCDEFGHIJKLMNOPQRSTUVWXYZ0" ..
    "123456789.,!?-+/():;%&`'*#=[]\"")
love.graphics.setFont(font)
love.graphics.print(text, x, y)
end


function love.load()
    love.graphics.setBackgroundColor(54, 172, 248)
		

end

function love.draw()
    drawGraphics()
	useDefaultFont("hello",210,100,20)
	useImgFont("world",210,140)
	useTTFFont("中文",210,160,18)
	
end

function love.update(dt)

end

function love.keypressed(key)

end