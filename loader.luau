-- loader.luau | fetch + assemble spiff from raw GitHub at runtime.
--   loadstring(game:HttpGet("https://raw.githubusercontent.com/scramblepaws/spiff/main/loader.luau"))()
local config = getgenv().SpiffConfig
if type(config) ~= "table" then
	config = {}
	getgenv().SpiffConfig = config
end
local Base = config.Base or "https://raw.githubusercontent.com/scramblepaws/spiff/main"
local CB = "?cb=" .. tostring(math.floor((os.clock and os.clock() or 0) * 1000))

local function log(...)
	print("[spiff]", ...)
end

local function httpGet(url)
	local attempts = {
		function()
			return game:HttpGet(url)
		end,
		function()
			return game:HttpGetAsync(url)
		end,
		function()
			return request({ Url = url, Method = "GET" }).Body
		end,
		function()
			return http_request({ Url = url, Method = "GET" }).Body
		end,
	}
	local last = "no http method available"
	for _, attempt in ipairs(attempts) do
		local ok, res = pcall(attempt)
		if ok and typeof(res) == "string" and #res > 0 then
			return res
		end
		if not ok then
			last = res
		end
	end
	error("[spiff] HttpGet failed: " .. tostring(last))
end

local compile = loadstring or load
assert(typeof(compile) == "function", "[spiff] this executor has no loadstring/load")

log("fetching manifest from", Base)
local manifestChunk = compile(httpGet(Base .. "/src/manifest.luau" .. CB))
assert(manifestChunk, "[spiff] manifest did not compile")
local manifest = manifestChunk()
assert(type(manifest) == "table", "[spiff] manifest is not a list")

local mods = {}
for _, key in ipairs(manifest) do
	local chunk, err = compile(httpGet(Base .. "/src/" .. key:gsub("%.", "/") .. ".luau" .. CB))
	assert(chunk, "[spiff] compile " .. key .. ": " .. tostring(err))
	local factory = chunk()
	assert(typeof(factory) == "function", "[spiff] " .. key .. " must return function(ctx)")
	mods[key] = factory
end
log("loaded", #manifest, "modules")

local ctx = { _mods = mods, _cache = {} }
function ctx.require(key)
	local cached = ctx._cache[key]
	if cached ~= nil then
		return cached
	end
	local factory = mods[key]
	assert(factory, "[spiff] missing module: " .. key)
	local value = factory(ctx)
	ctx._cache[key] = value
	return value
end

local ok, Library = pcall(ctx.require, "init")
assert(ok, "[spiff] init failed: " .. tostring(Library))

getgenv().Spiff = Library
log("ready - spiff", Library._VERSION, "-> getgenv().Spiff")

-- ---- demo ------------------------------------------------------------------
local function runDemo(src, label)
	local fn, err = compile(src)
	if not fn then
		warn("[spiff] " .. label .. " did not compile: " .. tostring(err))
		return false
	end
	local ok2, err2 = pcall(fn)
	if not ok2 then
		warn("[spiff] " .. label .. " error: " .. tostring(err2))
		return false
	end
	return true
end

if config.autoDemo ~= false then
	local okDemo, demoErr = pcall(function()
		local src = httpGet(Base .. "/demo.luau" .. CB)
		if not runDemo(src, "demo") then
			-- fallback so you always get a window if the hosted demo breaks
			runDemo([[
				local Menu = getgenv().Spiff
				local win = Menu.Window({ name = "spiff (fallback)" })
				local p = win:Page({ name = "Main" })
				local s = p:Section({ name = "General" })
				s:AddLabel({ text = "spiff " .. Menu._VERSION .. " loaded" })
				s:AddToggle({ name = "Test", value = true, callback = print })
				s:AddButton({ name = "Ping", callback = function() print("[spiff] pong") end })
			]], "fallback demo")
		end
	end)
	if not okDemo then
		warn("[spiff] demo fetch failed: " .. tostring(demoErr))
	end
end

return Library
