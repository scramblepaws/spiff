-- core/page.luau | a tab: a nav button plus a two-column scrolling body
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

		local button = render.button(window.tabStrip, {
			Text = self.name,
			Size = UDim2.new(0, render.textSize(self.name).X + 20, 1, 0),
			TextColor3 = theme.text,
			TextSize = theme.textsize,
			BackgroundColor3 = theme.darkcontrast,
			BackgroundTransparency = 0,
			LayoutOrder = #window.pages,
		})
		render.corner(button, 3)
		render.borders(button, theme.outline, theme.inline)
		self.button = button

		local content = render.frame(window.body, {
			Size = UDim2.new(1, 0, 1, 0),
			BackgroundTransparency = 1,
			Visible = false,
		})
		self.content = content

		local function column(posScale, posOffset, widthOffset)
			local col = render.scroll(content)
			col.Position = UDim2.new(posScale, posOffset, 0, 0)
			col.Size = UDim2.new(0.5, widthOffset, 1, 0)
			render.list(col, { padding = 6 })
			render.padding(col, 6, 6)
			return col
		end
		self.left = column(0, 0, -8)
		self.right = column(0.5, 4, -8)

		ctx.util.signal.connect(button.MouseButton1Click, function()
			self:Show()
		end)

		return self
	end

	function Page:SetActive(on)
		self.button.BackgroundColor3 = on and theme.lightcontrast or theme.darkcontrast
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
		return section
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
