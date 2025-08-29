-- AKA LEFT 4 SURVIVAL

-- =========================================================
-- EXPLOITS
-- =========================================================
page_exploits:AddToggle({
	Position = UDim2.new(0,20,0,20),
	LabelText = "Hunter Ability Exploit",
	Callback = function(v)
		global_hunterexploit = v
		if global_hunterexploit then
			while global_hunterexploit and game.Players.LocalPlayer.Team==game.Teams do
				for _, v in game.Teams.Zombie:GetPlayers() do
					game.ReplicatedStorage.RemoteEvents.UserInputEvent:FireServer("LungeHit", v)
				end
				task.wait()
			end
		end
	end
})
