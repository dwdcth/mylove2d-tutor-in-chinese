require('string_zh_cn')

local lg=love.graphics
pinyin="" --拼音
hanzi={} --显示的汉字
page=1 --页数
zi="" --选择的字

--从输入的pinyin查string_zh_cn表里对应的汉字
function getHanzi(pinyin)
	--pinyin对应的所有汉字表
	local tmp= string_zh_cn[pinyin]
	--只从得到的汉字表tmp里取出9个
	if tmp then

		if(#tmp >9) then
		--判断某个拼音下汉字的个数可以分成几个组（每组9个）
			local rows=math.ceil(#tmp/9) 
			--page是页数，按“=”页数加1，“-”页数减1
			if page>rows then
				page=rows
			elseif page<1 then
				page=1
			end
			for i=1,9 do
			--把取出的9个汉字放到hanzi表里
				hanzi[i]=tmp[i+(page-1)*9]
			end
		else
			hanzi=tmp
		end
	else
		hanzi={}
	end
end

function love.load()
	--设置中文字体
	font=lg.newFont("YaHeiConsolas.ttf",18)
	lg.setFont(font)
end

function love.update()
	getHanzi(pinyin)
end

function love.draw()
	lg.print("fps: " .. love.timer.getFPS(), 20,20)
	lg.print("请输入拼音：" .. pinyin,100,100)
	lg.print("汉字：".. zi,300,100)
	if hanzi then
		for i,v in ipairs(hanzi) do		
			lg.print(i .. "." .. v,100+i*40,140)
			if love.keyboard.isDown(i .. "") then
				pinyin=""
				zi=zi..v
			end
		end
	end
end

function love.keypressed(key, unicode)
	--输入拼音
	local chars="abcdefghijklmnopqrstuvwxyz"
	if(string.find(chars,key)) then
		pinyin=pinyin .. key
	end
	
	if key=="backspace" then
		pinyin=string.sub(pinyin,1,string.len(pinyin)-1)
		--[[
		if pinyin~="" then
		pinyin=string.sub(pinyin,1,string.len(pinyin)-1)
		else
		--按退格键删除一个汉字 此处有问题
		hanzi=string.sub(hanzi,1,string.len(hanzi)-2)
		end
		]]
	end
	if key=="=" then
		page=page+1
	end
	if key=="-" then
		page=page-1
	end
	
end
