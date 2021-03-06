splash = {}
--初始化
function splash.load(img,music)
  splash.dt_temp = 0
  
  --加载资源
  splash.img=img
  splash.music=love.audio.newSource(music,"stream")
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
  state = "game"
  love.audio.stop(splash.music)
  game.load() --如果没有这句就会停在splash，因为此时玩家和敌机的检测会在game.update里始终为真
end
