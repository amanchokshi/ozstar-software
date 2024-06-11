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

local tool = 'pyuvdata'
local version = '2.4.4'
local root = "/fred/oz048/achokshi/software/"..tool.."/"..version.."/"

conflict("pyuvdata")

if not ( isloaded("python-scientific/3.10.4-foss-2022a") ) then
    load("python-scientific/3.10.4-foss-2022a")
end

if not ( isloaded("flexiblas/3.2.0") ) then
    load("flexiblas/3.2.0")
end

if not ( isloaded("fftw/3.3.10") ) then
    load("fftw/3.3.10")
end

if not ( isloaded("fftw.mpi/3.3.10") ) then
    load("fftw.mpi/3.3.10")
end

if not ( isloaded("scalapack/2.2.0-fb") ) then
    load("scalapack/2.2.0-fb")
end

if not ( isloaded("python/3.10.4") ) then
    load("python/3.10.4")
end

if not ( isloaded("scipy-bundle/2022.05") ) then
    load("scipy-bundle/2022.05")
end

if not ( isloaded("pyyaml/6.0") ) then
    load("pyyaml/6.0")
end

prepend_path("CMAKE_PREFIX_PATH", root)
prepend_path("LIBRARY_PATH", pathJoin(root, "lib"))
prepend_path("PATH", pathJoin(root, "bin"))
prepend_path("PYTHONPATH", pathJoin(root, "lib/python3.10/site-packages"))
