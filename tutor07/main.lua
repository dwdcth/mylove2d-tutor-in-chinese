local zorder={}
--z的取值越小越靠近屏幕,默认值0
function setZ(drawabl, z)
	--z的默认值为0
	z=z or 0
	if z<=1 and z>=0 then
			table.insert(zorder,{drawabl,z})
	else
			print("zorder must between 0 and 1")
	end
	table.sort(zorder, function(a,b) return a[2]>b[2] end)

end

function love.load()
	imgs={}
	for i=1,3 do
		table.insert(imgs,love.graphics.newImage("assets/img" .. i .. ".png"))
	end
end

function love.draw()
	--直接绘图,不注意顺序
	love.graphics.draw(imgs[2],400,200)
	love.graphics.draw(imgs[1],400,200)
	love.graphics.draw(imgs[3],400,200)

	setZ(imgs[2],0.2)
	setZ(imgs[1],0.3)
	setZ(imgs[3],0.1)
	for _,v in ipairs(zorder) do
		love.graphics.draw(v[1],200,200)
	end
end
