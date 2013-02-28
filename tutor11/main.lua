function love.load()
    --为了方便书写
	gr, li, lf	= love.graphics, love.image, love.filesystem

	image			= gr.newImage('Love.jpg')
	width, height	= gr.getWidth(), gr.getHeight()
	effect = gr.newPixelEffect [[
		extern vec4 Cmin;
		extern vec4 Cmax;
		vec4 effect(vec4 color,Image tex,vec2 tc,vec2 pc)
		{	vec4 pixel = Texel(tex,tc);
			//vec4的四个分量分别是r,g,b,a
			//下面把图片在cmax和cmin之间的像素的alpha分量设为0,即透明
			if ((pixel.r<=Cmax.r && pixel.r>=Cmin.r) &&
				(pixel.g<=Cmax.g && pixel.g>=Cmin.g) &&
				(pixel.b<=Cmax.b && pixel.b>=Cmin.b))
			{pixel.a        = 0;}
			return pixel;
		}
		]]

	--需要移除的像素范围,这与具体的图片相关,如此图,背景为蓝色,主体为粉红,
	--除了红色分量处的alpha不变,其他分量处的alpha都设为0
	remove_range = {
		r = { 0, 125 },
		g = { 0, 255 },
		b = { 0, 255 }
		}
	--opengl的颜色范围0.0--1.0,值越小表明此分量占的比例越小
	remove_min = {remove_range.r[1]/255,remove_range.g[1]/255,remove_range.b[1]/255,1}
	remove_max = {remove_range.r[2]/255,remove_range.g[2]/255,remove_range.b[2]/255,1}
	effect:send('Cmin',remove_min) --向cmin传值
	effect:send('Cmax',remove_max)
	remove = false --透明变换开关

	-- 颜色变换效果
	effect2= love.graphics.newPixelEffect [[
        extern number time;
        vec4 effect(vec4 color, Image texture, vec2 texture_coords, vec2 pixel_coords)
        {
		//这些函数为了保证值在0.0--1.0之间,三角函数取值为-1.0--1.0
            return vec4((1.0+sin(time))/2.0, abs(cos(time)), abs(sin(time)), 1.0);
        }

    ]]
	change=false --颜色变换开关
end

function love.draw()
    --由于love是按先后顺序绘图,如果图片不透明,此据会被挡住
	gr.print('you can not see this ,before the img transparented',10,40)
	if remove then
		gr.setPixelEffect( effect )
		gr.draw( image )
		gr.setPixelEffect() --还原默认的效果
		else
		gr.draw( image )
	end
	if change then
		gr.setPixelEffect(effect2)
		gr.rectangle('fill', 10,305,790,285)
		gr.setPixelEffect()

	end

	gr.print( 'Press <r> to change background to transparent.', 10, 10)
	gr.print( 'Press <c> to see the beautiful color.', 10, 25)

end

local t=0
function love.update(dt)
	 t = t + dt
    effect2:send("time", t)

end

function love.keypressed(key)
	if key == 'escape'	then love.event.push( 'quit' )	end
	if key=="c" then change = not change end
	if key == 'r'		then remove = not remove end
end

