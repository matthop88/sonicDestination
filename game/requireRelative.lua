relativePath    = relativePath or function(path) return path end
    
requireRelative = function(path, params)
    if params then return require(relativePath(path)):init(params)
    else           return require(relativePath(path))          end
end
