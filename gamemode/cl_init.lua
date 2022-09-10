
DEFINE_BASECLASS("gamemode_base")

INDICE_PADDING = (0.075)

LARGURA_DA_TELA 		= ScrW()
ALTURA_DA_TELA 			= ScrH()

LARGURA_DA_TELA_PADDING = ( LARGURA_DA_TELA * INDICE_PADDING )
ALTURA_DA_TELA_PADDING  = ( ALTURA_DA_TELA  * INDICE_PADDING )

BRANCO_ABSOLUTO = Color( 255, 255, 255 )
PRETO_ABSOLUTO 	= Color( 000, 000, 000 )
AMARELO_BOGA 	= Color( 255, 251, 019 )
MARROM_BARBOSA 	= Color( 171, 158, 079 )


--[[
	TODO: Criar  um  arquivo
	exclusivo 		 somente
	para    esta   interface.
  ]]

local PANEL = {}

function PANEL:Init()
	self.tamanhoDoQuadrado = 0

	self:SetSize(
		LARGURA_DA_TELA,
		ALTURA_DA_TELA
	)

	largeBackground = self:Add("DPanel")
	largeBackground:Dock(FILL)
	largeBackground:SetSize(
		LARGURA_DA_TELA,
		ALTURA_DA_TELA
	)
	largeBackground.Paint = function()
		surface.SetDrawColor(MARROM_BARBOSA)
    	surface.DrawRect( 
			LARGURA_DA_TELA_PADDING / 2 * tamanhoDoQuadrado,
			ALTURA_DA_TELA_PADDING  / 2 * tamanhoDoQuadrado,
			LARGURA_DA_TELA - LARGURA_DA_TELA_PADDING * tamanhoDoQuadrado,
			ALTURA_DA_TELA  - ALTURA_DA_TELA_PADDING  * tamanhoDoQuadrado  
		)
	end

	self:Expand()
end

function PANEL:Expand()
	self:CreateAnimation(5, {
		index 	= 1,
		target 	= {self.tamanhoDoQuadrado = 1},
		easing 	= "inCubic",
	})
end

function PANEL:Paint()    
    surface.SetDrawColor(PRETO_ABSOLUTO)
    surface.DrawRect(0, 0, LARGURA_DA_TELA, ALTURA_DA_TELA)
end

vgui.Register("mainMenu", PANEL, "DPanel")

function GM:PostGamemodeLoaded()
	if !IsValid(mainMenu) then
		local mainMenu = vgui.Create("mainMenu")
	end
end