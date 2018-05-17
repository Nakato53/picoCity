TILE_SIZE = {x=8, y=8}
function WorldConverterToIso(x,y)
    isoX =x-y
    isoY =(x+y)/2
    return {x=isoX*TILE_SIZE.x, y=isoY*TILE_SIZE.y}
end
function WorldConverterToCell(x,y)
    cellX =	(2*y+x)/2
    cellY=	(2*y-x)/2
    return {x=cellX/TILE_SIZE.x, y=cellY/TILE_SIZE.y}
end
