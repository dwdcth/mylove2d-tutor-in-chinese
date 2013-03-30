
require('loveframes')
require('font')
require('bagbox')
require('equip')

function createEquaps()
	myequips={}
	
	--创建道具的方法
	for i=1,18 do
		--拼接图片名
		img=love.graphics.newImage("assets/d" .. (10+i) ..".png")  
		myequips[i]=equip:new()
		--可变参数，必须有三个参数,道具名字，道具介绍，图片
		myequips[i]:Create("道具"..i,"这是一把刀",img,{attack=10})
	end
	myequips[1]:SetName("万能钥匙")
	myequips[1]:SetText("可以打开所有宝箱")
	myequips[1]:SetValue("attack","无敌")
	myequips[2]:SetName("红钥匙")
	myequips[2]:SetText("可以打开红色宝箱")
	myequips[2]:SetValue("attack",90)
	myequips[3]:SetName("蓝钥匙")
	myequips[3]:SetText("可以打开蓝色宝箱")
	myequips[3]:SetValue("attack",50)
	myequips[4]:SetName("黄钥匙")
	myequips[4]:SetText("可以打开黄色宝箱")
	myequips[4]:SetValue("attack",30)
	
	
	
end

function love.load()
	
	createEquaps()
	bag=bagbox:new() --背包对象  必须
	
	--背包的宽、高，道具的行数、列数，道具宽、高，相邻行、列的间隔
	bag:SetUp() --可以使用空参数，必须
	
	--创建背包里的道具，参数是道具类型的表
	bag:SetAllEquip(myequips) --必须，可以使空参数
	
	--设置光标，图片类型，可以传入"default"使用默认光标，非必须
	bag:SetCursor("default")
	
	bag:Create() --必须，且放在最后，使用前面的参数创建背包
	
	
	
	
end


function love.draw()
	
	
	loveframes.draw()
end



function love.update(dt)
bag:update(dt)
loveframes.update()

end

function love.mousepressed(x, y, button)



	loveframes.mousepressed(x, y, button)

end

function love.mousereleased(x, y, button)



	loveframes.mousereleased(x, y, button)

end
function love.keypressed(key, unicode)
	
	bag:keypressed(key,unicode)
	
	loveframes.keypressed(key, unicode)
	if key=="a" then
		local cloud=equip:new()
		equip:Create("一片浮云","站在浮云之上，才知宇宙无限",love.graphics.newImage("assets/box2.png"))
		bag:AddItem(5,equip)
	end
	if key=="d" then
		bag:DelItem(4)
	end
end

function love.keyreleased(key)
	
	loveframes.keyreleased(key)

end

