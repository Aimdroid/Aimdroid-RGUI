-- AKA LEFT 4 SURVIVAL

ignore_team=true

-- =========================================================
-- VARIABLES
-- =========================================================

RE = game.ReplicatedStorage.RemoteEvents

-- =========================================================
-- GLOBALS
-- =========================================================

global_hunterexploit=false
global_soundspam=false

-- =========================================================
-- EXPLOITS
-- =========================================================

page_exploits:AddToggle({
	Position = UDim2.new(0,20,0,10),
	LabelText = "Hunter Ability Exploit",
	Callback = function(v)
		global_hunterexploit = v
		if global_hunterexploit then
			game.Players.LocalPlayer.Character.HumanoidRootPart.Anchored=true
			while global_hunterexploit do
				for _, v in game.Teams.Survivors:GetPlayers() do
					RE.UserInputEvent:FireServer("LungeHit", v)
				end
				task.wait()
			end
			game.Players.LocalPlayer.Character.HumanoidRootPart.Anchored=false
		end
	end
})

-- =========================================================
-- MISC
-- =========================================================

page_misc:AddToggle({
	Position = UDim2.new(0,20,0,10),
	LabelText = "Sound Spam",
	Callback = function(v)
		global_soundspam = v
		if global_soundspam then
			while global_soundspam do
				RE.UserInputEvent:FireServer("Lunge")
				task.wait()
			end
		end
	end
})
