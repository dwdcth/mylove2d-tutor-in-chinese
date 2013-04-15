
--字符串转table,支持中英文混排
--会在当前目录下生成talk.lua
function zhstr(str,tname)
	local f = io.open("talk.lua", "a")
	local len=#str

	f:write(tname,"={")
	local i=1
	while(i<len) do
		if string.byte(str,i,i)>127 then
			f:write("\"",string.sub(str,i,i+1),"\",")

			i=i+2

		else
			f:write("\"",string.sub(str,i,i),"\",")
			i=i+1

		end
	end

	f:write("}")
	f:write("\n")
	f:close()
end

zhstr("半山hello无极","talk1")
