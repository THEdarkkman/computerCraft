-- Setting up local variable
local methods = peripheral.getMethods("sophisticatedstorage:chest_0")
local getItemDetailSlot1 = peripheral.call("sophisticatedstorage:chest_0", "getItemDetail", 1)

-- Setting up the terminal
term.clear()
term.setCursorPos(1, 1)

-- Declare the monitor
local monitor = peripheral.find("monitor")

-- Serialized text
local textToPrint = textutils.serialise(methods)
local textToPrint2 = textutils.serialise(getItemDetailSlot1)

-- Setting up monitor
monitor.setCursorPos(1, 1)
monitor.clear()
print("Monitor's text size is: ", monitor.getTextScale())
-- Reduce scale for fitting
monitor.setTextScale(0.5)

if getItemDetailSlot1 then
    print("Display Name: " .. getItemDetailSlot1.displayName)
    print("Enchantments:")
    for _, enchantment in ipairs(getItemDetailSlot1.enchantments) do
        print("- " .. enchantment.displayName .. " Level: " .. enchantment.level)
    end
else
    print("No item details found.")
end


-- filesystem
local file = io.open("itemNBT", "w")
if file then 
    file:write(textToPrint2)
    file:close()
end
--]]

-- Text printing to terminal
print(textToPrint)
--print(textToPrint2)

-- Text printing to monitor
monitor.write(textToPrint2)
