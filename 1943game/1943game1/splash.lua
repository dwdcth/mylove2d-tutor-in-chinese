splash = {}
--初始化
function splash.load(state,img,music)
  splash.dt_temp = 0
  splash.state=state
  --加载资源
  splash.img=love.graphics.newImage(img)
  splash.music=love.audio.newSource(music, "stream" )
  splash.music:setLooping(true)
  love.audio.play(splash.music)
end

function splash.draw()
  love.graphics.draw(splash.img,0,(splash.dt_temp-1)*32*scale,0,scale,scale)
 
  -- 2.5s  后显示提示
  if splash.dt_temp == 2.5 then
    love.graphics.printf("Press Start",
      0,80*scale,love.graphics.getWidth(),"center")
  end
  
end

function splash.update(dt)
  
  splash.dt_temp = splash.dt_temp + dt
  -- 计时2.5s
  if splash.dt_temp > 2.5 then
    splash.dt_temp = 2.5
  end
  
	
	
end

function splash.keypressed(key)
  --改变游戏状态
  splash.state = "game"
  love.audio.stop(splash.music)
end
