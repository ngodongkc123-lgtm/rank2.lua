local network = game:GetService("ReplicatedStorage"):WaitForChild("Network")

-- ID summoner cố định từ log của bạn
local SUMMONER_ID = "92024667d35c45c3aef99e3ae444ca69"

print("=== BẮT ĐẦU COIN JAR ===")

-- 1. Gọi spawn Coin Jar
local spawnSuccess, spawnResult = pcall(function()
    return network.CoinJar_Spawn:InvokeServer(SUMMONER_ID)
end)

if not spawnSuccess then
    print("❌ Lỗi CoinJar_Spawn:", spawnResult)
    return
end

print("✅ Đã spawn Coin Jar, kết quả trả về:", spawnResult)

-- 2. Giả định spawnResult chính là ID của Coin Jar mới
local coinJarID = spawnResult
if typeof(coinJarID) ~= "string" then
    print("⚠️ Kết quả trả về không phải string, cần kiểm tra lại logic lấy ID.")
    print("Kiểu dữ liệu nhận được:", typeof(coinJarID))
    -- Thử tìm ID trong các trường nếu nó là table
    if typeof(coinJarID) == "table" then
        coinJarID = coinJarID.ID or coinJarID.InstanceID or coinJarID.JarID
        if coinJarID then
            print("Đã trích xuất ID từ bảng:", coinJarID)
        else
            print("Không tìm thấy ID trong bảng.")
            return
        end
    else
        return
    end
end

print("ID Coin Jar vừa tạo:", coinJarID)

-- 3. Lấy dữ liệu phần thưởng
local dataSuccess, dataResult = pcall(function()
    return network["Random Events: Request Coin Jar Data"]:InvokeServer(coinJarID)
end)

if dataSuccess then
    print("📦 Dữ liệu Coin Jar:", dataResult)
else
    print("❌ Lỗi lấy dữ liệu:", dataResult)
end

print("=== HOÀN TẤT ===")
