local network = game:GetService("ReplicatedStorage"):WaitForChild("Network")

-- 1. Mở giao diện RainbowMachine
network.EventLog_Once:FireServer("OpenTab", "RainbowMachine")
task.wait(0.4)

-- 2. Gọi Index: Request Hatch Count
local indexOK, indexResult = pcall(function()
    return network["Index: Request Hatch Count"]:InvokeServer()
end)
if indexOK then
    print("📊 Hatch Count:", indexResult)
else
    print("⚠️ Lỗi Index:", indexResult)
end
task.wait(0.3)

-- 3. Kích hoạt RainbowMachine với số 50
local machineID = "d1f3228b6c1948afbb02c7b2757d64ff"
local amount = 50

print("Đang kích hoạt RainbowMachine với", amount, "...")
local success, result = pcall(function()
    return network.RainbowMachine_Activate:InvokeServer(machineID, amount)
end)

if success then
    print("✅ Kích hoạt thành công! Phần thưởng:", result)
else
    print("❌ Thất bại:", result)
end

-- 4. Đóng giao diện
network.EventLog_Once:FireServer("CloseTab", "RainbowMachine")
print("Đã đóng RainbowMachine.")
