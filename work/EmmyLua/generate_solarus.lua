local api = require('solarus_lua_api')

local function safeDesc(src)
    return string.gsub(src, "\n", "\n---")
end

local function genFunction(moduleName, funName, fun, static)
    local code = "---" .. safeDesc(fun.description) .. "\n"
    local argList = ''
    local typeList = {}

    -- args
    local currentArg = ""
    for match in fun.args:gsub(" or ", "|"):gsub("any type", "any"):gsub(" ", ""):gsub(",", " "):gsub(":", ": "):gmatch("%S+") do
        if ((match ~= "nil:") and
                (match ~= "any:") and
                (match ~= "boolean:") and
                (match ~= "string:") and
                (match ~= "number:") and
                (match ~= "integer:") and
                (match ~= "function:") and
                (match ~= "table:") and
                (match ~= "thread:") and
                (match ~= "userdata:")) then
            if (match:match(":")) then
                currentArg = match:gsub(":", "")
                argList = argList .. currentArg .. ","
            else
                typeList[currentArg] = (typeList[currentArg] or "") .. match:gsub(" or ", ""):gsub("%]", "") .. (currentArg:match("^%[") and "|nil" or "") .. "|"
            end
        end
    end
    for arg in argList:gmatch("[^,]+") do
        code = code .. '---@param ' .. arg:gsub("%[", "") .. " " .. tostring(typeList[arg]):gsub("|$", ""):gsub(",$", ""):gsub(" ", "_") .. '\n'
    end

    if fun.returns ~= "" then
        code = code .. '---@return ' .. fun.returns:gsub(", ?", "|"):gsub(" or ", "|"):gsub("optional (%S+)", "%1|nil"):gsub("%s?+%s?", ","):gsub("%s?and%s?", ","):gsub(", ?$", ""):gsub(" ", "_") .. '\n'
    end

    local dot = static and '.' or ':'
        code = code .. "function " .. moduleName .. dot .. funName .. "(" .. argList:gsub(",$", ""):gsub("%[", "") .. ") end\n\n"
    return code
end

local function genModule(name, api, nested)
    local f = assert(io.open("emmy_api/" .. name .. ".lua", 'w'))
    f:write("---@class " .. name .. (api.inherits and (" : " .. api.inherits) or "") .. '\n')
    if api.description then
        f:write('---' .. safeDesc(api.description) .. '\n')
    end
    f:write("local m = {}\n\n")

    if (api.childs) then
        for childName, child in pairs(api.childs) do
            -- modules
            if (child.type == "class" or child.type == "lib") then
                f:write("---@type " .. name .. '.' .. childName .. '\n')
                f:write("m." .. childName .. ' = nil\n\n')
                genModule(name .. '.' .. childName, child, true)
            end

            -- functions
            if (child.type == "function" or child.type == "method") then
                f:write(genFunction('m', childName, child, child.type == "function"))
            end
        end
    end

    f:write((nested ~= true and "_G." .. name .. " = m\n\n" or "") .. "return m")
    f:close()
end

print("---start")

local succeed = os.execute("mkdir emmy_api")
print(succeed and "   'emmy_api' directory created" or "   'emmy_api' directory already exists")
for moduleName, module in pairs(api) do
    print("   class '" .. moduleName .. "' created")
    genModule(moduleName, module)
end

print('---finished')
