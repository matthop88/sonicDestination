return {
    assertTrue = function(self, name, expression)
        if expression == true then
            print("PASSED => " .. name)
            return true
        else
            print("FAILED => " .. name)
            return false
        end
    end,

    assertEquals = function(self, name, expected, actual)
        if expected == actual then
            print("PASSED => " .. name)
            return true
        else
            print("FAILED => " .. name)
            print("  Expected: ", expected)
            print("  Actual: ",   actual)
            return false
        end
    end,
}
