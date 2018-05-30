function GameScreenNew()
	t = 0
	cameraNew()
	cursorInit()
	tileMapSetSeed(currentSeed)
	tileMapInit()
	currentState = "move"
	music(0)

	city = {
		ressources = {
			food = 150,
			wood = 80,
			water = 110
		},
		population = 0,
		populationmax = 0,
		populationscore = 0,
		level = 1,
		upgrade = 1

	}

	upgrades = {
		position = 1,
		textes = {
			{
				titre = "ameliorer les productions",
				sprite = 130
			},
			{
				titre = "augmenter la carte",
				sprite = 128
			},
			

		},
		cost = {
			wood = 200,
			food = 200,
			water = 200,
			population = 50
		}
	}

	levels = {
			cost = {
				wood = 500,
				food = 500,
				water = 500,
				population = 500
			},
			ferme = 15,
			chateau = 8,
			bois = 4
	}

	cameraCenterOn(cursor.x,cursor.y)
	
	day = {
		current = 900,
		max = 900,
		step = 10,
		tick = 0
	}



buildBar = {}
buildBar.position = 1
buildBar.tiles = {
		{
		sprite = 224,
		tile = 224,
		costs = {
			food = 5,
			wood = 0,
			water = 5
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
			food = 10,
			wood = 15,
			water = 5
		},
		size = 1,
		name = "petite maison",
		desc = "heberger une famille.",
		descnext =  "pop : +5",
		init = houseinit,
		update = houseupdate
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
		descnext =  "famille. pop : +50",
		init = buildinginit
	},
	{
		sprite = 39,
		tile = 39,
		costs = {
			food = 10,
			wood = 10,
			water = 10
		},
		size = 1,
		name = "ferme",
		desc = "produit de la nourriture",
		descnext =  "tout les 3 jours",
		init = fermeinit,
		update = fermeupdate
	},
	{
		sprite = 43,
		tile = 43,
		costs = {
			food = 8,
			wood = 10,
			water = 15
		},
		size = 1,
		name = "chateau d'eau",
		desc = "produit de l'eau",
		descnext =  "tout les jours",
		init = fermeinit,
		update = chateaudeauupdate
	},
	{
		sprite = 45,
		tile = 45,
		costs = {
			food = 8,
			wood = 15,
			water = 8
		},
		size = 1,
		name = "scierie",
		desc = "produit de bois",
		descnext =  "poser proche d'une foret",
		init = boisinit,
		update = boisupdate
	},
}
	DecorsManagerInit()

	return {
		update = GameScreenUpdate,
		draw = GameScreenDraw
	}
end

function GameScreenUpdate()
	
	t+=1
	
	day.current += day.step
	day.tick = 0
	if day.current > day.max*1.5 or day.current < 250 then
		if(day.current < 250 and currentState != "dead" and city.population ) then
			GameScreenNightTick()
			day.tick = 1
		end
		if(day.current > day.max*1.5  and currentState != "dead")then
			GameScreenLunchTick()
			day.tick = 2
		end
		day.step *=-1
	end

	if ( currentState == "dead" ) then
		if btnp(5,0) then
			currentScreen = WorldSelectionScreenNew()
		end
	end

	if(currentState == "build") then

		if btnp(5,0) then
			if (cursor.canConstruct or buildBar.position==1) then
				GameScreenBuildSelection()
			else
				sfx(2)
			end
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
			
			local currentTile = carte.tiles[cursor.y][cursor.x].sprite
			if currentTile == 13 then
				local trueTile = carte.tiles[cursor.y][cursor.x].data
				currentTile = carte.tiles[trueTile.y][trueTile.x].sprite
			end

			if btnp(0,1) and currentTile == 68 then --touche S sur hotel de ville
				currentState = "upgrade" 
			end

			if btnp(5,0) then 
				if (carte.tiles[cursor.y][cursor.x].sprite == 9 or carte.tiles[cursor.y][cursor.x].sprite == 11)  == false then
					currentState = "build" 
					GameScreenSelectBuildTool()
				else
					sfx(2)
				end
			end
		else 
			if(currentState == "upgrade") then


				if btnp(0,0) then 
					upgrades.position-=1
					if upgrades.position < 1 then 
						upgrades.position = #upgrades.textes
					end
					
				end
				if btnp(1,0) then 
					upgrades.position+=1
					if upgrades.position > #upgrades.textes then 
						upgrades.position = 1
					end
				end

				if btnp(4,0) then 
					currentState = "move" 
					cursor.size = 1
				end

				if btnp(5,0) then 
					if upgrades.position==1 then
						if city.ressources.food >= levels.cost.food and city.ressources.wood >= levels.cost.wood and city.ressources.water >= levels.cost.water and city.population >= levels.cost.population then
							city.level += 1
							
							city.ressources.food -= levels.cost.food
							city.ressources.wood -= levels.cost.wood
							city.ressources.water -= levels.cost.water
							

							levels.cost.food = levels.cost.food*3
							levels.cost.wood = levels.cost.wood*3
							levels.cost.water = levels.cost.water*3
							levels.cost.population = levels.cost.population*3

							currentState = "move"
						else
							sfx(2)
						end
						 
					end

					if upgrades.position==2 then
						if city.ressources.food >= upgrades.cost.food and city.ressources.wood >= upgrades.cost.wood and city.ressources.water >= upgrades.cost.water and city.population >= upgrades.cost.population then
							city.upgrade += 1
							carte.position.x -= 3
							carte.position.y -= 3
							carte.visibility.x += 6
							carte.visibility.y += 6
							

							city.ressources.food -= upgrades.cost.food
							city.ressources.wood -= upgrades.cost.wood
							city.ressources.water -= upgrades.cost.water

							upgrades.cost.food = upgrades.cost.food*2
							upgrades.cost.wood = upgrades.cost.wood*2
							upgrades.cost.water = upgrades.cost.water*2
							upgrades.cost.population = upgrades.cost.population*2
							
							currentState = "move"

						else
							sfx(2)
						end
						
					end
					
				end

			end
		end
	end


	cursorUpdate()
	DecorsManagerUpdate()

end

function GameScreenDraw()
	cameraToWorld()
	cursorDraw()

	fade_scr(
		 1-(max(day.current, 550) / day.max)
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
	DecorsManagerDraw()
end



function UIDraw()

	rectfill(0,0,127,10, 2)
	rect(0,0,127,10, 7)

	spr(192, 3, 2, 1, 1)
	print(city.ressources.food,12,3,9)

	spr(193, 33, 2, 1, 1)
	print(city.ressources.wood,42,3,9)

	spr(194, 63, 2, 1, 1)
	print(city.ressources.water,72,3,9)

	spr(195, 93, 2, 1, 1)
	print(city.population .. "/"..city.populationmax ,102,3,9)


	if currentState == "move" then

			local currentTile = carte.tiles[cursor.y][cursor.x].sprite
			if currentTile == 13 then
				local trueTile = carte.tiles[cursor.y][cursor.x].data
				currentTile = carte.tiles[trueTile.y][trueTile.x].sprite
			end

			if(currentTile > 11) then
				rectfill(0,117,127,127, 2)
				rect(0,117,127,127, 7)

				if currentTile == 33 then print("foret", 3, 120, 7) end
				if currentTile == 35 then print("maison", 3, 120, 7) end
				if currentTile == 39 then print("ferme", 3, 120, 7) end
				if currentTile == 41 then print("ferme", 3, 120, 7) end
				if currentTile == 43 then print("chateau d'eau", 3, 120, 7) end
				if currentTile == 45 then print("scierie", 3, 120, 7) end
				if currentTile == 132 then print("scierie sans bois", 3, 120, 7) end
				if currentTile == 64 then print("immeuble", 3, 120, 7) end
				if currentTile == 68 then print("hotel de ville, s pour upgrade", 3, 120, 7) end
			end

		
	end
	if ( currentState == "dead")then

		rectfill(2,53,125,91,11)
		rect(2,53,124,91, 7)

		print("fin : votre ville est deserte ", 5,56,7)
		print("max pop : " .. city.populationscore , 29,64,7)

		print("x pour redemarrer ", 15,80,1)

	end
	if ( currentState == "upgrade")then

		--background
		rectfill(0,107,127,127, 15)
		rect(0,107,127,127, 7)

		rectfill(0,95,127,105, 15)
		rect(0,95,127,105, 7)


		spr(upgrades.textes[upgrades.position].sprite,6,109,2,2)
		print(upgrades.textes[upgrades.position].titre,23,116,1)

		if upgrades.position == 1 then
			spr(192, 5, 97, 1, 1)
			print("-"..levels.cost.food,15,98,4)
			spr(193, 35, 97, 1, 1)
			print("-"..levels.cost.wood,45,98,4)
			spr(194, 65, 97, 1, 1)
			print("-"..levels.cost.water,75,98,4)
			spr(195, 95, 97, 1, 1)
			print(levels.cost.population,105,98,4)
		end

		
		if upgrades.position == 2 then
			spr(192, 5, 97, 1, 1)
			print("-"..upgrades.cost.food,15,98,4)
			spr(193, 35, 97, 1, 1)
			print("-"..upgrades.cost.wood,45,98,4)
			spr(194, 65, 97, 1, 1)
			print("-"..upgrades.cost.water,75,98,4)
			spr(195, 95, 97, 1, 1)
			print(upgrades.cost.population,105,98,4)
		end
		

		if cursor.z < -2 then
			spr(196, 1, 114, 1, 1)
			spr(197, 119, 114, 1, 1)
		end
	end

	if ( currentState == "build")then
		--background
		rectfill(0,107,127,127, 15)
		rect(0,107,127,127, 7)

		local infos = buildBar.tiles[buildBar.position]

		rectfill(0,95,127,105, 15)
		rect(0,95,127,105, 7)

		print("cout :",5,98,13)
		spr(192, 40, 97, 1, 1)
		print("-"..infos.costs.food,50,98,4)
		spr(193, 70, 97, 1, 1)
		print("-"..infos.costs.wood,80,98,4)
		spr(194, 100, 97, 1, 1)
		print("-"..infos.costs.water,110,98,4)

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
		if carte.tiles[cursor.y][cursor.x].sprite > 11 and carte.tiles[cursor.y][cursor.x].sprite != 68 then 
			if GameScreenApplyCost() then 
				sfx(0) 
			else 
				sfx(2)
				return nil 
			end
			--si immeuble
			if (carte.tiles[cursor.y][cursor.x].sprite == 64 or carte.tiles[cursor.y][cursor.x].sprite == 68) then
				carte.tiles[cursor.y][cursor.x-1].sprite = 5
				carte.tiles[cursor.y-1][cursor.x].sprite = 5
				carte.tiles[cursor.y-1][cursor.x-1].sprite = 5

			end
			-- si case proche immeuble
			if (carte.tiles[cursor.y][cursor.x].sprite == 13) then
				local immeublePos = carte.tiles[cursor.y][cursor.x].data
				if carte.tiles[immeublePos.y][immeublePos.x].sprite != 68 then
					carte.tiles[immeublePos.y][immeublePos.x-1].sprite = 5
					carte.tiles[immeublePos.y-1][immeublePos.x].sprite = 5
					carte.tiles[immeublePos.y-1][immeublePos.x-1].sprite = 5
					carte.tiles[immeublePos.y][immeublePos.x].sprite = 5
				end
			end
			carte.tiles[cursor.y][cursor.x] = {}
			carte.tiles[cursor.y][cursor.x].sprite = 5

			currentState = "move"	
			cursor.size = 1		
		end
	else
		
		if GameScreenApplyCost() then 
			sfx(1) 
		else 
			sfx(2)
			return nil 
		end
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

		if infos.init == nil then
		else
			infos.init(cursor.x, cursor.y)
		end

		if infos.update != nil then
			carte.tiles[cursor.y][cursor.x].update = infos.update
		end
		
		
	end	
end

function GameScreenApplyCost()
	local infos = buildBar.tiles[buildBar.position]
	local canApply = true

	if city.ressources.food - infos.costs.food < 0 or city.ressources.wood - infos.costs.wood < 0 or city.ressources.water - infos.costs.water < 0 then
		canApply = false
	end

	if canApply then
		city.ressources.food -= infos.costs.food
		city.ressources.wood -= infos.costs.wood
		city.ressources.water -= infos.costs.water

		local pos = WorldConverterToIso(cursor.x,cursor.y)
		pos.x -= cam.x
		pos.y -= cam.y

		if infos.costs.food > 0 then
			DecorsManagerAdd(192, 3,2,pos.x,pos.y, "-"..infos.costs.food)
		end

		if infos.costs.wood > 0 then
			DecorsManagerAdd(193, 33,2, pos.x,pos.y, "-"..infos.costs.wood)
		end


		if infos.costs.water > 0 then
			DecorsManagerAdd(194,63,2,pos.x,pos.y, "-"..infos.costs.water)
		end



	end

	return canApply
end

function GameScreenLunchTick()

end

function GameScreenNightTick()

	--gestion nourriture
	local needFood = city.population
	city.ressources.food -= city.population
	if(city.ressources.food < 0) then
		-- si pas assez de bouffe
		city.population += flr(city.ressources.food*1.5)

		city.ressources.food = 0
	end
	--gestion eau
	local needWater = city.population
	city.ressources.water -= city.population
	if(city.ressources.water < 0) then
		-- si pas assez d'eau
		city.population += flr(city.ressources.water*1.5)
		city.ressources.water = 0
		
	end

	if city.population <= 0 and city.populationscore > 0 then

		currentState = "dead"	

	else
		local ecartPop = city.populationmax - city.population 

		if ecartPop >= 1 then
			ecartPop += 1
			ecartPop = ecartPop/2
			ecartPop = max(2, ecartPop)
			city.population += flr(rnd(ecartPop))

			if city.population > city.populationscore then
				city.populationscore = city.population
			end
		end
	end

end