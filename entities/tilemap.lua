function tileMapNew()
	tileMapSetSeed(rnd(1000))
	tileMapInit()
end

function tileMapInit()
	carte.position = { x = 45, y = 45 }
	carte.visibility = { x = 10, y = 10}

			carte.tiles[cursor.y][cursor.x].sprite = 13
			carte.tiles[cursor.y][cursor.x].data = {x= cursor.x+1, y =cursor.y+1}
			carte.tiles[cursor.y][cursor.x+1].sprite = 13
			carte.tiles[cursor.y][cursor.x+1].data = {x= cursor.x+1, y =cursor.y+1}
			carte.tiles[cursor.y+1][cursor.x].sprite = 13
			carte.tiles[cursor.y+1][cursor.x].data = {x= cursor.x+1, y =cursor.y+1}
			carte.tiles[cursor.y+1][cursor.x+1].sprite = 68


	cursor.x +=2
	cursor.y +=2		
end

function tileMapSetSeed(seed)
	currentSeed = seed
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
	 		if carte.tiles[y][x].update != nil then
	 			carte.tiles[y][x].update(x,y)
	 		end
	 		if sprite == 64 or sprite == 68 then
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

