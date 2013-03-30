--[[------------------------------------------------
	-- Love Frames - A GUI library for LOVE --
	-- Copyright (c) 2012 Kenny Shields --
--]]------------------------------------------------

-- slider class
local newobject = loveframes.NewObject("slider", "loveframes_object_slider", true)

--[[---------------------------------------------------------
	- func: initialize()
	- desc: initializes the object
--]]---------------------------------------------------------
function newobject:initialize()

	self.type = "slider"
	self.text = "Slider"
	self.slidetype = "horizontal"
	self.width = 5
	self.height = 5
	self.max = 10
	self.min = 0
	self.value = 0
	self.decimals = 5
	self.internal = false
	self.internals = {}
	self.OnValueChanged	= nil
	
	-- create the slider button
	table.insert(self.internals, loveframes.objects["sliderbutton"]:new(self))
	
	-- set initial value to minimum
	self:SetValue(self.min)
	
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
	
	local internals = self.internals
	local sliderbutton 	= internals[1]
	local parent = self.parent
	local base = loveframes.base
	local update = self.Update
	
	self:CheckHover()
	
	-- move to parent if there is a parent
	if parent ~= base and parent.type ~= "list" then
		self.x = self.parent.x + self.staticx
		self.y = self.parent.y + self.staticy
	end
	
	if sliderbutton then
		if self.slidetype == "horizontal" then
			self.height = sliderbutton.height
		elseif self.slidetype == "vertical" then
			self.width = sliderbutton.width
		end
	end
	
	-- update internals
	for k, v in ipairs(self.internals) do
		v:update(dt)
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
	
	local internals = self.internals
	local skins = loveframes.skins.available
	local skinindex = loveframes.config["ACTIVESKIN"]
	local defaultskin = loveframes.config["DEFAULTSKIN"]
	local selfskin = self.skin
	local skin = skins[selfskin] or skins[skinindex]
	local drawfunc = skin.DrawSlider or skins[defaultskin].DrawSlider
	local draw = self.Draw
	local drawcount = loveframes.drawcount
	
	-- set the object's draw order
	self:SetDrawOrder()
		
	if draw then
		draw(self)
	else
		drawfunc(self)
	end
	
	-- draw internals
	for k, v in ipairs(internals) do
		v:draw()
	end

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
	
	local internals = self.internals
	
	if self.hover and button == "l" then
		if self.slidetype == "horizontal" then
			local xpos = x - self.x
			local button = internals[1]
			local baseparent = self:GetBaseParent()
			if baseparent and baseparent.type == "frame" then
				baseparent:MakeTop()
			end
			button:MoveToX(xpos)
			button.down = true
			button.dragging = true
			button.startx = button.staticx
			button.clickx = x
		elseif self.slidetype == "vertical" then
			local ypos = y - self.y
			local button = internals[1]
			local baseparent = self:GetBaseParent()
			if baseparent and baseparent.type == "frame" then
				baseparent:MakeTop()
			end
			button:MoveToY(ypos)
			button.down = true
			button.dragging = true
			button.starty = button.staticy
			button.clicky = y
		end
	end
	
	for k, v in ipairs(internals) do
		v:mousepressed(x, y, button)
	end
	
end

--[[---------------------------------------------------------
	- func: SetValue(value)
	- desc: sets the object's value
--]]---------------------------------------------------------
function newobject:SetValue(value)

	if value > self.max then
		return
	end
	
	if value < self.min then
		return
	end
	
	local decimals = self.decimals
	local newval = loveframes.util.Round(value, decimals)
	local internals = self.internals
	local onvaluechanged = self.OnValueChanged
	
	-- set the new value
	self.value = newval
	
	-- slider button object
	local sliderbutton = internals[1]
	local slidetype = self.slidetype
	local width = self.width
	local height = self.height
	local min = self.min
	local max = self.max
	
	-- move the slider button to the new position
	if slidetype == "horizontal" then
		local xpos = width * ((newval - min) / (max - min))
		sliderbutton:MoveToX(xpos)
	elseif slidetype == "vertical" then
		local ypos = height - height * ((newval - min) / (max - min))
		sliderbutton:MoveToY(ypos)
	end
	
	-- call OnValueChanged
	if onvaluechanged then
		onvaluechanged(self)
	end
	
end

--[[---------------------------------------------------------
	- func: GetValue()
	- desc: gets the object's value
--]]---------------------------------------------------------
function newobject:GetValue()

	return self.value
	
end

--[[---------------------------------------------------------
	- func: SetMax(max)
	- desc: sets the object's maximum value
--]]---------------------------------------------------------
function newobject:SetMax(max)

	self.max = max
	
	if self.value > self.max then
		self.value = self.max
	end
	
end

--[[---------------------------------------------------------
	- func: GetMax()
	- desc: gets the object's maximum value
--]]---------------------------------------------------------
function newobject:GetMax()

	return self.max
	
end

--[[---------------------------------------------------------
	- func: SetMin(min)
	- desc: sets the object's minimum value
--]]---------------------------------------------------------
function newobject:SetMin(min)

	self.min = min
	
	if self.value < self.min then
		self.value = self.min
	end
	
end

--[[---------------------------------------------------------
	- func: GetMin()
	- desc: gets the object's minimum value
--]]---------------------------------------------------------
function newobject:GetMin()

	return self.min
	
end

--[[---------------------------------------------------------
	- func: SetMinMax()
	- desc: sets the object's minimum and maximum values
--]]---------------------------------------------------------
function newobject:SetMinMax(min, max)

	self.min = min
	self.max = max
	
	if self.value > self.max then
		self.value = self.max
	end
	
	if self.value < self.min then
		self.value = self.min
	end
	
end

--[[---------------------------------------------------------
	- func: GetMinMax()
	- desc: gets the object's minimum and maximum values
--]]---------------------------------------------------------
function newobject:GetMinMax()

	return self.min, self.max
	
end

--[[---------------------------------------------------------
	- func: SetText(name)
	- desc: sets the objects's text
--]]---------------------------------------------------------
function newobject:SetText(text)

	self.text = text
	
end

--[[---------------------------------------------------------
	- func: GetText()
	- desc: gets the objects's text
--]]---------------------------------------------------------
function newobject:GetText()

	return self.text
	
end

--[[---------------------------------------------------------
	- func: SetDecimals(decimals)
	- desc: sets the objects's decimals
--]]---------------------------------------------------------
function newobject:SetDecimals(decimals)

	self.decimals = decimals
	
end

--[[---------------------------------------------------------
	- func: SetButtonSize(width, height)
	- desc: sets the objects's button size
--]]---------------------------------------------------------
function newobject:SetButtonSize(width, height)
	
	local internals = self.internals
	local sliderbutton = internals[1]
	
	if sliderbutton then
		sliderbutton.width = width
		sliderbutton.height = height
	end
	
end

--[[---------------------------------------------------------
	- func: GetButtonSize()
	- desc: gets the objects's button size
--]]---------------------------------------------------------
function newobject:GetButtonSize()

	local internals = self.internals
	local sliderbutton = internals[1]
	
	if sliderbutton then
		return sliderbutton.width, sliderbutton.height
	else
		return false
	end
	
end

--[[---------------------------------------------------------
	- func: SetSlideType(slidetype)
	- desc: sets the objects's slide type
--]]---------------------------------------------------------
function newobject:SetSlideType(slidetype)

	self.slidetype = slidetype
	
	if slidetype == "vertical" then
		self:SetValue(self.min)
	end
	
end

--[[---------------------------------------------------------
	- func: GetSlideType()
	- desc: gets the objects's slide type
--]]---------------------------------------------------------
function newobject:GetSlideType()

	return self.slidetype
	
end