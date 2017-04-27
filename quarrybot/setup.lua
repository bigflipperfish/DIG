-- QuarrySetup version 0.1.4

--Inventory management.

local function selectItem(name,damageValue)
	if damageValue == nil then
		damageValue = 0
	end
	
	for slot = 1,16 do
		local details = turtle.getItemDetail(slot)
		
		if details then
			if details.name == name and details.damage == damageValue then
				turtle.select(slot)
				return true
			end
		end
	end
end

local function moveSlot(slot)
	turtle.select(slot)
	
	for toSlot = 1,16 do
		if toSlot == slot then
			--MOVE ALONG, NOTHING TO SEE HERE
		elseif turtle.transferTo(toSlot) then
			return true
		end
	end
end

local function prepInventory()
	moveSlot(1)
	selectItem("EnderStorage:enderChest")
	turtle.transferTo(1)
	moveSlot(2)
	selectItem("EnderStorage:enderChest",4095)
	turtle.transferTo(2)
end

--Basic movement functionality.

local function dig(direction,reps)
	if reps == nil then
		reps = 1
	end
	
	for i=1,reps do
		if direction == "up" then
			while turtle.detectUp() do
				turtle.digUp()
			end
		end
	end
	
	for i=1,reps do
		if direction == "down" then
			while turtle.detectDown() do
				turtle.digDown()
			end
		end
	end
	
	for i=1,reps do
		if direction == "forward" then
			while turtle.detect() do
				turtle.dig()
			end
		end
	end
end

local function move(direction,reps)
	if reps == nil then
		reps = 1
	end
	
	if direction == "up" then
		for i=1,reps do
			while not turtle.up() do
				turtle.digUp()
			end
		end
	end
	
	if direction == "down" then
		for i=1,reps do
			while not turtle.down() do
				turtle.digDown()
			end
		end
	end
	
	if direction == "forward" then
		for i=1,reps do
			while not turtle.forward() do
				turtle.dig()
			end
		end
	end
	
	if direction == "back" then
		for i=1,reps do
			while not turtle.back() do
				print("Movement obstructed")
			end
		end
	end
end

local function turn(direction,reps)
	if reps == nil then
		reps = 1
	end
	
	for i=1,reps do
		if direction == "right" then
			turtle.turnRight()
		end
	end 
	
	for i=1,reps do
		if direction == "left" then
			turtle.turnLeft()
		end
	end
end

local function refuel()
	if turtle.refuel() then
		return true
	else
		return false
	end
	
end

local function checkFuel()
	if turtle.getFuelLevel() < 100 then
		while not refuel() do
			io.write("Put fuel into inventory and hit enter...")
			read()
		end
	end
end

--Basic setup functionality.

local function getMaterials()
	for slot=1,16 do
		turtle.select(slot)
		turtle.suckDown()
	end
end

local function bootTurtle()
	peripheral.call("bottom", "turnOn")
end

local function placeTurtle()
	dig("down")
	
	while not selectItem("ComputerCraft:CC-TurtleAdvanced") do
		print("Put QuarryBots in my inventory and push enter")
		read()
	end
	
	turtle.placeDown()
	
	while not selectItem("EnderStorage:enderChest") do
		print("Put all white EnderStorage chest in my inventory and push enter")
		read()
	end
	
	turtle.dropDown(1)
	
	while not selectItem("EnderStorage:enderChest",4095) do
		print("Put all black EnderStorage chest in my inventory and push enter")
		read()
	end
	
	turtle.dropDown(1)
	bootTurtle()
end

local function placeRedstone()
	move("forward")
	turn("right")
	dig("down")
	
	while not selectItem("minecraft:redstone") do
		print("Put redstone in my inventory and push enter")
		read()
	end
	
	turtle.placeDown()
	
	for i=1,14 do
		move("forward")
		dig("down")
		
		while not selectItem("minecraft:redstone") do
			print("Put redstone in my inventory and push enter")
			read()
		end

		turtle.placeDown()
	end
end

local function setup()
	getMaterials()
	turn("right")
	move("forward")
	
	for bot=1,6 do
		move("forward",2)
		turn("right")
		placeTurtle()
		turn("left")
	end
	
	move("forward",2)
	turn("right")
	placeTurtle()
	
	placeRedstone()
	
	turn("left")
	move("back")
	move("down")
	
	prepInventory()
end

--Main program

local function main()
	term.clear()
	term.setCursorPos(1,2)
	print("Push enter to start setup...")
	read()	
	
	term.clear()
	term.setCursorPos(1,2)
	print("Ensure the following items are in a chest below me:")
	print("    x1  Lever")
	print("    x15 Redstone dust")
	print("    x7  QuarryBot turtles")
	print("    x8  Quarry enderchests (all white)")
	print("    x8  Fuel enderchests (all black)")
	print("Push enter to continue")
	read()
	setup()
	
	term.clear()
	term.setCursorPos(1,2)
	print("Pull lever to begin quarry!")
end

main()