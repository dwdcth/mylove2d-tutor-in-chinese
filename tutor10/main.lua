local function par()
  -- created from particle8.psi

  local img=love.graphics.newImage("par.png")
  local ps = love.graphics.newParticleSystem( img, 100 )

  ps:setEmissionRate( 13 )
  ps:setLifetime( -1 ) -- forever
  ps:setParticleLife( 0.436508, 0.992063 )
  ps:setDirection( -1.5708 )
  ps:setSpread( 6.28319 )
  -- ps:setRelative( false )
  ps:setSpeed( 9.5238, 9.5238 )
  ps:setGravity( 0, 0 )
  ps:setRadialAcceleration( -0.634921, -0.634921 )
  ps:setTangentialAcceleration( 0, 0 )
  ps:setSizes( 1.3817, 2.04464 ) -- there's a bug in 0.7.1 that forces us to set the size variation using its own function
  ps:setSizeVariation( 0.428571 )
  ps:setSpin( 0, 0, 0 )
  ps:setColors( 46, 145, 255, 46, 248, 139, 44, 72 )
  -- ps:setColorVariation( 0.206349 )
  -- ps:setAlphaVariation( 0 )

  return ps
end

function love.load()
	 ps=par()
end

function love.draw()
	love.graphics.draw(ps,400,300)
end

function love.update(dt)
	ps:update(dt)
end
