local STRING_UTIL = require("tools/lib/stringUtil")

return {
    encode = function(self)
        local encoded = "  properties = {\n"
        encoded = encoded .. self:encodeMusic()
        encoded = encoded .. self:encodeSounds()
        encoded = encoded .. self:encodeTime()
        encoded = encoded .. "  },\n"

        return encoded
    end,

    encodeMusic = function(self)
        local encoded = ""

        for k, v in pairs(self) do
            if STRING_UTIL:startsWith(k, "music") then
                encoded = encoded .. "      " .. k .. " = \"" .. v .. "\",\n"
            end
        end
        
        return encoded
    end,

    encodeSounds = function(self)
        local encoded = ""
        if self.sounds then
            encoded = encoded .. "      sounds = {\n"
            for k, v in pairs(self.sounds) do
                encoded = encoded .. self:generateKV(10, k, v)
            end
            encoded = encoded .. "      },\n"
        end
        return encoded
    end,

    generateKV = function(self, padding, key, value)
        if type(value) == "table" then
            return self:generateKVTable(padding, key, value)
        else
            local myValue = value
            if     type(myValue) == "string"  then myValue = "\"" .. myValue .. "\""
            elseif type(myValue) == "boolean" then
                if myValue then myValue = "true"
                else            myValue = "false" end
            end
            return string.rep(" ", padding) .. key .. " = " .. myValue .. ",\n"
        end
    end,

    generateKVTable = function(self, padding, key, value)
        local result = string.rep(" ", padding) .. key .. " = {\n"
        for k,v in pairs(value) do
            result = result .. self:generateKV(padding + 4, k, v)
        end
        return result .. string.rep(" ", padding) .. "},\n"
    end,

    encodeTime = function(self)
        local encoded = ""
        if self.time then
            encoded = encoded .. "      time = {\n"
            for k, v in pairs(self.time) do
                encoded = encoded .. self:generateKV(10, k, v)
            end
            encoded = encoded .. "      },\n"
        end
        return encoded
    end,

    getTime = function(self)
        if not self.time then self.time = {} end
        return self.time
    end,    

    getRings = function(self)
        if not self.rings then self.rings = {} end
        return self.rings
    end,         
}
