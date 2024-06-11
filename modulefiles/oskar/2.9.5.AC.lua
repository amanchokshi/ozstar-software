help([==[

Description
===========
The OSKAR package consists of a number of applications for the simulation of 
astronomical radio interferometers. OSKAR has been designed primarily to 
produce simulated data from telescopes that use aperture arrays, as 
envisaged for the SKA.

More information
================
 - Homepage: https://ska-telescope.gitlab.io/

]==])

whatis([==[Description: 
The OSKAR package consists of a number of applications for the simulation of 
astronomical radio interferometers. OSKAR has been designed primarily to 
produce simulated data from telescopes that use aperture arrays, as 
envisaged for the SKA.
]==])
whatis([==[Homepage: https://ska-telescope.gitlab.io/]==])
whatis([==[URL: https://ska-telescope.gitlab.io/]==])

local tool = 'oskar'
local version = '2.9.5'
local root = "/fred/oz048/achokshi/software/"..tool.."/"..version.."/"

conflict("oskar")

if not ( isloaded("cuda/12.0.0") ) then
    load("cuda/12.0.0")
end

if not ( isloaded("foss/2022a") ) then
    load("foss/2022a")
end

if not ( isloaded("python-scientific/3.10.4-foss-2022a") ) then
    load("python-scientific/3.10.4-foss-2022a")
end

if not ( isloaded("qt5/5.15.5") ) then
    load("qt5/5.15.5")
end

if not ( isloaded("hdf5/1.13.1") ) then
    load("hdf5/1.13.1")
end

if not ( isloaded("casacore/3.5.0.AC") ) then
    load("casacore/3.5.0.AC")
end

prepend_path("CMAKE_PREFIX_PATH", root)
prepend_path("LIBRARY_PATH", pathJoin(root, "lib"))
prepend_path("PATH", pathJoin(root, "bin"))

prepend_path("CMAKE_LIBRARY_PATH", pathJoin(root, "lib64"))
prepend_path("CMAKE_PREFIX_PATH", root)
prepend_path("CPATH", pathJoin(root, "include"))
prepend_path("LD_LIBRARY_PATH", pathJoin(root, "lib"))
prepend_path("LIBRARY_PATH", pathJoin(root, "lib"))
prepend_path("LIBRARY_PATH", pathJoin(root, "lib64"))
prepend_path("PATH", pathJoin(root, "bin"))
prepend_path("PYTHONPATH", pathJoin(root, "lib/python3.10/site-packages"))
