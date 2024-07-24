# Testing

Really basic testing in Lua.

`Testing`:
```lua
function test(act, exp, opts)
    <<<Check Equality>>>
    <<<Stringify>>>

    if type(opts["msg"]) == "string" then msg = opts["msg"] end
    if type(msg) == "string" then
        print("===== " .. "Testing: \27[0;4m" .. msg .. "\27[0m =====")
    else
        print("===========")
    end

    if isEq(act, exp) then
        print("\27[32m✅ Test Passed\27[0m")
    else
        local indent = 2
        local expandTbl = false

        if type(opts) == "table" then
            if type(opts["indent"]) == "number" then indent = opts["indent"] end
            if type(opts["expandTbl"]) == "boolean" then expandTbl = opts["expandTbl"] end
        end

        io.stderr:write("\27[31m❌ Test Failed\27[0m\n")
        io.stderr:write("\27[31mExpected:\27[0m\n")
        io.stderr:write(strify(exp, indent, expandTbl) .. "\n")
        io.stderr:write("\27[31mGot:\27[0m\n")
        io.stderr:write(strify(act, indent, expandTbl) .. "\n")
    end
    print("===========")
end
```

## Check Equality

`Check Equality`:
```lua
function isEq(x, y)
    if type(x) ~= type(y) then return false end
    if type(x) ~= "table" then return x == y end
    if #x ~= #y then return false end
    for k, _ in pairs(x) do if not isEq(x[k], y[k]) then return false end end

    return true
end
```

## Turn Anything into a String

`Stringify`:
```lua
function strify(item, indent, expandTbl, curIndent, inTbl, tmpNoIndent)
    indent = indent or 2
    curIndent = curIndent or indent
    if type(expandTbl) ~= "boolean" then expandTbl = expandTbl or false end
    if type(inTbl) ~= "boolean" then inTbl = inTbl or false end

    if type(item) == "string" then
        if (inTbl and not expandTbl) or tmpNoIndent then return "\"" .. item .. "\"" end
        return string.rep(" ", curIndent) .. "\"" .. item .. "\""
    elseif type(item) ~= "table" then
        if (inTbl and not expandTbl) or tmpNoIndent then return tostring(item) end
        return string.rep(" ", curIndent) .. tostring(item)
    else
        local out = string.rep(" ", curIndent) .. "{"
        if tmpNoIndent or not expandTbl then out = "{" end

        for k, v in pairs(item) do
            if expandTbl then out = out .. "\n" end
            if type(k) == "number" then
                out = out .. strify(v, indent, expandTbl, curIndent + indent, true)
            else
                if not tmpNoIndent and expandTbl then out = out .. string.rep(" ", curIndent + indent) end
                out = out .. "[\"" .. k .. "\"] = " .. strify(v, indent, expandTbl, curIndent + indent, true, true)
            end

            if next(item, k) ~= nil then
                out = out .. ","
                if not expandTbl then out = out .. " " end
            end
        end
        if expandTbl then out = out .. "\n" .. string.rep(" ", curIndent) end
        out = out .. "}"
        return out
    end
end
```
