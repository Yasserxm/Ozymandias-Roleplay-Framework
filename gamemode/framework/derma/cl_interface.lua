local PANEL = {}

function PANEL:OnKeyCodePressed(KEY_TAB)
	self:Remove()
end

function PANEL:Init()
	self:MakePopup(true)
	self:SetMouseInputEnabled(false)
	self.isAnimating   = true
	self.animationTime = 2

	self:SetSize(
		LARGURA_DA_TELA,
		ALTURA_DA_TELA
	)

	largeBackground = self:Add("DPanel")
	largeBackground.Think = function()
		if self.isAnimating then
			largeBackground:Center()
		end
	end
	largeBackground.Paint = function()
		surface.SetDrawColor(MARROM_BARBOSA)
		surface.DrawRect(0, 0, LARGURA_DA_TELA, ALTURA_DA_TELA)
	end
	largeBackground:SizeTo(LARGURA_DA_TELA, ALTURA_DA_TELA, self.animationTime, 0, .1, function()
		self:SetMouseInputEnabled(true)
		self.isAnimating = false
	end)
end

function PANEL:Paint()    
	surface.SetDrawColor(PRETO_ABSOLUTO)
	surface.DrawRect(0, 0, LARGURA_DA_TELA, ALTURA_DA_TELA)
end

vgui.Register("mainMenu", PANEL, "DPanel")

concommand.Add("mainMenu", function()
	vgui.Create("mainMenu")
end)