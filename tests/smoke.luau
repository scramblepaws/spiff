-- tests/smoke.luau | run after loader.luau in an executor.
-- Builds the library and asserts the public surface exists. Grows each phase.
local Menu = getgenv().Spiff
assert(Menu, "[smoke] Spiff not loaded")

assert(type(Menu.Unload) == "function", "[smoke] Library.Unload missing")

print("[smoke] ok", Menu._VERSION)
