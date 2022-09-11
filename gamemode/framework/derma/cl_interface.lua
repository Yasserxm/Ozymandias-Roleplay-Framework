-- TODO: Quando os painéis foram removidos, remover também os timers.

local PANEL = {}

--[[
function PANEL:OnKeyCodePressed()
	self:Remove()
end
]]

function PANEL:Init()
    self:MakePopup(true)
    self:SetMouseInputEnabled(false)
    self.fadeAlpha = 255
    self.volume    = 1

	self:SetSize(
		LARGURA_DA_TELA,
		ALTURA_DA_TELA
	)

    timer.Create("OzymandiasIntro", 2, 1, function()
        self.subTitle = self:Add("titleLabel")
        self.subTitle:SetMouseInputEnabled(false)
        self.subTitle:SetText("''Meu nome é Ozymandias, e sou Rei dos Reis: Desesperai, ó grandes, vendo as minhas obras!''")
        self.subTitle:CenterVertical(.65)
        self.subTitle.alwaysCentered = true

        self.buttonExit = self:Add("menuButton")
        self.buttonExit:SetText("Bem-vindo " .. LocalPlayer():Nick() .. ".")
        self.buttonExit:CenterVertical(.75)
        self.buttonExit:CenterHorizontal()
        self.buttonExit.startFaded = true
        self.buttonExit.AfterClick = function()
            self:StopMusicAndRemove(1, "outQuint")
        end
        self.buttonExit.invertColor = true

        timer.Create("OzymandiasIntroDelay", 1, 1, function()
            self.buttonExit:Fadein(.1, 255)
            self:SetMouseInputEnabled(true)
        end)
    end)

    self:PlayMusic()
end

function PANEL:Paint(w, h)
    surface.SetDrawColor(PRETO_ABSOLUTO)
    surface.DrawRect(0, 0, w, h)
end

function PANEL:PlayMusic()
	local path = ("sound/" .. "music/hl2_song8.mp3")
    
	sound.PlayFile(path, "noplay", function(channel, error, errorMessage)
        if IsValid(channel) then
            channel:Play()
            channel:SetVolume(self.volume)

            self.channel = channel
        else
            print("Erro, o áudio não pode ser executado", error, errorMessage)
        end
    end)
end

function PANEL:StopMusicAndRemove(length, insertedEasing)
	self:CreateAnimation(length, {
        index  = 1,
		target = {
			volume = 0
		},
		easing = insertedEasing,

        Think = function()
            if IsValid(self.channel) then
                self.channel:SetVolume(self.volume)
            end
        end,

        OnComplete = function()
            if IsValid(self.channel) then
                self.channel:Stop()
            end

            vgui.Create("mainMenu")

            timer.Create("OzymandiasRemovePreMenu", 1, 1, function()
                self:Remove()
            end)
        end
	})
end

function PANEL:OnRemove()
    timer.Remove("OzymandiasRemovePreMenu")
    timer.Remove("OzymandiasIntroDelay")
    timer.Remove("OzymandiasIntro")

    if IsValid(self.channel) then
        self.channel:Stop()
    end
end

vgui.Register("preMenu", PANEL, "DPanel")

concommand.Add("preMenu", function()
	vgui.Create("preMenu")
end)

local PANEL = {}

--[[
function PANEL:OnKeyCodePressed()
	self:Remove()
end
]]

function PANEL:Init()
	self:MakePopup(true)
	self:SetMouseInputEnabled(false)
    self.isMainMenu    = true
	self.isAnimating   = true
    self.gradient      = false
	self.animationTime = (1)
    self.gradientAlpha = (0)

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

    self.innerBackground = self:Add("DPanel")
    self.innerBackground.Think = function()
        self.innerBackground:Center()
    end
    self.innerBackground.Paint = function()
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
	self.innerBackground:SizeTo(LARGURA_DA_TELA, ALTURA_DA_TELA, self.animationTime * 2, 0, .2, function()
        self:SetMouseInputEnabled(true)
		self.isAnimating = false
	end)

    self.buttonExit = self:Add("menuButton")
    self.buttonExit:SetText("Opa, vamos nessa!")
    self.buttonExit:CenterVertical(.75)
    self.buttonExit:CenterHorizontal()
    self.buttonExit.startFaded  = true
    self.buttonExit.AfterClick = function()
        self:Remove()
    end

    self.mainTitle = self:Add("titleLabel")
    self.mainTitle:SetMouseInputEnabled(false)
    self.mainTitle:SetText("Ozymandias")
    self.mainTitle:SetFont("OzymandiasTitleFont")
    self.mainTitle:CenterVertical(.35)
    self.mainTitle:SetExpensiveShadow(ScreenScale(1), PRETO_ABSOLUTO)
    self.mainTitle.alwaysCentered = true
    self.mainTitle.useBackground  = false
    self.mainTitle.useSoundFX     = true
    self.mainTitle.AfterWriting   = function()
        self.buttonExit:Fadein(1, 255)
    end

    self.subTitle = self:Add("titleLabel")
    self.subTitle:SetMouseInputEnabled(false)
    self.subTitle:SetText("Uma framework produzida pela comunidade lusófona de Garry's Mod.")
    self.subTitle:CenterVertical(.5)
    self.subTitle.alwaysCentered = true
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


--[[
    Botão utilizado por toda
    a framework.
--]]

local PANEL = {}

function PANEL:Init()
    self.startTime  = SysTime()
    self.parent     = self:GetParent()

    self.invertColor = false
    self.primaryColor   = PRETO_ABSOLUTO
    self.secundaryColor = BRANCO_ABSOLUTO

    self.startFaded  = false
    self.fadeAlpha  = (0)

    self.margin     = (ScreenScale(8))
    self.strokeSize = (ScreenScale(4))
    self.roundness  = (0)

    self.clickSound = ("buttons/button3.wav")
    self.enterSound = ("buttons/button16.wav")
    self.exitSound  = ("buttons/lightswitch2.wav")

    self:SetText("Cancelar")
    self:SetFont("OzymandiasButtonFont")

    self:SetTextColor(self.secundaryColor)

    self:SizeToContents()
    self:SetWide(self:GetWide() + self.margin)
    self:SetTall(self:GetTall() + (self.margin / 4))

    self.initTime = math.Round(SysTime() - self.startTime, 1)
    self:PostInit(self.initTime)
end

function PANEL:PostInit(initTime)
    timer.Create("OzymandiasButton" .. math.random(1, 9999) + self:CursorPos(), initTime, 1, function()
        if self.invertColor then
            local oldPrimaryColor   = self.primaryColor
            local oldSecundaryColor = self.secundaryColor

            self.primaryColor   = oldSecundaryColor
            self.secundaryColor = oldPrimaryColor

            self:SetTextColor(self.secundaryColor)
        end

        local newWidth, newHeight = self:GetContentSize()
        self:SizeToContents()

        self:SetWide(self:GetWide() + self.margin)
        self:SetPos(self:GetX() - (newWidth / 2) + self.margin * (self.margin / ScreenScale(4)), self:GetY() - (newHeight / 2))
    end)
end

function PANEL:OnCursorEntered()
    self:BeWider(2, 20, "outCubic")

    if self.parent.isMainMenu then
        self.parent:SetGradient(true)
    end

    surface.PlaySound(self.enterSound)
end

function PANEL:OnCursorExited()
    self:BeWider(1, 0, "outQuint")

    if self.parent.isMainMenu then
        self.parent:SetGradient(false)
    end

    surface.PlaySound(self.exitSound)
end

function PANEL:Paint(w, h)
    local circleSize = ScreenScale(1)

    if !(self.startFaded) then
        draw.RoundedBox(ScreenScale(0) + self.roundness, -- Porque sim.
        0,        0,                        w,        h,
        self.primaryColor)

        draw.RoundedBox(
        ScreenScale(0)  +   self.roundness,  0,       0,
        math.Clamp((w   *   self.roundness ^ -1), 0, w),
        circleSize,         ColorAlpha(self.secundaryColor ,
        math.Clamp(255 * self.roundness ^ -1, 0,  255)))
    else
        self:SetTextColor(ColorAlpha(self:GetTextColor(), self.fadeAlpha))

        draw.RoundedBox(ScreenScale(0) + self.roundness,
        0,        0,                        w,        h,
        ColorAlpha(self.primaryColor, self.fadeAlpha))

        draw.RoundedBox(
        ScreenScale(0)  +   self.roundness,  0,       0,
        math.Clamp((w   *   self.roundness ^ -1), 0, w),
        circleSize,         ColorAlpha(self.secundaryColor ,
        math.Clamp(255 * self.roundness ^ -1, 0,  255 * self.fadeAlpha)))
    end
end

function PANEL:DoClick()
    surface.PlaySound(self.clickSound)

    self:AfterClick()
end

function PANEL:AfterClick()
end

function PANEL:BeWider(length, newBorder, insertedEasing)
	self:CreateAnimation(length, {
        index  = 1,
		target = {
			roundness = ScreenScale(newBorder)
		},
		easing = insertedEasing,
	})
end

function PANEL:Fadein(length, newAlpha, insertedEasing)
	self:CreateAnimation(length, {
        index  = 2,
		target = {
			fadeAlpha = newAlpha
		},
		easing = insertedEasing,

        OnComplete = function()
            surface.PlaySound("garrysmod/content_downloaded.wav")
        end
	})
end



vgui.Register("menuButton", PANEL, "DButton")


--[[
    Label utilizada por toda
    a framework.
--]]

local PANEL = {}

function PANEL:Init()
    self.startTime = (SysTime())
    self.charCount = (0)
    self.textChar  = (0)
    self.textFull  = ("")
    self.textSizeW = (0)
    self.textSizeH = (0)
    self.animSpeed = (10)
    self.alwaysCentered = false
    self.useBackground  = true
    self.useSoundFX     = false
    self.ready          = false
    self.isAnimating    = true
    self.soundFX        = ("ui/buttonrollover.wav")

    self:SetFont("OzymandiasSmallLabelFont")
    self:SetColor(COR_INVISIVEL)

    self.initTime = math.Round(SysTime() - self.startTime, 1)
    self:PostInit(self.initTime)
end

function PANEL:PostInit(initTime)
    timer.Create("OzymandiasLabel" .. math.random(1, 9999) + self:CursorPos(), initTime, 1, function()
        self.textChar = (0)
        self.lastChar = (utf8.len(self:GetText()))
        self.textFull = (self:GetText())

        self:AutoWrite(self.animSpeed, self.lastChar, "outQuint")

        if self:GetColor() == COR_INVISIVEL then
            self:SetColor(BRANCO_ABSOLUTO)
        end

        self.ready = true
    end)
end

function PANEL:Think()
    if self.ready then
        self:SetText(utf8.sub(self.textFull, 0, self.textChar))
        
        if self.isAnimating then
            self:SizeToContents()

            if (self.useSoundFX) and math.Round(self.textChar) > self.charCount then
                surface.PlaySound(self.soundFX)
            end

            self.charCount = math.Round(self.textChar)
        end

        if self.alwaysCentered then
            self:CenterHorizontal(.5)
        end
    end
end

function PANEL:Paint()
    if self.useBackground then
        draw.RoundedBox(0, 0, 0, self:GetWide(), self:GetTall(), PRETO_ABSOLUTO)
    end
end

function PANEL:AutoWrite(length, newChar, insertedEasing)
    self:CreateAnimation(length, {
		target = {
			textChar = newChar
		},
		easing = insertedEasing,
        OnComplete = function()
            self.IsAnimating = false
            
            if self.useSoundFX then
                surface.PlaySound(self.soundFX)
            end

            self:AfterWriting()
        end
	})
end

function PANEL:AfterWriting()
end

vgui.Register("titleLabel", PANEL, "DLabel")