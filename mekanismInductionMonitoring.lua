-- Terminal preparation
term.clear()
term.setCursorPos(1,1)

-- Monitor preparation
local monitor = peripheral.find("monitor")
if monitor then
    monitor.setBackgroundColour(colors.gray)
    monitor.clear()
    monitor.setCursorPos(1,1)
end

-- Configuration
local config = {
    isTestingModeEnabled = false
}
if config.isTestingModeEnabled then
    print("Testing mode is enabled.")
end

-- Variable declaration
inductionPort = nil
local energy
local energySuffix
local progressBar
local monitorColor = colors.gray
local pos1
local pos2

-- Functions

-- Print text serialised
local function printText(text)
    print(textutils.serialise(text))
end

-- Convert Joules to RF(Redstone Flux)
local function convertToRF(amntEnergy)
    return math.floor(amntEnergy / 2.5)
end

-- Find suffix and convert value
local function formatEnergyValue(val)
    val = val + 1       -- bugProof
    local suffix
    local energy = 1    -- bugProof
    if val < 1000 then
        suffix = ''
    elseif val < 1000000 then
        energy = val / 1000
        suffix = 'k'
    elseif val < 1000000000 then
        energy = val / 1000000
        suffix = 'M'
    elseif val < 1000000000000 then
        energy = val / 1000000000
        suffix = 'G'
    else
        energy = val / 1000000000000
        suffix = 'T'
    end
    return suffix, energy
end

-- Round a number to a specific number of decimal places
local function roundToDecimal(number, decimalPlaces)
    local powerOf10 = 10 ^ decimalPlaces
    return math.floor(number * powerOf10 + 0.5) / powerOf10
end

-- Monitor draw region 
local function drawRegion(pos1, pos2, monitorColor, monitor)
    --[[
    - pos1          Top-left coordinates
    - pos2          Bottom-right corner coordinates
    - monitorColor  Color you want to draw with
    - monitor       Monitor you want to draw to
    ]] 
    local x1, y1 = pos1[1], pos1[2]     -- Top-left corner coordinates
    local x2, y2 = pos2[1], pos2[2]     -- Bottom-right corner coordinates
    local numSpaces = y2 - y1 + 1       -- Calculate the number of blank spaces to write
    if monitor and config.isTestingModeEnabled then
        printText("Monitor is working")
        printText("Color: " .. monitorColor)
        printText("Drawing region at x1:" .. x1 .. " x2:"..x2.." y1:"..y1.." y2:"..y2)
        printText("Drawed region is "..numSpaces.. " pixels long")
    end
    monitor.setBackgroundColour(monitorColor)  -- Set the color for the draw

    -- Loop through each line of the region
    for y = y1, y2 do
        -- Loop through each column of the region
        for x = x1, x2 do
            monitor.setCursorPos(x,y)
            monitor.write(" ")
        end
    end
    -- Reset the background color to the default
    monitor.setBackgroundColour(colors.gray)
end

-- Check for induction port in peripheral
local function isInductionPort()
    local name = "inductionPort"
    for _, side in pairs(peripheral.getNames()) do
        if name == peripheral.getType(side) then
            printText("Found " .. name .. " on " .. side)
            return peripheral.wrap(side)
        end
    end
    print("There is no "..name .." in the peripheral list")
    return false
end

local function getCurrentEnergy(inductionPort)
    local suffix, energy = formatEnergyValue(convertToRF(inductionPort.getEnergy()))
    energy = roundToDecimal(energy, 2)
    return suffix, energy
end

local function getMaxEnergy(inductionPort)            
    local suffix, energy = formatEnergyValue(convertToRF(inductionPort.getMaxEnergy()))
    energy = roundToDecimal(energy, 1)
    return suffix, energy
end

local function getLastInput()
    local suffix, energy = formatEnergyValue(convertToRF(inductionPort.getLastInput()))
    energy = roundToDecimal(energy, 0)
    return suffix, energy
end

local function getLastOutput()
    local suffix, energy  = formatEnergyValue(convertToRF(inductionPort.getLastOutput()))
    energy = roundToDecimal(energy, 0)
    return suffix, energy
end

local function drawBar()
    local monitorColor = colors.black
    local pos1 = {1, 18}
    local pos2 = {29, 19}
    drawRegion(pos1, pos2, monitorColor, monitor)    
end

local function drawProgressBar()
    monitorColor = colors.red
    progressBar = roundToDecimal(inductionPort.getEnergyFilledPercentage() * 28 + 1, 1)
    pos1 = {1, 18}
    pos2 = {progressBar, 19}
    drawRegion(pos1, pos2, monitorColor, monitor)    
end

-- Monitor updating
-- Refresh and update the monitor each time the function is called
local function monitorUpdateValue()
    local energy 
    local energySuffix
    local maxEnergy
    local maxEnergySuffix
    -- Title
    monitor.setCursorPos(1,1)
    monitor.write("INDUCTION BATTERY")
    monitor.setCursorPos(1,2)
    monitor.write("-----------------")
    -- Stored energy
    monitor.setCursorPos(1,3)
    monitor.write("Energy")
    monitor.setCursorPos(10,3)
    monitor.write(":")
    monitor.setCursorPos(11,3)
    energySuffix, energy = getCurrentEnergy(inductionPort)
    maxEnergySuffix, maxEnergy = getMaxEnergy(inductionPort)
    monitor.write(energy ..energySuffix .."RF / " .. maxEnergy ..maxEnergySuffix .."RF")
    -- Input
    monitor.setCursorPos(1,4)
    monitor.write("Input")
    monitor.setCursorPos(10,4)
    monitor.write(":")
    monitor.setCursorPos(11,4)
    energySuffix, energy = getLastInput()
    monitor.write(energy .. energySuffix .. "RF")
    -- Output
    monitor.setCursorPos(1,5)
    monitor.write("Output")
    monitor.setCursorPos(10,5)
    monitor.write(":")
    monitor.setCursorPos(11,5)
    energySuffix, energy = getLastOutput()
    monitor.write(energy .. energySuffix .. "RF")
end
-----------------

-- Code

-- Assign the induction port object
inductionPort = isInductionPort()

-- Testing
if config.isTestingModeEnabled then
    -- Test and printing
    printText("Testing print:")
    printText("color is " .. monitorColor)
    printText(inductionPort.getEnergyFilledPercentage())
end
-- check if inductionPort is present
if not inductionPort then -- if not, stop the program
    print("There is no induction port, aborting.")
    return
else
    -- Program start here
    
    -- Draw the initial bar outside the loop
    drawBar()

    while true do
        -- Main loop --

        -- Check if a monitor is present
        if monitor then
            -- Call monitoring
            monitorUpdateValue()

            -- Draw the progression bar
            drawProgressBar()
        else
            printText("No monitor is present, aborting")
            return false
        end

        os.sleep(1)
    end
end