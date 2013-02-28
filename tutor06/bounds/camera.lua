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

--设置摄相机的x偏移,如果value在左右边界之间,那么设置
--摄相机的x偏移为value;若value小于左边界设置x偏移为左边界;
--若value大于右边界,设置x偏移为右边界
function camera:setX(value)
   if self._bounds then
    self._x = math.clamp(value, self._bounds.x1, self._bounds.x2)
  else
    self._x = value
  end
end
--设置摄相机的y偏移
function camera:setY(value)
     if self._bounds then
    self._y = math.clamp(value, self._bounds.y1, self._bounds.y2)
  else
    self._y = value
  end
end

function camera:setOffset(x, y)
  if x then self:setX(x) end
  if y then self:setY(y) end
end

--左上角,右下角的坐标
function camera:setBounds(x1, y1, x2, y2)
  self._bounds = { x1 = x1, y1 = y1, x2 = x2, y2 = y2 }
end

function camera:getBounds()
  return unpack(self._bounds)
end

--把x,y固定到 min , max之间 画个坐标轴就明白了
function math.clamp(x, min, max)
  return x < min and min or (x > max and max or x)
end

--[[ 上面的代码等价与下面的
function math.clamp(x, min, max)
    if x < min then
        return min
    elseif x > max then
        return max
    else
        return x
    end
end
]]
