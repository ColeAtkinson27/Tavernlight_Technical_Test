void Game::addItemToPlayer(const std::string& recipient, uint16_t itemId) {
	Player* player = g_game.getPlayerByName(recipient);
	if (!player) {
		player = new Player(nullptr);
		if (!IOLoginData::loadPlayerByName(player, recipient)) {
			//The player pointer needs to be cleaned up in the event the load failed
			delete(player);
			return;
		}
	}

	Item* item = Item::CreateItem(itemId);
	if (!item) {
		//The player pointer needs to be cleaned up in the event no item was found
		delete(player);
		return;
	}

	g_game.internalAddItem(player->getInbox(), item, INDEX_WHEREEVER, FLAG_NOLIMIT);

	if (player->isOffline()) {
		IOLoginData::savePlayer(player);
	}

	//Once the player's data is saved, delete the player pointer
	delete(player);
}