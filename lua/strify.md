# Stringify

An enhanced version of Lua's builtin `tostring()`, especially for tables.

`Stringify`:
```lua
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
```