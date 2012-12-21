camera = {}
--平移变换的x,y偏移
camera._x = 0
camera._y = 0
--缩放变换的x,y系数
camera.scaleX = 1
camera.scaleY = 1
--旋转变换的角度
camera.rotation = 0

--保存变换前的坐标系统,并进行平移,缩放,旋转变换
function camera:set()
  love.graphics.push()
  love.graphics.rotate(-self.rotation)
  love.graphics.scale(1 / self.scaleX, 1 / self.scaleY)
  love.graphics.translate(-self._x, -self._y)
end
--恢复保存的坐标系统
function camera:unset()
  love.graphics.pop()
end



function camera:rotate(dr)
  self.rotation = self.rotation + dr
end

function camera:scale(sx, sy)
  sx = sx or 1
  self.scaleX = self.scaleX * sx
  self.scaleY = self.scaleY * (sy or sx)
end

--设置摄相机的x偏移
function camera:setX(value)
  self._x = value
end
--设置摄相机的y偏移
function camera:setY(value)
    self._y = value
end

function camera:setOffset(x, y)
  if x then self:setX(x) end
  if y then self:setY(y) end
end

