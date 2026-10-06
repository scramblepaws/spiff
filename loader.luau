-- loader.luau | fetch + assemble spiff from raw GitHub at runtime.
--   loadstring(game:HttpGet("https://raw.githubusercontent.com/scramblepaws/spiff/main/loader.luau"))()
getgenv().SpiffConfig = getgenv().SpiffConfig or {}
local Base = getgenv().SpiffConfig.Base or "https://raw.githubusercontent.com/scramblepaws/spiff/main"
local CB = "?cb=" .. tostring(math.floor(tick())) -- ponytail: busts raw caches during dev

local function fetch(path)
	local ok, src = pcall(function()
		return game:HttpGet(Base .. "/" .. path .. CB)
	end)
	assert(ok and typeof(src) == "string", "[spiff] fetch failed: " .. path .. " (" .. tostring(src) .. ")")
	return src
end

local manifestChunk = assert(loadstring(fetch("src/manifest.luau")), "[spiff] manifest did not compile")
local manifest = manifestChunk()

local mods = {}
for _, key in ipairs(manifest) do
	local chunk, err = loadstring(fetch("src/" .. key:gsub("%.", "/") .. ".luau"))
	assert(chunk, "[spiff] compile " .. key .. ": " .. tostring(err))
	local factory = chunk()
	assert(typeof(factory) == "function", "[spiff] " .. key .. " must return function(ctx)")
	mods[key] = factory
end

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
assert(ok, "[spiff] init: " .. tostring(Library))

getgenv().Spiff = Library

if getgenv().SpiffConfig.autoDemo ~= false then
	pcall(function()
		loadstring(game:HttpGet(Base .. "/demo.luau" .. CB))()
	end)
end

return Library
