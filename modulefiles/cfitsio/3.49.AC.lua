local tool = 'cfitsio'
local version = '3.49'
help("Sets up the paths you need to use "..tool.." version "..version)
whatis([[For further information see https://heasarc.gsfc.nasa.gov/docs/software/fitsio/]] )

if (mode() ~= "whatis") then
local root = "/fred/oz048/achokshi/software/"..tool.."/"..version.."/"
prepend_path("PATH", root.."bin")
prepend_path("LD_LIBRARY_PATH", root.."lib")
prepend_path("PKG_CONFIG_PATH",root.."lib/pkgconfig")
setenv("CFITSIO_ROOT", root)
setenv("CFITSIO_INCLUDE_DIR", root.."include")
setenv("CFITSIO_LIB", root.."lib")
end
