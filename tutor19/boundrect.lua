--根据loveframe自定义一个控件，包围矩形
local newobject = loveframes.NewObject("boundrect", "loveframes_object_boundrect", true)

--[[---------------------------------------------------------
	- func: initialize()
	- desc: initializes the object
--]]---------------------------------------------------------
function newobject:initialize()

	self.type = "boundrect"
	self.width = 50
	self.height = 50
	self.internal = false
	self.down = false
	self.clickable = false
	self.enabled = true
	self.text=""
	--按enter键执行
	self.OnEnter=nil
	--偏移
	self.sy,self.sx=0,0
	--表示当前所在行，列
	self.row,self.col=1,1
	
	self.swapCount=0 --记录按下交换键的次数
	
	--记录交换物品的id
	self.oldId=0
	self.newId=0
	--物品表
	self.resTable={}
	--物品提示编辑框
	self.tipText=nil
	--物品提示内容
	self.tip=""
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
	if parent ~= base then
		self.x = self.parent.x + self.staticx+self.sx
		self.y = self.parent.y + self.staticy+self.sy
		
	end
	
	if update then
		update(self, dt)
		
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
	
	local skins = loveframes.skins.available
	local skinindex = loveframes.config["ACTIVESKIN"]
	local defaultskin = loveframes.config["DEFAULTSKIN"]
	local selfskin = self.skin
	local skin = skins[selfskin] or skins[skinindex]
	local drawfunc = skin.DrawImageButton or skins[defaultskin].DrawImageButton
	local draw = self.Draw
	local drawcount = loveframes.drawcount    
	
	-- set the object's draw order
	self:SetDrawOrder()
		
	if draw then
		draw(self)
	else
		drawfunc(self)
	end
	
	love.graphics.setColor(0, 204, 51, 255)
	love.graphics.setLine(2, "smooth")
	love.graphics.rectangle("line", self.x - 1, self.y - 1, self.width + 4, self.height + 4)
	if self.oldIdX then
	love.graphics.setColor(0, 0, 255, 255)
	love.graphics.setLine(2, "smooth")
	love.graphics.rectangle("line", self.oldIdX - 1, self.oldIdY - 1, self.width + 4, self.height + 4)
	elseif self.newIdX then
	love.graphics.setColor(0, 0, 255, 255)
	love.graphics.setLine(2, "smooth")
	love.graphics.rectangle("line", self.newIdX - 1, self.newIdY - 1, self.width + 4, self.height + 4)
	end
	
	
end

--第一个道具的内容无法自动提示，必须手动设置
function newobject:SetFirstTip(tip)
	self.tipText:SetText(tip)
end

--交换函数 按s键
function newobject:OnSwap(oldId,newId)
	
	local oldImg=self.resTable[oldId]:GetImage()
	local newImg=self.resTable[newId]:GetImage()
	
	--由于loveframes没有提供把imagebutton的道具设置为空的方法
	--不能交换的两个物品有一个为空，
	
	self.resTable[oldId]:SetImage(newImg)
	self.resTable[newId]:SetImage(oldImg)
	
	self.oldIdX=nil
	self.newIdX=nil
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

if(key=="down") then
	if self.y>self.parent.y+self.maxY-self.dy-25-self.dy/2 then
		self.sy=self.sy
		self.row=self.row
	else	
		self.sy=self.sy+self.dy
		self.row=self.row+1
	end
	print("down")
	print(self.y)
		
	self.tip="道具" .. (self.row-1)*self.cols+self.col
	self.tipText:SetText(self.tip)
end

if(key=="up") then
	
	if self.y<self.parent.y+self.minY+self.dy/2 then
		self.sy=self.sy
		self.row=self.row
			print("up if")

	else	
		print("up else")

		self.sy=self.sy-self.dy
		self.row=self.row-1
	end
	self.tip="道具" .. (self.row-1)*self.cols+self.col
	self.tipText:SetText(self.tip)	

	
end
if(key=="right") then
	if self.x>self.parent.x+self.maxX-self.dx-50 then
		self.sx=self.sx
		self.col=self.col
	else	
		self.sx=self.sx+self.dx
		self.col=self.col+1
	end
	self.tip="道具" .. (self.row-1)*self.cols+self.col
	self.tipText:SetText(self.tip)		

end

if(key=="left") then
	if self.x<self.parent.x+self.minX+self.dx/2 then
		self.sx=self.sx
				self.col=self.col

	else	
		self.sx=self.sx-self.dx
				self.col=self.col-1

end
	self.tip="道具" .. (self.row-1)*self.cols+self.col
	self.tipText:SetText(self.tip)	
end

if(key=="return") then
	self:OnEnter()
end

if(key=="s") then
	if self.oldId==0 and self.newId==0 then
		self.oldId=(self.row-1)*self.cols+self.col
			print(self.oldId .. "  oldid")

	self.oldIdX,self.oldIdY=self.x,self.y
	else 
		self.newId=(self.row-1)*self.cols+self.col
		print(self.newId .. "  new id")
			self.newIdX,self.newIdY=self.x,self.y

	end
	self.swapCount=self.swapCount+1
	
	--执行交换，并复位
	if self.swapCount==2 then
	self:OnSwap(self.oldId,self.newId)
	print(self.oldId)
	self.swapCount=0
	self.oldId=0
	self.newId=0
	end
end

end

function newobject:SetDelta(dx,dy)
	self.dx=dx
	self.dy=dy
end
--边界，左上顶点，右下顶点
function newobject:SetBounds(x1,y1,x2,y2)
	self.minX=x1
	self.maxX=x2
	self.minY=y1
	self.maxY=y2
end
function newobject:SetRowCol(rows,cols)
	self.rows=rows
	self.cols=cols
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
		self.down = true
		loveframes.hoverobject = self
	end
	
end

--设置对象
function newobject:SetObject(obj)
	self.obj=obj
end

--[[---------------------------------------------------------
	- func: mousereleased(x, y, button)
	- desc: called when the player releases a mouse button
--]]---------------------------------------------------------
function newobject:mousereleased(x, y, button)
	--[[
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
	
	self.down = false
]]
end

--[[---------------------------------------------------------
	- func: SetText(text)
	- desc: sets the object's text
--]]---------------------------------------------------------
function newobject:SetText(text)

	self.text = text
	
end

--[[---------------------------------------------------------
	- func: GetText()
	- desc: gets the object's text
--]]---------------------------------------------------------
function newobject:GetText()

	return self.text
	
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

--[[---------------------------------------------------------
	- func: SetImage(image)
	- desc: sets the object's image
--]]---------------------------------------------------------
function newobject:SetImage(image)

	if type(image) == "string" then
		self.image = love.graphics.newImage(image)
	else
		self.image = image
	end

end

--[[---------------------------------------------------------
	- func: GetImage()
	- desc: gets whether the object is enabled or not
--]]---------------------------------------------------------
function newobject:GetImage()

	return self.image

end

--[[---------------------------------------------------------
	- func: SizeToImage()
	- desc: makes the object the same size as it's image
--]]---------------------------------------------------------
function newobject:SizeToImage()

	local image = self.image
	
	if image then
		self.width = image:getWidth()
		self.height = image:getHeight()
	end

end
