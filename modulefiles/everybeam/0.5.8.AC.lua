help([==[

Description
===========
Library that provides the antenna response pattern for several instruments,
such as LOFAR (and LOBES), SKA (OSKAR), MWA, JVLA, etc.


More information
================
 - Homepage: https://everybeam.readthedocs.io/
]==])

whatis([==[Description: Library that provides the antenna response pattern for several instruments,
such as LOFAR (and LOBES), SKA (OSKAR), MWA, JVLA, etc.]==])
whatis([==[Homepage: https://everybeam.readthedocs.io/]==])
whatis([==[URL: https://everybeam.readthedocs.io/]==])

local tool = 'everybeam'
local version = '0.5.8'
local root = "/fred/oz048/achokshi/software/"..tool.."/"..version.."/"

conflict("everybeam")

if not ( isloaded("foss/2022a") ) then
    load("foss/2022a")
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

if not ( isloaded("boost/1.79.0") ) then
    load("boost/1.79.0")
end

if not ( isloaded("cfitsio/4.2.0") ) then
    load("cfitsio/4.2.0")
end

if not ( isloaded("wcslib/7.11") ) then
    load("wcslib/7.11")
end

if not ( isloaded("gsl/2.7") ) then
    load("gsl/2.7")
end

if not ( isloaded("hdf5/1.13.1") ) then
    load("hdf5/1.13.1")
end

if not ( isloaded("python/3.10.4") ) then
    load("python/3.10.4")
end

if not ( isloaded("casacore/3.5.0.AC") ) then
    load("casacore/3.5.0.AC")
end

prepend_path("CMAKE_LIBRARY_PATH", pathJoin(root, "lib64"))
prepend_path("CMAKE_PREFIX_PATH", root)
prepend_path("CPATH", pathJoin(root, "include"))
prepend_path("LD_LIBRARY_PATH", pathJoin(root, "lib"))
prepend_path("LIBRARY_PATH", pathJoin(root, "lib"))
prepend_path("LIBRARY_PATH", pathJoin(root, "lib64"))
prepend_path("PKG_CONFIG_PATH", pathJoin(root, "lib64/pkgconfig"))
prepend_path("PKG_CONFIG_PATH", pathJoin(root, "share/pkgconfig"))
prepend_path("XDG_DATA_DIRS", pathJoin(root, "share"))
