local T, C, F = unpack(select(2, ...))

local format = string.format
local floor = math.floor

F.Round = function(num, idp)
	if idp and idp > 0 then
		local mult = 10^idp
		return floor(num * mult + 0.5) / mult
	end
	return floor(num + 0.5)
end

F.Timer = function(steptime)
	if GetFramerate() >= 60 then
		return 60 * steptime
	else 
		return GetFramerate() * steptime
	end
end

F.Hex = function(rgb)
	local r,g,b = rgb[1],rgb[2],rgb[3]
	return format("|cff%02x%02x%02x",r*255,g*255,b*255)
end

F.Gradient = function(perc,a,b)
	perc = perc > 1 and 1 or perc < 0 and 0 or perc -- Stay between 0-1
	local r1,g1,b1,r2,g2,b2 = a[1],a[2],a[3],b[1],b[2],b[3]
	local r = r1+(r2-r1)*perc
	local g = g1+(g2-g1)*perc
	local b = b1+(b2-b1)*perc
	return r,g,b
end