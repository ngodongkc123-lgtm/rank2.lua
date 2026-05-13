local network = game:GetService("ReplicatedStorage"):WaitForChild("Network")

-- 1. Mở tab (log)
network.EventLog_Once:FireServer("OpenTab", "GoldMachine")
task.wait(0.4)

-- 2. Gọi Index: Request Hatch Count (giống hệt log của bạn)
local hatchOk, hatchResult = pcall(function()
    return network["Index: Request Hatch Count"]:InvokeServer()
end)
if hatchOk then
    print("📊 Hatch Count:", hatchResult)
else
    print("⚠️ Lỗi khi gọi Index:", hatchResult)
end
task.wait(0.3)

-- 3. Kích hoạt với số 500
print("Đang kích hoạt GoldMachine với 500...")
local success, result = pcall(function()
    return network.GoldMachine_Activate:InvokeServer("5079e00776c1491394f47486ff945cd6", 500)
end)

if success then
    print("✅ Thành công! Phần thưởng:", result)
else
    print("❌ Thất bại:", result)
end

-- 4. Đóng tab
network.EventLog_Once:FireServer("CloseTab", "GoldMachine")
print("Đã đóng.")
