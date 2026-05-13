local network = game:GetService("ReplicatedStorage"):WaitForChild("Network")
local vim = game:GetService("VirtualInputManager")
local cam = workspace.CurrentCamera

-- ===== CÀI ĐẶT =====
local eggName = "Hollow Egg"
local buyAmount = 25
local clickTimes = 7
local clickDelay = 0.12  -- giây giữa các lần click
-- ====================

-- 1. Mua trứng
print("Đang mua " .. buyAmount .. " " .. eggName .. "...")
local ok, res = pcall(function()
    return network.Eggs_RequestPurchase:InvokeServer(eggName, buyAmount)
end)
if not ok then
    print("❌ Lỗi mua:", res)
    return
end
print("✅ Đã mua xong.")

-- 2. Đợi giao diện mở trứng hiện ra (nếu có)
task.wait(2)

-- 3. Lấy tọa độ giữa màn hình
local viewport = cam.ViewportSize
local posX, posY = viewport.X / 2, viewport.Y / 2
print("Sẽ click " .. clickTimes .. " lần vào giữa màn hình (" .. posX .. ", " .. posY .. ")")

-- 4. Thực hiện click
for i = 1, clickTimes do
    pcall(function()
        -- Nhấn chuột trái
        vim:SendMouseButtonEvent(posX, posY, 0, true, nil, 1)
        task.wait(0.03)
        -- Nhả chuột trái
        vim:SendMouseButtonEvent(posX, posY, 0, false, nil, 1)
    end)
    task.wait(clickDelay)
end

print("✅ Đã click " .. clickTimes .. " lần. Hoàn tất!")
