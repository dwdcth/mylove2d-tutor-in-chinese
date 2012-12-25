local anim = {}
anim.__index = anim
--[[
tex
    存有动画帧的纹理句柄。
nframes
    动画帧数
FPS
    动画回放速度，以帧每秒为单位。
x,y即小图在大图中的坐标
x
    动画第一帧在纹理中的X坐标，以纹理坐标为单位。
y
    动画第一帧在纹理中Y坐标，以纹理坐标为单位。
w
    动画帧的宽度。
h
    动画帧的高度。
]]
--[[
Play 	开始播放动画
Stop 	停止播放动画
Resume 	（从暂停等状态）恢复动画。
Update 	更新动画
IsPlaying 	检测动画是否正在播放。

SetMode 	设置回放模式。
SetSpeed 	设置回放速度。
SetFrame 	设置当前动画的帧。
SetFrames 	设置所有的动画帧。

GetMode 	获得当前的回放模式。
GetSpeed 	获得当前的回放速度。
GetFrame 	获得当前的动画帧。
GetFrames 	获得所有的动画帧。
]]
function newAnimation( tex,nframes,FPS,x,y,w,h )
	local  a = {}
	a.img=tex
	a.fps=FPS
	a.w=w
	a.h=h
	a.posx=0
	a.posy=0
	local imgw = tex:getWidth()
	local imgh = tex:getHeight()
	--nframes=nframes or (imgw*imgh/w/h)
	a.nframes=nframes
	--quad tu kuai
	a.Frame={}
	--在整个动画中的帧位置
	a.posf=1
	a.stopFlag=false
	a.resumFlag=false
	a.stopPos=1
	a.timer=0 --计时器
	a.mode="11"
	a.debug=false
	for i=1,nframes do
		table.insert(a.Frame,love.graphics.newQuad(x+(i-1)*w,
		y,w,h,imgw,imgh))
	end

	return setmetatable(a, anim)
end

function anim:Play()
	if(self.debug==true) then
		love.graphics.print("posf  " .. self.posf,10,10)
	end
	if(self.stopFlag==true) then
		love.graphics.drawq(self.img,self.Frame[self.stopPos],self.posx,self.posy)
	else

		love.graphics.drawq(self.img,self.Frame[self.posf],self.posx,self.posy)

	end
end
function anim:Stop()
	if(self.stopFlag==false) then
		self.stopPos=self.posf
		self.stopFlag=true
	end
end
function anim:Resume()
	if(self.stopFlag==true) then
		self.posf=self.stopPos
		self.stopFlag=false
	end
end

function anim:Update(dt)
	self.timer = self.timer+dt
	if(self.timer*self.fps>1) then
		self.timer=0
		if(self.mode=="11") then
			if(self.posf>self.nframes-1) then
				self.posf=1
			else
			self.posf=self.posf+1
			end
		--逆序播放放不循环
		elseif(self.mode=="00") then
			if(self.posf<1) then
				self.posf=1
			else
				self.posf=self.posf-1
			end

		--逆序播放循环
		elseif(self.mode=="01") then
			if(self.posf<1) then
				self.posf=self.nframes
			else
				self.posf=self.posf-1
			end
		--正序播放循环
		else
			if(self.posf>self.nframes) then
				self.posf=nframes
			else
				self.posf=self.posf-1
			end
		end
	end
end

function anim:IsPlaying()
	if(self.stopFlag==true) then
		return true
	end
end

function anim:setMode(mode)
	self.mode=mode
	if(mode=="00" or mode =="01") then
		self.posf=self.nframes
	end
end

function anim:setSpeed(fps)
	self.fps=fps
end

function anim:setPos(x,y)
	self.posx=x
	self.posy=y
end

--设置要显示的帧,要继续显示使用Resume()
function anim:SetFrame(n)
	self.stopPos=n
	self.stopFlag=true
end
--设置播放的总帧数
function anim:SetFrames(n)
	sefl.nframes=n
end
function anim:GetMode ()
	return self.mode
end

function anim:GetSpeed()
	return self.speed
end
function anim:GetFrame()
	return self.posf
end
function anim:GetFrames()
	return self.nframes
end
