help([==[

Description
===========
WSClean (w-stacking clean) is a fast generic widefield imager.
It implements several gridding algorithms and offers fully-automated multi-scale
multi-frequency deconvolution.


More information
================
 - Homepage: https://wsclean.readthedocs.io/
]==])

whatis([==[Description: WSClean (w-stacking clean) is a fast generic widefield imager.
It implements several gridding algorithms and offers fully-automated multi-scale
multi-frequency deconvolution.]==])
whatis([==[Homepage: https://wsclean.readthedocs.io/]==])
whatis([==[URL: https://wsclean.readthedocs.io/]==])

local tool = 'wsclean'
local version = '3.3'
local root = "/fred/oz048/achokshi/software/"..tool.."/"..version.."/"

conflict("wsclean")

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

if not ( isloaded("everybeam/0.6.0.AC") ) then
    load("everybeam/0.6.0.AC")
end

if not ( isloaded("idg/1.2.0.AC") ) then
    load("idg/1.2.0.AC")
end

prepend_path("CMAKE_LIBRARY_PATH", pathJoin(root, "lib64"))
prepend_path("CMAKE_PREFIX_PATH", root)
prepend_path("CPATH", pathJoin(root, "include"))
prepend_path("LD_LIBRARY_PATH", pathJoin(root, "lib"))
prepend_path("LD_LIBRARY_PATH", pathJoin(root, "lib64"))
prepend_path("LIBRARY_PATH", pathJoin(root, "lib"))
prepend_path("LIBRARY_PATH", pathJoin(root, "lib64"))
prepend_path("PATH", pathJoin(root, "bin"))
