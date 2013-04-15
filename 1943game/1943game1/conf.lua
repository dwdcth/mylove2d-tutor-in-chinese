-- 屏幕缩放
scale = 4
function love.conf(t)
  t.title = "1942 Game Boy"
  t.screen.width = 160*scale
  t.screen.height = 144*scale
end
