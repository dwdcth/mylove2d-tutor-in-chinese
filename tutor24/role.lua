shapes = require "hardoncollider.shapes"

role={}
--todo 先暂时如此，以后分别创建不同的role类
--todo 序列图 
--todo 每次在update里给self.x ,self.y赋值
local lg=love.graphics
function role:new(o)
   o = o or {}
   setmetatable(o,self)
   self.__index=self
   return o
end
--创建 imgname 图片路径，屏幕坐标，形状，
--形状形式为{"rect",x1,y1,x2,y2}
--属性(dynamic表示碰撞后反弹默认,wall表示碰撞后不会反弹,ladder 楼梯)
function role:create(img,name,x,y,attr,shape)
	self.image=lg.newImage(img)
	self.name=name
	self.x=x or 100
	self.y=y or 100
	--速度
	self.sx=2
	self.sy=0
	--跳跃力
	self.dx=0
	self.dy=2
	self.dir=""
	self.state="stop"
	--运动边界 左、右、上、下 --todo 坐标问题
	self.bound={0,lg.getWidth(),0,self.y+self.image:getHeight()/2}

	if not shape then
		local w=self.image:getWidth()
		local h=self.image:getHeight()
		local s=shapes.newPolygonShape(self.x,self.y,self.x+w,self.y, self.x+w,self.y+h, self.x,self.y+h)
		s.attr= attr or "dynamic"
		s.name=name
		self.shape=s  --todo name
		
	end
	self.attr=attr or "dynamic"
end
--绘图
function role:draw()
	
	lg.draw(self.image,self.x,self.y,0,1,1,self.image:getWidth()/2,self.image:getHeight()/2)
	
end

--更新
function role:update(dt)
	self.x,self.y=self.shape:center()
	self:motion(dt)
end



--设置跳跃力 水平、竖直
function role:setJumpForce(dx,dy)
	self.dx=dx or 1
	self.dy=dy or 1
end
--设置速度 水平、竖直
function role:setSpeed(sx,sy)
	
end


--运动  todo 边界处理
function role:motion(dt)
	if self.attr=="dynamic" then
	--向左
	 if love.keyboard.isDown("left") then
		self.dir="L"
		--self.x=self.x-self.sx
		self.shape:move(-self.sx,0)
		if self.state~="jump" and self.state~="down" then
		self.state="move"
		end
	 end
	 --向右
	 if love.keyboard.isDown("right") then
		self.dir="R"
		--self.x=self.x+self.sx
		self.shape:move(self.sx,0)
		if self.state~="jump" and self.state~="down" then
		self.state="move"
		end
	 end
	 --跳跃
	 if love.keyboard.isDown(" ") and self.state~="jump" and self.state~="down" then
		self.dir="U"
		self.state="jump"
		self.dy=8
	 end
	 
	 
	 
	if self.state=="jump" then
		self.dy=self.dy-dt*15
		if self.dy>0 then
			if self.y>=self.bound[3] then
			--self.y=self.y-self.dy
			self.shape:move(0,-self.dy)
			end
		else
			self.state="down"
			
		end
	end
	
	if self.state=="down" then
		self.dy=self.dy+dt*18
		if self.y<self.bound[4] then --todo 改进坐标\由world管理
			--self.y=self.y+self.dy
			self.shape:move(0,self.dy)
			
		else
			--self.y=self.bound[4]
			
			self.shape:moveTo(self.x,self.bound[4])
			self.state="stop"
		end
	end
	
	end
	
end
	--todo分离运动，返回dx，dy或x，y
