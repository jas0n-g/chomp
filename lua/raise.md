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