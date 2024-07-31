# Equality

Better `==` operator.

`Equality`:
```lua
function eq(x, y)
    if type(x) ~= type(y) then return false end
    if type(x) == "raise" then return eq(x.raise, y.raise) end
    if type(x) == "error" then return eq(x.err, y.err) end
    if type(x) == "table" then
        if #x ~= #y then return false end
        for k, _ in pairs(x) do if not eq(x[k], y[k]) then return false end end
    end
    if type(x) ~= "table" then return x == y end

    return true
end
```