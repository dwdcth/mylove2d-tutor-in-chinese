misc={}
--字符串分割,返回一个字符串表
function misc.split (s, delim)
  assert (type (delim) == "string" and string.len (delim) > 0,
          "bad delimiter")
  local start = 1
  local t = {}  -- results table
  -- find each instance of a string followed by the delimiter
  while true do
    local pos = string.find (s, delim, start, true) -- plain find
    if not pos then
      break
    end
    table.insert (t, string.sub (s, start, pos - 1))
    start = pos + string.len (delim)
  end -- while
  -- insert final one (after last delimiter)
  table.insert (t, string.sub (s, start))
  return t
end
--中英混合截取
function misc.zhsub(str,i,n)
    
	n=n or #str
	local p=i
	local tmp=""
    while p<=n do
	        if string.byte(str,p)>127 then
		 if p>#str-2 then break end
           tmp=tmp.. string.sub(str,p,p+2)
			p=p+2
          
        else
		
          tmp=tmp..  string.sub(str,p,p)
            p=p+1
           
        end
    
	end
	   return tmp
	end
function misc.str2tb(str)
    
	local n=#str
	local p=1
	local tmp={}
    while p<=n do
	        if string.byte(str,p)>127 then
		 if p>#str-1 then break end
           tmp[#tmp+1]=string.sub(str,p,p+2)
			p=p+3
          
        else
		
          tmp[#tmp+1]=string.sub(str,p,p)
            p=p+1
           
        end
    
	end
	   return tmp
	end
--滚动文字 t字符串表,rate出现时间间隔,闭包
function misc.rollText(t,rate,dt)
 
  local count=0
  local i=1
  local str=""
  local isEnd=false
   local function text()
    count=count+dt --love.timer.getDelta()
    if count>rate then
        count=0
        if i<=#t then
            str=str.. t[i]
            i=i+1
		else
			--isEnd=true
        end
    end
   
    return str--,isEnd
  end
  return text
    
end
