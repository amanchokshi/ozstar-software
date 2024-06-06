local tool = 'libconfig'
local version = 'master'
help("Sets up the paths you need to use "..tool.." version "..version)
whatis([[For further information see https://github.com/hyperrealm/libconfig]] )

if (mode() ~= "whatis") then
    local root = "/fred/oz048/achokshi/software/"..tool.."/"..version.."/"
    prepend_path("LD_LIBRARY_PATH", root.."lib")
    setenv("LIBCONFIG_INCLUDE_DIR", root.."include")
end
