# Equality

Better `==` operator.

`Equality`:
```lua
function eq(x, y)
    if type(x) ~= type(y) then return false end
    if type(x) ~= "table" then return x == y end
    if #x ~= #y then return false end
    for k, _ in pairs(x) do if not eq(x[k], y[k]) then return false end end

    return true
end
```

## Equality Tests

`Equality Tests`:
```lua
function eqTests()
    test(eq(5, 5), true, {["msg"] = "eq(5, 5)"})
    test(eq(5, 4), false, {["msg"] = "eq(5, 4)"})
    test(eq(5, "str"), false, {["msg"] = "eq(5, \"str\")"})
    test(eq("str", "str"), true, {["msg"] = "eq(\"str\", \"str\")"})
    test(eq("str", true), false, {["msg"] = "eq(\"str\", true)"})
    test(eq(false, true), false, {["msg"] = "eq(false, true)"})
    test(eq(false, false), true, {["msg"] = "eq(false, false)"})
    test(
        eq(false, {1, false, {"a", "sub", "list"}, ["key"] = "value"}),
        false,
        {["msg"] = "eq(false, {1, false, {\"a\", \"sub\", \"list\"}, [\"key\"] = \"value\"})"}
    )
    test(
        eq({1, false, {"a", "sub", "list"}, ["key"] = "value"}, {1, false, {"a", "sub", "list"}, ["key"] = "value"}),
        true,
        {["msg"] = "eq({1, false, {\"a\", \"sub\", \"list\"}, [\"key\"] = \"value\"}, {1, false, {\"a\", \"sub\", \"list\"}, [\"key\"] = \"value\"})"}
    )
end
eqTests()
```
