local bit=require('BinDecHex')
require('mmapcol')
grp={idx={},filename="",imgs={}}
function grp:new(o)
	o = o or {} --如果参数中没有提供table，则创建一个空的。
     --将新对象实例的metatable指向表(类)
     setmetatable(o,self)
     self.__index = self
     --最后返回构造后的对象实例
     return o
end
--filename文件名不需要后缀，从idx文件创建idx表
function grp:createIdx(filename)
	local file=assert(io.open(filename..".idx","rb"))
	local current = file:seek()  --保存当前文件首地址
    local size = file:seek("end")   -- 得到文件长度
    file:seek("set", current)       -- 恢复
	
	
	table.insert(self.idx,0) --第一个图像的地址实际是0
	local block=4 --设置文件偏移
	local num=size/block --一共多少个图像
	local tmp="" --存放临时4字节数据
	local data="" --存放tmp逆序后的数据
	
	for i=1,num do
		local bytes=file:read(block)
		--把每个byte都转完16进制数
		for b in string.gfind(bytes,".") do
			tmp=tmp ..string.format("%02x", string.byte(b))
		end
		
		--大端转小端
		data= string.sub(tmp,7,8) ..string.sub(tmp,5,6)..string.sub(tmp,3,4)..	string.sub(tmp,1,2) 
		--16进制数转10进制数存入self.idx
		table.insert(self.idx,bit.H2D(data))
		tmp="" --清空
		
		file:seek("set",block*i) --移动文件位置
	
	end
	
	file:close()
end
--从grp文件创建图像 index索引,filename文件名不要后缀
--返回Image类型，图片的偏移ox,oy
function grp:getImg(index,filename)

	local file=assert(io.open(filename..".grp","rb"))
	self:createIdx(filename)
	self.filename=filename
	local addr=self.idx[index] --获取图像地址
	if not addr then
		print("index is bigger")
	end
	local block=self.idx[index+1]-addr --获取图像占用字节数
	--移动文件地址
	file:seek("set",addr)
	local imgInfo=file:read(8) --读取前8个字节的图像信息
	local infostr=""
	for b in string.gfind(imgInfo,".") do
		infostr=infostr..string.format("%02x", string.byte(b))
	end
	local w,h=0,0 --图像的宽和高
	w=bit.H2D(string.sub(infostr,3,4)..string.sub(infostr,1,2))
	h=bit.H2D(string.sub(infostr,7,8)..string.sub(infostr,5,6))
	
	--用infostr="00000000f2ff2d00"测试通过
	local ox,oy=0,0 --图像的偏移
	--这里有的偏移是负数要判断
	if string.find(infostr,"ff",11,12) then
		local hex=string.sub(infostr,11,12)..string.sub(infostr,9,10)
		ox=-(bit.H2D(bit.BNot(hex))+1) --补码原理
	else
		ox=bit.H2D(string.sub(infostr,9,10))
	end
	if string.find(infostr,"ff",15,16) then
	local hex=string.sub(infostr,15,16)..string.sub(infostr,13,14)
		oy=-(bit.H2D(bit.BNot(hex))+1) --补码原理
	else
		oy=bit.H2D(string.sub(infostr,13,14))
	end
	

--先初始化为透明的图片
	imgdata=love.image.newImageData(w,h)
	for y=0,h-1 do
		for x=0,w-1 do --48,112,112,0
		imgdata:setPixel(x,y,0,0,0,0) --todo ,0还是255
		end
	end
	
	--读取索引为index的图像
	local data={}
	file:seek("set",addr)
	local bytes=file:read(block)
	local tmpstr=""
	--读取第一个图片
	for b in string.gfind(bytes,".") do
		table.insert(data,tonumber(string.format("%03d", string.byte(b))))
	end

	file:close()

	local row=0 --保存每行的字节数
	local p=9 --指向data里的数据里的颜色起始点
	local ks=0 --空白点个数
	local solidnum=0 --颜色点个数
	local nilc=0 --保存空白点个数
	local start=0
	for i=0,h do
		row=data[p] --i行的数据个数
		start=p
		p=p+1 --移动到下一点
		if row> 0 then --i行的数据都是颜色点，如果是透明点则为0
			 ks=0
			 while(1) do
				ks=ks+data[p] --当前行空白点的个数
				nilc=ks
				if ks>=w-1 then -- i行宽度到头，结束
				break
				end
			
				p=p+1 --移动到下一点 ，颜色点
				solidnum=data[p]  -- 不透明点个数
			
				p=p+1 --现在指向不透明点的颜色
				for j=0,solidnum-1 do
			
				imgdata:setPixel(j+nilc,i,mmapcol[data[p]][1],mmapcol[data[p]][2],mmapcol[data[p]][3],255)
				--移动到下一点
				ks=ks+1 --颜色点结束，便是透明点
				p=p+1
				end
			
				   if(ks>=w) then
						break -- i行宽度到头，结束
				   end
				   --todo
					if(p-start>=row) then
						break    --i行没有数据，结束
					end
			end
			if p>=#data then
			break
			end
		end
	
	end
	
	return love.graphics.newImage(imgdata),ox,oy	
end