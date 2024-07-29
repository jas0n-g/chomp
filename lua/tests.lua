function test(act, exp, opts)
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
    function strify(obj, opts)
        if type(obj) == "table" then
            local expandTbl = false
            local indent = 2
            local curIndent = 0
            if type(opts) == "table" then
                if type(opts["expandTbl"]) == "boolean" then expandTbl = opts["expandTbl"] end
                if type(opts["indent"]) == "number" and opts["indent"] == math.floor(opts["indent"]) then indent = opts["indent"] end
                if type(opts["curIndent"]) == "number" and opts["curIndent"] == math.floor(opts["curIndent"]) then curIndent = opts["curIndent"] end
            end

            local out = "{"
            for k, v in pairs(obj) do
                if expandTbl then out = out .. "\n" end
                if type(k) == "number" then
                    if expandTbl then out = out .. string.rep(" ", curIndent + indent) end
                    out = out .. strify(v, {["expandTbl"] = expandTbl, ["indent"] = indent, ["curIndent"] = curIndent + indent, ["isStr"] = type(v) == "string"})
                else
                    if expandTbl then out = out .. string.rep(" ", curIndent + indent) end
                    out = out .. "[\"" .. k .. "\"] = " .. strify(v, {["expandTbl"] = expandTbl, ["indent"] = indent, ["curIndent"] = curIndent + indent, ["isStr"] = type(v) == "string"})
                end
                if next(obj, k) ~= nil then
                    out = out .. ","
                    if not expandTbl then out = out .. " " end
                end
            end
            if expandTbl then out = out .. "\n" .. string.rep(" ", curIndent) end
            out = out .. "}"
            return out
        elseif type(obj) == "string" then
            return "\"" .. obj .. "\""
        elseif type(obj) == "raise" then
            return "raise(" .. strify(obj.raise) .. ")"
        elseif type(obj) == "error" then
            return "err(" .. strify(obj.err) .. ")"
        else
            return tostring(obj)
        end
    end

    if type(opts) == "table" and type(opts["msg"]) == "string" then
        print("===== " .. "Testing: \27[0;4m" .. opts["msg"] .. "\27[0m =====")
    else
        print("==========")
    end

    if eq(act, exp) then
        print("\27[32m✅ Test Passed\27[0m")
    else
        io.stderr:write("\27[31m❌ Test Failed\27[0m\n")
        io.stderr:write("\27[31mExpected:\27[0m\n")
        io.stderr:write(strify(exp, opts) .. "\n")
        io.stderr:write("\27[31mGot:\27[0m\n")
        io.stderr:write(strify(act, opts) .. "\n")
    end
    print("==========")
end
function strify(obj, opts)
    if type(obj) == "table" then
        local expandTbl = false
        local indent = 2
        local curIndent = 0
        if type(opts) == "table" then
            if type(opts["expandTbl"]) == "boolean" then expandTbl = opts["expandTbl"] end
            if type(opts["indent"]) == "number" and opts["indent"] == math.floor(opts["indent"]) then indent = opts["indent"] end
            if type(opts["curIndent"]) == "number" and opts["curIndent"] == math.floor(opts["curIndent"]) then curIndent = opts["curIndent"] end
        end

        local out = "{"
        for k, v in pairs(obj) do
            if expandTbl then out = out .. "\n" end
            if type(k) == "number" then
                if expandTbl then out = out .. string.rep(" ", curIndent + indent) end
                out = out .. strify(v, {["expandTbl"] = expandTbl, ["indent"] = indent, ["curIndent"] = curIndent + indent, ["isStr"] = type(v) == "string"})
            else
                if expandTbl then out = out .. string.rep(" ", curIndent + indent) end
                out = out .. "[\"" .. k .. "\"] = " .. strify(v, {["expandTbl"] = expandTbl, ["indent"] = indent, ["curIndent"] = curIndent + indent, ["isStr"] = type(v) == "string"})
            end
            if next(obj, k) ~= nil then
                out = out .. ","
                if not expandTbl then out = out .. " " end
            end
        end
        if expandTbl then out = out .. "\n" .. string.rep(" ", curIndent) end
        out = out .. "}"
        return out
    elseif type(obj) == "string" then
        return "\"" .. obj .. "\""
    elseif type(obj) == "raise" then
        return "raise(" .. strify(obj.raise) .. ")"
    elseif type(obj) == "error" then
        return "err(" .. strify(obj.err) .. ")"
    else
        return tostring(obj)
    end
end
function strifyTests()
    test(strify("a string"), "\"a string\"", {["msg"] = "strify(\"a string\")"})
    test(strify(2.1), "2.1", {["msg"] = "strify(2.1)"})
    test(strify(true), "true", {["msg"] = "strify(true)"})
    test(
        strify({5, false, {"a", "sub", "list"}, ["key"] = "value"}),
        "{5, false, {\"a\", \"sub\", \"list\"}, [\"key\"] = \"value\"}",
        {["msg"] = "{5, false, {\"a\", \"sub\", \"list\"}, [\"key\"] = \"value\"}"}
    )
end
strifyTests()
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
local raiseMetatable = {}
raiseMetatable.__index = raiseMetatable
function raise(val) return setmetatable({raise = val}, raiseMetatable) end

local oType = type
type = function (obj)
    if oType(obj) == "table" and getmetatable(obj) == raiseMetatable then return "raise" end
    return oType(obj)
end
function raiseTests()
    test(raise("value").raise, "value", {["msg"] = "raise(\"value\").raise"})
    test(raise(3).raise, 3, {["msg"] = "raise(3).raise"})
    test(raise(false).raise, false, {["msg"] = "raise(false).raise"})
    test(raise(raise(1)).raise, raise(1), {["msg"] = "raise(raise(1)).raise"})
    test(type(raise(1)), "raise", {["msg"] = "type(raise(1))"})
    test(strify(raise(1)), "raise(1)", {["msg"] = "strify(raise(1))"})
end
raiseTests()
local errorMetatable = {}
errorMetatable.__index = errorMetatable
function err(val) return setmetatable({err = val}, errorMetatable) end

local oType = type
type = function (obj)
    if oType(obj) == "table" and getmetatable(obj) == errorMetatable then return "error" end
    return oType(obj)
end
function catch(obj, f)
    if type(obj) ~= "error" then return obj end
    return f(obj, obj.err)
end
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
end
errorsTest()
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
