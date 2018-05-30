function houseupdate(x,y)	
	if city.population>0 then
		if(day.tick == 1)then
			local pos = WorldConverterToIso(x,y)
			pos.x -= cam.x
			pos.y -= cam.y
			DecorsManagerAdd(192, pos.x-4, pos.y, 93, 2, "")

			DecorsManagerAdd(194, pos.x+4, pos.y, 93, 2, "")
		end
	end
end


function fermeupdate(x,y)
	if city.population>0 then
	if(day.tick == 1)then
		local pos = WorldConverterToIso(x,y)
		pos.x -= cam.x
		pos.y -= cam.y
		city.ressources.water -= 1

		if(city.ressources.water < 0) then
			-- si pas assez d'eau
			city.population += flr(city.ressources.water*1.5)
			city.ressources.water = 0
			
		end

		DecorsManagerAdd(194, 63, 2, pos.x+4, pos.y+4, "")
	end
	if(day.tick == 2)then
		carte.tiles[y][x].datas.day+=1
		if carte.tiles[y][x].datas.day == 2 then
			carte.tiles[y][x].sprite += 2
		end
		if carte.tiles[y][x].datas.day == 3 then
			carte.tiles[y][x].sprite -= 2
			carte.tiles[y][x].datas.day = 0

			local pos = WorldConverterToIso(x,y)
			pos.x -= cam.x
			pos.y -= cam.y

			city.ressources.food += levels.ferme

			DecorsManagerAdd(192, pos.x,pos.y, 3,2, "+"..levels.ferme)

		end
	end
	end
end

function chateaudeauupdate(x,y)
	if city.population>0 then
	if(day.tick == 2)then
		
		
			carte.tiles[y][x].datas.day = 0

			local pos = WorldConverterToIso(x,y)
			pos.x -= cam.x
			pos.y -= cam.y
			city.ressources.water += levels.chateau
			DecorsManagerAdd(194, pos.x,pos.y, 63, 2, "+"..levels.chateau)
		
	end
	end
end

function boisupdate(x,y)
	if city.population>0 then
	carte.tiles[y][x].sprite = 45
	
	--test foret
	if carte.tiles[y-1][x].sprite == 33 or carte.tiles[y+1][x].sprite == 33 or carte.tiles[y][x-1].sprite == 33 or carte.tiles[y][x+1].sprite == 33 then
		if(day.tick == 2)then
			local pos = WorldConverterToIso(x,y)
			pos.x -= cam.x
			pos.y -= cam.y
			city.ressources.wood += levels.bois
			DecorsManagerAdd(193, pos.x,pos.y, 33, 2, "+"..levels.bois)
		end
	else
			carte.tiles[y][x].sprite = 132
	end

	end
end