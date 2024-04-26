function printSmallGuildNames(memberCount)
	-- this method is supposed to print names of all guilds that have less than memberCount max members
	local selectGuildQuery = "SELECT name FROM guilds WHERE max_members < %d;"
	local resultID = db.storeQuery(string.format(selectGuildQuery, memberCount))

	--The original function was not properly iterating through the returned database entries and
	--displaying them in a legible format.
	if resultID then
		while resultID:next() do
			local guildName = resultID:GetString("name")
			print (guildName)
		end
		--The result set should also be closed once we are finished with it.
		result.free(resultID)
	end
end