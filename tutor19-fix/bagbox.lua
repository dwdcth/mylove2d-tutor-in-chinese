--todo 添加记忆位置 setbackimg
require('loveframes')
require('selectbox')
require('equip')

--一个道具包含一个图片，文字提示，位置,是否可见
--道具表={ {img,text,row,col,show}  }

bagbox={
nilImg=love.graphics.newImage('assets/box.png'),
equips={},
imgbtn={},
} 

function bagbox:new(o)
	o = o or {} --如果参数中没有提供table，则创建一个空的。
     --将新对象实例的metatable指向表(类)
     setmetatable(o,self)
     self.__index = self
     --最后返回构造后的对象实例
     return o
end

--背包的宽、高，道具的行数、列数，道具宽、高，相邻行、列的间隔
function bagbox:SetUp(bw,bh,rows,cols,resw,resh,dx,dy)
	print("new")
	--设置默认参数,这样new的时候不写参数值也可以
	
	--行、列数目
	self.rows=rows or 3
	self.cols=cols or 6
	--相邻行、列的间隔
	self.dx=dx or 2
	self.dy=dy or 2
	--背包的位置
	self.bx,self.by=20,20 
	--背包宽，高
	self.bw=bw or 600
	self.bh=bh or 370
	--道具的宽、高
	self.resw= resw or 98
	self.resh=resh or 98
	--道具的总高度
	self.dhs=(self.dy+self.resh)*self.rows
	--提示框的内容
	self.tip="这里显示道具信息"
	--注意提示框在frame里
	self.tipx,self.tipy=2,self.dhs+25+2
	self.tipw,self.tiph=self.bw-4,self.bh-self.dhs-25-4 -- %TODO: add set 	
	print(self.dhs)
	--背包关闭标志，一开始没有背包所以是true  
	self.close=false
	
	--背包名
	self.name="背包"
	
	--是否是第一次创建
	--self.first=true
end
--一次设置所有装备  equips是equip表
function bagbox:SetAllEquip(equips)
	if equips then 
		self.equips=equips
		
	else
	
		local num=self.rows*self.cols
		for i=1,num do
		
			--初始化道具
			self.equips[i]=equip:new()
			self.equips[i]:Create()
			self.equips[i].img=self.nilImg
		end
	end
end

function bagbox:SetPos(x,y)
	self.bx,self.by  =x,y
end
--设置标题
function bagbox:SetName(name)
	self.name=self.name or "背包"
end

--设置光标
function bagbox:SetCursor(img)
	if img then
		if img=="default" then
			self.cursor="default"
		else
			self.cursor=img
		end
	else
		self.cursor=nil
	end
	
end

function bagbox:Create()
	
	
	
	--背包组成  frame,imagebutton,selectbox,panel+text
	--创建背包
	
		self.bag = loveframes.Create("frame")
		local bag=self.bag --简化书写
		-- $TODO: ok
		
		bag.OnClose=function() self.close=true end
			 
		bag:SetName(self.name)
		bag:SetPos(self.bx,self.by)
		bag:SetSize(self.bw,self.bh)
		--先暂时不处理道具个数过多的情况
		
		local num=self.rows*self.cols
		
		for i=1,num do
			
			self.imgbtn[i]=loveframes.Create("imagebutton",self.bag)
			self.imgbtn[i]:SetImage(self.equips[i].img)
			self.imgbtn[i]:SetPos((math.ceil((i-1)%6))*(self.resw+self.dx),(math.ceil(i/6)-1)*(self.resh+self.dy)+25)
			
			self.imgbtn[i]:SetText("")
		end
		
		
		
		self.selectBox=loveframes.Create("selectbox",bag)
		self.selectBox:SetCursor(self.cursor)
		local myselect=self.selectBox
		myselect:SetPos(0,25) -- $TODO: add memory feature
		--设置选择框的边界，这里在frame里，故如此 
		myselect:SetBound(0,25,self.bw,self.dhs)
		myselect.OnEnter=function()  print(myselect:GetId()) end
		myselect:SetKey("s")
		myselect:SetRowCol(3,6,98,98)
		self.resPanel=loveframes.Create("panel", bag)
		local respanel = self.resPanel
		respanel:SetPos(self.tipx, self.tipy)
		respanel:SetSize(self.tipw,self.tiph)
		
		self.tipText=loveframes.Create("text",respanel)
		local text1 = self.tipText
		
		text1:SetText(self.tip)
	
	
	--交换装备

	self.selectBox.ReturnSwap=function(obj)
		local tmp=equip:new()
		tmp=self.equips[obj.oldId]
		self.equips[obj.oldId]=self.equips[obj.newId]
		self.equips[obj.newId]=tmp
		--没有下面这句图片不更新
		self.imgbtn[obj.oldId]:SetImage(self.equips[obj.oldId].img)
		self.imgbtn[obj.newId]:SetImage(self.equips[obj.newId].img)

	end
	
end
--添加道具   索引，装备
function bagbox:AddItem(index,equip)
	if equip then
		self.equips[index]=equip
		self.imgbtn[index]:SetImage(equip.img)
	else
		print("no img")
	end
end
--移除道具
function bagbox:DelItem(index)
	local tmp=equip:new()
	tmp:Create("","",self.nilImg)
	self.equips[index]=tmp
	self.imgbtn[index]:SetImage(self.nilImg)
	
end

function bagbox:Close()
	self.bag:Remove()
	
end

function bagbox:draw()
	
	loveframes.draw()
end




function bagbox:update(dt)
	
	
	--更新提示
	local id=self.selectBox:GetId()
	local tmptip=self.equips[id]:GetAllValue()
	self.tip=tmptip
	self.tipText:SetText(self.tip)
	loveframes.update(dt)
end

function bagbox:keypressed(key, unicode)
	if key=="q" then
		
			if  self.close then
				self:Create()
				self.close=false
			else
			
			self:Close()
			self.close=true
				
			end
		
		
	end
	
end

