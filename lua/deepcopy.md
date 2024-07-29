# Deepcopy

Copy anything, recursively if its a table.

`Deepcopy`:
```lua
function deepcopy(obj)
    if type(obj) == "table" then
        local out = {}
        for k, v in pairs(obj) do out[k] = deepcopy(v) end
        return out
    elseif type(obj) == "raise" then
        return raise(deepcopy(obj.raise))
    elseif type(obj) == "error" then
        return err(deepcopy(obj.err))
    else
        return obj
    end
end
```

## Deepcopy Tests

`Deepcopy Tests`:
```lua
<<<Deepcopy>>>

function deepcopyTests()
    test(deepcopy(1), 1, {["msg"] = "deepcopy(1)"})
    test(deepcopy(true), true, {["msg"] = "deepcopy(true)"})
    test(deepcopy("copy"), "copy", {["msg"] = "deepcopy(\"copy\")"})
    test(deepcopy(err(1)), err(1), {["msg"] = "deepcopy(err(1))"})
    test(deepcopy(raise(1)), raise(1), {["msg"] = "deepcopy(raise(1))"})
    test(deepcopy(err(raise(1))), err(raise(1)), {["msg"] = "deepcopy(err(raise(1)))"})
    test(deepcopy(raise(err(1))), raise(err(1)), {["msg"] = "deepcopy(raise(err(1)))"})
    test(
        deepcopy({1, true, {"a", "sub", "list"}, ["key"] = "value"}),
        {1, true, {"a", "sub", "list"}, ["key"] = "value"},
        {["msg"] = "deepcopy({1, true, {\"a\", \"sub\", \"list\"}, [\"key\"] = \"value\"})"}
    )
end
deepcopyTests()
```
