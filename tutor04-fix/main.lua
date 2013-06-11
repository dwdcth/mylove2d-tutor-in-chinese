data = { 
2, 2, 2, 2, 2, 2, 2, 1, 1, 1,
2, 2, 1, 1, 1, 1, 1, 1, 1, 1,
 2, 2, 1, 1, 1, 1, 1, 1, 1, 1, 
 2, 2, 1, 1, 1, 1, 1, 1, 1, 1, 
 2, 2, 1, 1, 1, 1, 1, 1, 1, 1, 
 2, 1, 1, 1, 1, 1, 1, 1, 1, 1, 
 2, 1, 1, 1, 1, 1, 1, 1, 1, 1, 
 2, 2, 1, 1, 1, 1, 1, 1, 1, 1, 
 1, 2, 1, 1, 1, 1, 1, 1, 1, 1, 
 1, 1, 1, 1, 1, 1, 1, 1, 1, 1 }
 
quadtable={}
function makeQuad(data)
	local quad
	for i=1,10 do  --列
		for j=10,1,-1 do  --行
			if data[10*(j-1)+i]==1 then
				quad=love.graphics.newQuad( 0, 0, 42, 21, 42, 42 )
			else
				quad=love.graphics.newQuad( 0, 21, 42, 21, 42, 42 )
			end
			table.insert(quadtable,quad)
		end
	end
	
end

function drawMap(quads,x,y)
	local w,h=42,21 --图块的宽和高
	local m=10 --行数
	
	for i=1,10 do --行
		for j=1,10 do  --列
			love.graphics.drawq(image,quads[m*(i-1)+j],x+w/2*(i-1)+w/2*(j-1),y+h/2*(i-1)-h/2*(j-1))
		end
	end
end
function love.load()
	makeQuad(data)
	image=love.graphics.newImage("assets/45.png")
end
function love.draw()

	drawMap(quadtable,200,200)
	
end
