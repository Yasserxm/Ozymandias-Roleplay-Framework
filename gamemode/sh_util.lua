--[[
	Criação das globais utilizadas
	pela interface  da  framework.
  ]]

if (CLIENT) then
	INDICE_PADDING = (0.05)

	LARGURA_DA_TELA 		= ScrW()
	ALTURA_DA_TELA 			= ScrH()

	LARGURA_DA_TELA_PADDING = ( LARGURA_DA_TELA * INDICE_PADDING )
	ALTURA_DA_TELA_PADDING  = ( ALTURA_DA_TELA  * INDICE_PADDING )
end

--[[
	Palhetas 	de	 cores 
	standard do Ozymandias.
  ]]

BRANCO_ABSOLUTO = Color( 255, 255, 255 )
PRETO_ABSOLUTO 	= Color( 000, 000, 000 )
AMARELO_BOGA 	= Color( 255, 251, 019 )
MARROM_BARBOSA 	= Color( 171, 158, 079 )
COR_INVISIVEL	= Color( 000, 000, 000, 000)

--[[
	Palhetas 	de 	 cores
	standard do Protótpipo.
]]

VERMELHO_ERRO 	= Color( 209, 038, 038 )
VERMELHO_SOMBRA = Color( 133, 063, 063	)


--[[
	Funções utilizadas para
	incluir arquivos dentro
	da Framework.
]]

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

function util.IncludeDir(directory)
	local fullDirectory = ("ozymandias/gamemode/" .. directory .. "/*.lua")

	for k, v in pairs(file.Find(fullDirectory, "LUA")) do
		util.Include(directory .. "/" .. v)
	end
end

--Somente inclusões abaixo
util.IncludeDir("framework/derma")
util.IncludeDir("framework/library")