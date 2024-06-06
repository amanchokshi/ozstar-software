local tool = 'cuffs'
local version = 'master'
help("Sets up the paths you need to use "..tool.." version "..version)
whatis([[For further information see https://github.com/sarrvesh/cuFFS]] )
load("gcc/12.2.0", "openmpi/4.1.4", "cfitsio/4.2.0", "hdf5/1.14.0", "cuda/12.0.0", "libconfig/master")

if (mode() ~= "whatis") then
    local root = "/fred/oz048/achokshi/software/"..tool.."/"..version.."/"
    prepend_path("PATH", root.."bin")
end
