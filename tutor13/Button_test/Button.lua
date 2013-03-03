require('middleclass')
local lg=love.graphics
Button=class('Button')

--按钮上显示的文字,按钮位置
function Button:initialize(text,x,y)
	self.text=text
	--为按钮内框位置
	self.bx=x
	self.by=y
	self.font =lg.newFont(18) --18号字体一个字母宽11,高21
	lg.setFont(self.font)
	--文字宽度
	self.tw=self.font:getWidth(text)
	--这里的按钮为两个矩形,内框,外框
	--内框默认40宽,25高,外框和内框间距4像素
	self.bw=40
	self.bh=25
	if self.tw>33 then --即3个字母
			self.bw=self.tw+4
	end

	--tx,ty是文字显示的位置,,文字据内框2像素
	self.tx=self.bx+2
	self.ty=self.by+2

	--是否点击
	self.isDown=false
end

--在屏幕上显示的坐标,可以为空,为空时,即初始化时的值
function Button:draw(x,y)
	self.bx=x or self.bx
	self.by=y or self.by
	--先保存原来的颜色
	local r, g, b, a = love.graphics.getColor( )

	--先画外框
	lg.setColor(130,183,237) --淡蓝色
	lg.rectangle( "fill", self.bx-4,self.by-4, self.bw+8, self.bh+8 )

	--再画内框
	if(self.isDown) then
	lg.setColor(130,183,237) --淡蓝色
	lg.rectangle("fill",self.bx,self.by,self.bw,self.bh)
	self.isDown=false
	else
	lg.setColor(100,126,250) --较深的蓝色
	lg.rectangle("fill",self.bx,self.by,self.bw,self.bh)
	end
	--画文字
	lg.setColor(255,0,0)
	lg.print(self.text,self.tx,self.ty)
	--恢复以前颜色
	lg.setColor(r,g,b,a)

	lg.print("bx=" .. self.bx .. " by=" .. self.by,10,20)
	lg.print("moux=" .. love.mouse.getX() .. " mouy=" .. love.mouse.getY() ,10,40)
end

--就是检测鼠标在按钮区域是否按下
function Button:isClick()
	local moux= love.mouse.getX( )
	local mouy=love.mouse.getY( )
	if moux>self.bx and moux <self.bx+self.bw then
		if mouy>self.by and mouy<self.by+self.bh then
			if love.mouse.isDown("l") then
				self.isDown=true
				return true
			 end
		end

	end

end
--事件处理函数
function Button:onClick(fun)
	self.clickFun=fun
end

function Button:update()
	self:isClick() --不断检测鼠标左键是否按下
	if self.isDown then
		self:clickFun()
	end
end
