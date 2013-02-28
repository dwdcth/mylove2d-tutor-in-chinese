require('camera')
math.randomseed(os.time())
math.random()
math.random()
math.random()
rectangles={}


--随机创建矩形
function love.load(args)
	camera.layers = {}

	for i = 0.5, 3, 0.5 do

		--创建很多矩形
			local rectangles = {}
			--创建 3*6=18个矩形
			for j=1,3 do
			--创建了rectangles
					table.insert(rectangles, {
					math.random(0, 1600),
					math.random(0, 1600),
					math.random(50, 400),
					math.random(50, 400),

					color = { math.random(0, 255), math.random(0, 255),math.random(0,255) }
					})
				end


				--创建图层,在每个图层上画一个矩形,i是缩放系数,匿名函数为绘制此图层的函数
			camera:newLayer(i,
				function () --画图函数
				--在layers上画图
					for _, v in ipairs(rectangles) do
					love.graphics.setColor(v.color)
					love.graphics.rectangle('fill', unpack(v))
					love.graphics.setColor(255, 255, 255)
					end
				end
			)
	end

end

function love.update(dt)
	camera:setOffset(love.mouse.getX() * 2, love.mouse.getY() * 2)
end

function love.draw()
	camera:draw()
	love.graphics.print("FPS: " .. love.timer.getFPS(), 2, 2)
end

function love.keypressed(key, unicode)
	if key == ' ' then
	love.load()
	elseif key == 'escape' then
	love.event.push('quit')
	end
end
