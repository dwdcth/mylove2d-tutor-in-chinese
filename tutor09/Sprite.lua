require('middleclass')
--精灵类,只是对quad的一个包装


--这里的lg为了简化书写
local lg=love.graphics
Sprite=class('Sprite')
--tex是love2d里的Image类型;x,y图块在大图里左顶点的坐标;w,h图块的宽和高
function Sprite:initialize(tex,x,y,w,h)
	self.quad=lg.newQuad(x,y,w,h,
		tex:getWidth(),tex:getHeight())
	--图块的中心坐标
	self.ox=w/2
	self.oy=h/2
	self.tex=tex
end
--屏幕x,y坐标,r旋转角度,sx,sy缩放,ox,oy中心,kx,ky剪切系数,不是很明白
function Sprite:render(x,y, r, sx, sy, ox, oy, kx, ky)
	--px,py屏幕上的坐标
	self.px=x
	self.py=y
	--参数的默认值
	self.r=r or 0
	self.sx=sx or 1
	self.sy=sy or 1
	self.ox=ox or (self.ox)
	self.oy=oy or (self.oy)

	lg.drawq(self.tex,self.quad,self.px,self.py,self.r,
					self.sx,self.sy,self.ox,self.oy,self.kx,self.ky)
end

--这个设置颜色只能设置屏幕的颜色,不能设置顶点颜色,以后再实现
function Sprite:setColor(r, g, b, a)
	self.colorFlag=true
	--上次的颜色
	self.lr,self.lg,self.lb,self.la=lg.getColor()
	self.r,self.g,self.b,self.a=r,g,b,a
	print(self.r)
	lg.setColor(r,g,b,a)
end
--设置精灵的中心
function Sprite:setHotSpot(ox,oy)
	self.ox=ox or 0
	self.oy=oy or 0
end

function Sprite:getHotSpot()
	return self.ox,self.oy
end
