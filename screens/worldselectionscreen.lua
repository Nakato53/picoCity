function WorldSelectionScreenNew()
	
	
	text = "generation en cours"
	refreshWorld = 1
	return {
		update = WorldSelectionScreenUpdate,
		draw = WorldSelectionScreenDraw
	}
end

function WorldSelectionScreenInit()
	cameraNew()
	cursorInit()
	tileMapNew()
	carte.position = { x = 35, y = 35 }
	carte.visibility = { x = 30, y = 30}
	refreshWorld = 0
	cameraCenterOn(cursor.x,cursor.y)
end

function WorldSelectionScreenUpdate()
	
	if (btnp(1)) then
		refreshWorld = 1
	end



	if(refreshWorld == 4) then
		currentScreen = GameScreenNew()
	end

	if (btnp(5)) then
		refreshWorld = 3
		text = "initialisation ..."
	end

	if(refreshWorld == 2) then
		WorldSelectionScreenInit()
	end
	if(refreshWorld==0) then 
		cursorUpdate()
	end
end

function WorldSelectionScreenDraw()
	if(refreshWorld > 0)then
		cls(4)
		
		rectfill(20,53,107,71, 11)
		rect(20,53,107,71, 7)
		rect(0,0,127,127, 13)

		print(text, 27,56,7)
		print("veuillez patienter", 29,64,7)


		refreshWorld += 1
	
	else
		cameraToWorld()
		tileMapDraw()
		cameraToUI()
		WorldSelectionScreenDrawUI()
	end

	
end

function WorldSelectionScreenDrawUI()

	--background
	rectfill(0,107,127,127, 15)
	rect(0,107,127,127, 7)
	
	print("> : monde suivant ", 22,112,13)
	print("x : choisir ce monde ", 22,118,13)

	--background
	rectfill(23,3,98,11, 7)
	print("selection du monde ", 25,5,1)
end

