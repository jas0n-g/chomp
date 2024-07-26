# Errors

Raise a value.

`Errors`:
```lua
<<<Errors Type>>>
<<<Catch an Error>>>
<<<Try>>>
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

If an object is an error, run a function on it with a signature like
`function (err, val)` where `err` is the actual error and `val` is the value
inside the error.

`Catch an Error`:
```lua
function catch(obj, f)
    if type(obj) ~= "error" then return obj end
    return f(obj, obj.err)
end
```

## Try

If an object is an error, it returns a raise value of the error. Depends on
[raise](raise.md). After getting a value from this, check if the value is of
type `raise` and return it.

`Try`:
```lua
function try(obj)
    if type(obj) ~= "error" then return obj end
    return raise(obj)
end
```

## Errors Tests

`Errors Tests`:
```lua
<<<Errors>>>
function errorsTest()
    test(err("value").err, "value", {["msg"] = "err(\"value\").err"})
    test(err(3).err, 3, {["msg"] = "err(3).err"})
    test(err(false).err, false, {["msg"] = "err(false).err"})
    test(err(err(1)).err, err(1), {["msg"] = "err(err(1)).err"})
    test(type(err(1)), "error", {["msg"] = "type(err(1))"})
    test(strify(err(1)), "err(1)", {["msg"] = "strify(err(1))"})
    test(
        catch(err(1), function (err, val) return err end),
        err(1),
        {["msg"] = "catch(err(1), ...)"}
    )
    test(
        catch(1, function (err, val) return err end),
        1,
        {["msg"] = "catch(1, ...)"}
    )
    test(try(err(1)), raise(err(1)), {["msg"] = "try(err(1))"})
    test(try(1), 1, {["msg"] = "try(1)"})
end
errorsTest()
```
