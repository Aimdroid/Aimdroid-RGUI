-- =========================================================
-- LOCAL MODE SETUP
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

function access_check()
	return pcall(function() Instance.new("BoolValue").Parent = game:GetService("CoreGui") end)
end

for i = 1, 120 do
	task.wait(0.1)
	if mode then break end
end
if not mode then return end

-- =========================================================
-- DRAWBOX FUNCTION
-- =========================================================
local function DrawBox(parent, x, y, width, height, thickness)
	thickness = thickness or 2
	local color = Color3.new(1, 1, 1)

	local mainFrame = Instance.new("Frame")
	mainFrame.Size = UDim2.new(0, width, 0, height)
	mainFrame.Position = UDim2.new(0, x, 0, y)
	mainFrame.BackgroundTransparency = 1
	mainFrame.BorderSizePixel = 0
	mainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
	mainFrame.Parent = parent

	local top = Instance.new("Frame")
	top.Size = UDim2.new(1, 0, 0, thickness)
	top.Position = UDim2.new(0, 0, 0, 0)
	top.BackgroundColor3 = color
	top.BorderSizePixel = 0
	top.Parent = mainFrame

	local bottom = Instance.new("Frame")
	bottom.Size = UDim2.new(1, 0, 0, thickness)
	bottom.Position = UDim2.new(0, 0, 1, -thickness)
	bottom.BackgroundColor3 = color
	bottom.BorderSizePixel = 0
	bottom.Parent = mainFrame

	local left = Instance.new("Frame")
	left.Size = UDim2.new(0, thickness, 1, 0)
	left.Position = UDim2.new(0, 0, 0, 0)
	left.BackgroundColor3 = color
	left.BorderSizePixel = 0
	left.Parent = mainFrame

	local right = Instance.new("Frame")
	right.Size = UDim2.new(0, thickness, 1, 0)
	right.Position = UDim2.new(1, -thickness, 0, 0)
	right.BackgroundColor3 = color
	right.BorderSizePixel = 0
	right.Parent = mainFrame

	return mainFrame
end

-- =========================================================
-- TUNGTUNG UI LIBRARY
-- =========================================================
local TungTungUI = {}
TungTungUI.__index = TungTungUI

local Players = game:GetService("Players")
local player = Players.LocalPlayer
local PlayerGui = player:WaitForChild("PlayerGui")
local UserInputService = game:GetService("UserInputService")

TungTungUI.Panels = {}

function TungTungUI:CreateMainWindow(name, properties)
	properties = properties or {}
	local window = {}

	window.Name = name or "MainWindow"
	window.Size = properties.Size or UDim2.new(0, 500, 0, 380)
	window.Position = properties.Position or UDim2.new(0.5, 0, 0.5, 0)
	window.AnchorPoint = Vector2.new(0.5, 0.5)
	window.BackgroundColor = properties.BackgroundColor or Color3.fromRGB(30, 30, 30)

	window.ScreenGui = Instance.new("ScreenGui")
	window.ScreenGui.Name = window.Name
	window.ScreenGui.ScreenInsets = Enum.ScreenInsets.None
	window.ScreenGui.ResetOnSpawn = false
	if mode == "Undetected" then
		window.ScreenGui.Parent = game:GetService("CoreGui")
	else
		window.ScreenGui.Parent = PlayerGui
	end

	window.drawboxes = Instance.new("Folder")
	window.drawboxes.Parent = window.ScreenGui

	window.Frame = Instance.new("Frame")
	window.Frame.Size = window.Size
	window.Frame.Position = window.Position
	window.Frame.AnchorPoint = window.AnchorPoint
	window.Frame.BackgroundTransparency = 1
	window.Frame.Parent = window.ScreenGui

	local TOPBAR_HEIGHT = 45
	window.TopBar = Instance.new("Frame")
	window.TopBar.Size = UDim2.new(1, 0, 0, TOPBAR_HEIGHT)
	window.TopBar.Position = UDim2.new(0, 0, 0, 0)
	window.TopBar.BackgroundColor3 = Color3.fromRGB(180, 0, 0)
	window.TopBar.BorderSizePixel = 0
	window.TopBar.Parent = window.Frame

	window.Icon = Instance.new("ImageLabel")
	window.Icon.Position = UDim2.new(0, 0, 0, 0)
	window.Icon.BackgroundColor3 = Color3.fromRGB(120, 0, 0)
	window.Icon.BorderSizePixel = 0
	window.Icon.Image = "rbxassetid://9389749368"
	window.Icon.ScaleType = Enum.ScaleType.Fit
	window.Icon.Parent = window.TopBar

	local function updateIconSize()
		window.Icon.Size = UDim2.new(0, window.TopBar.AbsoluteSize.Y, 1, 0)
	end
	updateIconSize()
	window.TopBar:GetPropertyChangedSignal("AbsoluteSize"):Connect(updateIconSize)

	window.BottomBar = Instance.new("Frame")
	window.BottomBar.Size = UDim2.new(1, 0, 0, 25)
	window.BottomBar.Position = UDim2.new(0, 0, 1, -25)
	window.BottomBar.BackgroundColor3 = Color3.fromRGB(180, 0, 0)
	window.BottomBar.BorderSizePixel = 0
	window.BottomBar.Parent = window.Frame

	local bottomLabel = Instance.new("TextLabel")
	bottomLabel.Size = UDim2.new(1, 0, 1, 0)
	bottomLabel.BackgroundTransparency = 1
	bottomLabel.Text = "   Aimdroid v1"
	bottomLabel.TextXAlignment = Enum.TextXAlignment.Left
	bottomLabel.TextColor3 = Color3.fromRGB(230, 230, 230)
	bottomLabel.Font = Enum.Font.GothamBold
	bottomLabel.TextSize = 16
	bottomLabel.Parent = window.BottomBar

	window.PageContainer = Instance.new("Frame")
	window.PageContainer.Size = UDim2.new(1, 0, 1, -TOPBAR_HEIGHT-25)
	window.PageContainer.Position = UDim2.new(0, 0, 0, TOPBAR_HEIGHT)
	window.PageContainer.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
	window.PageContainer.BorderSizePixel = 0
	window.PageContainer.Parent = window.Frame

	window.Pages = {}
	window.PageButtons = {}

	do
		local dragging, dragInput, dragStart, startPos
		window.TopBar.InputBegan:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 then
				dragging = true
				dragStart = input.Position
				startPos = window.Frame.Position
				input.Changed:Connect(function()
					if input.UserInputState == Enum.UserInputState.End then
						dragging = false
					end
				end)
			end
		end)
		window.TopBar.InputChanged:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseMovement then
				dragInput = input
			end
		end)
		UserInputService.InputChanged:Connect(function(input)
			if input == dragInput and dragging then
				local delta = input.Position - dragStart
				window.Frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X,
					startPos.Y.Scale, startPos.Y.Offset + delta.Y)
			end
		end)
	end

	function window:AddPage(name)
		local page = Instance.new("Frame")
		page.Size = UDim2.new(1, 0, 1, 0)
		page.Position = UDim2.new(0, 0, 0, 0)
		page.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
		page.BorderSizePixel = 0
		page.Visible = false
		page.Parent = self.PageContainer

		self.Pages[name] = page

		local PADDING = 5
		local button = Instance.new("TextButton")
		local ICON_GAP = window.Icon.Size.X.Offset + 5
		button.Size = UDim2.new(0, 80, 1, -PADDING)
		button.Position = UDim2.new(0, ICON_GAP + (#self.PageButtons * (80 + 5)), 0, PADDING)
		button.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
		button.TextColor3 = Color3.fromRGB(255, 255, 255)
		button.Font = Enum.Font.Gotham
		button.TextSize = 16
		button.Text = name
		button.BorderSizePixel = 0
		button.Modal = true
		button.Parent = self.TopBar

		button.MouseButton1Click:Connect(function()
			for _, pg in pairs(self.Pages) do
				pg.Visible = false
			end
			page.Visible = true
		end)

		table.insert(self.PageButtons, button)

		local pageObj = {}
		pageObj.Frame = page

		function pageObj:AddToggle(props)
			props = props or {}
			local toggle = {}
			toggle.Size = props.Size or UDim2.new(0, 50, 0, 25)
			toggle.Position = props.Position or UDim2.new(0, 10, 0, 10)
			toggle.LabelText = props.LabelText or "Toggle"
			toggle.Value = props.Value or false
			toggle.Callback = props.Callback or function() end
			toggle.CircleColor = props.CircleColor or Color3.fromRGB(180, 0, 0)

			toggle.Frame = Instance.new("Frame")
			toggle.Frame.Size = toggle.Size
			toggle.Frame.Position = toggle.Position
			toggle.Frame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
			toggle.Frame.BorderSizePixel = 0
			toggle.Frame.Parent = page

			local corner = Instance.new("UICorner")
			corner.CornerRadius = UDim.new(0, 12)
			corner.Parent = toggle.Frame

			toggle.Circle = Instance.new("Frame")
			toggle.Circle.Size = UDim2.new(0, 23, 0, 23)
			toggle.Circle.Position = UDim2.new(0, 1, 0, 1)
			toggle.Circle.BackgroundColor3 = toggle.Value and Color3.fromRGB(0, 255, 0) or toggle.CircleColor
			toggle.Circle.Parent = toggle.Frame

			local circleCorner = Instance.new("UICorner")
			circleCorner.CornerRadius = UDim.new(0, 12)
			circleCorner.Parent = toggle.Circle

			toggle.Label = Instance.new("TextLabel")
			toggle.Label.Size = UDim2.new(0, 120, 0, 25)
			toggle.Label.Position = UDim2.new(0, 60, 0, 0)
			toggle.Label.BackgroundTransparency = 1
			toggle.Label.Text = toggle.LabelText
			toggle.Label.TextColor3 = Color3.fromRGB(230, 230, 230)
			toggle.Label.Font = Enum.Font.Gotham
			toggle.Label.TextSize = 16
			toggle.Label.TextXAlignment = Enum.TextXAlignment.Left
			toggle.Label.Parent = toggle.Frame

			toggle.Frame.InputBegan:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 then
					toggle.Value = not toggle.Value
					if toggle.Value then
						toggle.Circle:TweenPosition(UDim2.new(1, -24, 0, 1), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.2, true)
						toggle.Circle.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
					else
						toggle.Circle:TweenPosition(UDim2.new(0, 1, 0, 1), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.2, true)
						toggle.Circle.BackgroundColor3 = toggle.CircleColor
					end
					toggle.Callback(toggle.Value)
				end
			end)

			return toggle
		end

		function pageObj:AddDropdown(properties)
			properties = properties or {}
			local dropdown = {}

			dropdown.Position = properties.Position or UDim2.new(0, 10, 0, 10)
			dropdown.Size = properties.Size or UDim2.new(0, 150, 0, 25)
			dropdown.Options = properties.Options or {"Option1", "Option2"}
			dropdown.Selected = dropdown.Options[1]
			dropdown.Callback = properties.Callback or function() end
			dropdown.LabelText = properties.LabelText

			dropdown.Frame = Instance.new("Frame")
			dropdown.Frame.Size = dropdown.Size
			dropdown.Frame.Position = dropdown.Position
			dropdown.Frame.BackgroundColor3 = properties.BackgroundColor or Color3.fromRGB(50, 50, 50)
			dropdown.Frame.BorderSizePixel = 0
			dropdown.Frame.Parent = pageObj.Frame

			dropdown.ValueLabel = Instance.new("TextLabel")
			dropdown.ValueLabel.Size = UDim2.new(1, -20, 1, 0)
			dropdown.ValueLabel.Position = UDim2.new(0, 5, 0, 0)
			dropdown.ValueLabel.BackgroundTransparency = 1
			dropdown.ValueLabel.Text = dropdown.Selected
			dropdown.ValueLabel.TextColor3 = Color3.fromRGB(230, 230, 230)
			dropdown.ValueLabel.Font = Enum.Font.Gotham
			dropdown.ValueLabel.TextSize = 16
			dropdown.ValueLabel.TextXAlignment = Enum.TextXAlignment.Left
			dropdown.ValueLabel.Parent = dropdown.Frame

			dropdown.Button = Instance.new("TextButton")
			dropdown.Button.Size = UDim2.new(0, 20, 1, 0)
			dropdown.Button.Position = UDim2.new(1, -20, 0, 0)
			dropdown.Button.BackgroundTransparency = 1
			dropdown.Button.Text = "▼"
			dropdown.Button.TextColor3 = Color3.fromRGB(230, 230, 230)
			dropdown.Button.Font = Enum.Font.Gotham
			dropdown.Button.TextSize = 16
			dropdown.Button.Parent = dropdown.Frame

			dropdown.List = Instance.new("Frame")
			dropdown.List.Size = UDim2.new(1, 0, 0, #dropdown.Options * 25)
			dropdown.List.Position = UDim2.new(0, 0, 1, 0)
			dropdown.List.BackgroundColor3 = properties.ListColor or Color3.fromRGB(40, 40, 40)
			dropdown.List.BorderSizePixel = 0
			dropdown.List.Visible = false
			dropdown.List.Parent = dropdown.Frame

			for i, option in ipairs(dropdown.Options) do
				local item = Instance.new("TextButton")
				item.Size = UDim2.new(1, 0, 0, 25)
				item.Position = UDim2.new(0, 0, 0, (i-1) * 25)
				item.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
				item.BorderSizePixel = 0
				item.Text = option
				item.TextColor3 = Color3.fromRGB(230, 230, 230)
				item.Font = Enum.Font.Gotham
				item.TextSize = 16
				item.Parent = dropdown.List

				item.MouseButton1Click:Connect(function()
					dropdown.Selected = option
					dropdown.ValueLabel.Text = option
					dropdown.List.Visible = false
					dropdown.Callback(option)
				end)
			end

			dropdown.Button.MouseButton1Click:Connect(function()
				dropdown.List.Visible = not dropdown.List.Visible
			end)

			if dropdown.LabelText then
				dropdown.RightLabel = Instance.new("TextLabel")
				dropdown.RightLabel.Size = UDim2.new(0, 120, 0, 25)
				dropdown.RightLabel.Position = UDim2.new(0, dropdown.Position.X.Offset + dropdown.Size.X.Offset + 10, 0, dropdown.Position.Y.Offset)
				dropdown.RightLabel.BackgroundTransparency = 1
				dropdown.RightLabel.Text = dropdown.LabelText
				dropdown.RightLabel.TextColor3 = Color3.fromRGB(230, 230, 230)
				dropdown.RightLabel.Font = Enum.Font.Gotham
				dropdown.RightLabel.TextSize = 16
				dropdown.RightLabel.TextXAlignment = Enum.TextXAlignment.Left
				dropdown.RightLabel.Parent = pageObj.Frame
			end

			return dropdown
		end

		return pageObj
	end

	TungTungUI.Panels[name] = window
	return window
end

-- =========================================================
-- ENTITY FETCHING (ESP HELPERS + CHECK)
-- =========================================================
local esp_models = {}

local function ispossibleray(p)
	if not p:IsA("BasePart") then return false end
	local tung = 0.5
	local size = p.Size
	local dims = {size.X, size.Y, size.Z}
	table.sort(dims)
	return dims[1] <= tung and dims[2] <= tung
end
ignore_team=false
local function get_nearest_object()
	local localPlayer = game.Players.LocalPlayer
	local character = localPlayer.Character
	if not character or not character:FindFirstChild("HumanoidRootPart") then return nil end
	local cam = workspace.CurrentCamera
	local localRootPos = character.HumanoidRootPart.Position

	local closestPart = nil
	local closestDist = math.huge

	for _, v in ipairs(esp_models) do
		if v.model then
			if ignore_team and v.colour==game.Players.LocalPlayer.TeamColor.Color then continue end
			local partsToCheck = {v.model:FindFirstChild("HumanoidRootPart"), v.model:FindFirstChild("Head")}
			for _, part in ipairs(partsToCheck) do
				if part then
					local direction = part.Position - cam.CFrame.Position
					local raycastParams = RaycastParams.new()
					raycastParams.FilterDescendantsInstances = {character, part.Parent}
					raycastParams.FilterType = Enum.RaycastFilterType.Exclude
					raycastParams.IgnoreWater = true

					local maxDistance = direction.Magnitude
					local origin = cam.CFrame.Position
					local remainingDistance = maxDistance
					local hitPart
					repeat
						local result = workspace:Raycast(origin, direction.Unit * remainingDistance, raycastParams)
						if not result then hitPart = nil break end
						if ispossibleray(result.Instance) then
							local traveled = (result.Position - origin).Magnitude + 0.01
							remainingDistance = remainingDistance - traveled
							origin = result.Position + direction.Unit * 0.01
							raycastParams.FilterDescendantsInstances = {character, part.Parent, result.Instance}
						else
							hitPart = result.Instance
							break
						end
					until remainingDistance <= 0

					if not hitPart then
						local dist = (part.Position - localRootPos).Magnitude
						if dist < closestDist then
							closestDist = dist
							closestPart = part
						end
					end
				end
			end
		end
	end
	return closestPart
end

function WaitForChildOfClass(parent, className, timeOut)
	local waitTime = 0
	local warned = false
	repeat
		local obj = parent:FindFirstChildOfClass(className)
		if obj then return obj end
		waitTime = waitTime + wait()
		if timeOut and waitTime > timeOut then return nil end
		if not warned and waitTime > 5 then
			warn("Infinite yield possible waiting on", parent:GetFullName() .. ":FindFirstChildOfClass(\"".. className .. "\")")
			warned = true
		end
	until false
end

local function new_esp_object()
	return {model=nil, drawbox=nil, colour=Color3.new(1,1,1)}
end

function esp_check(h)
	if not h:IsA("Model") then return end
	if not h:WaitForChild("HumanoidRootPart", 8) then return end
	local humanoid = WaitForChildOfClass(h, "Humanoid", 8)
	if not humanoid then return end
	for _, s in ipairs(esp_models) do
		if s.model == h then return end
	end
	local struct = new_esp_object()
	struct.model = h

	local plrcheck = game.Players:GetPlayerFromCharacter(h)
	if plrcheck then
		if plrcheck == game.Players.LocalPlayer then return end
		struct.colour = plrcheck.TeamColor.Color
		plrcheck:GetPropertyChangedSignal("TeamColor"):Connect(function()
			struct.colour = plrcheck.TeamColor.Color
		end)
	end

	table.insert(esp_models, struct)

	local function cleanup()
		for i = #esp_models, 1, -1 do
			if esp_models[i].model == h then
				if esp_models[i].drawbox then
					esp_models[i].drawbox:Destroy()
				end
				table.remove(esp_models, i)
			end
		end
	end

	humanoid.Died:Connect(cleanup)
	h.AncestryChanged:Connect(function(_, parent)
		if not parent then cleanup() end
	end)
end

workspace.DescendantAdded:Connect(esp_check)
for _, h in workspace:GetDescendants() do task.spawn(esp_check, h) end

-- =========================================================
-- WINDOW CREATION
-- =========================================================
local mainWin = TungTungUI:CreateMainWindow("MainWindow", {Size = UDim2.new(0, 550, 0, 410)})

local page_legitbot = mainWin:AddPage("LegitBot")
local page_ragebot = mainWin:AddPage("RageBot")
local page_rendering = mainWin:AddPage("Rendering")
local page_exploits = mainWin:AddPage("Exploits")
local page_misc = mainWin:AddPage("Misc")

-- =========================================================
-- GLOBAL VARIABLES
-- =========================================================
global_esp = false
global_rage = false
global_m1 = false
global_antiaim = false
global_antiaim_mode = "Backwards"
global_aimbot = false
global_hunterexploit = false

-- =========================================================
-- INPUT HANDLING
-- =========================================================
game:GetService("UserInputService").InputBegan:Connect(function(h, hh)
	if hh then return end
	if h.UserInputType == Enum.UserInputType.MouseButton1 then global_m1 = true end
	if h.KeyCode == Enum.KeyCode.Insert then mainWin.Frame.Visible = not mainWin.Frame.Visible end
end)
game:GetService("UserInputService").InputEnded:Connect(function(h)
	if h.UserInputType == Enum.UserInputType.MouseButton1 then global_m1 = false end
end)

-- =========================================================
-- LEGITBOT
-- =========================================================
page_legitbot:AddToggle({
	Position = UDim2.new(0,20,0,10),
	LabelText = "Aimbot",
	Callback = function(v)
		global_aimbot = v
		if not global_aimbot then return end
		while global_aimbot do
			local objp = get_nearest_object()
			if global_m1 and objp then
				workspace.CurrentCamera.CFrame = CFrame.lookAt(
					workspace.CurrentCamera.Focus.Position - (objp.Position - workspace.CurrentCamera.Focus.Position).Unit *
						math.max((workspace.CurrentCamera.CFrame.Position - workspace.CurrentCamera.Focus.Position).Magnitude, 0),
					objp.Position
				)
				game:GetService("RunService").RenderStepped:Wait()
			else
				game:GetService("RunService").Heartbeat:Wait()
			end
		end
	end
})

-- =========================================================
-- RAGEBOT
-- =========================================================
page_ragebot:AddToggle({
	Position = UDim2.new(0,20,0,10),
	LabelText = "Ragebot",
	Callback = function(v)
		global_rage = v
		if not global_rage then return end
		game:GetService("UserInputService").MouseBehavior = Enum.MouseBehavior.LockCenter
		while global_rage do
			local objp = get_nearest_object()
			if global_m1 and objp then
				local og = workspace.CurrentCamera.CFrame
				workspace.CurrentCamera.CFrame = CFrame.lookAt(
					workspace.CurrentCamera.Focus.Position - (objp.Position - workspace.CurrentCamera.Focus.Position).Unit *
						math.max((workspace.CurrentCamera.CFrame.Position - workspace.CurrentCamera.Focus.Position).Magnitude, 12),
					objp.Position
				)
				game:GetService("RunService").RenderStepped:Wait()
				workspace.CurrentCamera.CFrame = og
				game:GetService("RunService").Heartbeat:Wait()
			else
				game:GetService("RunService").Heartbeat:Wait()
			end
		end
		game:GetService("UserInputService").MouseBehavior = Enum.MouseBehavior.Default
	end
})

page_ragebot:AddToggle({
	Position = UDim2.new(0,20,0,50),
	LabelText = "Anti Aim",
	Callback = function(v)
		global_antiaim = v
		if not global_antiaim then return end
		local root = game.Players.LocalPlayer.Character.HumanoidRootPart
		root.Parent.Humanoid.AutoRotate = false
		while global_antiaim do
			if global_antiaim_mode == "Backwards" then
				if root.Parent.Humanoid.MoveDirection.Magnitude > 0 then
					task.wait(0.3)
					if root.Parent.Humanoid.MoveDirection.Magnitude <= 0 then continue end
					root.CFrame = CFrame.lookAt(root.Position, root.Position - root.Parent.Humanoid.MoveDirection)
				end
			end
			task.wait(0.035)
		end
		root.Parent.Humanoid.AutoRotate = true
	end
})

local dropdown = page_ragebot:AddDropdown({
	Position = UDim2.new(0,20,0,90),
	Options = {"Backwards", "Spin", "Jitter", "Random"},
	LabelText = "Anti Aim Mode",
	Callback = function(choice) global_antiaim_mode = choice end
})

-- =========================================================
-- RENDERING (ESP)
-- =========================================================
page_rendering:AddToggle({
	Position = UDim2.new(0,20,0,20),
	LabelText = "ESP",
	Callback = function(v)
		global_esp = v

		local referenceDistance = 20
		local referenceWidth = 50
		local minWidth = 1
		local maxWidth = 200

		if global_esp then
			while global_esp do
				for _, struct in ipairs(esp_models) do
					local model = struct.model
					local hrp = model:FindFirstChild("HumanoidRootPart")
					if not hrp then continue end
					if not struct.drawbox then
						struct.drawbox = DrawBox(mainWin.drawboxes, 0, 0, referenceWidth, referenceWidth*1.5, 1)
						struct.drawbox.Visible = true
					end
					local cam = workspace.CurrentCamera
					local topWorld = hrp.Position + Vector3.new(0,2.5,0)
					local bottomWorld = hrp.Position + Vector3.new(0,-3.5,0)
					local topScreen, topVisible = cam:WorldToViewportPoint(topWorld)
					local bottomScreen, bottomVisible = cam:WorldToViewportPoint(bottomWorld)
					local hrpScreen, hrpVisible = cam:WorldToViewportPoint(hrp.Position)
					if not (topVisible or bottomVisible or hrpVisible) then struct.drawbox.Visible=false continue end
					local distance = (cam.CFrame.Position - hrp.Position).Magnitude
					local targetWidth = math.clamp(referenceWidth*(referenceDistance/math.max(distance,0.001)),minWidth,maxWidth)
					local targetHeight = math.abs(topScreen.Y-bottomScreen.Y)
					local centerX = hrpScreen.X
					local centerY = (topScreen.Y+bottomScreen.Y)/2
					struct.drawbox.Visible=true
					struct.drawbox.Position=UDim2.new(0,centerX,0,centerY)
					struct.drawbox.Size=UDim2.new(0,math.floor(targetWidth+0.5),0,math.floor(targetHeight+0.5))
					for _, v in ipairs(struct.drawbox:GetChildren()) do
						v.BackgroundColor3=struct.colour
					end
				end
				game:GetService("RunService").RenderStepped:Wait()
			end
			for _, struct in ipairs(esp_models) do
				if struct.drawbox then struct.drawbox.Visible=false end
			end
		end
	end
})
