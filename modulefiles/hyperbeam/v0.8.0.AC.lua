local tool = 'hyperbeam'
local version = 'v0.8.0'
help("Sets up the paths you need to use "..tool.." version "..version)
whatis([[For further information see https://github.com/MWATelescope/mwa_hyperdrive]] )
load("cuda/12.0.0")

local root = "/fred/oz048/achokshi/software/"..tool.."/"..version.."/"

prepend_path("CMAKE_PREFIX_PATH", root)
prepend_path("CPATH", pathJoin(root, "include"))
prepend_path("LD_LIBRARY_PATH", pathJoin(root, "lib"))
prepend_path("LIBRARY_PATH", pathJoin(root, "lib"))
