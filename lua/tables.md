# Table Functions

Some useful table functions.

`Tables`:
```lua
<<<Tail>>>
<<<Head>>>
<<<Slicing>>>
```

## Tail

Depends on [stringify](strify.md), [deepcopy](deepcopy.md), and [errors](errors.md).

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

Depends on [stringify](strify.md), [deepcopy](deepcopy.md), and [errors](errors.md).

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

Depends on [stringify](strify.md), [deepcopy](deepcopy.md), and [errors](errors.md).

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

## Table Functions Tests

`Tables Tests`:
```lua
<<<Tables>>>

function tableTests()
    test(tail({1, 2, 3, 4, 5}), {2, 3, 4, 5}, {["msg"] = "tail({1, 2, 3, 4, 5})"})
    test(tail({1, 2, 3, 4, 5}, 2), {3, 4, 5}, {["msg"] = "tail({1, 2, 3, 4, 5}, 2)"})
    test(tail(1), err("1st argument (1) is not a table"), {["msg"] = "tail(1)"})
    test(tail({1}, 1.2), err("2nd argument (1.2) is not an integer"), {["msg"] = "tail({1}, 1.2)"})
    test(tail({1}, true), err("2nd argument (true) is not an integer"), {["msg"] = "tail({1}, true)"})
    test(head({1, 2, 3, 4, 5}), {1}, {["msg"] = "head({1, 2, 3, 4, 5})"})
    test(head({1, 2, 3, 4, 5}, 2), {1, 2}, {["msg"] = "head({1, 2, 3, 4, 5}, 2)"})
    test(head(1), err("1st argument (1) is not a table"), {["msg"] = "head(1)"})
    test(head({1}, 1.2), err("2nd argument (1.2) is not an integer"), {["msg"] = "head({1}, 1.2)"})
    test(head({1}, true), err("2nd argument (true) is not an integer"), {["msg"] = "head({1}, true)"})
    test(slice({1, 2, 3, 4, 5}), {1, 2, 3, 4, 5}, {["msg"] = "slice({1, 2, 3, 4, 5})"})
    test(slice({1, 2, 3, 4, 5}, 2), {2, 3, 4, 5}, {["msg"] = "slice({1, 2, 3, 4, 5}, 2)"})
    test(slice({1, 2, 3, 4, 5}, 2, 4), {2, 3, 4}, {["msg"] = "slice({1, 2, 3, 4, 5}, 2, 4)"})
    test(slice(1), err("1st argument (1) is not a table"), {["msg"] = "slice(1)"})
    test(slice({1}, 1.2), err("2nd argument (1.2) is not an integer"), {["msg"] = "slice({1}, 1.2)"})
    test(slice({1}, true), err("2nd argument (true) is not an integer"), {["msg"] = "slice({1}, true)"})
    test(slice({1}, 1, 1.2), err("3rd argument (1.2) is not an integer"), {["msg"] = "slice({1}, 1, 1.2)"})
    test(slice({1}, 1, true), err("3rd argument (true) is not an integer"), {["msg"] = "slice({1}, 1, true)"})
end
tableTests()
```
