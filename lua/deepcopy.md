# Deepcopy

Copy a value or recursively copy a table.

`Deepcopy`:
```lua
function deepcopy(x)
    local y = nil
    if type(x) == "table" then
        if #x == 0 then return {} end
        y = {}
        for k, v in pairs(x) do y[k] = deepcopy(v) end
    else
        y = x
    end
    return y
end
```

## Deepcopy Tests

`Deepcopy Tests`:
```lua
<<<Deepcopy>>>

function deepcopyTests()
    test(deepcopy({}), {}, {["msg"] = "deepcopy({})"})
    test(deepcopy(nil), nil, {["msg"] = "deepcopy(nil)"})
    test(deepcopy(false), false, {["msg"] = "deepcopy(false)"})
    test(deepcopy(3.1), 3.1, {["msg"] = "deepcopy(3.1)"})
    test(
        deepcopy({["key"] = "value", {"a", "sub", {"list", 2}}}),
        {["key"] = "value", {"a", "sub", {"list", 2}}},
        {["msg"] = "deepcopy({[\"key\"] = \"value\", {\"a\", \"sub\", {\"list\", 2}}})"}
    )
end
deepcopyTests()
```
