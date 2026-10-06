-- util/signal.luau | connection tracking + a minimal emitter
return function(ctx)
	local signal = {}

	-- track an RBXScriptConnection so Unload can drop it
	function signal.connect(event, fn)
		local conn = event:Connect(fn)
		ctx.state.connections[#ctx.state.connections + 1] = conn
		return conn
	end

	function signal.disconnectAll()
		for _, conn in ipairs(ctx.state.connections) do
			pcall(function()
				conn:Disconnect()
			end)
		end
		table.clear(ctx.state.connections)
	end

	-- minimal event emitter, used by elements to broadcast Set()
	function signal.new()
		local s = { handlers = {} }
		function s:Connect(fn)
			table.insert(self.handlers, fn)
			return {
				Disconnect = function()
					for i, h in ipairs(self.handlers) do
						if h == fn then
							table.remove(self.handlers, i)
							return
						end
					end
				end,
			}
		end
		function s:Fire(...)
			for _, fn in ipairs(self.handlers) do
				pcall(fn, ...)
			end
		end
		return s
	end

	return signal
end
