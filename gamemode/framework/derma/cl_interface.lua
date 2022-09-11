local PANEL = {}

function PANEL:OnKeyCodePressed()
	self:Remove()
end

function PANEL:Init()
	self:MakePopup(true)
	self:SetMouseInputEnabled(false)
    self.isMainMenu    = true
	self.isAnimating   = true
    self.gradient      = false
	self.animationTime = 1
    self.gradientAlpha = 0

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
	end)

    innerBackground = self:Add("DPanel")
    innerBackground.Think = function()
        innerBackground:Center()
    end
    innerBackground.Paint = function()
        local fraction    = .1
        local senoidMult  = (math.sin(CurTime() * .5) ^ 2)
        local extraSlideW = ((LARGURA_DA_TELA * fraction)
        * senoidMult)
        local extraSlideH = ((ALTURA_DA_TELA  * fraction)
        * senoidMult)

        surface.SetDrawColor(BRANCO_ABSOLUTO)
        surface.SetTexture(surface.GetTextureID("vgui/ozymandias_background"))
        surface.DrawTexturedRect(
        -extraSlideW / 2, -extraSlideH / 2,
        LARGURA_DA_TELA + extraSlideW,
        ALTURA_DA_TELA  + extraSlideH)

        surface.SetDrawColor(ColorAlpha(MARROM_BARBOSA, gradientAlpha))
        surface.SetTexture(surface.GetTextureID("vgui/gradient-d"))
        surface.DrawTexturedRect(0, 0, LARGURA_DA_TELA, ALTURA_DA_TELA)
    end
	innerBackground:SizeTo(LARGURA_DA_TELA, ALTURA_DA_TELA, self.animationTime * 2, 0, .2, function()
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

function PANEL:Think()
    if self:GetGradient() then
        self:ChangeGradient(1, 255, "outQuint")
    else
        self:ChangeGradient(1, 0, "outQuint")
    end
end

function PANEL:Paint()    
	surface.SetDrawColor(PRETO_ABSOLUTO)
	surface.DrawRect(0, 0, LARGURA_DA_TELA, ALTURA_DA_TELA)
end

function PANEL:SetGradient(boolean)
    self.gradient = boolean
end

function PANEL:GetGradient()
    return self.gradient
end

function PANEL:ChangeGradient(length, newAlpha, insertedEasing)
	self:CreateAnimation(length, {
        index  = 1,
		target = {
			gradientAlpha = newAlpha
		},
		easing = insertedEasing
	})
end

vgui.Register("mainMenu", PANEL, "DPanel")

concommand.Add("mainMenu", function()
	vgui.Create("mainMenu")
end)


local PANEL = {}

function PANEL:Init()
    self.parent = self:GetParent()

    self.strokeSize   = (ScreenScale(4))
    self.roundness    = (0)

    self:SetText("CANCELAR")
    self:SetFont("OzymandiasButtonFont")

    self:SetTextColor(BRANCO_ABSOLUTO)
end

function PANEL:OnCursorEntered()
    self:BeWider(2, 20, "outCubic")

    if self.parent.isMainMenu then
        self.parent:SetGradient(true)
    end
end

function PANEL:OnCursorExited()
    self:BeWider(1, 0, "outQuint")

    if self.parent.isMainMenu then
        self.parent:SetGradient(false)
    end
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