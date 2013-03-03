require 'middleclass'
--声明一个类,也可用class('Person', Object) 或Object:subclass('Person') middleclass的根类是Object
Person = class('Person')

--构造函数
function Person:initialize(name)
	self.name = name
end
function Person:speak()
	print('Hi, I am ' .. self.name ..'.')
end

--继承或Person:subclass('AgedPerson')
AgedPerson = class('AgedPerson', Person)
--类变量
AgedPerson.static.ADULT_AGE = 18

--注意在子类里要调用父类里的构造函数
function AgedPerson:initialize(name, age)
	Person.initialize(self, name) --注意在子类里要调用父类里的构造函数
	self.age = age
end

--覆盖子类里的方法,感觉确实像从c++里的虚函数
function AgedPerson:speak()
	Person.speak(self)
	--可以实例里直接访问类变量
	if(self.age < AgedPerson.ADULT_AGE) then
		print('I am a child.')
		else
		print('I am an adult.')
	end
end

--等价于AgedPerson('Billy the Kid', 13),new()隐含调用
local p1 = AgedPerson:new('Billy', 13)
local p2 = AgedPerson:new('Luke', 21)

p1:speak()
print("----------------")
p2:speak()
