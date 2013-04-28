require "editor"

function resources()
	-- love.graphics.newImage("")
	-- love.audio.newSource("", "stream")
	pImg = "data/images/"
	pSnd = "data/sound/"
	pMus = "data/music/"

	-- Graphics:
	player1 = love.graphics.newImage(pImg .. "player1.png")
	player2 = love.graphics.newImage(pImg .. "player2.png")
	player3 = love.graphics.newImage(pImg .. "player3.png")
	player1:setFilter("nearest", "nearest")
	player2:setFilter("nearest", "nearest")
	player3:setFilter("nearest", "nearest")

	wall1 = love.graphics.newImage(pImg .. "wall.png")
	wall1:setFilter("nearest", "nearest")

	mush0 = love.graphics.newImage(pImg .. "enemy1.png")
	mush1 = love.graphics.newImage(pImg .. "enemy2.png")
	mush2 = love.graphics.newImage(pImg .. "enemy3.png")
	mush3 = love.graphics.newImage(pImg .. "enemy5.png")
	mush0:setFilter("nearest", "nearest")
	mush1:setFilter("nearest", "nearest")
	mush2:setFilter("nearest", "nearest")
	mush3:setFilter("nearest", "nearest")

	bullet1 = love.graphics.newImage(pImg .. "bullet.png")
	bullet1:setFilter("nearest", "nearest")

	orb1 = love.graphics.newImage(pImg .. "orb1.png")
	orb1:setFilter("nearest", "nearest")

	


end

function love.load()
	resources()
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
				local x = player.x
				local y = player.y
				if player.right == true then
					table.insert(bullets, {x, y, "right"})
					bulletShot = true
					print("PEW!")
				elseif player.left == true then
					table.insert(bullets, {x, y, "left"})
					bulletShot = true
					print("PEW!")
				end
			end 
		end

		logic(dt)
	elseif level == -0 then
		editorUpdate(dt)
	end
end

function love.draw()
	love.graphics.push()
	love.graphics.translate(screen.transX, screen.transY)
	love.graphics.scale(screen.scale, screen.scale)
	if level == -0 then
		editorDraw()
		love.graphics.pop()
	elseif level == 1 then
		loadEnt()
		drawEnts()
		love.graphics.pop()
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
	player.h = 14
	player.w = 8
	player.speed = 75
	player.jump = false
	player.jumpCount = 0
	player.jumpSpeed = 70
	player.touchesGround = true
	player.right = true
	player.left = false
	player.health = 5
	player.maxHealth = 5
	score = 0

	bulletShot = false
	bulletCounter = 0

	blocksize = 16

	walls = {} -- x, y
	bullets = {} -- x, y, dir
	mushes = {} -- x, y, dir, gravity
	orbs = {} -- x, y
	textile = {}

	ash = {}
	ash.x = 0
	ash.y = 0
end

function drawEnts()
	love.graphics.setColor(255, 255, 255)

	love.graphics.draw(player1, player.x, player.y)

	for each, wall in pairs(walls) do
		love.graphics.draw(wall1, wall[1], wall[2])
	end

	for each, mush in pairs(mushes) do
		if mush[3] == "right" then
			love.graphics.draw(mush1, mush[1], mush[2])
		elseif mush[3] == "left" then
			love.graphics.draw(mush2, mush[1], mush[2])
		elseif mush[3] == "neut" then
			love.graphics.draw(mush3, mush[1], mush[2])
		end 
	end

	for each, bullet in pairs(bullets) do
		love.graphics.draw(bullet1, bullet[1], bullet[2])
	end

	for each, orb in pairs(orbs) do
		love.graphics.draw(orb1, orb[1], orb[2])
	end

	for each, tex in pairs(textile) do
		love.graphics.draw(wall1, tex[1], tex[2])
	end

end

function loadEnt()
	if loadLvl == true then
		-- resetEnts()
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

	-- PLAYER - WALL STUFF:
	for each, wall in pairs(walls) do
		if wall[1] <= player.x+player.w and wall[1]+blocksize >= player.x then
			-- Gravity Stuff:
			if player.y <= wall[2]+blocksize and player.y+player.h >= wall[2]-1 then
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
		-- (left | right)
		if player.y+player.h >= wall[2] and player.y < wall[2]+blocksize then
			if player.x+player.w >= wall[1] and player.x+player.w < wall[1]+blocksize then
				player.x = player.x - player.speed * dt

			elseif player.x <= wall[1]+blocksize+1 and player.x > wall[1] then
				player.x = player.x + player.speed * dt

			end
		end
	end

	-- MUSH LOGIC 
	for each, mush in pairs(mushes) do
		-- Collsions:
		if mush[3] ~= "neut" then
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
						-- print("MUSH4 = true")

					elseif mush[2] <= wall[2] then
						mush[4] = false
						-- print("MUSH4 = false")

					end
				end
			end

			-- Player - Mush collision detection
			if mush[2]+blocksize >= player.y and mush[2] < player.y+player.h then
				if mush[1]+blocksize >= player.x and mush[1]+blocksize < player.x+player.w then
					mush[3] = "left"
					mush[1] = mush[1] - player.speed*2 * dt
					player.health = player.health - 1
					print("Bop!")
				elseif mush[1] <= player.x+player.w+1 and mush[1] > player.x then
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

			-- Death:
			for every, bullet in pairs(bullets) do
				-- print("bullet: " .. bullet[1] .. " " .. bullet[2] .. "\n")
				-- print("mush: " .. mush[1] .. " " .. mush[2] .. "\n")
				if bullet[2]+blocksize >= mush[2] and bullet[2] < mush[2]+blocksize then
					if bullet[1]+blocksize >= mush[1] and bullet[1] <= mush[1]+blocksize then
						table.remove(bullets, every)
						mush[3] = "neut"
						score = score + 1
						print("BLAM")
						-- print("1 :O")
					end
				end
			end
		end
	end

	-- ORB LOGIC:
	for each, orb in pairs(orbs) do
		if orb[2]+blocksize >= player.y and orb[2] < player.y+blocksize then
			if orb[1]+blocksize >= player.x and orb[1] <= player.x+blocksize then
				if player.health == player.maxHealth then
					score = score + 1
					print("score: " .. score)
				elseif player.health < player.maxHealth then
					player.health = player.health + 1
					print("health: " .. player.health)
				end
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

		if bullet[3] == "right" then
			bullet[1] = bullet[1] + (player.speed*2) * dt
		elseif bullet[3] == "left" then
			bullet[1] = bullet[1] - (player.speed*2) * dt
		end
	end
end