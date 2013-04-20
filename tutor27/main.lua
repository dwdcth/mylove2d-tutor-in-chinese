require('font')
require('menu')
function love.load()
 love.graphics.setFont(menufont)
 jyMenu=menu:new()
 jyMenu:SetImage("assets/title.png")
 jyMenu:SetMusic("assets/game17.ogg")
 jyMenu:AddMenu("重新开始")
 jyMenu:AddMenu("载入进度")
 jyMenu:SubMenu("进度1",2) --第二项主菜单的子菜单
 jyMenu:SubMenu("进度2",2)
 jyMenu:SubMenu("进度3",2)
 jyMenu:AddMenu("游戏设置")
 jyMenu:AddMenu("退出游戏",function () love.event.push("quit") end)

end 
function love.draw()
    jyMenu:draw()
    
end

function love.keypressed(key,unicode)
  jyMenu:keypressed(key,unicode)

end