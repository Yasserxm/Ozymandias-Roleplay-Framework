-- Including all the features made for base gamemode
DEFINE_BASECLASS("gamemode_base")

-- Global table to store all the framework's information

oz = oz or {util = {}, meta = {}}

include("shared.lua")

util.Include("main/sh_data.lua")

-- Sending essential files to the players
AddCSLuaFile("cl_init.lua") 
AddCSLuaFile("shared.lua")
AddCSLuaFile("main/sh_data.lua")
