local function releaseStorage(player)
	--The value will be set to nil in storage instead on -1. If anyone attempts to perform
	--a check using the value, -1 will evalutate to true when that may not be wanted.
	player:setStorageValue(1000, nil)
end

function onLogout(player)
	if player:getStorageValue(1000) == 1 then
		--There is no reason to tie releaseStorage to an event, unless you are wanting
		--to delay the event.
		releaseStorage (player)
	end
	return true
end