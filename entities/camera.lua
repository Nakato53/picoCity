cameraOffset = {x = -60, y = -60}
function cameraNew()
	cam = {x = -60, y = 16}
end

function cameraMoveOf(x,y)
	cam.x = cam.x+x
	cam.y = cam.y+y
end

function cameraMove(x, y)
	cam.x = x
	cam.y = y
end

function cameraToUI()
	camera(0,0)
end

function cameraToWorld()
	camera(cam.x,cam.y)
end


function cameraCenterOn(x,y)
	local iso = WorldConverterToIso(x,y)
	iso.x += cameraOffset.x
	iso.y += cameraOffset.y

	cameraMove(iso.x, iso.y)
end