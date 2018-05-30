-- Simplex Noise Example
-- by Anthony DiGirolamo

local Perms = {
   151, 160, 137, 91, 90, 15, 131, 13, 201, 95, 96, 53, 194, 233, 7, 225,
   140, 36, 103, 30, 69, 142, 8, 99, 37, 240, 21, 10, 23, 190, 6, 148,
   247, 120, 234, 75, 0, 26, 197, 62, 94, 252, 219, 203, 117, 35, 11, 32,
   57, 177, 33, 88, 237, 149, 56, 87, 174, 20, 125, 136, 171, 168, 68,   175,
   74, 165, 71, 134, 139, 48, 27, 166, 77, 146, 158, 231, 83, 111,   229, 122,
   60, 211, 133, 230, 220, 105, 92, 41, 55, 46, 245, 40, 244, 102, 143, 54,
   65, 25, 63, 161, 1, 216, 80, 73, 209, 76, 132, 187, 208, 89, 18, 169,
   200, 196, 135, 130, 116, 188, 159, 86, 164, 100, 109, 198, 173, 186, 3, 64,
   52, 217, 226, 250, 124, 123, 5, 202, 38, 147, 118, 126, 255, 82, 85, 212,
   207, 206, 59, 227, 47, 16, 58, 17, 182, 189, 28, 42, 223, 183, 170, 213,
   119, 248, 152, 2, 44, 154, 163, 70, 221, 153, 101, 155, 167, 43, 172, 9,
   129, 22, 39, 253, 19, 98, 108, 110, 79, 113, 224, 232, 178, 185, 112, 104,
   218, 246, 97, 228, 251, 34, 242, 193, 238, 210, 144, 12, 191, 179, 162, 241,
   81,   51, 145, 235, 249, 14, 239,   107, 49, 192, 214, 31, 181, 199, 106, 157,
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

terrainmap_colors = {11, 11,  11,  9,  9,  9,  7,  7, -- deep ocean
                     7, 5, 5,    -- coastline
                     5, 3, 3, 3, 3, -- green land
                     3,  3,  3,  3} -- mountains

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
