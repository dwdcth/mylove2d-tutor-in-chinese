
--计算一个长为width的矩阵中第num个数所在的x列，y行
function calcXY(num,width)
	local x=num%width
	local y=num/width
	if(x~=0) then
	y=math.ceil(y)
	else
	--如果可以整除,就是最后一个
	x=width

	end
	return x,y
end
--从大图生成quad表
function makeQuad(map)
	--大图的高和宽
	local imageheight=map["tilesets"][1].imageheight
	local imagewidth=map["tilesets"][1].imagewidth
	--大图水平和竖直方向图块的数目
	local numx=tonumber(map["properties"]["numx"])
	local numy=tonumber(map["properties"]["numy"])
	--水平及竖直间距
	local spacing= map["tilesets"][1].spacing
	local margin=map["tilesets"][1].margin
	--图块的宽和高
	local blockx=tonumber(map["properties"]["blockx"])
	local blocky=tonumber(map["properties"]["blocky"])
	--水平及竖直方向图块的个数
	local width=map["layers"][1].width
	local height=map["layers"][1].height
	--图块排列表
	local array=map["layers"][1].data

	--统计不同的图块数目
	local j=1
	for i=1,#array do
		if(array[i]~=array[i-1]) then
		local x,y=calcXY(array[i],numx)
		--创建一个quad图像参数     需要显示的小图的左顶点在大图中的x,y坐标,每个小图的宽、高,大图的宽、高
		quadtable[j]=love.graphics.newQuad((x-1)*blockx+x*spacing,(y-1)*blocky+y*margin,blockx,blocky,imagewidth,imageheight)
		j=j+1
		end
	end
end

--画地图
function drawMap(map,image)
	--图块排列表
	local array=map["layers"][1].data
	--水平方向图块的个数
	local width=map["layers"][1].width
	--图块的宽和高
	local blockx=tonumber(map["properties"]["blockx"])
	local blocky=tonumber(map["properties"]["blocky"])

	local j=0
	for i=1,#array do
		local x,y=calcXY(i,width)
		if(array[i]~=array[i-1]) then
			j=j+1
		end
		love.graphics.drawq(image,quadtable[j],mapX+(x-1)*blockx,mapY+(y-1)*blocky)
	end

end
