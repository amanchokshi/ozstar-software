help([==[

Description
===========
Image Domain Gridding (IDG) is a fast method for convolutional resampling (gridding/degridding)
of radio astronomical data (visibilities). Direction dependent effects (DDEs) or A-tems can be applied
in the gridding process.
The algorithm is described in "Image Domain Gridding: a fast method for convolutional resampling of visibilities",
Van der Tol (2018).
The implementation is described in "Radio-astronomical imaging on graphics processors", Veenboer (2020).
Please cite these papers in publications using IDG.


More information
================
 - Homepage: https://idg.readthedocs.io/
]==])

whatis([==[Description: Image Domain Gridding (IDG) is a fast method for convolutional resampling (gridding/degridding)
of radio astronomical data (visibilities). Direction dependent effects (DDEs) or A-tems can be applied
in the gridding process.
The algorithm is described in "Image Domain Gridding: a fast method for convolutional resampling of visibilities",
Van der Tol (2018).
The implementation is described in "Radio-astronomical imaging on graphics processors", Veenboer (2020).
Please cite these papers in publications using IDG.
]==])
whatis([==[Homepage: https://idg.readthedocs.io/]==])
whatis([==[URL: https://idg.readthedocs.io/]==])

local tool = 'idg'
local version = '1.2.0'
local root = "/fred/oz048/achokshi/software/"..tool.."/"..version.."/"

conflict("idg")

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

if not ( isloaded("python/3.10.4") ) then
    load("python/3.10.4")
end

if not ( isloaded("cuda/12.0.0") ) then
    load("cuda/12.0.0")
end

prepend_path("CMAKE_LIBRARY_PATH", pathJoin(root, "lib64"))
prepend_path("CMAKE_PREFIX_PATH", root)
prepend_path("CPATH", pathJoin(root, "include"))
prepend_path("LD_LIBRARY_PATH", pathJoin(root, "lib"))
prepend_path("LIBRARY_PATH", pathJoin(root, "lib"))
prepend_path("LIBRARY_PATH", pathJoin(root, "lib64"))
prepend_path("PATH", pathJoin(root, "bin"))
prepend_path("PKG_CONFIG_PATH", pathJoin(root, "lib64/pkgconfig"))
prepend_path("PKG_CONFIG_PATH", pathJoin(root, "share/pkgconfig"))
prepend_path("XDG_DATA_DIRS", pathJoin(root, "share"))
