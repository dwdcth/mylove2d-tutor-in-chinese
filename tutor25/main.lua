require('talk')
--说明请注意自行修改字体
--滚动文字 t字符串表,rate出现时间间隔
function rollText(t,rate)
  
  local count=0
  local i=1
  local str=""
 
  local function text()
	count=count+love.timer.getDelta()
	if count>rate then
		count=0
		if i<=#t then
			str=str.. t[i]
			i=i+1
		end
	end
	
	return str
  end
  return text
    
end
function love.load()

  font=love.graphics.newFont("YaHeiConsolas.ttf",48)
  love.graphics.setFont(font)
  --rollText是函数类型
  roll=rollText(talk1,0.3)
  
end
function love.draw()
  str=roll()
  love.graphics.print(str,100,100)
  
end

