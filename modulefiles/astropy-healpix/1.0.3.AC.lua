help([==[

Description
===========
HEALPix (Hierarchical Equal Area isoLatitude Pixelisation) is an algorithm for 
pixellizing a sphere that is sometimes used in Astronomy to store data from 
all-sky surveys, but the general algorithm can apply to any field that has to 
deal with representing data on a sphere.

astropy-healpix is a new BSD-licensed implementation that is separate from the 
original GPL-licensed HEALPix library and associated healpy Python wrapper. See 
About this package for further information about the difference between this new 
implementation and the original libraries.

More information
================
 - Homepage: https://astropy-healpix.readthedocs.io/

]==])

whatis([==[Description: 
HEALPix (Hierarchical Equal Area isoLatitude Pixelisation) is an algorithm for 
pixellizing a sphere that is sometimes used in Astronomy to store data from 
all-sky surveys, but the general algorithm can apply to any field that has to 
deal with representing data on a sphere.

astropy-healpix is a new BSD-licensed implementation that is separate from the 
original GPL-licensed HEALPix library and associated healpy Python wrapper. See 
About this package for further information about the difference between this new 
implementation and the original libraries.
]==])
whatis([==[Homepage: https://astropy-healpix.readthedocs.io/]==])
whatis([==[URL: https://astropy-healpix.readthedocs.io/]==])

local root = "/fred/oz048/achokshi/software/astropy-healpix"

conflict("astropy-healpix")

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
