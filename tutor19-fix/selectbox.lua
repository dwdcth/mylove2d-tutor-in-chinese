
-- todo draw函数 selectbox 皮肤 使用光标图片时的变色（两幅图片）

--根据loveframe自定义一个控件，包围矩形
local newobject = loveframes.NewObject("selectbox", "loveframes_object_selectbox", true)

--[[---------------------------------------------------------
	- func: initialize()
	- desc: initializes the object
--]]---------------------------------------------------------
function newobject:initialize()

	self.type = "selectbox"
	--选择框的长宽
	self.width ,self.height= 98,98
	--单元格的长、宽
	self.cw,self.ch=98,98
	self.internal = false
	self.down = false
	self.clickable = false
	self.enabled = true
	
	--返回选择的id
	self.ReturnSwap=function(obj) end
	
	--按enter键执行
	self.OnEnter=function() end
	--一些参数的默认值，方便测试
	self.minX=0
	self.minY=0
	self.maxX=800
	self.maxY=600
	--相邻的行、列间距
	self.dx=2
	self.dy=2
	--总的行列数
	self.rows=6
	self.cols=8
	
	--坐标
	self.x=1
	self.y=1
	self.staticx,self.staticy=self.x,self.y
	--偏移，相对背包起点
	self.sx,self.sy=0,0
	--表示当前所在行，列
	self.row,self.col=1,1
	--记录交换物品的id
	self.oldId=0
	self.newId=0
	self.selectCount=0 --记录按下选择键的次数
	--当前选择框id
	self.Id=1
	self.enterdown=false
	--self.selectCount=0 --记录按下交换键的次数
	
	--记录交换物品的id
	--self.oldId=0
	--self.newId=0
	--物品表
	--self.resTable={}
	--物品提示编辑框
	--self.tipText=nil
	--物品提示内容
	--self.tip=""
	
	
end

--[[---------------------------------------------------------
	- func: update(deltatime)
	- desc: updates the object
--]]---------------------------------------------------------
function newobject:update(dt)
	
	local visible = self.visible
	local alwaysupdate = self.alwaysupdate
	
	if not visible then
		if not alwaysupdate then
			return
		end
	end
	
	self:CheckHover()
	
	local hover = self.hover
	local hoverobject = loveframes.hoverobject
	local down = self.down
	local parent = self.parent
	local base = loveframes.base
	local update = self.Update
	
	if not hover then
		self.down = false
	else
		if hoverobject == self then
			self.down = true
		end
	end
	
	if not down and hoverobject == self then
		self.hover = true
	end
	
	
	-- move to parent if there is a parent
	--坐标
	if parent ~= base then
		self.x = self.parent.x + self.staticx+self.sx
		self.y = self.parent.y + self.staticy+self.sy
	else
		self.x=self.staticx+self.sx
		self.y=self.staticy+self.sy
	end
	
	if update then
		update(self, dt)
		
	end
	
	
end

function newobject:GetText()
	return ""
end

--绘制选择框的函数
function newobject:drawCursor()

	if not self.image then
		--绘制选择框
		love.graphics.setColor(0, 204, 51, 255)
		love.graphics.setLine(2, "smooth")
		love.graphics.rectangle("line", self.x , self.y , self.width + 2, self.height + 2)
		--绘制选择键按下后的颜色	
		if self.selectCount==1 then
		love.graphics.setColor(0, 0, 255, 255)
		love.graphics.setLine(2, "smooth")
		love.graphics.rectangle("line", self.oldIdX , self.oldIdY, self.width + 2, self.height + 2)
		elseif self.selectCount==2 then
		love.graphics.setColor(0, 0, 255, 255)
		love.graphics.setLine(2, "smooth")
		love.graphics.rectangle("line", self.newIdX , self.newIdY , self.width + 2, self.height + 224)
		end
		--绘制entert键后按下的颜色
		if self.enterdown then
		love.graphics.setColor(255, 0, 51, 255)
		love.graphics.setLine(2, "smooth")
		love.graphics.rectangle("line", self.x , self.y , self.width + 2, self.height + 2)
		end
	
	else
		love.graphics.draw(self.image,self.x,self.y)
	
	end

end
--[[---------------------------------------------------------
	- func: draw()
	- desc: draws the object
--]]---------------------------------------------------------
function newobject:draw()
	
	local visible = self.visible
	
	if not visible then
		return
	end
	
	self:drawCursor()
	--[[
	local skins = loveframes.skins.available
	local skinindex = loveframes.config["ACTIVESKIN"]
	local defaultskin = loveframes.config["DEFAULTSKIN"]
	local selfskin = self.skin
	local skin = skins[selfskin] or skins[skinindex]
	-- $TODO: skin
	local drawfunc = skin.DrawButton or skins[defaultskin].DrawButton
	local draw = self.Draw
	local drawcount = loveframes.drawcount    
	
	-- set the object's draw order
	self:SetDrawOrder()
	
	--drawfunc=function()
		
	
	
	--end
	if draw then
		draw(self)
	else
		drawfunc(self)
	end
	]]
	
		--[[]
		if self.enterdown then
			print("enter,draw")
			love.graphics.setColor(0, 0, 255, 255)
			love.graphics.setLine(2, "smooth")
			love.graphics.rectangle("line", self.x, self.y, self.width + 2, self.height + 2)
		end
	]]
	--[[
	elseif self.newIdX then
	love.graphics.setColor(0, 0, 255, 255)
	love.graphics.setLine(2, "smooth")
	love.graphics.rectangle("line", self.newIdX - 1, self.newIdY - 1, self.width + 4, self.height + 4)
	end
	]]
	
end

--image为love2d 图片类型
function newobject:SetCursor(image)

	if image then
		
		if image=="default" then
			self.image = love.graphics.newImage("assets/choice.png")
		else
			self.image=image
		end
	else
		self.image=nil
	end

end
--设置行、列数，选择框的长、宽
function newobject:SetRowCol(rows,cols,width,height)
	self.rows,self.cols,self.width,self.height=rows,cols,width,height
end
--设置单元格的长宽，相邻行、列的间距
function newobject:SetCell(cw,ch,dx,dy)
	self.cw,self.ch,self.dx,self.dy=cw,ch,dx,dy
end

--设置边界，左上顶点，右下顶点
function newobject:SetBound(x1,y1,x2,y2)
	self.minX=x1
	self.maxX=x2
	self.minY=y1
	self.maxY=y2
end

--返回在列表里的序号
function newobject:GetId()
	return (self.row-1)*self.cols+self.col
end
--返回行列数
function newobject:GetIndex()
	return self.row,self.col
end

--设置选择键		
function newobject:SetKey(key)
	self.selectkey=key
end

--选择键,返回前后选择的id ,执行onswap函数
function newobject:Select()
	if self.oldId==0 and self.newId==0 then
		self.oldId=self:GetId()
		print(self.oldId .. "  oldid")

		self.oldIdX,self.oldIdY=self.x,self.y
	else 
		self.newId=self:GetId()
		print(self.newId .. "  new id")
		self.newIdX,self.newIdY=self.x,self.y

	end
	
	self.selectCount=self.selectCount+1
	--按下两次，复位
	if self.selectCount>=2 then
	self:ReturnSwap(self)
	
	--print(self.oldId)
	--print(self.newId)
	-- %TODO: return id
	self.selectCount=0
	self.oldId=0
	self.newId=0
	end	
	
end

--移动，dir方向
function newobject:Move(dir)
	
	if(dir=="down") then
		if self.y>self.parent.y+self.maxY-self.height*1.5 then
			self.sy=self.sy
			self.row=self.row
			
		else	
			self.sy=self.sy+self.dy+self.ch
			self.row=self.row+1
			print(self.sy)
		end
		
	end

	if(dir=="up") then
		
		if self.y<self.parent.y+self.minY+self.height*0.5 then
			self.sy=self.sy
			self.row=self.row
		else	
			self.sy=self.sy-self.dy-self.ch
			self.row=self.row-1
		end
	end
	
	if(dir=="right") then
		if self.x>self.parent.x+self.maxX-self.width*1.5 then
			self.sx=self.sx
			self.col=self.col
		else	
			self.sx=self.sx+self.dx+self.cw
			self.col=self.col+1
			print(self.col)
		end
	end

	if(dir=="left") then
		if self.x<self.parent.x+self.minX+self.width*0.5 then
			self.sx=self.sx
			self.col=self.col
		else	
			self.sx=self.sx-self.dx-self.cw
			self.col=self.col-1
		end
	end


end









--第一个道具的内容无法自动提示，必须手动设置
function newobject:SetFirstTip(tip)
	self.tipText:SetText(tip)
end


--[[---------------------------------------------------------
	- func: keypressed(key)
	- desc: called when the player presses a key
--]]---------------------------------------------------------
function newobject:keypressed(key, unicode)

	local visible = self.visible
	local children = self.children
	local internals = self.internals
	
	if not visible then
		return
	end
	
	if children then
		for k, v in ipairs(children) do
			v:keypressed(key, unicode)
		end
	end
	
	if internals then
		for k, v in ipairs(internals) do
			v:keypressed(key, unicode)
		end
	end
	self:Move(key)
	if(key=="return") then
		self.OnEnter() -- $TODO: change
		self.enterdown= true	
	else
	--按其它键时恢复
		self.enterdown=false
	end
	if(key==self.selectkey) then
		self:Select()
		
	end

end

--[[---------------------------------------------------------
	- func: keyreleased(key)
	- desc: called when the player releases a key
--]]---------------------------------------------------------
function newobject:keyreleased(key)

	local visible = self.visible
	local children = self.children
	local internals = self.internals
	
	if not visible then
		return
	end
	
	if children then
		for k, v in ipairs(children) do
			v:keyreleased(key)
		end
	end
	
	if internals then
		for k, v in ipairs(internals) do
			v:keyreleased(key)
		end
	end
	
end


--设置对象
function newobject:SetObject(obj)
	self.obj=obj
end





--[[---------------------------------------------------------
	- func: mousepressed(x, y, button)
	- desc: called when the player presses a mouse button
--]]---------------------------------------------------------

function newobject:mousepressed(x, y, button)
	
	local visible = self.visible
	
	if not visible then
		return
	end
	
	local hover = self.hover
	
	if hover and button == "l" then
		local baseparent = self:GetBaseParent()
		if baseparent and baseparent.type == "frame" then
			baseparent:MakeTop()
		end
		--鼠标支持
		self.down = true
		loveframes.hoverobject = self
	end
	
end


--[[---------------------------------------------------------
	- func: mousereleased(x, y, button)
	- desc: called when the player releases a mouse button
--]]---------------------------------------------------------

function newobject:mousereleased(x, y, button)
	
	local visible = self.visible
	
	if not visible then
		return
	end
	
	local hover = self.hover
	local down = self.down
	local clickable = self.clickable
	local enabled = self.enabled
	local onclick = self.OnClick

	if hover and down and clickable and button == "l" then
		if enabled then
			if onclick then
				onclick(self, x, y)
			end
		end
	end
	--鼠标支持
	self.down = false

end







--[[---------------------------------------------------------
	- func: SetClickable(bool)
	- desc: sets whether the object can be clicked or not
--]]---------------------------------------------------------
function newobject:SetClickable(bool)

	self.clickable = bool
	
end

--[[---------------------------------------------------------
	- func: GetClickable(bool)
	- desc: gets whether the object can be clicked or not
--]]---------------------------------------------------------
function newobject:GetClickable()

	return self.clickable
	
end


--[[---------------------------------------------------------
	- func: SetClickable(bool)
	- desc: sets whether the object is enabled or not
--]]---------------------------------------------------------
function newobject:SetEnabled(bool)

	self.enabled = bool
	
end


--[[---------------------------------------------------------
	- func: GetEnabled()
	- desc: gets whether the object is enabled or not
--]]---------------------------------------------------------
function newobject:GetEnabled()

	return self.enabled
	
end




--[[

--交换函数 按s键
function newobject:OnSwap(oldId,newId)
	
	local oldImg=self.resTable[oldId]:GetImage()
	local newImg=self.resTable[newId]:GetImage()
	
	--由于loveframes没有提供把imagebutton的道具设置为空的方法
	--不能交换的两个物品有一个为空，
	
	self.resTable[oldId]:SetCursor(newImg)
	self.resTable[newId]:SetCursor(oldImg)
	
	self.oldIdX=nil
	self.newIdX=nil
end
]]




