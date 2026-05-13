local network = game:GetService("ReplicatedStorage"):WaitForChild("Network")

local eggName = "Hollow Egg"
local quantity = 10

print("Đang mua " .. quantity .. " " .. eggName .. "...")
local success, result = pcall(function()
    return network.Eggs_RequestPurchase:InvokeServer(eggName, quantity)
end)

if success then
    print("✅ Đã mua thành công " .. quantity .. " " .. eggName)
    print("Kết quả:", result)
else
    print("❌ Lỗi:", result)
end
