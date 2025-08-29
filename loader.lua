-- =========================================================
-- MODE SETUP
-- =========================================================
local mode
local entryfunc = Instance.new("BindableFunction")
function entryfunc.OnInvoke(str)
	mode = str
end

game:GetService("StarterGui"):SetCore("SendNotification", {
	Title = "Aimdroid v1",
	Text = "Load Aimdroid GUI As:",
	Icon = "rbxassetid://9389749368",
	Duration = 10,
	Callback = entryfunc,
	Button1 = "Undetected",
	Button2 = "Legacy"
})

for i = 1, 120 do
	task.wait(0.1)
	if mode then break end
end
if not mode then return end

Identification = nil

-- ScreenGui
local loaderGui = Instance.new("ScreenGui")
loaderGui.Name = "LoaderGui"
loaderGui.ResetOnSpawn = false
loaderGui.IgnoreGuiInset = true
if mode=="Undetected" then
	loaderGui.Parent = game:GetService("CoreGui")
else
	loaderGui.Parent = game.Players.LocalPlayer.PlayerGui
end

-- Main Frame (wider centered box)
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 500, 0, 200) 
mainFrame.Position = UDim2.new(0.5, -250, 0.5, -100)
mainFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
mainFrame.BorderSizePixel = 0
mainFrame.Parent = loaderGui

-- UICorner for rounded edges
local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 8)
corner.Parent = mainFrame

-- Top Bar
local topBar = Instance.new("Frame")
topBar.Size = UDim2.new(1, 0, 0, 30)
topBar.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
topBar.BorderSizePixel = 0
topBar.Parent = mainFrame

local topCorner = Instance.new("UICorner")
topCorner.CornerRadius = UDim.new(0, 8)
topCorner.Parent = topBar

-- Title
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -40, 1, 0)
title.Position = UDim2.new(0, 10, 0, 0)
title.BackgroundTransparency = 1
title.Text = "Aimdroid Loader"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Font = Enum.Font.GothamBold
title.TextSize = 16
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = topBar

-- Close Button
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 30, 0, 30)
closeBtn.Position = UDim2.new(1, -30, 0, 0)
closeBtn.BackgroundTransparency = 1
closeBtn.Text = "X"
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 18
closeBtn.TextColor3 = Color3.fromRGB(255, 75, 75)
closeBtn.Parent = topBar

-- Load Button (red)
local loadBtn = Instance.new("TextButton")
loadBtn.Size = UDim2.new(0, 300, 0, 40)
loadBtn.Position = UDim2.new(0.5, -150, 0.5, -40)
loadBtn.BackgroundColor3 = Color3.fromRGB(220, 50, 50)
loadBtn.Text = "Aimdroid v1 For ROBLOX"
loadBtn.Font = Enum.Font.GothamBold
loadBtn.TextSize = 16
loadBtn.TextColor3 = Color3.new(1,1,1)
loadBtn.Parent = mainFrame

local loadCorner = Instance.new("UICorner")
loadCorner.CornerRadius = UDim.new(0, 6)
loadCorner.Parent = loadBtn

-- Fetching Button (grey)
local fetchBtn = Instance.new("TextButton")
fetchBtn.Size = UDim2.new(0, 300, 0, 40)
fetchBtn.Position = UDim2.new(0.5, -150, 0.5, 20)
fetchBtn.BackgroundColor3 = Color3.fromRGB(120, 120, 120)
fetchBtn.Text = "Fetching..."
fetchBtn.Font = Enum.Font.GothamBold
fetchBtn.TextSize = 16
fetchBtn.TextColor3 = Color3.new(1,1,1)
fetchBtn.AutoButtonColor = false
fetchBtn.Active=false
fetchBtn.Parent = mainFrame

local fetchCorner = Instance.new("UICorner")
fetchCorner.CornerRadius = UDim.new(0, 6)
fetchCorner.Parent = fetchBtn


--==================================================
-- DRAGGING FUNCTIONALITY
--==================================================
do
	local dragging = false
	local dragInput, dragStart, startPos

	local function update(input)
		local delta = input.Position - dragStart
		mainFrame.Position = UDim2.new(
			startPos.X.Scale, startPos.X.Offset + delta.X,
			startPos.Y.Scale, startPos.Y.Offset + delta.Y
		)
	end

	topBar.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = true
			dragStart = input.Position
			startPos = mainFrame.Position
			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					dragging = false
				end
			end)
		end
	end)

	topBar.InputChanged:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement then
			dragInput = input
		end
	end)

	game:GetService("UserInputService").InputChanged:Connect(function(input)
		if input == dragInput and dragging then
			update(input)
		end
	end)
end


--==================================================
-- FUNCTIONS
--==================================================

function Identify()
	local url = "https://raw.githubusercontent.com/Aimdroid/Aimdroid-RGUI/refs/heads/main/Extension/" .. game.PlaceId .. ".lua"
	local success, result = pcall(function()
		return game:HttpGet(url)
	end)
	if success and result and #result > 0 then
		return url
	else
		return false
	end
end

-- Close button logic
closeBtn.MouseButton1Click:Connect(function()
	loaderGui:Destroy()
end)

-- Load button logic
local function LoadAimdroid()
	loadstring(game:HttpGet("https://raw.githubusercontent.com/Aimdroid/Aimdroid-RGUI/refs/heads/main/main.lua"))()
end

loadBtn.MouseButton1Click:Connect(function()
	LoadAimdroid()
end)

fetchBtn.MouseButton1Click:Connect(function()
	LoadAimdroid()
	loadstring(game:HttpGet(Identification))()
end)

--==================================================
-- IDENTIFICATION
--==================================================

Identification=Identify()

if Identification then
	local name
	pcall(function()
		name = game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name
	end)
	fetchBtn.Text="Load Aimdroid For "..(name or "TUNG TUNG TUNG TUNG TUNG TUNG TUNG TUNG")
	fetchBtn.BackgroundColor3=Color3.new(0,1,0)
	fetchBtn.Active=true
else
	fetchBtn.Text="Game not supported"
end
