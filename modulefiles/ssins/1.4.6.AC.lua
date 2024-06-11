help([==[

Description
===========
SSINS is a python package intended for radio frequency interference flagging in
radio astronomy datasets. It stands for Sky-Subtracted Incoherent Noise Spectra.

More information
================
 - Homepage: https://ssins.readthedocs.io/

]==])

whatis([==[Description: 
SSINS is a python package intended for radio frequency interference flagging in
radio astronomy datasets. It stands for Sky-Subtracted Incoherent Noise Spectra.
]==])
whatis([==[Homepage: https://ssins.readthedocs.io/]==])
whatis([==[URL: https://ssins.readthedocs.io/]==])

local tool = 'ssins'
local version = '1.4.6'
local root = "/fred/oz048/achokshi/software/"..tool.."/"..version.."/"

conflict("ssins")

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
