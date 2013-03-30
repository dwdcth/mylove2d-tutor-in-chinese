require('grp')
--创建一个grp
hdgrp=grp:new()
function love.load()
	image=hdgrp:getImg(1,"hdgrp") --读取第一张图片
end

function love.draw()
	love.graphics.draw(image,100,100)
end

