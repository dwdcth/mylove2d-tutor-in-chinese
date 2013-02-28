local mousePos={}
qx,qy=100,100
playSound=false
function drawQuad(x,y,width,height)
    love.graphics.setColor(0, 255, 0)
    love.graphics.quad("fill",x,y,x+width,y,x+width,y+height,x,y+height)
end

function drawMouseTrack()
	love.graphics.setPointSize( 3 )
	local x, y = love.mouse.getPosition( )
	table.insert(mousePos,x)
	table.insert(mousePos,y)
	love.graphics.setColor(255,0,0)
	--取出mousePos table里的元素,下面即c语言的for(int i=1,i<mousePos.legth;i+=2)
	for i=1,#mousePos,2 do
	love.graphics.point(mousePos[i],mousePos[i+1])
	end
end
