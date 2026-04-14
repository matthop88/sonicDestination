return {
	handleCollisionWithPlayer = function(self, object, player)
		object:onCollisionWithPlayer(player)
	end,

	handleCollisionWithDangerousToNPCs = function(self, object, objectDangerousToNPCs)
		if object.onCollisionWithDangerousToNPCs then
			object:onCollisionWithDangerousToNPCs(objectDangerousToNPCs)
		end
	end,
}
