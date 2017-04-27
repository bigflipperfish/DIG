--QuarryBot Version 0.2.2beta

--Inventory Management

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

--Basic movement functionality.

local function checkForTurtle()
	local success,blockID = turtle.inspectUp()
	
	if blockID.name == "ComputerCraft:CC-TurtleAdvanced" then
		return true
	else
		return false
	end
end

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
				if checkForTurtle() == false then
					turtle.dig()
				end
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
	if selectItem("EnderStorage:enderChest",4095) then
		dig("forward")
		turtle.place()
		turtle.suck()
		if turtle.refuel() then
			dig("forward")
			return true
		else
			return false
		end
		
	else
		for i=1,16 do
			turtle.select(i)
			if turtle.refuel() then
				return true
			else
				return false
			end
		end
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

--Quarry functionality

local function dumpSupplies()
	dig("forward")
	
	while not selectItem("EnderStorage:enderChest") do
		print("Put all white EnderStorage chest in my inventory and push enter")
	end
	
	turtle.place()
	
	for i=3,16 do
		turtle.select(i)
		turtle.drop()
	end
	
	turtle.select(1)
	dig("forward")
end

local function digLayer()
	move("down")
	move("forward",15)
	turn("right")
	move("forward")
	turn("right")
	move("forward",15)
	turn("right")
	move("forward")
	turn("right")
end

local function surface(depth)
	print("Going up " .. depth .. " times!")
	move("up",depth)
end

local function quarry()
	local depth = 0
	local success, blockID = turtle.inspectDown()
	
	while blockID.name ~= "minecraft:bedrock" and blockID.name ~= "factorization:BlastedBedrock" do
		checkFuel()
		digLayer()
		depth = depth + 1
		if turtle.getItemCount(15) > 0 then
			dumpSupplies()
		end
		print("Ready for layer " .. depth)
		success, blockID = turtle.inspectDown()
	end
	print("I found " .. blockID.name .. "!")
	surface(depth)
end

local function waitForRedstone(updateFreq)
	while redstone.getInput("front") == false do
		sleep(updateFreq)
	end
end

--SmartTurtle functionality
local function assignJob()

	local success, blockID = turtle.inspectDown()
	
	if blockID.name == "EnderStorage:enderChest" then
		os.setComputerLabel("AlphaBot")
		
	elseif success == false then
		os.setComputerLabel("TunnelBot")
	
	elseif blockID.name == "minecraft:iron_ore" then
		os.setComputerLabel("BranchBot")
		
	elseif blockID.name == "minecraft:redstone_block" then
		os.setComputerLabel("Updating...")
	
	else
		os.setComputerLabel("QuarryBot")
	end
end

local function doJob()
	local job = os.getComputerLabel()
	
	if job == "QuarryBot" then
		print("Waiting for a redstone signal...")
		waitForRedstone(0.1)
		turn("right",2)
		quarry()
		dumpSupplies()
		shell.run("DIG/quarrybot/teardown")

	elseif job == "AlphaBot" then
		shell.run("DIG/quarrybot/setup")
		redstone.setOutput("front",true)
		turn("right",2)
		quarry()
		dumpSupplies()
		shell.run("DIG/quarrybot/teardown")
		
	elseif job == "Updating" then
		shell.run("update")
		os.setComputerLabel("DIGBot")
		
	elseif job == "TunnelBot" then
		shell.run("DIG/mine/tunnel")
	
	elseif job == "BranchBot" then
		shell.run("DIG/mine/branch")	
	end
end

--Main program

local function main()
	assignJob()
	doJob()
end

main()