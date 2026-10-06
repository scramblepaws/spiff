-- render/index.luau | native Roblox Instance backend.
-- The ONLY file that touches Instances directly; swap it for a Drawing backend
-- without touching core, elements, or widgets.
return function(ctx)
	local theme = ctx.util.theme
	local render = {}

	local function create(class, props, parent)
		local inst = Instance.new(class)
		if props then
			for k, v in next, props do
				inst[k] = v
			end
		end
		if parent then
			inst.Parent = parent
		end
		return inst
	end
	render.create = create

	function render.frame(parent, props)
		props = props or {}
		if props.BorderSizePixel == nil then
			props.BorderSizePixel = 0
		end
		if props.BackgroundColor3 == nil then
			props.BackgroundColor3 = theme.surface
		end
		return create("Frame", props, parent)
	end

	function render.label(parent, props)
		props = props or {}
		if props.BackgroundTransparency == nil then
			props.BackgroundTransparency = 1
		end
		if props.Font == nil then
			props.Font = theme.font
		end
		if props.TextSize == nil then
			props.TextSize = theme.textsize
		end
		if props.TextColor3 == nil then
			props.TextColor3 = theme.text
		end
		if props.TextXAlignment == nil then
			props.TextXAlignment = Enum.TextXAlignment.Left
		end
		-- Octernal look: every label is outlined
		if props.TextStrokeTransparency == nil then
			props.TextStrokeTransparency = 0
		end
		if props.TextStrokeColor3 == nil then
			props.TextStrokeColor3 = theme.outline
		end
		return create("TextLabel", props, parent)
	end

	function render.button(parent, props)
		props = props or {}
		if props.BackgroundTransparency == nil then
			props.BackgroundTransparency = 1
		end
		if props.AutoButtonColor == nil then
			props.AutoButtonColor = false
		end
		if props.Text == nil then
			props.Text = ""
		end
		return create("TextButton", props, parent)
	end

	function render.textbox(parent, props)
		props = props or {}
		if props.BackgroundColor3 == nil then
			props.BackgroundColor3 = theme.background
		end
		if props.TextColor3 == nil then
			props.TextColor3 = theme.text
		end
		if props.PlaceholderColor3 == nil then
			props.PlaceholderColor3 = theme.dim
		end
		if props.Font == nil then
			props.Font = theme.font
		end
		if props.TextSize == nil then
			props.TextSize = theme.textsize
		end
		if props.BorderSizePixel == nil then
			props.BorderSizePixel = 0
		end
		if props.ClearTextOnFocus == nil then
			props.ClearTextOnFocus = false
		end
		return create("TextBox", props, parent)
	end

	function render.stroke(parent, color, thickness)
		return create("UIStroke", {
			Color = color or theme.outline,
			Thickness = thickness or 1,
			ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
		}, parent)
	end

	-- one clean 1px border
	function render.borders(parent, color)
		render.stroke(parent, color or theme.inline, 1)
		return parent
	end

	function render.padding(parent, x, y)
		return create("UIPadding", {
			PaddingLeft = UDim.new(0, x),
			PaddingRight = UDim.new(0, x),
			PaddingTop = UDim.new(0, y),
			PaddingBottom = UDim.new(0, y),
		}, parent)
	end

	function render.list(parent, opts)
		opts = opts or {}
		return create("UIListLayout", {
			Padding = UDim.new(0, opts.padding or 4),
			FillDirection = opts.horizontal and Enum.FillDirection.Horizontal or Enum.FillDirection.Vertical,
			SortOrder = opts.sortOrder or Enum.SortOrder.LayoutOrder,
			HorizontalAlignment = opts.hAlign or Enum.HorizontalAlignment.Left,
			VerticalAlignment = opts.vAlign or Enum.VerticalAlignment.Top,
		}, parent)
	end

	function render.scroll(parent)
		return create("ScrollingFrame", {
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			ScrollBarThickness = 4,
			ScrollBarImageColor3 = theme.inline,
			CanvasSize = UDim2.new(),
			AutomaticCanvasSize = Enum.AutomaticSize.Y,
			Size = UDim2.new(1, 0, 1, 0),
		}, parent)
	end

	function render.textSize(text, size, font)
		local TextService = game:GetService("TextService")
		size = size or theme.textsize
		font = font or theme.font
		local ok, bounds = pcall(function()
			return TextService:GetTextSize(text, size, font, Vector2.new(1e4, 1e4))
		end)
		return (ok and bounds) or Vector2.new(#text * size * 0.6, size)
	end

	return render
end
