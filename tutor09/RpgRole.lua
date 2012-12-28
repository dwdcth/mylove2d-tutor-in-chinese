require('Anim')
require('middleclass')

RpgRole=class('RpgRole')

--方向常数
RpgRole.static.DOWN=1
RpgRole.static.LEFT=2
RpgRole.static.RIGHT=3
RpgRole.static.UP=4
RpgRole.static.LEFTDOWN=5
RpgRole.static.RIGHTDOWN=6
RpgRole.static.LEFTUP=7
RpgRole.static.RIGHTUP=8

--tex 为Image类型,nfrmes一幅图片中成套动作的帧数,如演示的图片有64个动作,但一套动作里的帧数是8
--fps,每秒播放的帧数,w帧的宽,h帧的高
function RpgRole:initialize(tex,nframes,FPS,w,h)
	self.direction=RpgRole.DOWN
	self.role={}
	--这里的8表示八个方向,每个方向一个role,即anim
	for i=1,8 do
		self.role[i]=Anim:new(tex,nframes,FPS,0,(i-1)*h,w,h)
	end
end



--下面的-1表示改状态和原来一样,后面的也是
function RpgRole: update(dt,dir)
	dir=dir or -1
	if (dir == self.direction or dir== -1) then
		self.role[self.direction]:update(dt)
	else
		self.setDirection(dir)

	end
end

function RpgRole: stopAll()
	for i=1,8 do
		self.role[i]:stop()
	end
end

function RpgRole: move(speed,dt)
	self.speed=speed
	--就是一个switch case语句
	local dir={
	[RpgRole.UP]=function() self.roleY =self.roleY  - self.speed * dt end ,
	[RpgRole.DOWN]=function() self.roleY =self.roleY  +  self.speed * dt end  ,
	[RpgRole.LEFT]=function() self.roleX =self.roleX  -  self.speed * dt end  ,
	[RpgRole.RIGHT]=function() self.roleX =self.roleX +   self.speed * dt end ,
	[RpgRole.LEFTUP]=function() self.roleX , self.roleY =
		(self.roleX -   self.speed * dt),(self.roleY  -  self.speed * dt) end,
	[RpgRole.LEFTDOWN]=function() self.roleX , self.roleY =
		(self.roleX -   self.speed * dt),(self.roleY  +  self.speed * dt) end,
	[RpgRole.RIGHTUP]=function() self.roleX ,self.roleY =
		(self.roleX +  self.speed * dt),(self.roleY  - self.speed * dt ) end,
	[RpgRole.RIGHTDOWN]=function() self.roleX,self.roleY  =
		(self.roleX +  self.speed * dt),(self.roleY  +  self.speed * dt) end,

	}
	--这里就是执行条件了
	dir[self.direction]()
end
--调用anim的play方法,从第一帧开始播放,实际是设置播放起始帧为1
function RpgRole: play(dir)
	self.direction=dir
	self.role[dir]:play()
end

function RpgRole: render(x ,y)
	x=x or -1
	y=y or -1
	if (x == -1 or y == -1) then
		self.role[self.direction]:render(self.roleX, self.roleY)
	else
		self.roleX = x
		self.roleY = y
		self.role[self.direction]:render(x, y)
	end
	--调试输出
	if(self.debug==true) then
	love.graphics.print("x " .. self.roleX .. " y " .. self.roleY,10,10)
	end
end
--设置方向
function RpgRole:setDirection(dir)
	if (self.direction ~= dir) then
		self.role[self.direction]:stop()
		self.direction = dir
		self.role[self.direction]:play()
	end
end

--设置角色在屏幕的坐标
function RpgRole: setXY(x,y)
		self.roleX = x
		self.roleY = y
end

function RpgRole: getX()
	return self.roleX
end

function RpgRole: getY()
	return self.roleY
end

function RpgRole: getDirection()
	return self.direction
end
