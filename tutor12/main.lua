lg=love.graphics
--canvas测试修改自love官方论坛里TechnoCat的framebuffer
function testCanvas()
  img= lg.newImage("tuzi.png")

  translate = {x=0, y=0}
  scene = {}
  scene.width = 2048
  scene.height = 2048

  --初始化Canvas
  myCanvas = lg.newCanvas(scene.width, scene.height)

  --创建随机物体
  imageSet = {} --为图片坐标集合
  for i = 1, 10000 do
    local entry = {}
    entry.x = math.random(scene.width-128)
    entry.y = math.random(scene.height-128)
    imageSet[i] = entry
  end
  --设置绘图操作
  lg.setCanvas(myCanvas)
  for _,v in ipairs(imageSet) do
    lg.draw(img, v.x, v.y)
  end
  lg.setCanvas()
   --另一种方法
  --[[
  myCanvas:renderTo(
      function()
        for _,v in ipairs(imageSet) do
          lg.draw(image, v.x, v.y)
        end
      end
  )
  --]]
end

function drawCanvas()
  lg.push()
  lg.translate(translate.x, translate.y)
  if testOn then
    lg.draw(myCanvas, 0, 0)
  else
    for _,v in ipairs(imageSet) do
      lg.draw(img, v.x, v.y)
    end
  end
  lg.pop()

 local  fps = love.timer.getFPS()
  if testOn then
    lg.setCaption("开启canvas时FPS:" ..fps,0,0)
  else
  lg.setCaption("关闭canvas时FPS:" ..fps,0,0)
  end
end


function testBatch()
    tex=lg.newImage("run.png")
      quad={}
      local w,h=84,108
    local texW,texH=tex:getWidth(),tex:getHeight()
    local col,row=texW/w,texH/h
    for i=1,row do
      for j=1,col do
      table.insert (quad,lg.newQuad((j-1)*w,(i-1)*h,w,h,texW,texH))
      end
    end
    --创建512个需要绘制的图片
	mySprite = lg.newSpriteBatch( tex,512)
end

function drawBatch()
  if testOn then
      mySprite:bind()
      for i=1,8 do
        for j=1,64 do
          --84,108为图块的宽和高,864为图片的高
          mySprite:setColor(math.random(0,255),math.random(0,255),math.random(0,255))
          mySprite:addq(quad[j],(j-1)*84,(j-1)*104+(i-1)*864,0,1,1,0,0,0,0)
        end
      end

      mySprite:unbind()

  else
   for i=1,8 do
        for j=1,64 do
          --84,108为图块的宽和高,864为图片的高
          mySprite:setColor(math.random(0,255),math.random(0,255),math.random(0,255))
          mySprite:addq(quad[j],math.ceil(j%8-1)*84,math.ceil(j/8-1)*104+(i-1)*864,0,1,1,0,0,0,0)
        end
    end
  end
  lg.draw(mySprite,0,0)
  local  fps = love.timer.getFPS()
  if testOn then
  lg.setCaption("使用bind时fps:" .. fps )
  else
  lg.setCaption("关闭bind时fps:" .. fps)
  end
end

function love.load()
  testOn=false --testOn为false时关闭canvas/spritebatch的bind,为true时开启
  mode=false  --mode为false测试spritebatch,为true测试canvas
  testCanvas()
  testBatch()
end



function love.update(dt)

  if love.keyboard.isDown("left") then
    translate.x = translate.x + 1000*dt
  elseif love.keyboard.isDown("right") then
    translate.x = translate.x - 1000*dt
  end

  if love.keyboard.isDown("up") then
    translate.y = translate.y + 1000*dt
  elseif love.keyboard.isDown("down") then
    translate.y = translate.y - 1000*dt
  end

end

function love.draw()
  lg.print("press <c> change mode, press <space> open stest",10,10)
    if mode then
     drawCanvas()
    else
      drawBatch()
    end


  lg.setCaption("FPS:" .. love.timer.getFPS() )
end

function love.keypressed(k)
  if k=="c" then
    mode = not mode
  end
  if k==" " then
    testOn= not testOn
  end
end
