require('middleclass')
menu=class('menu')
menu.static.colordark={120,0,0}   --暗色
menu.static.colorlight={255,0,0}  --亮色


--居中坐标按四个汉字标准,四项菜单
--菜单的坐标x,y 多少项n 可以为空
function menu:initialize( x, y, n )
	
    self.mainmenus={} --主菜单
    self.isInSub=false --是否进入子菜单
	self.id=1         --主菜单id
	self.sid=1        --子菜单id
	local font =  love.graphics.getFont( )

	local w,h = font:getWidth("一"),font:getHeight() --得到字体数据
	self.fw,self.fh=w,h
	self.x=x or (love.graphics.getWidth()-w*4)/2  --x居中
	self.y=y or (love.graphics.getHeight()-4*h-20)	  --y离底部20
end
--背景图
-- todo 参数检测
function menu:SetImage(imgname)

	self.img=love.graphics.newImage(imgname)
end
--设置背景音乐
function menu:SetMusic(source)
	self.music=love.audio.newSource(source)
	self.music:setLooping(true)
	love.audio.play(self.music)
end
--设置移动光标的音乐
function menu:SetMoveMusic(source )
	-- body
end
--设置选中时的音乐
function menu:SetSelectMusic( source )
	-- body
end
--新建菜单
function menu:AddMenu(name,func)
	
	self.mainmenus[#self.mainmenus+1]={name,{},func}

end

--添加子菜单 
function menu:SubMenu(name,parentid,func)
	-- body
	
	table.insert(self.mainmenus[parentid][2],{name,func})
end

function menu:draw()
	local r,g,b,a = love.graphics.getColor()  --保存原有颜色
	if self.img then
		love.graphics.draw(self.img,0,0)
	end
	--判断绘制对象
	local menus={}
	local id=0
	if self.isInSub then
		menus=self.mainmenus[self.id][2]
		id=self.sid
	else		
		menus=self.mainmenus
		id=self.id
	end

	for k,v in ipairs(menus) do
		if k==id then
			love.graphics.setColor(unpack(menu.colorlight))
		else
			love.graphics.setColor(unpack(menu.colordark))
		end
		love.graphics.print(v[1],self.x,(k-1)*self.fh+self.y)
	end

	--恢复
	love.graphics.setColor(r,g,b,a)
end

function menu:update(dt)
	
end

function menu:keypressed(key, unicode)
	local id = 0
	local menus = {}
	if self.isInSub then
		id=self.sid
		menus=self.mainmenus[self.id][2]
	else
		id=self.id
		menus=self.mainmenus
	end

	--键盘移动
	if key=="up" then
		id=id-1
	elseif key=="down" then
		id=id+1
	end
	if id>#menus then
		id=1
	elseif id<1 then
		id=#menus
	end

	--把id赋值回去,检测键盘
	if self.isInSub then
		self.sid=id
		local fun=menus[id][2] --第二项为函数
		if type(fun)=="function" then fun() end
		if key=="escape" then self.isInSub=false self.sid=1 end

	else
		self.id=id
		--回调
		if key=="return" then
			local fun=menus[id][3] --第三项是函数
			if type(fun)=="function" then fun() end
			local sub = menus[id][2] --第二项是子菜单
			if #sub>=1 then 
				self.isInSub=true 
			end
		end
	end	
end