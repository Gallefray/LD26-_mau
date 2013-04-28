function editorLoad()
	editorVar()
	setupDir()
end

function editorUpdate(dt)
	mouse.x = love.mouse.getX()
	mouse.y = love.mouse.getY()
	mouse.gx = mouse.x - (mouse.x % 40)
	mouse.gy = mouse.y - (mouse.y % 40)

	mouse.gx = (mouse.gx-screen.transX)/screen.scale
	mouse.gy = (mouse.gy-screen.transY)/screen.scale

	if love.mouse.isDown("l") then
		local x = mouse.gx
		local y = mouse.gy
		local cont = true 

		for each, pos in pairs(editPos) do 
			if pos[1] == x and pos[2] == y then
				cont = false
			end
		end

		if cont == true then
			if selected == 1 then
				for each, pos in pairs(editPos) do 
					if pos[1] == editPlayer.x and pos[2] == editPlayer.y then
						table.remove(editPos, key)
					end
				end				
				editPlayer.x = x
				editPlayer.y = y
				table.insert(editPos, {x, y})

			elseif selected == 2 then
				table.insert(editWalls, {x, y})
				table.insert(editPos, {x, y})

			elseif selected == 3 then
				table.insert(editMushes, {x, y})
				table.insert(editPos, {x, y})
			elseif selected == 4 then
				table.insert(editOrbs, {x, y})
				table.insert(editPos, {x, y})
			elseif selected == 5 then
				table.insert(editTex, {x, y})
				table.insert(editPos, {x, y})
			end
		end
	end
	if love.keyboard.isDown("d") then -- Thanks to wzl for this:
		counter = counter + 5 * dt
		if counter > scrollInterval then 
			screen.transX = screen.transX + 8*5
			counter = 0
		end
	elseif love.keyboard.isDown("a") then
		counter = counter + 5 * dt
		if counter > scrollInterval then 
			screen.transX = screen.transX - 8*5
			counter = 0
		end
	end
	function love.keypressed(key)
		if key == "e" then
			selected = selected - 1
			if selected < 1 then
				selected = maxSel
			end
		elseif key == "r" then
			selected = selected + 1
			if selected > maxSel then
				selected = 1
			end
		end

		if key == "s" and love.keyboard.isDown("lshift") then
			save(editLevel)
		end
	end
end

function editorDraw()
	love.graphics.setColor(0, 0, 255, 155)
	love.graphics.rectangle("line", mouse.gx, mouse.gy, 16, 16)

	love.graphics.setColor(255, 255, 255)
	love.graphics.draw(player1, editPlayer.x, editPlayer.y)

	for each, wall in pairs(editWalls) do
		love.graphics.draw(wall1, wall[1], wall[2])
	end

	for each, tex in pairs(editTex) do
		love.graphics.draw(wall1, tex[1], tex[2])
	end

	for each, mush in pairs(editMushes) do 
		love.graphics.draw(mush0, mush[1], mush[2])
	end

	for each, orb in pairs(editOrbs) do
		love.graphics.draw(orb1, orb[1], orb[2])
	end

	print("selection: " .. selected)
	
end

function editorVar()
	mouse = {}
	mouse.x = love.mouse.getX()
	mouse.y = love.mouse.getY()
	mouse.gx = mouse.x - (mouse.x % 16)/screen.scale
	mouse.gy = mouse.y - (mouse.y % 16)/screen.scale

	editPos = {}

	editPlayer = {}
	editPlayer.x = 0
	editPlayer.y = 0

	editWalls = {}
	editMushes = {}
	editOrbs = {} -- x, y
	editTex = {} -- tex, x, y

	selected = 1
	maxSel = 5

	counter = 0
	scrollInterval = 1

	editLevel = 1

	host = "?"
	path = love.filesystem.getUserDirectory()
	dirOne = "levels"
	setupDir()
end

function setupDir()
	if string.find(path, "/") then
		host = "unix"
	elseif string.find(path, "\\") then
		host = "NT"
	end
	os.execute("cd " .. path)
	if host == "unix" then
		os.execute("mkdir " .. dirOne .. "/")
		path = dirOne .. "/"
		print(path)
	elseif host == "NT" then
		os.execute("mkdir " .. dirOne .. "\\")
		path = dirOne .. "\\"
	end
end

function save(file)
	print(path)
	saveLvl = assert(io.open(path .. file .. ".lua", "w"))
	saveLvl:write("player.x = " .. editPlayer.x .. "\n")
	saveLvl:write("player.y = " .. editPlayer.y .. "\n")
	for each, wall in pairs(editWalls) do
		saveLvl:write("table.insert(walls, {" .. wall[1] .. ", " .. wall[2] .. "})\n")
	end
	for each, mush in pairs(editMushes) do
		local x = math.random(1, 2)
		if x == 1 then
			saveLvl:write("table.insert(mushes, {" .. mush[1] .. ", " .. mush[2] .. ", 'left', false})\n")
		elseif x == 2 then
			saveLvl:write("table.insert(mushes, {" .. mush[1] .. ", " .. mush[2] .. ", 'right', false})\n")
		end
	end
	for each, orb in pairs(editOrbs) do
		saveLvl:write("table.insert(orbs, {" .. orb[1] .. ", " .. orb[2] .. "})\n")
	end
	for each, tex in pairs(editTex) do
		saveLvl:write("table.insert(textile, {" .. tex[1] .. ", " .. tex[2] .. "})\n")
	end
	print("DONE!")
	saveLvl:close()
end