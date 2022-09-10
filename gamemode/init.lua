


-- Including all the features made for Sandbox gamemode
DeriveGamemode("sandbox")

function util.Include(fileName, state)
	if (state == "shared" or string.find(fileName, "sh_")) then
		AddCSLuaFile(fileName)
		include(fileName)
	elseif ((state == "server" or string.find(fileName, "sv_")) and SERVER) then
		include(fileName)
	elseif (state == "client" or string.find(fileName, "cl_")) then
		if (SERVER) then
			AddCSLuaFile(fileName)
		else
			include(fileName)
		end
	end
end

util.Include("sh_tween.lua")
util.Include("sh_animation.lua")

-- Sending essential files to the players
AddCSLuaFile("cl_init.lua") 
AddCSLuaFile("shared.lua")