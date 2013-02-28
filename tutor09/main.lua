require('Anim')
require('RpgRole')
--角色状态
local ROLESTATE_STAND= 0
local ROLESTATE_WALK= 1
local ROLESTATE_RUN= 2
--运动状态
local MODE_WALK= 1
local MODE_RUN= 2

local movemode=nil
local ROLESTATE=nil
local currdir=RpgRole.DOWN

function love.load()
	font=love.graphics.newFont(16)
	love.graphics.setFont(font)
	imgS=love.graphics.newImage("assets/stand.png")
	imgW=love.graphics.newImage("assets/walk.png")
	imgR=love.graphics.newImage("assets/run.png")
	--参数为: 图片,一套动作的帧数,播放速度,帧宽,帧高
	role_stand=RpgRole:new(imgS,8,8,84,108)
	role_walk=RpgRole:new(imgW,8,8,84,108)
	role_run=RpgRole:new(imgR,8,8,84,108)

	--打开输出
	role_stand.debug=true
	role_stand.debug=true
	role_stand.debug=true

	--注意要先设置方向,再设置位置,因为位置是绑定在方向上的
	role_stand:setDirection(currdir)
	role_stand:setXY(400,300)

	role_state = ROLESTATE_STAND;
	movemode = MODE_WALK;


end

function love.update(dt)

	local dir=-1
	--检测键盘设置运动模式,
	if(love.keyboard.isDown("1")) then
	movemode=MODE_WALK
	end
	if(love.keyboard.isDown("2")) then
	movemode=MODE_RUN
	end

	--检测键盘,设置运动方向
	if(love.keyboard.isDown("left")) then
		if(love.keyboard.isDown("up")) then
			dir=RpgRole.LEFTUP
		elseif(love.keyboard.isDown("down")) then
			dir=RpgRole.LEFTDOWN
		else
			dir=RpgRole.LEFT
		end

	elseif(love.keyboard.isDown("right")) then
		if(love.keyboard.isDown("up")) then
			dir=RpgRole.RIGHTUP
		elseif(love.keyboard.isDown("down")) then
			dir=RpgRole.RIGHTDOWN
		else
			dir=RpgRole.RIGHT
		end

	elseif(love.keyboard.isDown("up")) then
		dir=RpgRole.UP
	elseif(love.keyboard.isDown("down")) then
		dir=RpgRole.DOWN
	end


	if (dir == -1) then
		--没有方向键按下,变为站立状态
		if (role_state == ROLESTATE_WALK) then
			role_stand:setXY(role_walk:getX(), role_walk:getY())
			role_stand:play(role_walk:getDirection())
			role_walk:stopAll()
			role_state = ROLESTATE_STAND
		elseif (role_state == ROLESTATE_RUN) then
			role_stand:setXY(role_run:getX(), role_run:getY())
			role_stand:play(role_run:getDirection())
			role_run:stopAll()
			role_state = ROLESTATE_STAND
		else
			role_stand:update(dt)
		end
	--有方向键按下,且为行走状态
	elseif(movemode == MODE_WALK) then
		-- 状态一致
		if (role_state == ROLESTATE_WALK) then
			role_walk:setDirection(dir)
			role_walk:move(50, dt)
			role_walk:update(dt)
		--跑步状态变为行走,先停止跑步,从行走的第一帧开始播放动画,并设置行走状态
		elseif (role_state == ROLESTATE_RUN) then
			role_walk:setXY(role_run:getX(), role_run:getY())
			role_walk:play(dir)
			role_run:stopAll()
			role_state = ROLESTATE_WALK
		else
			role_walk:setXY(role_stand:getX(), role_stand:getY())
			role_walk:play(dir)
			role_stand:stopAll()
			role_state = ROLESTATE_WALK
		end
	--有方向键按下,且为跑步状态
	else
		-- 状态一致
		if (role_state == ROLESTATE_WALK) then
			role_run:setXY(role_walk:getX(), role_walk:getY())
			role_run:play(dir)
			role_walk:stopAll()
			role_state = ROLESTATE_RUN
		elseif (role_state == ROLESTATE_RUN) then
			role_run:setDirection(dir)
			role_run:move(90, dt)
			role_run:update(dt)
		else
			role_run:setXY(role_stand:getX(), role_stand:getY())
			role_run:play(dir)
			role_stand:stopAll()
			role_state = ROLESTATE_RUN
		end
	end

 end

function love.draw()
	love.graphics.print("1--walk,2--run",10,25)
	if (role_state == ROLESTATE_STAND) then
		role_stand:render()
	elseif (role_state == ROLESTATE_WALK) then
		role_walk:render()
	else
		role_run:render()
	end
end
