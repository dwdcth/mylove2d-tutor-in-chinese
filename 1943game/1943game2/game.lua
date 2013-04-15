game = {}

function game.load()
  -- 计时
  game.clock = 0
  -- 初始化敌机
  game.enemy_size = imgs["enemy"]:getWidth()
  game.enemies = {} --敌机存储表
  game.enemy_dt = 0  --敌机计时器
  game.enemy_rate = 2 --敌机产生时间间隔
  --初始化玩家
  game.player_size = imgs["player"]:getWidth()
  game.playerx = (160/2)*scale
  game.playery = (144-12)*scale
end

function game.draw()
  -- 绘制动态的背景
  for i = 0,4 do --绘制5列
    for j = -1,4 do  --绘制6行
	  --绘制坐标随时间变化，y坐标增大32*scale，这里32为图片的宽和高
      love.graphics.draw(imgs["background"],
                           i*32*scale,
                           (j+game.clock%1)*32*scale,
                           0,scale,scale)
    end
  end
  
  -- 绘制存储在表里的敌机坐标
  for _,v in ipairs(game.enemies) do
    love.graphics.draw(imgs["enemy"],
                         v.x,v.y,
                         0,scale,scale,
                         game.enemy_size/2,game.enemy_size/2)
	--在图形周围画一个圆
    if debug then  love.graphics.circle("line",v.x,v.y,game.enemy_size/2*scale) end
  end
  
  -- 绘制玩家
  love.graphics.draw(imgs["player"],
                       game.playerx,game.playery,
                       0,scale,scale,
                       game.player_size/2,game.player_size/2)
	--在图形周围画一个圆
  if debug then 
    love.graphics.circle("line",game.playerx,game.playery,game.player_size/2*scale)
  end
end

-- 计算两点的距离
function game.dist(x1,y1,x2,y2)
  return math.sqrt( (x1 - x2)^2 + (y1 - y2)^2 )
end

function game.update(dt)
  -- 背景计时
  game.clock = game.clock + dt
  -- 敌机计时
  game.enemy_dt = game.enemy_dt + dt
  
  -- 随机产生大量敌机的坐标
  if game.enemy_dt > game.enemy_rate then
    game.enemy_dt = game.enemy_dt - game.enemy_rate
    game.enemy_rate = game.enemy_rate - 0.01 * game.enemy_rate --缩短产生敌机的时间间隔，即敌机产生的越来越快
    local enemy = {}
    enemy.x = math.random((8)*scale,(160-8)*scale)
    enemy.y = -game.enemy_size  --负号表示产生后在y小于0
    table.insert(game.enemies,enemy)
  end
  
  -- 更新敌机的坐标
  for ei,ev in ipairs(game.enemies) do
    ev.y = ev.y + 70*dt*scale
    if ev.y > 144*scale then
      table.remove(game.enemies,ei)
    end
    -- 如果玩家和敌机的距离过近，重置游戏到开始状态
    if game.dist(game.playerx,game.playery,ev.x,ev.y) < (12+8)*scale then
      splash.load(imgs["title"],"assets/music.mp3")
      state = "splash"
    end
  end
  
  -- 玩家运动控制
  if love.keyboard.isDown("right") then
    game.playerx = game.playerx + 100*dt*scale
  end
  if love.keyboard.isDown("left") then
    game.playerx = game.playerx - 100*dt*scale
  end
  -- 不让玩家离开地图
  if game.playerx > 160*scale then
    game.playerx = 160*scale
  end
  if game.playerx < 0 then
    game.playerx = 0
  end
end

function game.keypressed(key)

end
