require "editor"

function resources()
end

function love.load()
	variables()
	editorLoad()
end

function love.update(dt)
	if level == 1 then
		if love.keyboard.isDown("escape") then
			love.event.quit()
		end
		if love.keyboard.isDown("left") then
			player.x = player.x - player.speed * dt
			player.dir = "left"
			player.left = true
			player.right = false
		elseif love.keyboard.isDown("right") then 
			player.x = player.x + player.speed * dt
			player.right = true
			player.left = false
		else
			player.left = false
			player.right = false
		end
		if love.keyboard.isDown("s") then
			if player.touchesGround == true then
				player.jump = true
			end
		end

		logic(dt)
	elseif level == -0 then
		editorUpdate(dt)
	end
end

function love.draw()
	love.graphics.translate(screen.transX, screen.transY)
	love.graphics.scale(screen.scale, screen.scale)
	if level == -0 then
		editorDraw()
	elseif level == 1 then
		loadEnt()
		drawEnts()
	end
end

function variables()
	level = 1
	loadLvl = true

	screen = {}
	screen.scale = 2.5
	screen.transX = 0
	screen.transY = 0
	screen.w = 800/screen.scale
	screen.h = 600/screen.scale

	player = {}
	player.x = screen.w/2
	player.y = screen.h/2
	player.speed = 75
	player.jump = false
	player.jumpCount = 0
	player.jumpSpeed = 70
	player.touchesGround = true
	player.right = false
	player.left = false

	blocksize = 16

	walls = {}
	bullets = {} -- x, y, dir
	mushes = {} -- x, y, dir
	orbs = {}

	ash = {}
	ash.x = 0
	ash.y = 0
end

function drawEnts()
	love.graphics.setColor(0, 0, 255)
	love.graphics.rectangle("fill", player.x, player.y, blocksize, blocksize)

	for each, wall in pairs(walls) do
		love.graphics.setColor(255, 0, 0)
		love.graphics.rectangle("fill", wall[1], wall[2], blocksize, blocksize)
	end

	for each, mush in pairs(mushes) do
		love.graphics.setColor(255, 255, 0)
		love.graphics.rectangle("fill", mush[1], mush[2], blocksize, blocksize)
	end

end

function resetEnts()
	player.jump = false
	player.jumpCount = 0
	player.jumpSpeed = 70
	player.touchesGround = true
	player.right = false
	player.left = false

	walls = {}
	mushes = {}
end

function loadEnt()
	if loadLvl == true then
		resetEnts()
		require(path .. level)
		loadLvl = false
	end
end

function logic(dt)
	for each, wall in pairs(walls) do
		if wall[1] <= player.x+blocksize and wall[1]+blocksize >= player.x then
			-- Gravity Stuff:
			if player.y <= wall[2]+blocksize and player.y+blocksize >= wall[2]-1 then
				player.touchesGround = true
				player.jumpCount = 0
			elseif player.y < wall[2] then
				player.touchesGround = false
			end

		-- Wall Collisions: 
			if player.y <= wall[2]+blocksize and player.y >= wall[2] then
				player.jump = false
			end
		end
		-- Some more Wall Collisions:
		if player.y+blocksize >= wall[2] and player.y < wall[2]+blocksize then
			-- print("woo wooo woo")
			if player.x+blocksize >= wall[1] and player.x+blocksize < wall[1]+blocksize then
				-- print("BOOYAH!!!")
				player.x = player.x - player.speed * dt
			elseif player.x <= wall[1]+blocksize+1 and player.x > wall[1] then
				-- print("NOM NOM NOM NOM NOM NOM ")
				player.x = player.x + player.speed * dt
			end
		end
	end

	for each, mush in pairs(mushes) do
		for each, wall in pairs(walls) do
			if mush[2]+blocksize >= wall[2] and mush[2] < wall[2]+blocksize then
				-- print("woo wooo woo")
				if wall[1]+blocksize >= wall[1] and wall[1]+blocksize < wall[1]+blocksize then
					-- print("BOOYAH!!!")
					mush[3] = "left"
				elseif wall[1] <= wall[1]+blocksize+1 and wall[1] > wall[1] then
					-- print("NOM NOM NOM NOM NOM NOM ")
					mush[3] = "right"
				end
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