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
    for match in fun.args:gmatch("[^%[]%S+[:]?") do
        if (match:match(":") or match:match("^%S$")) then
            currentArg = match:match("%S+[:]?"):gsub("[:$]", ", ")
            argList = argList .. currentArg
        elseif (match ~= " or" and (match:match(",") or match:match("$"))) then
            typeList[currentArg] = (typeList[currentArg] or "") .. match:gsub(", ?", ""):gsub(" ", ""):gsub("%]", "") .. (currentArg:match("^%[") and " | nil" or "") .. " | "
        end
    end
    for arg in argList:gmatch("%S+, ") do
        code = code .. '---@param ' .. arg:gsub(", $", ""):gsub("%[", "") .. " " .. tostring(typeList[arg]):gsub(" | $", ""):gsub(", $", "") .. '\n'
    end

    if fun.returns ~= "" then
        code = code .. '---@return ' .. fun.returns:gsub(" or ", " | "):gsub(", optional %S", ", %1 | nil"):gsub("%s?+%s?", ", "):gsub("%s?and%s?", ", "):gsub(", $", "") .. '\n'
    end

    local dot = static and '.' or ':'
        code = code .. "function " .. moduleName .. dot .. funName .. "(" .. argList:gsub(", $", ""):gsub("%[", "") .. ") end\n\n"
    return code
end

local function genModule(name, api)
    local f = assert(io.open("emmy_api/" .. name .. ".lua", 'w'))
    f:write("---@class " .. name .. '\n')
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
                genModule(name .. '.' .. childName, child)
            end

            -- functions
            if (child.type == "function" or child.type == "method") then
                f:write(genFunction('m', childName, child, false))
            end
        end
    end

    f:write("return m")
    f:close()
end

os.execute("mkdir emmy_api")
for moduleName, module in pairs(api) do
    genModule(moduleName, module)
end

print('--finished.')
