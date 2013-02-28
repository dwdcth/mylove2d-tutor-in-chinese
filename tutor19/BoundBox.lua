require('loveframes.third-party.middleclass')
require('loveframes')
require('boundrect')
require('font')

BoundBox=class('BoundBox')

--道具的行数,列数，宽，高，道具图片表
function BoundBox:initialize(rows,cols,resw,resh,imgs)
	--选择框的宽度
	self.bw=2
	--背包边框的位置
	self.fx,self.fy=20,25 
	--背包边框宽，高
	self.fw,self.fh=602,327
	--提示框的内容
	self.tip="这里显示道具信息"
	self.tipx,self.tipy=self.fx,self.fy+self.fh+5
	self.tipw,self.tiph=396,66
	--背包
	self.bag = loveframes.Create("frame")
	self.bag:SetName("背包")
	self.bag:SetSize(fw, fh)
	self.bag:SetPos(fx,fy)

	--道具框，由panel和text组成
	self.resPanel=loveframes.Create("panel")
	self.resPanel:SetPos(self.tipx,self.tipy+40)
	self.resPanel:SetSize(self.tipw,self.tiph)		
	self.resText = loveframes.Create("text",self.resPanel)
	self.resText:SetText("")
	self.resText.Update = function(object2, dt)
		object2:SetY(5)
		end

		
	self.rows,self.cols=rows,cols --道具行数，列数
	self.resw,self.resh=resw,resh --道具的宽和高
	
	--装备表
	self.equips={}
	for row=1,rows do
		for col=1,cols do
			local imgbtn=loveframes.Create("imagebutton",self.bag)		
			imgbtn:SetText("")
			imgbtn:SetImage(imgs[cols*(row-1)+col])
			imgbtn:SetSize(self.resw,self.resh)
			imgbtn:SetClickable(false)		
			imgbtn:SetPos(self.bw*col+self.resw*(col-1),self.fy+self.bw*row+self.resh*(row-1))
			imgbtn.OnClick=function() self.resText:SetText("你选择了第" .. self.cols*(row-1)+col .."个道具") end
			self.equips[cols*(row-1)+col]=imgbtn
		end
	end
	
	
	
	--包围矩形即选择框,是背包的子控件
	self.br=loveframes.Create("boundrect",self.bag)
	
		--25是frame的标题栏的宽度
	self.br:SetBounds(self.fx,self.fy+25,self.fw+self.fx,self.fh+self.fy+25)
	self.br:SetPos(0,25)
	--设置选择框每次移动的x，y距离
	self.br:SetDelta(self.resw+self.bw,self.resh+self.bw)
	--设置选择框的大小
	self.br:SetSize(self.resw,self.resh)
	
	self.br:SetRowCol(self.rows,self.cols)
	--道具表
	self.br.resTable=self.equips
	--道具的提示信息，在提示框里显示
	self.br.tipText=self.resText
	--enter键按下的回调函数
	self.br.OnEnter=function()  
		--print((self.br.row-1)*self.br.cols+self.br.col)
		self.equips[(self.br.row-1)*self.br.cols+self.br.col]:OnClick()
		--print("enter") 
		end
	--手动设置道具1的信息
	self.br:SetFirstTip("道具1")

end



function BoundBox:update(dt)
	loveframes.update(dt)
end
				
function BoundBox:draw()	
	loveframes.draw()
end

function BoundBox:mousereleased(x, y, button)
	loveframes.mousereleased(x, y, button)
end
function BoundBox:keypressed(key, unicode)
	loveframes.keypressed(key, unicode)
end

