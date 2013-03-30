--todo getallvalue要改
--装备类
equip={}
function equip:new(o)
	o =o or {}
	setmetatable(o,self)
    self.__index = self
    return o
end
--创建装备 图片love的图片类型、名字、简介，其它属性
function equip:Create(name,text,img,...)
	
	
	self.name=name or ""
	self.text=text or ""
	self.img=img or ""
	
	
	if arg then
		for i=1,#arg do
			for k,v in pairs(arg[i]) do
				self[k] = v
			end
		end
	end

end
--设置属性attri的值value
function equip:SetValue(attri,value)
	self[attri]=value

end
function equip:SetName(name)

	self.name=name
end
function equip:SetText(text)
	self.text=text
end
--返回属性描述
function equip:GetText()
	return self.text
end
--返回所有属性值 类型字符串 用来放在描述面板
function equip:GetAllValue()
	local attri=""
	attri=attri.. self.name ..":" .. self.text
	--equip里的干扰字符串
	local tmp="__indeximgnametextnewCreateSetValueSetNameSetTextGetTextGetAllValueGetValue"
	for k,v in pairs(self) do
	   if string.find(tmp,k) then 
		--	这里跳过函数名，否则会出现其它字符串
	   else
	   attri=attri .." "..k ..":" ..tostring(v)
	   end 
    end
	
	
	return attri
end
-- 通过属性名称，返回属性值
function equip:GetValue(attri)
   for k,v in pairs(self) do
	   if k==attri then
		 return v
	   end
   end

end