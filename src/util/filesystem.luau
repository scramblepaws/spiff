-- util/filesystem.luau | sUNC filesystem + JSON helpers, safe when absent
return function(ctx)
	local fs = {}
	local function has(fn)
		return typeof(fn) == "function"
	end

	function fs.ensure(folder)
		if has(makefolder) then
			pcall(makefolder, folder)
		end
	end

	function fs.exists(path)
		if not has(isfile) then
			return false
		end
		local ok, res = pcall(isfile, path)
		return ok and res or false
	end

	function fs.write(path, data)
		if not has(writefile) then
			return false
		end
		local ok = pcall(writefile, path, data)
		return ok
	end

	function fs.read(path)
		if not (has(readfile) and fs.exists(path)) then
			return nil
		end
		local ok, data = pcall(readfile, path)
		return ok and data or nil
	end

	function fs.encode(value)
		return game:GetService("HttpService"):JSONEncode(value)
	end

	function fs.decode(value)
		local ok, data = pcall(function()
			return game:GetService("HttpService"):JSONDecode(value)
		end)
		return ok and data or nil
	end

	return fs
end
