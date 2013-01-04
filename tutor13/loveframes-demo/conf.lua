function love.conf(t)

	t.title 	= "Love Frames Demo"
	t.author 	= "Nikolai Resokav"
	t.version 	= "0.8.0"
	
	t.console 			= true	 
	t.modules.joystick 	= false    
    t.modules.audio 	= true      
    t.modules.keyboard 	= true   
    t.modules.event 	= true      
    t.modules.image 	= true      
    t.modules.graphics 	= true   
    t.modules.timer 	= true      
    t.modules.mouse 	= true      
    t.modules.sound 	= true      
    t.modules.physics 	= false
    t.screen.fullscreen = false 
    t.screen.vsync 		= false
    
    t.screen.fsaa 		= 0           
    t.screen.height 	= 600       
    t.screen.width 		= 800   
	
end