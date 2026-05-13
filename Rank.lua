-- DANH SÁCH SCRIPT THEO TỪ KHÓA (giữ nguyên mẫu)
local questScripts = {
    ["coin jar"]  = "https://raw.githubusercontent.com/ngodongkc123-lgtm/rank2.lua/refs/heads/main/CoinJar.lua",
    ["comet"]     = "https://raw.githubusercontent.com/ngodongkc123-lgtm/rank2.lua/refs/heads/main/Comet.lua",
    ["lucky block"] = "https://raw.githubusercontent.com/ngodongkc123-lgtm/rank2.lua/refs/heads/main/LuckyBlock.lua",
    ["pinata"]    = "https://raw.githubusercontent.com/ngodongkc123-lgtm/rank2.lua/refs/heads/main/Pinata.lua",
    ["egg"]       = "https://raw.githubusercontent.com/ngodongkc123-lgtm/rank2.lua/refs/heads/main/Egg.lua",
    ["gold"]      = "https://raw.githubusercontent.com/ngodongkc123-lgtm/rank2.lua/refs/heads/main/Gold.lua",
    ["rainbow"]   = "https://raw.githubusercontent.com/ngodongkc123-lgtm/rank2.lua/refs/heads/main/Rainbow.lua"
}

-- Bảng lưu trữ trạng thái để tránh tải trùng một script nhiều lần gây lag máy
local executedQuests = {}

-- ==================== TẠO UI ====================
local Players = game:GetService("Players")
local playerGui = Players.LocalPlayer:WaitForChild("PlayerGui")

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "QuestTracker"
screenGui.ResetOnSpawn = false -- Giữ UI không bị mất khi nhân vật reset
screenGui.Parent = playerGui

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 500, 0, 350)
mainFrame.Position = UDim2.new(0.5, -250, 0.5, -175)
mainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
mainFrame.BackgroundTransparency = 0.2
mainFrame.BorderSizePixel = 0
mainFrame.Parent = screenGui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 12)
corner.Parent = mainFrame

local stroke = Instance.new("UIStroke")
stroke.Thickness = 2
stroke.Color = Color3.fromRGB(0, 170, 255)
stroke.Parent = mainFrame

local header = Instance.new("TextLabel")
header.Size = UDim2.new(1, 0, 0, 50)
header.Text = "TRACKER NHIỆM VỤ RANK"
header.TextColor3 = Color3.fromRGB(255, 255, 255)
header.BackgroundTransparency = 1
header.TextSize = 24
header.Font = Enum.Font.SourceSansBold
header.Parent = mainFrame

local list = Instance.new("TextLabel")
list.Size = UDim2.new(1, -30, 1, -60)
list.Position = UDim2.new(0, 15, 0, 55)
list.Text = "Đang lấy dữ liệu..."
list.TextColor3 = Color3.fromRGB(255, 255, 255)
list.BackgroundTransparency = 1
list.TextSize = 18
list.Font = Enum.Font.SourceSans
list.TextXAlignment = Enum.TextXAlignment.Left
list.TextYAlignment = Enum.TextYAlignment.Top
list.TextWrapped = true
list.Parent = mainFrame

-- ==================== ĐƯỜNG DẪN ====================
local questsHolder = playerGui:WaitForChild("GoalsSide").Frame.Quests.QuestsGradient.QuestsHolder

-- ==================== CẬP NHẬT UI ====================
task.spawn(function()
    while true do
        local displayText = ""
        local activeQuests = {} -- Lưu các nhiệm vụ hiện đang hiển thị trên UI

        for _, questFrame in pairs(questsHolder:GetChildren()) do
            if questFrame:FindFirstChild("Title") and questFrame:FindFirstChild("Progress") then
                local questType = questFrame.Name
                local title = questFrame.Title.Text
                local progress = questFrame.Progress.Text
                
                displayText = displayText .. string.format("[%s]: %s\n(%s)\n", questType:upper(), title, progress)
                displayText = displayText .. "----------------------------------------------\n"
                
                -- Đánh dấu là nhiệm vụ này vẫn đang tồn tại
                activeQuests[title] = true
            end
        end
        
        -- Dọn dẹp bộ nhớ: Nếu nhiệm vụ cũ đã biến mất khỏi UI, xóa nó khỏi danh sách đã thực thi
        for savedTitle in pairs(executedQuests) do
            if not activeQuests[savedTitle] then
                executedQuests[savedTitle] = nil
            end
        end

        list.Text = (displayText ~= "") and displayText or "Đang đợi nhiệm vụ mới..."
        task.wait(1)
    end
end)

-- ==================== QUÉT NHIỆM VỤ & CHẠY SCRIPT AN TOÀN ====================
task.spawn(function()
    while true do
        for _, questFrame in pairs(questsHolder:GetChildren()) do
            if questFrame:FindFirstChild("Title") then
                local titleText = questFrame.Title.Text
                local lowerTitle = string.lower(titleText)

                -- Chỉ xử lý nếu nhiệm vụ này chưa từng được chạy script
                if not executedQuests[titleText] then
                    for keyword, link in pairs(questScripts) do
                        if string.find(lowerTitle, keyword) then
                            -- Đánh dấu đã xử lý ngay lập tức để tránh trùng lặp do độ trễ mạng HttpGet
                            executedQuests[titleText] = true
                            
                            task.spawn(function()
                                local success, err = pcall(function()
                                    local scriptContent = game:HttpGet(link)
                                    local func, compileErr = loadstring(scriptContent)
                                    if func then
                                        func()
                                        print("✔️ Đã kích hoạt thành công script cho: " .. titleText)
                                    else
                                        warn("❌ Lỗi biên dịch từ khóa " .. keyword .. ": " .. tostring(compileErr))
                                    end
                                end)
                                
                                if not success then
                                    warn("❌ Lỗi kết nối / Tải file cho: " .. titleText .. " | Chi tiết: " .. tostring(err))
                                    executedQuests[titleText] = nil -- Reset lại để thử lại sau nếu bị lỗi mạng
                                end
                            end)
                            
                            break -- Thoát vòng lặp từ khóa, chuyển sang questFrame kế tiếp
                        end
                    end
                end
            end
        end
        task.wait(2)
    end
end)
