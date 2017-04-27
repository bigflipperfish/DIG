--Quarry Teardown version 0.0.2

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
	
	for i=1,reps do
		if direction == "up" then
			while not turtle.up() do
				turtle.digUp()
			end
		end
	end
	
	for i=1,reps do
		if direction == "down" then
			while not turtle.down() do
				turtle.digDown()
			end
		end
	end
	
	for i=1,reps do
		if direction == "forward" then
			while not turtle.forward() do
				turtle.dig()
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

--Basic teardown functionality

local function waitForRedstone(updateFreq)
	while redstone.getInput("back") == false do
		sleep(updateFreq)
	end
end

local function formQue()
	waitForRedstone(0.1)
	turn("left")
	
	while true do
		turtle.forward()
		sleep(0.1)
	end
end

local function waitForTurtle()
	local success,turtleCheck = turtle.inspect()
	
	while turtleCheck.name ~= "ComputerCraft:CC-TurtleAdvanced" do
		sleep(0.1)
		success,turtleCheck = turtle.inspect()
	end
end

local function pickUp()
	waitForTurtle()
	
	for i=1,16 do
		turtle.suck()
	end
	
	turtle.dig()
end

local function dumpSupplies()
	for slot = 1,16 do
		turtle.select(slot)
		turtle.drop()
	end
end

--SmartTurtle functionality

local function doJob()
	local job = os.getComputerLabel()
	
	if job == "AlphaBot" then
		turn("right")
		redstone.setOutput("right",true)
		for turtle=1,7 do
			sleep(0.5)
			pickUp()
		end
		turn("right",2)
		dumpSupplies()
	end
	
	if job == "QuarryBot" then
		formQue()
	end
end

--Main program

local function main()
	doJob()
end

main()