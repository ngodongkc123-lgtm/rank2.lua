local network = game:GetService("ReplicatedStorage"):WaitForChild("Network")

-- ID summoner cố định từ log
local SUMMONER_ID = "324f70571ba74f79930d37ceab9e2daf"

print("=== BẮT ĐẦU MINI PINATA ===")

-- 1. Consume Pinata
local spawnSuccess, spawnResult = pcall(function()
    return network.MiniPinata_Consume:InvokeServer(SUMMONER_ID)
end)

if not spawnSuccess then
    print("❌ Lỗi MiniPinata_Consume:", spawnResult)
    return
end

print("✅ Đã Consume, kết quả trả về:", spawnResult)

-- 2. Lấy ID Pinata mới
local pinataID = spawnResult
if typeof(pinataID) ~= "string" then
    print("⚠️ Kết quả không phải string, kiểu:", typeof(pinataID))
    -- Xử lý nếu là table
    if typeof(pinataID) == "table" then
        pinataID = pinataID.ID or pinataID.InstanceID or pinataID.PinataID
        if pinataID then
            print("Đã trích xuất ID:", pinataID)
        else
            print("Không tìm thấy ID trong bảng.")
            return
        end
    else
        return
    end
end

print("ID Pinata mới:", pinataID)

-- 3. Request Pinata Data
local dataSuccess, dataResult = pcall(function()
    return network["Random Events: Request Pinata Data"]:InvokeServer(pinataID)
end)

if dataSuccess then
    print("📦 Dữ liệu Pinata:", dataResult)
else
    print("❌ Lỗi lấy dữ liệu:", dataResult)
end

print("=== HOÀN TẤT ===")
