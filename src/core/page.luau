-- core/page.luau | a tab (outline->inline->color button) + its own section canvas
return function(ctx)
	local render = ctx.render
	local theme = ctx.util.theme

	local Page = {}
	Page.__index = Page

	function Page.new(window, info)
		info = info or {}
		local self = setmetatable({}, Page)
		self.window = window
		self.name = info.name or info.title or "Page"
		self.sections = {}
		self.sectionOffsets = { left = 0, right = 0 }

		local button = render.frame(window.tabStrip, {
			Size = UDim2.new(0, render.textSize(self.name).X + 41.6, 1, 0),
			BackgroundColor3 = theme.outline,
			LayoutOrder = #window.pages,
		})
		local inline = render.frame(button, {
			Position = UDim2.new(0, 1, 0, 1),
			Size = UDim2.new(1, -2, 1, -1),
			BackgroundColor3 = theme.inline,
		})
		local color = render.frame(inline, {
			Position = UDim2.new(0, 1, 0, 1),
			Size = UDim2.new(1, -2, 1, -1),
			BackgroundColor3 = theme.darkcontrast,
		})
		local title = render.label(color, {
			Text = self.name,
			Size = UDim2.new(1, 0, 1, 0),
			TextXAlignment = Enum.TextXAlignment.Center,
			TextYAlignment = Enum.TextYAlignment.Center,
		})
		local click = render.button(button, {
			Size = UDim2.new(1, 0, 1, 0),
			BackgroundTransparency = 1,
			Text = "",
		})
		ctx.util.signal.connect(click.MouseButton1Click, function()
			self:Show()
		end)
		self.button = button
		self.buttonColor = color

		local content = render.frame(window.body, {
			Size = UDim2.new(1, 0, 1, 0),
			BackgroundTransparency = 1,
			Visible = false,
		})
		self.content = content
		-- subtle column divider
		local divider = render.frame(content, {
			Position = UDim2.new(0.5, -1, 0, 0),
			Size = UDim2.new(0, 2, 1, 0),
			BackgroundColor3 = theme.accent,
			BackgroundTransparency = 0.35,
		})
		theme:Track(divider, "BackgroundColor3", "accent")

		return self
	end

	function Page:SetActive(on)
		self.buttonColor.BackgroundColor3 = on and theme.lightcontrast or theme.darkcontrast
	end

	function Page:Show()
		local win = self.window
		if win.currentPage and win.currentPage ~= self then
			win.currentPage.content.Visible = false
			win.currentPage:SetActive(false)
		end
		self.content.Visible = true
		self:SetActive(true)
		win.currentPage = self
	end

	function Page:Section(info)
		local Section = ctx.require("core.section")
		info = info or {}
		local section = Section.new(self, {
			name = info.name or info.title,
			side = info.side or info.Side or "left",
		})
		self.sections[#self.sections + 1] = section
		self:Update()
		return section
	end

	function Page:Update()
		local off = { left = 0, right = 0 }
		for _, s in ipairs(self.sections) do
			s.outer.Position = UDim2.new(
				s.side == "right" and 0.5 or 0,
				s.side == "right" and 2 or 5,
				0,
				5 + off[s.side]
			)
			off[s.side] = off[s.side] + s.axis + 4 + 5
		end
	end

	function Page:Destroy()
		if self.button then
			self.button:Destroy()
		end
		if self.content then
			self.content:Destroy()
		end
		for i in ipairs(self.sections) do
			self.sections[i] = nil
		end
	end

	return Page
end
