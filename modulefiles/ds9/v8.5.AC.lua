help([==[

Description
===========
SAOImageDS9 is an astronomical imaging and data visualization application.  
DS9 supports FITS images and binary tables, multiple frame buffers, region 
manipulation, and many scale algorithms and colormaps.

More information
================
 - Homepage: https://sites.google.com/cfa.harvard.edu/saoimageds9

]==])

whatis([==[Description: 
SAOImageDS9 is an astronomical imaging and data visualization application.  
DS9 supports FITS images and binary tables, multiple frame buffers, region 
manipulation, and many scale algorithms and colormaps.
]==])
whatis([==[Homepage: https://sites.google.com/cfa.harvard.edu/saoimageds9]==])
whatis([==[URL: https://sites.google.com/cfa.harvard.edu/saoimageds9]==])

local tool = 'ds9'
local version = 'v8.5'
local root = "/fred/oz048/achokshi/software/"..tool.."/"..version.."/"

conflict("ds9")

prepend_path("CMAKE_PREFIX_PATH", root)
prepend_path("CPATH", pathJoin(root, "include"))
prepend_path("LD_LIBRARY_PATH", pathJoin(root, "lib"))
prepend_path("LIBRARY_PATH", pathJoin(root, "lib"))
prepend_path("PATH", pathJoin(root, "bin"))
