-- core/section.luau | Octernal section: inline -> outline -> darkcontrast,
-- 1px accent top line, manual y-axis layout for elements.
return function(ctx)
	local render = ctx.render
	local theme = ctx.util.theme

	local Section = {}
	Section.__index = Section

	local ELEMENTS = {
		Label = "label",
		Button = "button",
		Toggle = "toggle",
		Slider = "slider",
		Textbox = "textbox",
		Dropdown = "dropdown",
		Multibox = "multibox",
		Keybind = "keybind",
		Colorpicker = "colorpicker",
		Listbox = "listbox",
		ConfigBox = "configbox",
		ButtonHolder = "buttonholder",
	}

	function Section.new(page, info)
		info = info or {}
		local self = setmetatable({}, Section)
		self.page = page
		self.window = page.window
		self.name = info.name or "Section"
		self.side = info.side == "right" and "right" or "left"
		self.axis = 20

		local outer = render.frame(page.content, {
			Position = UDim2.new(self.side == "right" and 0.5 or 0, self.side == "right" and 2 or 5, 0, 5 + page.sectionOffsets[self.side]),
			Size = UDim2.new(0.5, -7, 0, 22),
			BackgroundColor3 = theme.inline,
		})
		self.outer = outer
		local outline = render.frame(outer, {
			Position = UDim2.new(0, 1, 0, 1),
			Size = UDim2.new(1, -2, 1, -2),
			BackgroundColor3 = theme.outline,
		})
		self.outline = outline
		local inner = render.frame(outline, {
			Position = UDim2.new(0, 1, 0, 1),
			Size = UDim2.new(1, -2, 1, -2),
			BackgroundColor3 = theme.darkcontrast,
		})
		self.frame = inner
		local accent = render.frame(inner, {
			Size = UDim2.new(1, 0, 0, 1),
			BackgroundColor3 = theme.accent,
		})
		theme:Track(accent, "BackgroundColor3", "accent")
		local title = render.label(inner, {
			Text = self.name,
			Position = UDim2.new(0, 3, 0, 3),
			Size = UDim2.new(1, -6, 0, 15),
		})
		theme:Track(title, "TextColor3", "textcolor")
		self.title = title

		page.sectionOffsets[self.side] = page.sectionOffsets[self.side] + 105
		self:Update()
		return self
	end

	function Section:Update()
		self.outer.Size = UDim2.new(0.5, -7, 0, self.axis + 4)
	end

	function Section:Add(kind, info)
		local module = ctx.require("elements." .. kind)
		return module.new(self, info or {})
	end

	for api, kind in pairs(ELEMENTS) do
		local k = kind
		local method = function(self, info)
			return self:Add(k, info)
		end
		Section["Add" .. api] = method
		Section[api] = method -- reference-style: section:Toggle(...)
	end
	Section.AddButtonholder = Section.AddButtonHolder
	Section.Buttonholder = Section.ButtonHolder
	Section.AddConfigbox = Section.AddConfigBox
	Section.Configbox = Section.ConfigBox

	function Section:Destroy()
		if self.outer then
			self.outer:Destroy()
			self.outer = nil
		end
	end

	return Section
end
