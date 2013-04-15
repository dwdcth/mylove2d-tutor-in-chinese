require('splash')
require('game')

function love.load()
  -- 加载资源
  img_fn = {"bullet","enemy","player","title","background"}
  imgs = {}
  for _,v in ipairs(img_fn) do
    imgs[v]=love.graphics.newImage("assets/"..v..".gif")
  end
  font = love.graphics.newFont("assets/font.ttf",14*scale)
  love.graphics.setFont(font)

  -- 设置颜色
  bgcolor = {r=148,g=191,b=19}
  fontcolor = {r=46,g=115,b=46}

  -- 初始化游戏状态
  state = "splash"  
  
  --加载splash
  splash.load(imgs["title"],"assets/music.mp3")
  --加载游戏
  game.load()
end

function love.draw()
	--设置颜色
  love.graphics.setColor(bgcolor.r,bgcolor.g,bgcolor.b)
  --画背景
  love.graphics.rectangle("fill",
    0,0 ,love.graphics.getWidth(),love.graphics.getHeight())
  -- 恢复颜色
  love.graphics.setColor(255,255,255)
  
  
  -- 根据状态来绘图
  if state == "splash" then
    splash.draw()
  elseif state == "game" then
    game.draw()
  end
end

function love.update(dt)
  -- 根据状态更新
  if state == "splash" then
    splash.update(dt)
  elseif state == "game" then
    game.update(dt)
  end
end

function love.keypressed(key)
  -- 根据状态检测键盘
  if state == "splash" then
    splash.keypressed(key)
  elseif state == "game" then
    game.keypressed(key)
  end
  --打开调试
  if key == "`" then
    debug = not debug
  end
end
