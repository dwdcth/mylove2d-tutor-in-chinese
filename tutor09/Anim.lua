require('middleclass')
require('Sprite')
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
--Anim为Sprite的子类
Anim=class('Anim',Sprite)
--播放模式常量
Anim.static.ANIM_FWD="10" -- 正序播放不循环
Anim.static.ANIM_FWDL="11" --正序播放循环
Anim.static.ANIM_REV="00" --逆序播放不循环
Anim.static.ANIM_REVL="01"-- 逆序播放循环

function Anim:initialize(tex,nframes,FPS,x,y,w,h)
	Sprite.initialize(self,tex,x,y,w,h)
	self.fps=FPS
	local imgw = tex:getWidth()
	local imgh = tex:getHeight()
	--nframes=nframes or (imgw*imgh/w/h)
	self.nframes=nframes
	--帧集合
	self.frmTable={}
	--在整个动画中的帧位置
	self.posf=1
	self.stopFlag=false
	self.resumFlag=false
	self.stopPos=1
	self.timer=0 --计时器
	self.mode="11"
	self.debug=false
	for i=1,nframes do
		table.insert(self.frmTable,love.graphics.newQuad(x+(i-1)*w,
		y,w,h,imgw,imgh))
	end
end

function Anim:render(x,y,r,sx,sy, ox, oy, kx, ky)
	--参数默认值
	self.sx=sx or 1
	self.sy=sy  or 1
	self.r=r or 0
	self.ox=ox or self.ox
	self.oy=oy or self.oy
	self.px=x
	self.py=y
	if(self.debug==true) then
		love.graphics.print("posf  " .. self.posf,10,10)
	end
	if(self.stopFlag==true) then
		love.graphics.drawq(self.tex,self.frmTable[self.stopPos],
										self.px,self.py,self.r,self.sx,self.sy,self.ox,self.oy,kx,ky)
	else
		love.graphics.drawq(self.tex,self.frmTable[self.posf],
		self.px,self.py,self.r,self.sx,self.sy,self.ox,self.oy,kx,ky)
	end
end
--从第一帧开始播放动画
function Anim:play()
	self.stopFlag=false
	self.posf=1
end
function Anim:stop()
	if(self.stopFlag==false) then
		self.stopPos=self.posf
		self.stopFlag=true
	end
end
function Anim:resume()
	if(self.stopFlag==true) then
		self.posf=self.stopPos
		self.stopFlag=false
	end
end

function Anim:update(dt)
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

function Anim:isPlaying()
	if(self.stopFlag==true) then
		return true
	end
end

function Anim:setMode(mode)
	self.mode=mode
	if(mode=="00" or mode =="01") then
		self.posf=self.nframes
	end
end

function Anim:setSpeed(fps)
	self.fps=fps
end

--设置要显示的帧,要继续显示使用Resume()
function Anim:getFrame(n)
	self.stopPos=n
	self.stopFlag=true
end
--设置播放的总帧数
function Anim:getFrames(n)
	self.nframes=n
end
function Anim:getMode ()
	return self.mode
end

function Anim:getSpeed()
	return self.speed
end
function Anim:getFrame()
	return self.posf
end
function Anim:getFrames()
	return self.nframes
end
