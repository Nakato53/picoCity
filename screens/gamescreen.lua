function GameScreenNew()
	t = 0
	cameraNew()
	tileMapNew()
	cursorInit()
	currentState = "move"
	city = {
		ressources = {
			food = 100,
			wood = 40,
			water = 50
		},
		population = 10

	}
	cameraCenterOn(cursor.x,cursor.y)
	
	day = {
		current = 450,
		max = 900,
		step = 2
	}

	return {
		update = GameScreenUpdate,
		draw = GameScreenDraw
	}
end

function GameScreenUpdate()
	
	t+=1
	
	day.current += day.step
	if day.current > day.max*1.5 or day.current < 250 then
		day.step *=-1
	end


	if(currentState == "build") then

		if btnp(5,0) and (cursor.canConstruct or buildBar.position==1) then
			GameScreenBuildSelection()
		end

		if btnp(4,0) then 
			currentState = "move" 
			cursor.size = 1
		end

		if btnp(0,0) then 
			buildBar.position-=1
			if buildBar.position < 1 then 
				buildBar.position = #buildBar.tiles
			end
			GameScreenSelectBuildTool()
		end
		if btnp(1,0) then 
			buildBar.position+=1
			if buildBar.position > #buildBar.tiles then 
				buildBar.position = 1
			end
			GameScreenSelectBuildTool()
		end
	else 
		if(currentState == "move") then
			if btnp(0,0) then cursorMoveOf(-1,0) end
			if btnp(1,0) then cursorMoveOf(1,0) end
			if btnp(2,0) then cursorMoveOf(0,-1) end
			if btnp(3,0) then cursorMoveOf(0,1) end

			if btnp(5,0) and (carte.tiles[cursor.y][cursor.x].sprite == 9 or carte.tiles[cursor.y][cursor.x].sprite == 11)  == false then 
				currentState = "build" 
				GameScreenSelectBuildTool()
			end
		end
	end


	cursorUpdate()

end

function GameScreenDraw()
	cameraToWorld()
	cursorDraw()

	print(1-(max(day.current, 350) / day.max), cam.x + 5, cam.y + 30, 7)

	fade_scr(
		 1-(max(day.current, 350) / day.max)
	)

	tileMapDraw()

	--on build mode	
	if(currentState == "build" and (cursor.canConstruct or buildBar.position==1)) then

		local infos = buildBar.tiles[buildBar.position]
		--si immeuble
		if infos.size == 2 then
			local iso = WorldConverterToIso(cursor.x,cursor.y+1)
			if t%5 != 0 then
		 		spr(infos.tile,iso.x,iso.y-12,4,4)
		 	end
		else
		-- si monocase
			local iso = WorldConverterToIso(cursor.x,cursor.y)
			if t%5  != 0 then
		 		spr(infos.tile,iso.x,iso.y,2,2)
		 	end
		end
	end

	cursorDrawArrow()

	cameraToUI()
	UIDraw()
end



buildBar = {}
buildBar.position = 1
buildBar.tiles = {
	{
		sprite = 224,
		tile = 224,
		costs = {
			food = 2,
			wood = 0,
			water = 2
		},
		size = 1,
		name = "detruire",
		desc = "permet de raser un ",
		descnext =  "element de la carte"
	},
	{
		sprite = 35,
		tile = 35,
		costs = {
			food = 4,
			wood = 15,
			water = 5
		},
		size = 1,
		name = "petite maison",
		desc = "heberger une famille.",
		descnext =  "pop : +5"
	},
	{
		sprite = 37,
		tile = 64,
		costs = {
			food = 40,
			wood = 150,
			water = 50
		},
		size = 2,
		name = "immeuble",
		desc = "heberger de nombreuses ",
		descnext =  "famille. pop : +50"
	},
}

function UIDraw()

	print(carte.tiles[cursor.y][cursor.x].sprite, 5,40,0)

	rectfill(0,0,127,10, 2)
	rect(0,0,127,10, 7)

	spr(192, 3, 2, 1, 1)
	print(city.ressources.food,12,3,9)

	spr(193, 33, 2, 1, 1)
	print(city.ressources.wood,42,3,9)

	spr(194, 63, 2, 1, 1)
	print(city.ressources.water,72,3,9)

	spr(195, 93, 2, 1, 1)
	print(city.population,102,3,9)

	if ( currentState == "build")then
		--background
		rectfill(0,107,127,127, 15)
		rect(0,107,127,127, 7)

		local infos = buildBar.tiles[buildBar.position]
		spr(infos.sprite,6,109,2,2)
		print(infos.name,25,109,1)
		print(infos.desc,25,115,13)
		print(infos.descnext,25,121,13)

		if cursor.z < -2 then
			spr(196, 1, 114, 1, 1)
			spr(197, 119, 114, 1, 1)
		end

	end

end

function GameScreenSelectBuildTool()
	local infos = buildBar.tiles[buildBar.position]
	cursor.size = infos.size
end

function GameScreenBuildSelection()

	--si destruction
	if buildBar.position == 1 then
		if carte.tiles[cursor.y][cursor.x].sprite > 11 then 
			
			--si immeuble
			if (carte.tiles[cursor.y][cursor.x].sprite == 64) then
				carte.tiles[cursor.y][cursor.x-1].sprite = 5
				carte.tiles[cursor.y-1][cursor.x].sprite = 5
				carte.tiles[cursor.y-1][cursor.x-1].sprite = 5

			end
			-- si case proche immeuble
			if (carte.tiles[cursor.y][cursor.x].sprite == 13) then
				local immeublePos = carte.tiles[cursor.y][cursor.x].data
				carte.tiles[immeublePos.y][immeublePos.x-1].sprite = 5
				carte.tiles[immeublePos.y-1][immeublePos.x].sprite = 5
				carte.tiles[immeublePos.y-1][immeublePos.x-1].sprite = 5
				carte.tiles[immeublePos.y][immeublePos.x].sprite = 5
			end
			
			carte.tiles[cursor.y][cursor.x].sprite = 5
			currentState = "move"	
			cursor.size = 1		
		end
	else
		local infos = buildBar.tiles[buildBar.position]
		--si immeuble
		if infos.size == 2 then
			carte.tiles[cursor.y][cursor.x].sprite = 13
			carte.tiles[cursor.y][cursor.x].data = {x= cursor.x+1, y =cursor.y+1}
			carte.tiles[cursor.y][cursor.x+1].sprite = 13
			carte.tiles[cursor.y][cursor.x+1].data = {x= cursor.x+1, y =cursor.y+1}
			carte.tiles[cursor.y+1][cursor.x].sprite = 13
			carte.tiles[cursor.y+1][cursor.x].data = {x= cursor.x+1, y =cursor.y+1}
			carte.tiles[cursor.y+1][cursor.x+1].sprite = infos.tile
			currentState = "move"	
			cursor.size = 1		
		else
		-- si monocase
			carte.tiles[cursor.y][cursor.x].sprite = infos.tile
			currentState = "move"	
			cursor.size = 1	
		end
	end	
end		