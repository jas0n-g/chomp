function test(act, exp, opts)
    function eq(x, y)
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
        {["msg"] = "{5, false, {\"a\", \"sub\", \"list\"}, [\"key\"] = \"value\"}"})
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
