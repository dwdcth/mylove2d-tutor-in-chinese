require("tutor03")

function love.load()
sound = love.audio.newSource("assets/sound.wav", "static")
music = love.audio.newSource("assets/music.mp3") --默认是stream,动态加载,适合播放时间长的音乐
music:setVolume(0.5)
love.audio.play(music)
end

function love.draw()
	drawMouseTrack()
	drawQuad(qx,qy,20,20)
	love.graphics.print("qx=" .. qx .. "  qy=" .. qy,20,20)

end

function love.update(dt)
	--按键检测
	if(love.keyboard.isDown("up")) then
	qy=qy-5
	end
	if(love.keyboard.isDown("down")) then
	qy=qy+5
	end
	if(love.keyboard.isDown("left")) then
	qx=qx-5
	end
	if(love.keyboard.isDown("right")) then
	qx=qx+5
	end


	--检测小方块是否运动到窗口边界
	if(qx>=780)then
	qx=780
	playSound=true
	elseif(qx<0)then
	qx=0
	playSound=true
	end
	if(qy>=580)then
	qy=580
	playSound=true
	elseif(qy<=0)then
	qy=0
	playSound=true
	end


	if(playSound==true) then
		love.audio.play(sound)
		playSound=false
	end

end

function love.keypressed(key)
--~ 	if(key=="up") then
--~ 	qy=qy-5
--~ 	elseif(key=="down") then
--~ 	qy=qy+5
--~ 	elseif(key=="left") then
--~ 	qx=qx-5
--~ 	elseif(key=="right") then
--~ 	qx=qx+5
--~ 	end
end
