# Table Functions

Some useful table functions.

`Tables`:
```txt
<<<Tail>>>
<<<Head>>>
<<<Slicing>>>
<<<Mapping>>>
<<<Filter>>>
```

## Tail

Depends on [deepcopy](deepcopy.md), [errors](errors.md), and [stringify](strify.md).

`Tail`:
```lua
function tail(tbl, n)
    if type(tbl) ~= "table" then return err("1st argument (" .. strify(tbl) .. ") is not a table") end
    if type(n) ~= "number" or n ~= math.floor(n) then if n == nil then n = 1 else return err("2nd argument (" .. strify(n) .. ") is not an integer") end end

    local out = {}
    local i = 1
    for k, v in pairs(tbl) do
        if i > n then if type(k) == "number" then out[i - n] = deepcopy(v) else out[k] = deepcopy(v) end end
        i = i + 1
    end
    return out
end
```

## Head

Depends on [deepcopy](deepcopy.md), [errors](errors.md), and [stringify](strify.md).

`Head`:
```lua
function head(tbl, n)
    if type(tbl) ~= "table" then return err("1st argument (" .. strify(tbl) .. ") is not a table") end
    if type(n) ~= "number" or n ~= math.floor(n) then if n == nil then n = 1 else return err("2nd argument (" .. strify(n) .. ") is not an integer") end end

    local out = {}
    local i = 1
    for k, v in pairs(tbl) do
        if i <= n then if type(k) == "number" then out[i] = deepcopy(v) else out[k] = deepcopy(v) end end
        i = i + 1
    end
    return out
end
```

## Slicing

Depends on [deepcopy](deepcopy.md), [errors](errors.md), and [stringify](strify.md).

`Slicing`:
```lua
function slice(tbl, startIdx, endIdx)
    if type(tbl) ~= "table" then return err("1st argument (" .. strify(tbl) .. ") is not a table") end
    if type(startIdx) ~= "number" or startIdx ~= math.floor(startIdx) then if startIdx == nil then startIdx = 1 else return err("2nd argument (" .. strify(startIdx) .. ") is not an integer") end end
    if type(endIdx) ~= "number" or endIdx ~= math.floor(endIdx) then if endIdx == nil then endIdx = #tbl else return err("3rd argument (" .. strify(endIdx) .. ") is not an integer") end end

    local out = {}
    local i = 1
    for k, v in pairs(tbl) do
        if i >= startIdx and i <= endIdx then if type(k) == "number" then out[i - startIdx + 1] = deepcopy(v) else out[k] = deepcopy(v) end end
        i = i + 1
    end
    return out
end
```

## Mapping

Depends on [deepcopy](deepcopy.md), [errors](errors.md), and [stringify](strify.md).

`Mapping`:
```lua
function map(tbl, func)
    if type(tbl) ~= "table" then return err("1st argument (" .. strify(tbl) .. ") is not a table") end
    if type(func) ~= "function" then return err("2nd argument (" .. strify(func) .. ") is not a function") end

    local out = {}
    for k, v in pairs(tbl) do out[k] = func(v) end
    return out
end

function mapM(tbl, func)
    if type(tbl) ~= "table" then return err("1st argument (" .. strify(tbl) .. ") is not a table") end
    if type(func) ~= "function" then return err("2nd argument (" .. strify(func) .. ") is not a function") end

    for _, v in pairs(tbl) do func(v) end
end
```

## Filter

Depends on [deepcopy](deepcopy.md), [errors](errors.md), and [stringify](strify.md).

`Filter`:
```lua
function filter(tbl, func)
    if type(tbl) ~= "table" then return err("1st argument (" .. strify(tbl) .. ") is not a table") end
    if type(func) ~= "function" then return err("2nd argument (" .. strify(func) .. ") is not a function") end

    local out = {}
    for k, v in pairs(tbl) if type(k) == "number" then if func(v) == true then out[#out + 1] = v end else if func(v) == true then out[k] = v end end end
    return out
end
```