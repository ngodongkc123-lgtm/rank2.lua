local network = game:GetService("ReplicatedStorage"):WaitForChild("Network")
local player = game.Players.LocalPlayer

-- ID summoner cố định (từ log ảnh 13:57:46 của bạn)
local SUMMONER_ID = "1c70a8aa902c4e2884d3f45e4c3dc03d"

-- Hàm tìm sao chổi mới nhất trong Workspace (dựa vào tên)
local function findNewestComet()
    local newest = nil
    local latestTime = 0
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj.Name == "Comet" or obj.Name:find("Comet") then
            -- Thử lấy ID từ Attribute hoặc ObjectValue
            local idAttr = obj:GetAttribute("InstanceID") or obj:GetAttribute("ID")
            if not idAttr then
                local idObj = obj:FindFirstChild("ID") or obj:FindFirstChild("InstanceID")
                if idObj then idAttr = idObj.Value end
            end
            if idAttr then
                -- Giả định có thể so sánh thời gian spawn (nếu có)
                -- Tạm thời trả về ID của sao chổi đầu tiên tìm thấy có ID
                return idAttr
            end
        end
    end
    return nil
end

-- 1. Báo dừng AFK (không bắt buộc)
network["Idle Tracking: Stop Timer"]:FireServer()
task.wait(0.2)

-- 2. Spawn sao chổi
print("Đang gọi Comet_Spawn với ID summoner:", SUMMONER_ID)
local spawnSuccess, spawnResult = pcall(function()
    return network.Comet_Spawn:InvokeServer(SUMMONER_ID)
end)

if spawnSuccess then
    print("✅ Comet_Spawn thành công. Phản hồi:", spawnResult)
else
    print("❌ Lỗi Comet_Spawn:", spawnResult)
    return -- dừng script nếu không spawn được
end

-- 3. Chờ một chút để sao chổi xuất hiện trong workspace
task.wait(1.0)

-- 4. Tự động tìm ID của sao chổi mới
local cometInstanceID = findNewestComet()
if not cometInstanceID then
    print("⚠️ Không tìm thấy Comet mới trong Workspace. Có thể cần phải lấy ID từ sự kiện khác.")
else
    print("Tìm thấy Comet Instance ID:", cometInstanceID)
    
    -- 5. Yêu cầu dữ liệu sao chổi
    local dataSuccess, dataResult = pcall(function()
        return network["Random Events: Request Comet Data"]:InvokeServer(cometInstanceID)
    end)
    
    if dataSuccess then
        print("📦 Dữ liệu Comet:", dataResult)
    else
        print("❌ Lỗi lấy Data:", dataResult)
    end
end

print("Hoàn tất quy trình thả Comet.")
