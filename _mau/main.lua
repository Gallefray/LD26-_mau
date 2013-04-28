require "editor"

function resources()
end

function love.load()
	variables()
	editorLoad()
end

function love.update(dt)
	function love.keypressed(key)
		if key == "\\" then
      		debug.debug()
      	end
   	end
   	if love.keyboard.isDown("escape") then
		love.event.quit()
	end
	if level == 1 then
		if love.keyboard.isDown("left") then
			player.x = player.x - player.speed * dt
			screen.transX = screen.transX + (player.speed*2.5) * dt
			player.left = true
			player.right = false
		elseif love.keyboard.isDown("right") then 
			player.x = player.x + player.speed * dt
			screen.transX = screen.transX - (player.speed*2.5) * dt
			player.right = true
			player.left = false
		-- else
		-- 	player.left = false
		-- 	player.right = false
		end
		if love.keyboard.isDown("s") then
			if player.touchesGround == true then
				player.jump = true
			end
		end
		if love.keyboard.isDown("d") then
			if bulletCounter == 0 then
				print("DETECTED")
				local x = player.x
				local y = player.y
				if player.right == true then
					table.insert(bullets, {x, y, "right"})
					bulletShot = true
					print("1")
				elseif player.left == true then
					table.insert(bullets, {x, y, "left"})
					bulletShot = true
					print("2")
				end
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
	player.right = true
	player.left = false
	player.health = 10

	blocksize = 16

	walls = {} -- x, y
	bullets = {} -- x, y, dir
	mushes = {} -- x, y, dir, gravity
	orbs = {} -- x, y

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

	for each, bullet in pairs(bullets) do
		love.graphics.setColor(0, 255, 0)
		love.graphics.rectangle("fill", bullet[1], bullet[2], blocksize, blocksize)
	end

	for each, orb in pairs(orbs) do
		love.graphics.setColor(255, 255, 255)
		love.graphics.rectangle("fill", orb[1], orb[2], blocksize, blocksize)
	end

end

function resetEnts()
	player.jump = false
	player.jumpCount = 0
	player.jumpSpeed = 70
	player.touchesGround = true
	player.right = false
	player.left = false
	player.health = 10

	bulletShot = false
	bulletCounter = 0

	walls = {} -- x, y
	bullets = {} -- x, y, dir
	mushes = {} -- x, y, dir, gravity
	orbs = {} -- x, y

end

function loadEnt()
	if loadLvl == true then
		resetEnts()
		require(path .. level)
		loadLvl = false
	end
end

function logic(dt)
	-- PLAYER LOGIC:
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
	-- Player hurt/death screens
	if player.health < 1 then
		level = level - 2
		print("D: level is now: " .. level)
	end
	
	if ash.y+blocksize >= player.y and ash.y < player.y+blocksize then
		if player.x+blocksize >= ash.x and player.x <= ash.x+blocksize then
			level = level - 3	
		end
	end 

	-- PLAYER - WALL STUFF:
	for each, wall in pairs(walls) do
		if wall[1] <= player.x+blocksize and wall[1]+blocksize >= player.x then
			-- Gravity Stuff:
			if player.y <= wall[2]+blocksize and player.y+blocksize >= wall[2]-1 then
				player.touchesGround = true
				player.jumpCount = 0

			elseif player.y <= wall[2] then
				player.touchesGround = false

			end

		-- Wall Collisions: 
			if player.y <= wall[2]+blocksize and player.y >= wall[2] then
				player.jump = false
			end
		end
		-- Some more Wall Collisions:
		-- (left right)
		if player.y+blocksize >= wall[2] and player.y < wall[2]+blocksize then
			if player.x+blocksize >= wall[1] and player.x+blocksize < wall[1]+blocksize then
				player.x = player.x - player.speed * dt

			elseif player.x <= wall[1]+blocksize+1 and player.x > wall[1] then
				player.x = player.x + player.speed * dt

			end
		end
	end

	-- MUSH LOGIC 
	for each, mush in pairs(mushes) do
		-- Collsions:
		for each, wall in pairs(walls) do
			if mush[2]+blocksize >= wall[2] and mush[2] < wall[2]+blocksize then
				if mush[1]+blocksize >= wall[1] and mush[1]+blocksize < wall[1]+blocksize then
					mush[3] = "left"
				elseif mush[1] <= wall[1]+blocksize+1 and mush[1] > wall[1] then
					mush[3] = "right"
				end
			end
			-- Gravity Stuff:
			if wall[1] <= mush[1]+blocksize and wall[1]+blocksize >= mush[1] then
				if mush[2] <= wall[2]+blocksize and mush[2]+blocksize >= wall[2]-1 then
					mush[4] = true
					print("MUSH4 = true")

				elseif mush[2] <= wall[2] then
					mush[4] = false
					print("MUSH4 = false")

				end
			end
		end

		-- Player - Mush collision detection
		if mush[2]+blocksize >= player.y and mush[2] < player.y+blocksize then
			if mush[1]+blocksize >= player.x and mush[1]+blocksize < player.x+blocksize then
				mush[3] = "left"
				mush[1] = mush[1] - player.speed*2 * dt
				player.health = player.health - 1
				print("Bop!")
			elseif mush[1] <= player.x+blocksize+1 and mush[1] > player.x then
				mush[3] = "right"
				mush[1] = mush[1] + player.speed*2 * dt
				player.health = player.health - 1
				print("Bop!")
			end
		end

		-- Movement:
		if mush[3] == "right" then
			mush[1] = mush[1] + (player.speed/1.5) * dt
		elseif mush[3] == "left" then
			mush[1] = mush[1] - (player.speed/1.5) * dt
		end

		if mush[4] == false then
			mush[2] = mush[2] + 64 * dt
		end
	end

	-- ORB LOGIC:
	for each, orb in pairs(orbs) do
		if orb[2]+blocksize >= player.y and orb[2] < player.y+blocksize then
			if orb[1]+blocksize >= player.x and orb[1] <= player.x+blocksize then
				player.health = player.health + 1
				table.remove(orbs, each)
			end
		end
	end

	-- BULLET LOGIC:
	if bulletShot == true then
		bulletCounter = bulletCounter + 1 * dt
		if bulletCounter > 0.2 then
			bulletShot = false
			bulletCounter = 0
		end
	end
	for each, bullet in pairs(bullets) do
		local visbuf = 200
		if bullet[1] > player.x+screen.w + visbuf or bullet[1] < player.x-screen.w - visbuf then -- Do this upon wall collsions too! :P
			table.remove(bullets, each)
		end

		for every, mush in pairs(mushes) do
			if bullet[2]+blocksize >= mush[2] and bullet[2] <= mush[2]+blocksize then
				if bullet[1]+blocksize >= mush[1] and bullet[1] <= mush[1]+blocksize then
					table.remove(mush, every)
					table.remove(bullet, each)
				end
			end
		end
		if bullet[3] == "right" then
			bullet[1] = bullet[1] + (player.speed*2) * dt
		elseif bullet[3] == "left" then
			bullet[1] = bullet[1] - (player.speed*2) * dt
		end
	end

end