# Errors

Raise a value.

`Errors`:
```txt
<<<Errors Type>>>
<<<Catch an Error>>>
```

Also added error support to [stringify](strify.md) and [equality](equal.md).

## Errors Type

`Errors Type`:
```lua
local errorMetatable = {}
errorMetatable.__index = errorMetatable
function err(val) return setmetatable({err = val}, errorMetatable) end

local oType = type
type = function (obj)
    if oType(obj) == "table" and getmetatable(obj) == errorMetatable then return "error" end
    return oType(obj)
end
```

## Catch an Error

If an object is an error, run a function on it with a signature like `function (err, val)` where
`err` is the actual error and `val` is the value inside the error.

`Catch an Error`:
```lua
function catch(obj, f)
    if type(obj) ~= "error" then return obj end
    return f(obj, obj.err)
end
```