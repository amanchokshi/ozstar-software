local tool = 'hyperdrive'
local version = 'v0.3.0'
help("Sets up the paths you need to use "..tool.." version "..version)
whatis([[For further information see https://github.com/MWATelescope/mwa_hyperdrive]] )
load("cuda/12.0.0", "cfitsio/3.49")

if (mode() ~= "whatis") then
    local root = "/fred/oz048/achokshi/software/"..tool.."/"..version.."/"
    prepend_path("PATH", root.."bin")
end
