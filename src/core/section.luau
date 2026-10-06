-- core/section.luau | bordered panel holding elements, on the left or right column
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
			BackgroundColor3 = theme.section,
		})
		render.stroke(frame, theme.outline, 1)
		render.corner(frame, 4)
		render.padding(frame, 6, 6)
		self.frame = frame

		local title = render.label(frame, {
			Text = self.name,
			Size = UDim2.new(1, 0, 0, 16),
			TextXAlignment = Enum.TextXAlignment.Left,
		})
		theme:Track(title, "TextColor3", "text")
		self.title = title

		local content = render.frame(frame, {
			Position = UDim2.new(0, 0, 0, 18),
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

	function Section:Destroy()
		if self.frame then
			self.frame:Destroy()
			self.frame = nil
		end
	end

	return Section
end
