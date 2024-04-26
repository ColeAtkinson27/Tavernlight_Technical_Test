function removePlayerFromParty(playerId, membername)
	player = Player(playerId)
	local party = player:getParty()

	--If we did not find a party, then we can just exit early.
	if party == nil then
		return
	end

	for k,v in pairs(party:getMembers()) do
		if v == Player(membername) then
			party:removeMember(Player(membername))
			--Once we have removed the player, we can exit the function instead of
			--looping through the rest of the party.
			return
		end
	end
end