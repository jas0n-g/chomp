# Errors

`Errors`:
```lua
<<<Error Type>>>
<<<Catch>>>
```

## Error Type

`Error Type`:
```lua
local errorMetatable = {}
errorMetatable.__index = errorMetatable
function err(errVal) return setmetatable({ val = errVal }, errorMetatable) end
local oType = type
type = function(obj)
    if oType(obj) == "table" and getmetatable(obj) == errorMetatable then return "error" end
    return oType(obj)
end
```

## Catch

The function passed into `catch()` should have a signature similar to
`function name(err, val)`, where `err` is the actual error and `val` is the
value in the error.

`Catch`:
```lua
function catch(obj, f)
    if type(obj) ~= "error" then return obj end
    return f(obj, obj.msg)
end
```

## Errors Tests

`Errors Tests`:
```lua
<<<Errors>>>

function errorsTest()
    test(err(2).val, 2, {["msg"] = "err(2).val"})
    test(err("string").val, "string", {["msg"] = "err(string).val"})
    test(err().val, nil, {["msg"] = "err().val"})
    test(type(err()), "error", {["msg"] = "type(err())"})
    test(
        catch(
            "ok",
            function (err, val)
                if val == nil then return "error" end
            end
        ),
        "ok",
        {["msg"] = "catch test on ok"}
    )
    test(
        catch(
            err(),
            function (err, val)
                if val == nil then return "error" end
            end
        ),
        "error",
        {["msg"] = "catch test on error"}
    )
end
errorsTest()
```
