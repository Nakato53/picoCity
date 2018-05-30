function cursorInit()
	cursor = { x = 50 , y = 50, z = 0, step = 0.2, size = 1, canConstruct = true }
end

function cursorUpdate()
	cursor.canConstruct = true
	
	for x=1,cursor.size do
		for y=1,cursor.size do
			local onmap = cursorOnMap(cursor.x+(x-1), cursor.y+(y-1))
			if onmap == false then
				cursor.canConstruct = false
			end
		end
	end

	if cursor.z < -4 or cursor.z > 0 then
		cursor.step *= -1
	end

	cursor.z+=cursor.step
end

function cursorOnMap(x,y)

	if x < carte.position.x or x > carte.position.x + carte.visibility.x or y < carte.position.y or y > carte.position.y + carte.visibility.y or carte.tiles[y][x].sprite > 7 then
		return false
	end

	return true
end

function cursorDraw()

	if cursor.canConstruct == false then
		pal(7,8)
	end
	
	for x=1,cursor.size do
		for y=1,cursor.size do
			local iso = WorldConverterToIso(cursor.x+(x-1),cursor.y+(y-1))
			spr(1,iso.x,iso.y,2,2)
		end
	end
	pal()

end


function cursorDrawArrow()

	for x=1,cursor.size do
		for y=1,cursor.size do
			local iso = WorldConverterToIso(cursor.x+(x-1),cursor.y+(y-1))
			pal(7,0)
			spr(16,iso.x+5,iso.y+cursor.z,1,1)
			spr(16,iso.x+3,iso.y+cursor.z,1,1)
			spr(16,iso.x+4,iso.y+cursor.z-1,1,1)
			spr(16,iso.x+4,iso.y+cursor.z+1,1,1)
			pal()
			spr(16,iso.x+4,iso.y+cursor.z,1,1)
		end
	end

	


end


function cursorMoveOf(x,y)
	cursor.x = cursor.x+x
	cursor.y = cursor.y+y
	cameraCenterOn(cursor.x,cursor.y)
end
