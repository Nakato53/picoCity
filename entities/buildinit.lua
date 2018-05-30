function houseinit(x,y)
	city.populationmax += 5
end

function buildinginit(x,y)
	city.populationmax += 50
end

function fermeinit(x,y)
	carte.tiles[y][x].datas = {
		day = 0
	}
end
function boisinit(x,y)

end