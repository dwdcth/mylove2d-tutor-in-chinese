require "babel"

lang_zh=true  -- 显示中文为真,否则假
function love.load()

 --初始化babel
 babel.init({
        locale = "zh-CN",--这里的对应语言文件名，不要".lua"后缀
        locales_folders = {
         "lang" --设置语言文件的存放的位置
        }
    })
    	--设置字体，显示中文还是需要字体的,
        --这里没放字体，请到网上找YaHeiConsolas字体，或使用其它支持中文的字体
    cnfont=love.graphics.newFont("YaHeiConsolas.ttf",18)
    love.graphics.setFont(cnfont)
end

function love.update(dt)

end

function love.draw()
    --“_()”实际是babel.translate函数的别名
    love.graphics.print( _( "Hello world" ), 10, 10 ) --这句会把源字符串翻译为local对应的字符串
    love.graphics.print( _( "My name is %name%", { name = "半山" } ), 10, 30 )

end

function love.keypressed(key, unicode)
    --动态语言切换
    if key=="c" then
         lang_zh= not lang_zh
    end
    if  not lang_zh then
        babel.switchLocale("en-US")
    else
        babel.switchLocale("zh-CN")
    end
end
