function resources()
end

function love.load()
	variables()
end

function love.update(dt)
	if love.keyboard.isDown("escape") then
		love.event.quit()
	end
	if love.keyboard.isDown("left") then
		player.x = player.x - player.speed * dt
		player.dir = "left"
	elseif love.keyboard.isDown("right") then 
		player.x = player.x + player.speed * dt
		player.dir = "right"
	end
	if love.keyboard.isDown("s") then
		if player.touchesGround == true then
			player.jump = true
		end
	end

	logic(dt)
end

function love.draw()
	love.graphics.scale(screen.scale, screen.scale)
	drawEnts()
end

function variables()
	screen = {}
	screen.scale = 2.5
	screen.w = 800/screen.scale
	screen.h = 600/screen.scale

	player = {}
	player.x = screen.w/2
	player.y = screen.h/2
	player.size = 16
	player.speed = 75
	player.jump = false
	player.jumpCount = 0
	player.jumpSpeed = 70
	player.currentJumpSpeed = player.maxJumpSpeed
	player.touchesGround = true
	player.dir = "neutral"

	walls = {{screen.w/2, screen.h/2+16}, {screen.w/2-16, screen.h/2+16}, {screen.w/2-16, screen.h/2+16}, {screen.w/2+32, screen.h/2+64}, {screen.w/2-32, screen.h/2+16}}
	wallSize = 16
	mushes = {}
end

function drawEnts()
	love.graphics.setColor(0, 0, 255)
	love.graphics.rectangle("fill", player.x, player.y, player.size, player.size)

	for each, wall in pairs(walls) do
		love.graphics.setColor(255, 0, 0)
		love.graphics.rectangle("fill", wall[1], wall[2], wallSize, wallSize)
	end

	for each, mush in pairs(mushes) do
		love.graphics.setColor(255, 255, 0)
		love.graphics.rectangle("fill", mush[1], mush[2], 8, 8)
	end

end

function logic(dt)
	for each, wall in pairs(walls) do 
		-- Gravity Stuff:
		if wall[1] <= player.x+player.size and wall[1]+wallSize >= player.x then
			if player.y <= wall[2]+wallSize and player.y+player.size >= wall[2]-1 then
				player.touchesGround = true
				player.jumpCount = 0
			elseif player.y < wall[2] then
				player.touchesGround = false
			end
		end
	end

	-- More Gravity Stuff
	if player.touchesGround == false and player.jump == false then
		player.y = player.y + 70 * dt
	end
	if player.jumpCount < 1.1 then
		if player.jump == true then
			player.y = player.y - player.jumpSpeed * dt
			player.jumpCount = player.jumpCount + 2 * dt
		end
	else
		player.jump = false
	end

end

-- BE RIGHT BACK!