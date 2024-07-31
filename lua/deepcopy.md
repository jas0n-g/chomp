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