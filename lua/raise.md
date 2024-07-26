# Raise

Raise a value.

`Raise`:
```lua
local raiseMetatable = {}
raiseMetatable.__index = raiseMetatable
function raise(val) return setmetatable({raise = val}, raiseMetatable) end

local oType = type
type = function (obj)
    if oType(obj) == "table" and getmetatable(obj) == raiseMetatable then return "raise" end
    return oType(obj)
end
```

Also added raise support to [stringify](strify.md) and [equality](equal.md).

## Raise Tests

`Raise Tests`:
```lua
<<<Raise>>>
function raiseTests()
    test(raise("value").raise, "value", {["msg"] = "raise(\"value\").raise"})
    test(raise(3).raise, 3, {["msg"] = "raise(3).raise"})
    test(raise(false).raise, false, {["msg"] = "raise(false).raise"})
    test(raise(raise(1)).raise, raise(1), {["msg"] = "raise(raise(1)).raise"})
    test(type(raise(1)), "raise", {["msg"] = "type(raise(1))"})
    test(strify(raise(1)), "raise(1)", {["msg"] = "strify(raise(1))"})
end
raiseTests()
```
