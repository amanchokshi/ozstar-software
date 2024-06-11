help([==[

Description
===========
WODEN is C / CUDA code designed to be able to simulate low-frequency radio 
interferometric data. It is written to be simplistic and fast to allow all-sky 
simulations. Although WODEN was primarily written to simulate 
Murchinson Widefield Array (MWA, Tingay et al. 2013) visibilities, it is 
becoming less instrument-specific as time goes on. WODEN outputs uvfits files.

More information
================
 - Homepage: https://woden.readthedocs.io/

]==])

whatis([==[Description: 
WODEN is C / CUDA code designed to be able to simulate low-frequency radio 
interferometric data. It is written to be simplistic and fast to allow all-sky 
simulations. Although WODEN was primarily written to simulate 
Murchinson Widefield Array (MWA, Tingay et al. 2013) visibilities, it is 
becoming less instrument-specific as time goes on. WODEN outputs uvfits files.
]==])
whatis([==[Homepage: https://woden.readthedocs.io/]==])
whatis([==[URL: https://woden.readthedocs.io/]==])

local tool = 'woden'
local version = 'v2.0.0'
local root = "/fred/oz048/achokshi/software/"..tool.."/"..version.."/"

conflict("woden")

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

prepend_path("CMAKE_PREFIX_PATH", root)
prepend_path("LIBRARY_PATH", pathJoin(root, "lib"))
prepend_path("PATH", pathJoin(root, "bin"))
prepend_path("PYTHONPATH", pathJoin(root, "lib/python3.10/site-packages"))
