function tileMapNew()
	tileMapSetSeed(rnd(1000))
	tileMapInit()
end

function tileMapInit()
	carte.position = { x = 40, y = 40 }
	carte.visibility = { x = 35, y = 35}
end

function tileMapSetSeed(seed)
	init_perlin(seed)
end

function tileMapUpdate()

end

function tileMapDraw()
	 for y = carte.position.y,carte.position.y+carte.visibility.y do
	 	for x = carte.position.x,carte.position.x+carte.visibility.x do
	 		local iso = WorldConverterToIso(x,y)
	 		local sprite = carte.tiles[y][x].sprite
	 		local tailleX = 2
	 		local tailleY = 2
	 		local posX = iso.x
	 		local posY = iso.y
	 		if sprite == 64 then
	 			iso = WorldConverterToIso(x-1,y)
	 			posX = iso.x
	 			posY = iso.y - 12
	 			tailleY = 4
	 			tailleX = 4
	 		end
	 		spr(sprite,posX,posY,tailleX,tailleY)
	 	end
	 end
end

