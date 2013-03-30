require('string_zh_cn')


--pinyin保存拼音
--echozi选择条中显示的汉字     
--result保存最好选择的汉字  输出这三个变量

--page页码
--start是否启动输入法
--startkey启动输入法的按键
--display是否显示
--select选字标志，防止选字时输入数字
ime={
pinyin="",
echozi={},
result={},
page=1,
start=false,
startkey="f12",
display=false,
select=false,
}
function ime:new(o)
	o = o or {} --如果参数中没有提供table，则创建一个空的。
     --将新对象实例的metatable指向表(类)
     setmetatable(o,self)
     self.__index = self
     --最后返回构造后的对象实例
     return o
end
--pinyin string类型,返回table
--从输入的pinyin查string_zh_cn表里对应的汉字，只取9个以内
function ime:getHanzi(pinyin)

	--如果输入法没开启，直接返回，不执行后面的语句
	if not self.start then  
		return
	end



	--pinyin对应的所有汉字表
	local tmp= string_zh_cn[pinyin]
	--只从得到的汉字表tmp里取出9个
	if tmp then

		if(#tmp >9) then
		--判断某个拼音下汉字的个数可以分成几个组（每组9个）
			local rows=math.ceil(#tmp/9) 
			--page是页数，按“=”页数加1，“-”页数减1
			if self.page>rows then
				self.page=rows
			elseif self.page<1 then
				self.page=1
			end
			for i=1,9 do
			--把取出的9个汉字放到hanzi表里
				self.echozi[i]=tmp[i+(self.page-1)*9]
			end
		else
			self.echozi=tmp
		end
	else
		self.echozi={}
	end
end
--从输入的pinyin查string_zh_cn表里对应的所有汉字表
function ime:getHanziFull(pinyin)
	return string_zh_cn[pinyin]
end

--注意这里的table是这样的t={"啊","阿","嗄","腌","锕","錒"}
--只是用来解决love2d里的中文问题
function ime:table2string(t)
	local s=""
	if type(t)~="table" then
		print(" t should be table")
		return
	else
		for _,v in ipairs(t) do
			s=s .. v
		end
	end
	return s
end

function ime:show(flag)
	self.display=flag
end

--设置启动输入法的按键
function ime:setStartKey(key)
	self.startkey=key or "f12"
end
--检测按键是否按下
function ime:keyDetect(key)
	
	if key==self.startkey then
		self.start=not self.start
	end
	
	--如果输入法没开启，直接返回，不执行后面的语句
	if not self.start then  
		return
	end
	--输入拼音
	local chars="abcdefghijklmnopqrstuvwxyz1234567890 ,." --字母、数字、空格、逗号、句号
	local charsNum="1234567890 ,." --数字、空格、逗号、句号

	--todo 多键检测
	
	--如果是小写字母，作为拼音输入
	if(string.find(chars,key) ) then
		
		--不允许pinyin以空格开头
		if self.pinyin=="" and key==" " then
			key=""
		end
		--不允许选字时按其他键
		if #self.echozi >0 and string.find(charsNum,key) then
		return
		end
		self.pinyin=self.pinyin .. key
	
	
	end
	--删除键,当有拼音时删除拼音，拼音删完了若有汉字删汉字
	if key=="backspace" then
		
			
		if self.pinyin~="" then
		self.pinyin=string.sub(self.pinyin,1,string.len(self.pinyin)-1)
		else
		table.remove(self.result)
		
		end
		
	end
	--下翻页
	if key=="=" then
		self.page=self.page+1
	end
	--上翻页
	if key=="-" then
		self.page=self.page-1
	end
end

function ime:update()
--如果输入法没开启，直接返回，不执行后面的语句
	if not self.start then  
		return
	end
	
	self:getHanzi(self.pinyin)
end

--返回self.pinyin,self.echozi,self.result，方便调用

function ime:draw(x,y)

--如果输入法没开启，直接返回，不执行后面的语句
	if not self.start then  
		return
	end

	local x=x or 50
	local y=y or 450
	if self.display then
	love.graphics.setColor(210,105,30) --#D2691E 
	love.graphics.rectangle( "line", x-10, y, 700+10, 80 )
	--love.graphics.print("fps: " .. love.timer.getFPS(), 20,20)
	love.graphics.print("请输拼音仅单字全拼：" .. self.pinyin,x,y)
	love.graphics.setColor(184,134,11) --#B8860B
	love.graphics.line(x-10,y+40,x+700,y+40)
	love.graphics.setColor(210,105,30)
	love.graphics.print("结果：".. self:table2string(self.result),x+340,y)
	end
	
		for i,v in ipairs(self.echozi) do
			
			if self.display then 
				love.graphics.print(i .. "." .. v,x+i*50,y+40) --选字条,50是字体的宽度+10像素的间隔
			end
			--数字键选字
			if love.keyboard.isDown(i .. "") then
				
				table.insert(self.result,v)
				self.pinyin=""
				
				return 
		    --回车键得到拼音
			elseif love.keyboard.isDown("return") then
				for i=1,string.len(self.pinyin) do
					table.insert(self.result,string.sub(self.pinyin,i,i))
				end
				self.pinyin=""
				
				return
		    --空格键选第一个字
			elseif love.keyboard.isDown(" ") then
			
				table.insert(self.result,self.echozi[1])
				self.pinyin=""
				
				return
			end
		end
	--如果是随便的字母
	if love.keyboard.isDown("return") then
		
	
			for i=1,string.len(self.pinyin) do
				table.insert(self.result,string.sub(self.pinyin,i,i))
			end
		self.pinyin=""
		return
		
	end
	
	return self.pinyin,self.echozi,self:table2string(self.result)
	
end