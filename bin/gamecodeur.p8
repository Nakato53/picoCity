pico-8 cartridge // http://www.pico-8.com
version 16
__lua__
-- GameCodeurJamGestion
-- by Nakato
-- ./main.lua
currentScreen = nil

function _init()
currentScreen = MenuScreenNew()
end

function _update()
currentScreen.update()
end

function _draw()
cls(0)
currentScreen.draw()
end

























































































































































































































































































































































































































-- ./managers/decorsmanager.lua
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
-- ./managers/gamemanager.lua
function GameManagerNew()
gamestate = {}
end
-- ./utils/fade.lua
function fade_scr(fa)
fa=max(min(1,fa),0)
local fn=8
local pn=15
local fc=1/fn
local fi=flr(fa/fc)+1
local fades={
{1,1,1,1,0,0,0,0},
{2,2,2,1,1,0,0,0},
{3,3,4,5,2,1,1,0},
{4,4,2,2,1,1,1,0},
{5,5,2,2,1,1,1,0},
{6,6,13,5,2,1,1,0},
{7,7,6,13,5,2,1,0},
{8,8,9,4,5,2,1,0},
{9,9,4,5,2,1,1,0},
{10,15,9,4,5,2,1,0},
{11,11,3,4,5,2,1,0},
{12,12,13,5,5,2,1,0},
{13,13,5,5,2,1,1,0},
{14,9,9,4,5,2,1,0},
{15,14,9,4,5,2,1,0}
}

for n=1,pn do
pal(n,fades[n][fi],0)
end
end
-- ./utils/perlin.lua
-- Simplex Noise Example
-- by Anthony DiGirolamo

local Perms = {
151, 160, 137, 91, 90, 15, 131, 13, 201, 95, 96, 53, 194, 233, 7, 225,
140, 36, 103, 30, 69, 142, 8, 99, 37, 240, 21, 10, 23, 190, 6, 148,
247, 120, 234, 75, 0, 26, 197, 62, 94, 252, 219, 203, 117, 35, 11, 32,
57, 177, 33, 88, 237, 149, 56, 87, 174, 20, 125, 136, 171, 168, 68, 175,
74, 165, 71, 134, 139, 48, 27, 166, 77, 146, 158, 231, 83, 111, 229, 122,
60, 211, 133, 230, 220, 105, 92, 41, 55, 46, 245, 40, 244, 102, 143, 54,
65, 25, 63, 161, 1, 216, 80, 73, 209, 76, 132, 187, 208, 89, 18, 169,
200, 196, 135, 130, 116, 188, 159, 86, 164, 100, 109, 198, 173, 186, 3, 64,
52, 217, 226, 250, 124, 123, 5, 202, 38, 147, 118, 126, 255, 82, 85, 212,
207, 206, 59, 227, 47, 16, 58, 17, 182, 189, 28, 42, 223, 183, 170, 213,
119, 248, 152, 2, 44, 154, 163, 70, 221, 153, 101, 155, 167, 43, 172, 9,
129, 22, 39, 253, 19, 98, 108, 110, 79, 113, 224, 232, 178, 185, 112, 104,
218, 246, 97, 228, 251, 34, 242, 193, 238, 210, 144, 12, 191, 179, 162, 241,
81, 51, 145, 235, 249, 14, 239, 107, 49, 192, 214, 31, 181, 199, 106, 157,
184, 84, 204, 176, 115, 121, 50, 45, 127, 4, 150, 254, 138, 236, 205, 93,
222, 114, 67, 29, 24, 72, 243, 141, 128, 195, 78, 66, 215, 61, 156, 180
}

-- make Perms 0 indexed
for i = 0, 255 do
Perms[i]=Perms[i+1]
end
-- Perms[256]=nil

-- The above, mod 12 for each element --
local Perms12 = {}

for i = 0, 255 do
local x = Perms[i] % 12
Perms[i+256], Perms12[i], Perms12[i+256] = Perms[i], x, x
end

-- Gradients for 2D, 3D case --
local Grads3 = {
{ 1, 1, 0 }, { -1, 1, 0 }, { 1, -1, 0 }, { -1, -1, 0 },
{ 1, 0, 1 }, { -1, 0, 1 }, { 1, 0, -1 }, { -1, 0, -1 },
{ 0, 1, 1 }, { 0, -1, 1 }, { 0, 1, -1 }, { 0, -1, -1 }
}

for row in all(Grads3) do
for i=0,2 do
row[i]=row[i+1]
end
-- row[3]=nil
end

for i=0,11 do
Grads3[i]=Grads3[i+1]
end

function GetN2d (bx, by, x, y)
local t = .5-x*x-y*y
local index = Perms12[bx+Perms[by]]
return max(0, (t*t)*(t*t))*(Grads3[index][0]*x+Grads3[index][1]*y)
end

---
-- @param x
-- @param y
-- @return Noise value in the range [-1, +1]
function Simplex2D (x, y)
local s = (x+y)*0.366025403 -- F
local ix, iy = flr(x+s), flr(y+s)
local t = (ix+iy)*0.211324865 -- G
local x0 = x+t-ix
local y0 = y+t-iy
ix, iy = band(ix, 255), band(iy, 255)
local n0 = GetN2d(ix, iy, x0, y0)
local n2 = GetN2d(ix+1, iy+1, x0-0.577350270, y0-0.577350270) -- G2
local xi = 0
if x0 >= y0 then xi = 1 end
local n1 = GetN2d(ix+xi, iy+(1-xi), x0+0.211324865-xi, y0-0.788675135+xi) -- x0+G-xi, y0+G-(1-xi)
return 70*(n0+n1+n2)
end

terrainmap_colors = {11, 11, 11, 9, 9, 9, 7, 7, -- deep ocean
7, 5, 5, -- coastline
5, 3, 3, 3, 3, -- green land
3, 3, 3, 3} -- mountains

carte = {}
function init_perlin(seed)
srand(seed)
local noisedx = rnd(1024)
local noisedy = rnd(1024)

carte = {}
carte.tiles = {}

for y=0,100 do
local ligne = {}
for x=0,100 do
local octaves = 5
local freq = .007
local max_amp = 0
local amp = 1
local value = 0
local persistance = .55
for n=1,octaves do

value = value+Simplex2D(noisedx+freq*x,
noisedy+freq*y)
max_amp += amp
amp *= persistance
freq *= 2
end
value /= max_amp
if value>1 then value = 1 end
if value<-1 then value = -1 end
value += 1
value *= #terrainmap_colors/2
value = flr(value+.5)
value = terrainmap_colors[value]
if value == nil then value = 11 end
if value < 7 then
if rnd(10)<1 then
value = 33
end
end

add(ligne,{sprite=value})
end
add(carte.tiles,ligne)
end
end

-- ./utils/move.lua

-- ./utils/WorldConverter.lua
TILE_SIZE = {x=8, y=8}
function WorldConverterToIso(x,y)
isoX =x-y
isoY =(x+y)/2
return {x=isoX*TILE_SIZE.x, y=isoY*TILE_SIZE.y}
end
function WorldConverterToCell(x,y)
cellX = (2*y+x)/2
cellY= (2*y-x)/2
return {x=cellX/TILE_SIZE.x, y=cellY/TILE_SIZE.y}
end

-- ./screens/worldselectionscreen.lua
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


-- ./screens/menuscreen.lua
function MenuScreenNew()



return {
datas = {
position = 1,
slides =
{
{
titre = "bienvenue",
lines = {
"debutons par un petit tutorial",
"...",
"",
"",
"(->) pour continuer"
}
},
{
titre = "dans gc-sim ...",
lines = {
"vous devez faire grandir",
"une ville depuis son",
"commencement ",
"",
"depuis quelque cases",
"jusqu'a une grande ville",
"(->) pour continuer"
}
},
{
titre = "pour commencer",
lines = {
"vous allez devoir choisir",
"un monde de depart",
"",
"vous pourrez choisir",
"parmis une multitude",
"de monde",
"",
"(->) pour continuer"
}
},
{
titre = "bien choisir ...",
lines = {
"vous devez pouvoir",
"nourrir vos vilageois",
"repondre a leur soif",
"construire leurs maisons",
"",
"choisissez donc bien ",
"...",
"",
"(->) pour continuer"
}
},
{
titre = "(!) attention (!) ",
lines = {
"vos villageois consomment",
"de l'eau et nourriture ",
"toute les nuits",
"",
"un manque de ressources ",
"fait partir vos villageois",
"",

"(->) pour continuer"
}
},
{
titre = "les ressouces",
lines = {
"les fermes ont un temps ",
"de production de 3 jours",
"",
"les scieries et chateau d'eau",
"delivrent les leurs tout ",
"les jours",
"",

"(->) pour continuer"
}
},
{
titre = "les touches",
lines = {
"fleches pour vous deplacer",
"x pour ouvrir les constructions",
"x pour valider une construction",
"c pour annuler",
"s pour upgrade sur ",
" l'hotel de ville",
"",

" X pour demarrer"
}
},

}
},
update = MenuScreenUpdate,
draw = MenuScreenDraw
}
end

function MenuScreenUpdate()

if(btnp(1)) then
currentScreen.datas.position+=1
if currentScreen.datas.position > #currentScreen.datas.slides then
currentScreen.datas.position = #currentScreen.datas.slides
end
end


if(btnp(5)) then
currentScreen = WorldSelectionScreenNew()
end

end

function MenuScreenDraw()
cls(4)


rect(0,0,127,127, 13)
rect(9,28,117,37, 13)
rectfill(10,28,117,37, 7)

local infos = currentScreen.datas.slides[currentScreen.datas.position]
print(infos.titre, 40,30,13)

for i=1,#infos.lines do
print(infos.lines[i], 3,50+i*7,7)
end



end
-- ./screens/gamescreen.lua
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
descnext = "element de la carte"
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
descnext = "pop : +5",
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
descnext = "famille. pop : +50",
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
descnext = "tout les 3 jours",
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
descnext = "tout les jours",
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
descnext = "poser proche d'une foret",
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
if(day.current > day.max*1.5 and currentState != "dead")then
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
if (carte.tiles[cursor.y][cursor.x].sprite == 9 or carte.tiles[cursor.y][cursor.x].sprite == 11) == false then
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
if t%5 != 0 then
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
-- ./entities/tilemap.lua
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


-- ./entities/cursor.lua
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

-- ./entities/buildupdate.lua
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
-- ./entities/buildinit.lua
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
-- ./entities/camera.lua
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
__gfx__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0007700000000770077000000000000bb000000000000004400000000000000aa00000000000000cc00000000000000110000000000000000000000000000000
00077000000770000007700000000bbbbbb00000000004444440000000000aaaaaa0000000000cccccc000000000011111100000000000000000000000000000
000770000770000000000770000bbbbbbbbbb0000004444444444000000aaaaaaaaaa000000cccccccccc0000001111111111000000000000000000000000000
0007700070000000000000070bbbbbbbbbbbbbb004444444444444400aaaaaaaaaaaaaa00cccccccccccccc00111111111111110000000000000000000000000
777777770770000000000770000bbbbbbbbbb0000004444444444000000aaaaaaaaaa000000cccccccccc0000001111111111000000000000000000000000000
07777770000770000007700000000bbbbbb00000000004444440000000000aaaaaa0000000000cccccc000000000011111100000000000000000000000000000
0077770000000770077000000000000bb000000000000004400000000000000aa00000000000000cc00000000000000110000000000000000000000000000000
00077000000000077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000000000000000000005500000000000000000000000000000000000000000000dddddd00000000000000000000000000000
00000000000000000000000000000000495500000000055555500000000000000000000000000000000000000000dccccccd0000000000055000000000000000
0000000000000001000000000000009455950000000555555555500000000000000000000000000000000000000d6dddddd6d000000005556550000000000000
000000000000001b100000000000495549495000005555555555550000000000000000000000000000000000000d65666656d000000056656999999000000000
00000000000011bb31000000000455949494950000555555555555000000000000000000000000000000000000d6656566566d00049999999444444400000000
000000000001b1b3310100000045454949495500005745555554750000000000000000000000000990000000000d66555566d000004444444466500000000000
00000000001bb313331b100000544454945545000054474554744500000000000000000000000999a99000000000dd666ddd0000005566656666550000000000
00000000001b331311bb3100005444595544450000574445744475000000000000000000000999a999a990000000d0ddd00d0000005056656655050000000000
0000000001bb3331b1b33100005744454444750000544745447445000000000fa00000000999a999a999a990000d000dd000d000005005555500050000000000
000000000013331bb313331000574745444445000057444574447500000009f939f0000009a999a999a999a0000d0bbbdbb0d00005000b454440005000000000
000000000011111b331331b000544745745445000054474544744500000fafafafafa00009a9a999a999a9a000dbdbbbdbbbbd00050b4bb544bbb05000000000
000000000bbb41bb33311bb00b554445445455b00b554445744455b009f939f9f9f939f00449a9a999a9a4400bdbbbbbdbbbbdb00bbbb445bb44b44000000000
00000000000bbb133314b000000555454455b000000555454455b000000fafafafafa000000449a9a9a44000000bbbbbdbbbb00000044bb54bb4400000000000
0000000000000bb111b000000000055555b000000000055555b00000000009f939f0000000000449a440000000000bbdbdb0000000000bb5b440000000000000
000000000000000b4000000000000005b000000000000005b00000000000000fa000000000000004400000000000000db0000000000000054000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000055000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000005555550000000000000000000000000000660000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000555555555500000000000000000000000066556600000000000000000000000000000000000000000000000000000000000000000000000000000
00000000055555555555555000000000000000000006655555566000000000000000000000000000000000000000000000000000000000000000000000000000
00000005555555555555555550000000000000000665555555555660000000000000000000000000000000000000000000000000000000000000000000000000
00000555555555555555555555500000000000066555555555555556600000000000000000000000000000000000000000000000000000000000000000000000
00005555555555555555555555550000000006655555555555555555566000000000000000000000000000000000000000000000000000000000000000000000
00005555555555555555555555550000000665555555555555555555555660000000000000000000000000000000000000000000000000000000000000000000
000054455555555555555555544500000665555555555555555555555555ddd00000000000000000000000000000000000000000000000000000000000000000
000054444555555555555554444500000ddd5555555555555555555555ddd5000000000000000000000000000000000000000000000000000000000000000000
00005444444555555555544444450000006ddd555555555555555555ddd665000000000000000000000000000000000000000000000000000000000000000000
0000547444444555555444447445000000666ddd55555555555555ddd56665000000000000000000000000000000000000000000000000000000000000000000
000054447444444554444474444500000066655ddd5555555555ddd5556665000000000000000000000000000000000000000000000000000000000000000000
00005444447444454444744444450000006665556ddd555555ddd665556665000000000000000000000000000000000000000000000000000000000000000000
0000547444447445447444447445000000566555666ddd55ddd56665556665000000000000000000000000000000000000000000000000000000000000000000
000054447444444544444474444500000065545566655dddd5556665556654000000000000000000000000000000000000000000000000000000000000000000
00005444447444454444744444450000006665445665556665556665545565000000000000000000000000000000000000000000000000000000000000000000
00005474444474454474444474450000006665556554556665556654456665000000000000000000000000000000000000000000000000000000000000000000
00005444744444454444447444450000006665556665445665545565556665000000000000000000000000000000000000000000000000000000000000000000
00005444447444454444744444450000005665556665554554456665556665000000000000000000000000000000000000000000000000000000000000000000
0000547444447445447444447445000000655455666555ddd5556665556654000000000000000000000000000000000000000000000000000000000000000000
00005444744444454444447444450000006665445665addddda56665545545000000000000000000000000000000000000000000000000000000000000000000
000b544444744445444474444445b000006b6555655ad50005da66544566b0000000000000000000000000000000000000000000000000000000000000000000
0bba547444447445447444447445bbb00bba6555666d5500055d55655566bbb00000000000000000000000000000000000000000000000000000000000000000
000bb55474444445444444744558b000000bb555666d5500055d66655568b0000000000000000000000000000000000000000000000000000000000000000000
00008be554744445444474455eb0000000008be5666d5500055d66655eb000000000000000000000000000000000000000000000000000000000000000000000
0000000b855474454474455bb00000000000000b866d5577755d665bb00000000000000000000000000000000000000000000000000000000000000000000000
000000000ba5544544455ba000000000000000000bad57fff75d6ba0000000000000000000000000000000000000000000000000000000000000000000000000
00000000000b8555455be0000000000000000000000b7f777f7be000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000bb55b800000000000000000000000000ffffff00000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000eb000000000000000000000000000000770000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000444000004445008800055000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
07770000000077700004444400049954000885556558880000000000000000000000000000000000000000000000000000000000000000000000000000000000
07700000000007700044444400499594000088656988999000000000000000000000000000000000000000000000000000000000000000000000000000000000
07070000000070700044444400445995049998999884444400000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000bb00000000054444004994950004448848866500000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000b4aa4b000000775440004994500005566888666550000000000000000000000000000000000000000000000000000000000000000000000000000000000
000bb4acca4bb0007700000000440000005056888655050000000000000000000000000000000000000000000000000000000000000000000000000000000000
0bb44ac11ca44bb00000000c00000000005008858800050000000000000000000000000000000000000000000000000000000000000000000000000000000000
000bb4acca4bb0000000000c00000000050088454840005000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000b4aa4b000000000007c1000000005088bb5488bb05000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000bb0000000000007ccc10000000b88b445bb88b44000000000000000000000000000000000000000000000000000000000000000000000000000000000
070700000000707000007ccccc10000000044bb54bb8400000000000000000000000000000000000000000000000000000000000000000000000000000000000
077000000000077000007ccccc10000000000bb5b440000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0777000000007770000007ccc1000000000000054000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000001110000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000444000000000000c000009999990000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0004444400044450000c000009ffff90000700000000700000000000000000000000000000000000000000000000000000000000000000000000000000000000
0044444400499540007c100009ffff90007500000000570000000000000000000000000000000000000000000000000000000000000000000000000000000000
004444440499594007ccc10009ffff90075000000000057000000000000000000000000000000000000000000000000000000000000000000000000000000000
00544440044599507ccccc1000ffff00075000000000057000000000000000000000000000000000000000000000000000000000000000000000000000000000
07754400499495007ccccc100f3333f0007500000000570000000000000000000000000000000000000000000000000000000000000000000000000000000000
770000004994500007ccc100f333333f000700000000700000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000440000000111000f333333f000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000999000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000099a9900000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000099a99900000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000099aa99900000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000099aa995900000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000009999955900000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000009c99555900000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00009909cc9559000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00990099cc9590000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
009a9900999590900000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
09aaaa99009909a90000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
9aaaaaaa99009aa90000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
099aaaaaaa99aa900000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00099aaaaa99a9000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000099aa90090000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000009900000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__sfx__
000300002b6202b6302c6302c6402c6502b6502965027650256502365022650206501d6501d6501b650196501865016650146501364012640116400f6300e6200d6200c6200b6200a61009610076100461002600
000100001005013050140501405014050140501405014050000000e050140501505015050160501105016050170501705018050190501a0501b0501c0501d0501f050210502405025050280502b0502e05032050
0003000003770027700277002770027700276002700017000a7000970000000097000970008700057000470004700027000170000000000000000000000000000000000000000000000000000000000000000000
0027000a0c050090500c0000c0500c0000c050060500c0000c0500a0000c000090000b0000c0000a0000900008000080000700006000060000600006000060000600006000060000600006000050000400004000
001d00001c7301c730237301c7301a7301a7301c7301c7301c7301e7301e7301e7301e7201d7301c7301b7301c7301c7301d7301e7301e7301e7301d7201a72019720197201d7301a7301c7301c7301a7301a730
001e001b097500d75010750107500e750097500a7500c7500c7500d7500d7500b7500a7500b7500d7500d7500c7500d7500e7500d7500d7500d7500e7500c7500c7500d7500e7500815000000000000000000000
__music__
02 03040544








