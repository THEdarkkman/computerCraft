-- start timer
local startTime = os.clock()
-- Setting up peripheral
local inv0 = peripheral.wrap("sophisticatedstorage:chest_0")
local inv1 = peripheral.wrap("sophisticatedstorage:chest_1")
local inv1Name = "sophisticatedstorage:chest_1"

-- Iterate every slot of the inventory
local function pullItems(inv1, inv2, inv2Name)
    for slot = 1, inv2.size() do
        inv1.pullItems(inv2Name, slot, 64)
    end
end

-- Round a number to a specific number of decimal places
local function roundToDecimal(number, decimalPlaces)
    local powerOf10 = 10 ^ decimalPlaces
    return math.floor(number * powerOf10 + 0.5) / powerOf10
end

-- Moving Item from inv1 to inv0
pullItems(inv0, inv1, inv1Name)

-- end timer
local endTime = os.clock()
local tickPerOp = (endTime - startTime) * 20 / inv1.size()
print("moving ".. inv1.size() .. " slots, took: " .. roundToDecimal(tickPerOp, 4) .. " t/slot")