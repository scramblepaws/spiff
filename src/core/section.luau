-- core/section.luau | Octernal-style panel: dark fill, inline+outline border,
-- accent top strip, holding elements on the left or right column.
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

		local parent = self.side == "right" and page.right or page.left
		local frame = render.frame(parent, {
			Size = UDim2.new(1, 0, 0, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			BackgroundColor3 = theme.darkcontrast,
		})
		render.borders(frame, theme.inline, theme.outline)
		render.padding(frame, 6, 6)
		self.frame = frame

		local accent = render.frame(frame, {
			Size = UDim2.new(1, 0, 0, 1),
			Position = UDim2.new(0, 0, 0, 0),
			BackgroundColor3 = theme.accent,
		})
		theme:Track(accent, "BackgroundColor3", "accent")

		local title = render.label(frame, {
			Text = self.name,
			Position = UDim2.new(0, 0, 0, 4),
			Size = UDim2.new(1, 0, 0, 15),
			TextXAlignment = Enum.TextXAlignment.Left,
		})
		theme:Track(title, "TextColor3", "text")
		self.title = title

		local content = render.frame(frame, {
			Position = UDim2.new(0, 0, 0, 22),
			Size = UDim2.new(1, 0, 0, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			BackgroundTransparency = 1,
		})
		render.list(content, { padding = 4, sortOrder = Enum.SortOrder.LayoutOrder })
		self.content = content

		return self
	end

	function Section:Add(kind, info)
		local module = ctx.require("elements." .. kind)
		return module.new(self, info or {})
	end

	for api, kind in pairs(ELEMENTS) do
		local k = kind
		Section["Add" .. api] = function(self, info)
			return self:Add(k, info)
		end
	end
	-- accept both capitalisations
	Section.AddButtonholder = Section.AddButtonHolder

	function Section:Destroy()
		if self.frame then
			self.frame:Destroy()
			self.frame = nil
		end
	end

	return Section
end
