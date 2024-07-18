help([==[

Description
===========
pyuvdata defines a pythonic interface to interferometric data sets. Currently 
pyuvdata supports reading and writing of miriad, uvfits, CASA measurement sets 
and uvh5 files and reading of FHD (Fast Holographic Deconvolution) visibility 
save files, SMA Mir files and MWA correlator FITS files.

More information
================
 - Homepage: https://pyuvdata.readthedocs.io/

]==])

whatis([==[Description: 
pyuvdata defines a pythonic interface to interferometric data sets. Currently 
pyuvdata supports reading and writing of miriad, uvfits, CASA measurement sets 
and uvh5 files and reading of FHD (Fast Holographic Deconvolution) visibility 
save files, SMA Mir files and MWA correlator FITS files.
]==])
whatis([==[Homepage: https://pyuvdata.readthedocs.io/]==])
whatis([==[URL: https://pyuvdata.readthedocs.io/]==])

local tool = "pyuvdata"
local version = "3.0.0"
local root = "/fred/oz048/achokshi/software/" .. tool .. "/" .. version .. "/"

conflict("pyuvdata")

if not (isloaded("gcc/12.3.0")) then
	load("gcc/12.3.0")
end

if not (isloaded("python/3.11.3")) then
	load("python/3.11.3")
end

prepend_path("CMAKE_PREFIX_PATH", root)
prepend_path("LIBRARY_PATH", pathJoin(root, "lib"))
prepend_path("PATH", pathJoin(root, "bin"))
prepend_path("PYTHONPATH", pathJoin(root, "lib/python3.10/site-packages"))
