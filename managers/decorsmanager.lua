function DecorsManagerInit()
	decors = {}
end

function DecorsManagerUpdate()
	for i=#decors,1,-1 do
		decors[i].current += 1
		if (decors[i].current == decors[i].step) then del(decors, decors[i]) end
	end
end

function DecorsManagerAdd(spriteID, fromX, fromY, toX, toY, value)
		local tmpDecors = {
			sprite = spriteID,
			from = {
					x = fromX,
					y = fromY
				},
			to = {
					x = toX,
					y = toY
				},
			text = value,
			step = 30,
			current = 0

		}
		add(decors, tmpDecors)

end

function DecorsManagerDraw()
	

	for i=1,#decors do
		local dec = decors[i]
		local dest = dec.to
		local start = dec.from
		local percent = dec.current/dec.step
		local decal = {
				x =start.x+ (dest.x - start.x)*percent,
				y =start.y+ (dest.y - start.y)*percent
		}
		for i=1,15 do
			pal(i,0)
		end
		spr(dec.sprite,decal.x-1, decal.y,1,1)
		spr(dec.sprite,decal.x+1, decal.y,1,1)
		spr(dec.sprite,decal.x, decal.y-1,1,1)
		spr(dec.sprite,decal.x, decal.y+1,1,1)
		pal()
		spr(dec.sprite,decal.x, decal.y,1,1)
		if dec.text != "" then
			print(dec.text, decal.x+9, decal.y+1, 7)
		end
	end


	
end