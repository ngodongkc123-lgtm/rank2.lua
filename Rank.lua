-- DANH SÁCH SCRIPT THEO TỪ KHÓA (giữ nguyên mẫu)
local questScripts = {
    ["coin jar"]  = "https://raw.githubusercontent.com/quocngo1412/Rank/refs/heads/main/CoinJar.lua",
    ["comet"]     = "https://raw.githubusercontent.com/quocngo1412/Rank/refs/heads/main/Comet.lua",
    ["lucky block"] = "https://raw.githubusercontent.com/quocngo1412/Rank/refs/heads/main/LuckyBlock.lua",
    ["pinata"]    = "https://raw.githubusercontent.com/quocngo1412/Rank/refs/heads/main/Pinata.lua",
    ["egg"]       = "https://raw.githubusercontent.com/quocngo1412/Rank/refs/heads/main/Egg.lua",
    ["gold"]      = "https://raw.githubusercontent.com/quocngo1412/Rank/refs/heads/main/Gold.lua",
    ["rainbow"]   = "https://raw.githubusercontent.com/quocngo1412/Rank/refs/heads/main/Rainbow.lua"
}

-- ==================== TẠO UI ====================
local Players = game:GetService("Players")
local playerGui = Players.LocalPlayer:WaitForChild("PlayerGui")

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "QuestTracker"
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
spawn(function()
    while true do
        local displayText = ""
        for _, questFrame in pairs(questsHolder:GetChildren()) do
            if questFrame:FindFirstChild("Title") and questFrame:FindFirstChild("Progress") then
                local questType = questFrame.Name
                local title = questFrame.Title.Text
                local progress = questFrame.Progress.Text
                displayText = displayText .. string.format("[%s]: %s\n(%s)\n", questType:upper(), title, progress)
                displayText = displayText .. "----------------------------------------------\n"
            end
        end
        list.Text = (displayText ~= "") and displayText or "Đang đợi nhiệm vụ mới..."
        task.wait(1)
    end
end)

-- ==================== QUÉT TOÀN BỘ NHIỆM VỤ & CHẠY SCRIPT ====================
spawn(function()
    while true do
        for _, questFrame in pairs(questsHolder:GetChildren()) do
            if questFrame:FindFirstChild("Title") then
                local titleText = questFrame.Title.Text
                local lowerTitle = string.lower(titleText)

                for keyword, link in pairs(questScripts) do
                    if string.find(lowerTitle, string.lower(keyword)) then
                        pcall(function()
                            loadstring(game:HttpGet(link))()
                        end)
                        break -- Mỗi nhiệm vụ chỉ chạy 1 script (ưu tiên từ khóa đầu tiên khớp)
                    end
                end
            end
        end
        task.wait(0.8)
    end
end)
