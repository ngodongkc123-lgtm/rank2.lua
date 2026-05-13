local network = game:GetService("ReplicatedStorage"):WaitForChild("Network")

-- ID summoner cố định từ log
local SUMMONER_ID = "41b63dee107641658e6afe613f722f3a"

print("=== BẮT ĐẦU MINI LUCKY BLOCK ===")

-- 1. Consume Mini Lucky Block
local consumeSuccess, consumeResult = pcall(function()
    return network.MiniLuckyBlock_Consume:InvokeServer(SUMMONER_ID)
end)

if not consumeSuccess then
    print("❌ Lỗi MiniLuckyBlock_Consume:", consumeResult)
    return
end

print("✅ Đã Consume, kết quả trả về:", consumeResult)

-- 2. Lấy ID Lucky Block mới
local luckyBlockID = consumeResult
if typeof(luckyBlockID) ~= "string" then
    print("⚠️ Kết quả không phải string, kiểu:", typeof(luckyBlockID))
    -- Xử lý nếu là table
    if typeof(luckyBlockID) == "table" then
        luckyBlockID = luckyBlockID.ID or luckyBlockID.InstanceID or luckyBlockID.BlockID
        if luckyBlockID then
            print("Đã trích xuất ID:", luckyBlockID)
        else
            print("Không tìm thấy ID trong bảng.")
            return
        end
    else
        return
    end
end

print("ID Lucky Block mới:", luckyBlockID)

-- 3. Request Lucky Block Data
local dataSuccess, dataResult = pcall(function()
    return network["Random Events: Request Lucky Block Data"]:InvokeServer(luckyBlockID)
end)

if dataSuccess then
    print("📦 Dữ liệu Lucky Block:", dataResult)
else
    print("❌ Lỗi lấy dữ liệu:", dataResult)
end

print("=== HOÀN TẤT ===")
