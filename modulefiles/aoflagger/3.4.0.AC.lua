help([==[

Description
===========
The AOFlagger software can find and remove radio-frequency interference (RFI) 
in radio astronomical observations


More information
================
 - https://aoflagger.readthedocs.io/
]==])

whatis([==[Description: The AOFlagger software can find and remove 
radio-frequency interference (RFI) in radio astronomical observations]==])
whatis([==[Homepage: https://aoflagger.readthedocs.io/]==])
whatis([==[URL: https://aoflagger.readthedocs.io/]==])

local tool = 'aoflagger'
local version = '3.4.0'
local root = "/fred/oz048/achokshi/software/"..tool.."/"..version.."/"

conflict("everybeam")

if not ( isloaded("foss/2022a") ) then
    load("foss/2022a")
end

if not ( isloaded("flexiblas/3.2.0") ) then
    load("flexiblas/3.2.0")
end

if not ( isloaded("python-scientific/3.10.4-foss-2022a") ) then
    load("python-scientific/3.10.4-foss-2022a")
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

if not ( isloaded("boost/1.79.0") ) then
    load("boost/1.79.0")
end

if not ( isloaded("cfitsio/4.2.0") ) then
    load("cfitsio/4.2.0")
end

if not ( isloaded("gsl/2.7") ) then
    load("gsl/2.7")
end

if not ( isloaded("hdf5/1.13.1") ) then
    load("hdf5/1.13.1")
end

if not ( isloaded("lua/5.4.4") ) then
    load("lua/5.4.4")
end

if not ( isloaded("libpng/1.6.37") ) then
    load("libpng/1.6.37")
end

if not ( isloaded("libxml2/2.9.13") ) then
    load("libxml2/2.9.13")
end

if not ( isloaded("casacore/3.5.0.AC") ) then
    load("casacore/3.5.0.AC")
end

prepend_path("CMAKE_LIBRARY_PATH", pathJoin(root, "lib64"))
prepend_path("CMAKE_PREFIX_PATH", root)
prepend_path("CPATH", pathJoin(root, "include"))
prepend_path("LD_LIBRARY_PATH", pathJoin(root, "lib"))
prepend_path("PYTHONPATH", pathJoin(root, "lib"))
prepend_path("LIBRARY_PATH", pathJoin(root, "lib"))
prepend_path("XDG_DATA_DIRS", pathJoin(root, "share"))
prepend_path("PATH", pathJoin(root, "bin"))
