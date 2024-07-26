function test(act, exp, opts)
    function eq(x, y)
        if type(x) == type(y) and type(x) == "raise" then return eq(x.raise, y.raise) end
        if type(x) == type(y) and type(x) == "error" then return eq(x.err, y.err) end
        if type(x) ~= type(y) then return false end
        if type(x) ~= "table" then return x == y end
        if #x ~= #y then return false end
        for k, _ in pairs(x) do if not eq(x[k], y[k]) then return false end end

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
function try(obj)
    if type(obj) ~= "error" then return obj end
    return raise(obj)
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
    test(try(err(1)), raise(err(1)), {["msg"] = "try(err(1))"})
    test(try(1), 1, {["msg"] = "try(1)"})
end
errorsTest()
