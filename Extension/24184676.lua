-- AKA LEFT 4 SURVIVAL

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
			while global_hunterexploit and game.Players.LocalPlayer.Team==game.Teams do
				for _, v in game.Teams.Zombie:GetPlayers() do
					RE.UserInputEvent:FireServer("LungeHit", v)
				end
				task.wait()
			end
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
