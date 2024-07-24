function test(act, exp, opts)
    function isEq(x, y)
        if type(x) ~= type(y) then return false end
        if type(x) ~= "table" then return x == y end
        if #x ~= #y then return false end
        for k, _ in pairs(x) do if not isEq(x[k], y[k]) then return false end end

        return true
    end
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
function deepcopy(x)
    local y = nil
    if type(x) == "table" then
        if #x == 0 then return {} end
        y = {}
        for k, v in pairs(x) do y[k] = deepcopy(v) end
    else
        y = x
    end
    return y
end

function deepcopyTests()
    test(deepcopy({}), {}, {["msg"] = "deepcopy({})"})
    test(deepcopy(nil), nil, {["msg"] = "deepcopy(nil)"})
    test(deepcopy(false), false, {["msg"] = "deepcopy(false)"})
    test(deepcopy(3.1), 3.1, {["msg"] = "deepcopy(3.1)"})
    test(
        deepcopy({["key"] = "value", {"a", "sub", {"list", 2}}}),
        {["key"] = "value", {"a", "sub", {"list", 2}}},
        {["msg"] = "deepcopy({[\"key\"] = \"value\", {\"a\", \"sub\", {\"list\", 2}}})"}
    )
end
deepcopyTests()
local errorMetatable = {}
errorMetatable.__index = errorMetatable
function err(errVal) return setmetatable({ val = errVal }, errorMetatable) end
local oType = type
type = function(obj)
    if oType(obj) == "table" and getmetatable(obj) == errorMetatable then return "error" end
    return oType(obj)
end
function catch(obj, f)
    if type(obj) ~= "error" then return obj end
    return f(obj, obj.msg)
end

function errorsTest()
    test(err(2).val, 2, {["msg"] = "err(2).val"})
    test(err("string").val, "string", {["msg"] = "err(string).val"})
    test(err().val, nil, {["msg"] = "err().val"})
    test(type(err()), "error", {["msg"] = "type(err())"})
    test(
        catch(
            "ok",
            function (err, val)
                if val == nil then return "error" end
            end
        ),
        "ok",
        {["msg"] = "catch test on ok"}
    )
    test(
        catch(
            err(),
            function (err, val)
                if val == nil then return "error" end
            end
        ),
        "error",
        {["msg"] = "catch test on error"}
    )
end
errorsTest()
