
--游戏世界,统一使用中心为绘图起始点

-- todo 自定义碰撞 ,碰到敌人怎么办
--colltmp碰撞时的临时变量
--一般改变的是边界、速度、位置，因此规定为"boundl,boundr,boundu,boundd,sx,sy,x,y"
gmworld={roles={},colltmp={}} 
function gmworld:new(o)
	o = o or {} --如果参数中没有提供table，则创建一个空的。
     --将新对象实例的metatable指向表(类)
     setmetatable(o,self)
     self.__index = self
     --最后返回构造后的对象实例
     return o
end
--网格宽
function gmworld:create(cellsize,fps)
	--获取屏幕宽高
	self.w=love.graphics.getWidth()
	self.h=love.graphics.getHeight()
	
	self.fps=fps or 30
	self.cellsize=cellsize or 50
	self.HC = require 'hardoncollider'
	self.Collider = self.HC(self.cellsize,on_collide,on_collideStop)
	--todo 加上屏幕参数 0,0,self.w,self.h,
	
end

--todo 障碍


--添加角色 
function gmworld:addRole(role)
	local name=role.name
	self.roles[name]=role
	self.Collider:addShape(role.shape)
	
end


function gmworld:update(dt)

--设置fps
	love.timer.sleep(1/self.fps - love.timer.getDelta( ))

	for _,v in pairs(self.roles) do
		v:update(dt)
	end
	self.Collider:update(dt)
end

function gmworld:draw()

--todo 中心

	for _,v in pairs(self.roles) do
		
		v:draw()
		
	end
end

function gmworld:getCollTmp()
	return self.colltmp
end
--角色与角色碰撞 todo 应该按动量定理，动能，暂时按原速度反弹
function gmworld:collideRole(dt, shape_a, shape_b)
 
		print("hhh")
 
	
end
local collCont=0
--角色与墙碰撞
function gmworld:collideWall(dt, shape_a, shape_b)
	local wall,role
	if shape_a.attr=="wall" then
		wall=self.roles[shape_a.name]
		role=self.roles[shape_b.name]
	else
		wall=self.roles[shape_b.name]
		role=self.roles[shape_a.name]
	end
	local name=role.name
	
	if collCont==0 then
	self.colltmp[name]={boundu=role.bound[3]} --保存name角色的boundu属性
	collCont=collCont+1
	end
	role.bound[3]=wall.y+role.image:getHeight()
	
	
	
end

--角色与楼梯碰撞
function gmworld:collideLadder(dt, shape_a, shape_b)

end
--碰撞回调，调用上面的三个处理函数
function on_collide(dt,shape_a,shape_b)
	
	local attr=shape_a.attr..shape_b.attr
	if string.len (attr)==14 then--即dynamicdynamic
	--self:collideRole(dt,shape_a,shape_b)
    elseif string.len(attr)==11 then --即dynamicwall
	
	gmworld:collideWall(dt,shape_a,shape_b)    
    elseif string.len(attr)==13 then --即ladder
	--self:collideLadder(dt,shape_a,shape_b)
	end
end

--碰撞结束,恢复参数
function on_collideStop(dt,shape_a,shape_b)
	local tmp=gmworld:getCollTmp()
	
	for k,v in pairs(tmp) do
		if v.boundl then
		gmworld.roles[k].bound[1]=v.boundl
		elseif v.boundr then
		gmworld.roles[k].bound[2]=v.boundr
		elseif v.boundu then
	
		gmworld.roles[k].bound[3]=v.boundu
		collCont=collCont-1
		elseif v.boundd then
		gmworld.roles[k].bound[4]=v.boundd
		elseif v.sx then
		gmworld.roles[k].sx=v.sx
		elseif v.sy then
		gmworld.roles[k].sy=v.sy
		elseif v.x then
		gmworld.roles[k].x=v.x
		elseif v.y then
		gmworld.roles[k].y=v.y
		end
		
	end
end