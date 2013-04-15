require('loveframes')
require('selectbox')
require('misc')


--fh字体高、curPage当前页、count逐字里的计数、每个字显示的间隔、st逐字里时间计数
--curStr逐字里当前字符串、isEnd里字是否显示完、isShow是否显示对话、isOver所有对话
--是否显示完、onOver结束时的回调函数
message={fh=basicfont:getHeight(),curPage=1,count=1,rate=0.1,st=0,curStr="",
isEnd=false,isShow=true,isOver=false,onOver=function()end}
function message:new(o)
	o= o or{}
	setmetatable(o,self)
    self.__index = self
    return o
end
--逐字显示,需要 显示形式="逐字显示",hasSelect=false
--MES{ 显示形式="逐字显示" , 内容={对话对话对话\n换行,翻页},结束后事件=nil }
function message:add(option)
	if type(option.msg)~="table" then
		error("no msg")
	end
	local ph=150 --对话框的高  todo
	local fh=self.fh --字体高
	if option.mode=="wd" then
		self.lnShow=false
	else
		self.lnShow=true
	end
	if option.fun and type(option.fun)=="function" then
		self.onOver=option.fun
	else
		error("fun is not function") 
	end
	
	self.panel=loveframes.Create("panel")
	self.panel:SetSize(love.graphics.getWidth(),ph)
	self.panel:SetPos(0,love.graphics.getHeight()-ph)
	
	
	self.pageNum=#option.msg
	self.msg=option.msg
	self.text=loveframes.Create("text",self.panel)
    self.ln=#misc.split(self.msg[self.curPage],"\n") --行数

	if self.lnShow then
		self.text:SetText(option.msg[self.curPage])
		self.select=loveframes.Create("selectbox",self.panel)
		--设置行数、列数、行列宽
		self.select:SetRowCol(1,1,love.graphics.getWidth(),fh)
		--设置每格的宽、间距
		self.select:SetCell(love.graphics.getWidth(),fh,0,0)
		--设置边界
		self.select:SetBound(0,0,love.graphics.getWidth(),self.ln*fh)
	end
	
end
function message:draw()
	if self.isShow then
		--画提示箭头
		if self.curPage>1 and self.curPage<self.pageNum then
			--画向上和下
			love.graphics.setColor(255,0,0)
			love.graphics.triangle( "fill", 100, 600, 125, 560, 150, 600 )
			love.graphics.triangle( "fill", 100, 600, 125, 560, 150, 600 )
		elseif self.curPage==1 then
			--画向下
			love.graphics.setColor(255,0,0)
			love.graphics.triangle( "fill", 700, 560, 750, 560, 725, 600 )
		elseif self.curPage==self.pageNum then
			--画向上
			love.graphics.setColor(255,0,0)
			love.graphics.triangle( "fill", 100, 600, 125, 560, 150, 600 )
		end
	end
end

function message:lineUpdate(dt)
self.id=self.select:GetId()
	

	if self.id==self.ln and love.keyboard.isDown(" ") then
		self.curPage=self.curPage+1
		--把光标移至第一行
		for i=1,self.id-1 do
			self.select:Move("up")
		end
		
	end
	if self.curPage>self.pageNum then
		self.curPage=self.pageNum
	end
	if self.curPage==self.pageNum and self.id==self.ln then
		--结束事件
		self.isOver=true
		self:onOver()
	end
	if self.curPage<=self.pageNum then
		self.ln=#misc.split(self.msg[self.curPage],"\n")
		
		self.text:SetText(self.msg[self.curPage])
	end
	
	
		
		self.select:SetBound(0,0,love.graphics.getWidth(),self.ln*self.fh)

end

function message:wordUpdate(dt)
	local t=misc.str2tb(self.msg[self.curPage])
	self.st=self.st+dt
	
    if self.st>self.rate then
        self.st=0
		
        if self.count<=#t then
            self.curStr=self.curStr.. t[self.count]
            self.count=self.count+1
		else
			self.isEnd=true
			

		end
	end
	if self.isEnd and self.curPage==self.pageNum then
	--结束事件
	self.isOver=true
	self:onOver()

	end
	if self.isEnd and love.keyboard.isDown(" ")then
		self.curPage=self.curPage+1
		
		if self.curPage>self.pageNum then
			self.curPage=self.pageNum
			self.curStr=""
			self.st=self.rate
			self.isEnd=false
			self.count=1
		end
	end
	self.text:SetText(self.curStr)
	
	
end

function message:update(dt)
	if self.lnShow then
		self:lineUpdate(dt)
	else
		self:wordUpdate(dt)
	end
	
end
function message:keypressed(key, unicode)
	if key=="escape" and self.isOver then
		self.panel:Remove()
		self.isShow=false
	end
end