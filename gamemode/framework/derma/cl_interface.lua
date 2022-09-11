local PANEL = {}

function PANEL:OnKeyCodePressed(KEY_TAB)
	self:Remove()
end

function PANEL:Init()
	self:MakePopup(true)
	self:SetMouseInputEnabled(false)
	self.isAnimating   = true
	self.animationTime = 1

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

    buttonExit = self:Add("menuButton")
    buttonExit:SetSize(LARGURA_DA_TELA / 10, ALTURA_DA_TELA / 16)
    buttonExit:Center()
    buttonExit.DoClick = function()
        self:Remove()
    end
end

function PANEL:Paint()    
	surface.SetDrawColor(PRETO_ABSOLUTO)
	surface.DrawRect(0, 0, LARGURA_DA_TELA, ALTURA_DA_TELA)
end

vgui.Register("mainMenu", PANEL, "DPanel")

concommand.Add("mainMenu", function()
	vgui.Create("mainMenu")
end)


local PANEL = {}

function PANEL:Init()
    self.strokeSize   = (ScreenScale(4))
    self.roundness    = (0)

    self:SetText("CANCELAR")
    self:SetFont("OzymandiasButtonFont")

    self:SetTextColor(BRANCO_ABSOLUTO)
end

function PANEL:OnCursorEntered()
    self:BeWider(2, 20, "outCubic")
end

function PANEL:OnCursorExited()
    self:BeWider(1, 0, "outQuint")
end

function PANEL:Paint(w, h)
    draw.RoundedBox(ScreenScale(0) + self.roundness,
    self.strokeSize / 2,        self.strokeSize / 2,
    w - self.strokeSize,        h - self.strokeSize,
    PRETO_ABSOLUTO)
end

function PANEL:BeWider(length, newBorder, insertedEasing)
	self:CreateAnimation(length, {
		target = {
			roundness = ScreenScale(newBorder)
		},
		easing = insertedEasing
	})
end

vgui.Register("menuButton", PANEL, "DButton")