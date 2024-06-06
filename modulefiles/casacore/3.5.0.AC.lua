help([==[

Description
===========
A suite of C++ libraries for radio astronomy data processing.
The ephemerides data needs to be in DATA_DIR and the location must be specified at runtime.
Thus user's can update them.


More information
================
 - Homepage: https://github.com/casacore/casacore
]==])

whatis([==[Description: A suite of C++ libraries for radio astronomy data processing.
The ephemerides data needs to be in DATA_DIR and the location must be specified at runtime.
Thus user's can update them.
]==])
whatis([==[Homepage: https://github.com/casacore/casacore]==])
whatis([==[URL: https://github.com/casacore/casacore]==])

local tool = 'casacore'
local version = '3.5.0'
local root = "/fred/oz048/achokshi/software/"..tool.."/"..version.."/"

conflict("casacore")

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

if not ( isloaded("cfitsio/4.2.0") ) then
    load("cfitsio/4.2.0")
end

if not ( isloaded("wcslib/7.11") ) then
    load("wcslib/7.11")
end

if not ( isloaded("hdf5/1.13.1") ) then
    load("hdf5/1.13.1")
end

if not ( isloaded("scipy-bundle/2022.05") ) then
    load("scipy-bundle/2022.05")
end

if not ( isloaded("boost.python/1.79.0") ) then
    load("boost.python/1.79.0")
end

if not ( isloaded("ncurses/6.3") ) then
    load("ncurses/6.3")
end

if not ( isloaded("gsl/2.7") ) then
    load("gsl/2.7")
end

prepend_path("CMAKE_PREFIX_PATH", root)
prepend_path("CPATH", pathJoin(root, "include"))
prepend_path("LD_LIBRARY_PATH", pathJoin(root, "lib"))
prepend_path("LIBRARY_PATH", pathJoin(root, "lib"))
prepend_path("PATH", pathJoin(root, "bin"))
prepend_path("PKG_CONFIG_PATH", pathJoin(root, "lib/pkgconfig"))
