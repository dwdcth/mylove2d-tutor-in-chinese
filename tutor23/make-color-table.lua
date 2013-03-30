local f = assert(io.open(arg[1], "rb"))
local block = 3
local num
while true do
	--每次读取3个字节
    local bytes = f:read(block)
	
    if not bytes then break end
	
	io.write("{")
    for b in string.gfind(bytes, ".") do
		num=tonumber(string.byte(b)) --把每个字节转化为number*4
      io.write(tostring(num)..",")
	end
	io.write("},")
	
end
f:close()