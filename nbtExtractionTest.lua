while true do
    -- Clear terminal
term.clear()
term.setCursorPos(1, 1)

-- declare variables
local block = peripheral.wrap("blockReader_0")
local getInfo = peripheral.getMethods("blockReader_0")
local monitorResY = 6*2
local monitorResX = 9*2

------ Function ------
-- Input X amount of blank spaces
local function blankSpaces(num1, monitor)
    local spaces = ""
    for i = 1, num1 do
        spaces = spaces .. " "
    end
    return spaces
end

-- Energy bar
local function energyBar(numActual, numTotal, barSize)
    return math.ceil(barSize * numActual / numTotal)
end

------ Function ------

-- Serialisation of info
local text = textutils.serialise(getInfo)

-- Preparing to store info into file
local text1 = textutils.serialise(block.getBlockData())

-- Getting block data 
local data = block.getBlockData()
local text2 = textutils.serialise(data.Items[1])
local text3 = textutils.serialise(data.rfPerTick)
local text4 = textutils.serialise(data.Energy)

-- Print
print(text)
print(text2)
print(text3)
print(text4)

-- Preparing the monitor
local monitor = peripheral.find("monitor")
if monitor then
    monitor.setBackgroundColour(colors.gray)
    monitor.setTextColour(colors.white)
    monitor.clear()
    monitor.setCursorPos(1, 1)
    monitor.write("Energy = ".. data.Energy .. " RF")
    monitor.setCursorPos(1, 2)                  -- Monitor block resolution is 9x6 starting top left
    monitor.setBackgroundColour(colors.black)   -- set the colors to black
    monitor.write(blankSpaces(monitorResX * 2, monitor))         -- write with a black backgroud
    monitor.setCursorPos(1, 2)
    monitor.setBackgroundColour(colors.red)
    monitor.write(blankSpaces(energyBar(data.Energy, 500000, monitorResX)))
    monitor.setCursorPos(1,3)
    monitor.setBackgroundColour(colors.gray)
    monitor.write("Energy Consumption")
    monitor.setCursorPos(1,4)
    monitor.write(data.rfPerTick .. "RF/t")
end
os.sleep(2)
end
