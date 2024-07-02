help([==[

Description
===========
CHIPS: The Cosmological H i Power Spectrum Estimator
Power Spectrum estimation code for EoR science
For further information see https://doi.org/10.3847/0004-637X/818/2/139

More information
================
 - Homepage: https://doi.org/10.3847/0004-637X/818/2/139

]==])

whatis([==[Description: 
CHIPS: The Cosmological H i Power Spectrum Estimator
Power Spectrum estimation code for EoR science
For further information see https://doi.org/10.3847/0004-637X/818/2/139
]==])
whatis([==[Homepage: https://doi.org/10.3847/0004-637X/818/2/139]==])
whatis([==[URL: https://doi.org/10.3847/0004-637X/818/2/139]==])

local tool = "chips"
local version = "master"
local root = "/fred/oz048/achokshi/software/" .. tool .. "/" .. version .. "/"

conflict("chips")

if not (isloaded("foss/2022a")) then
	load("foss/2022a")
end

if not (isloaded("python-scientific/3.10.4-foss-2022a")) then
	load("python-scientific/3.10.4-foss-2022a")
end

if not (isloaded("lapack/3.10.1")) then
	load("lapack/3.10.1")
end

if not (isloaded("cfitsio/4.2.0")) then
	load("cfitsio/4.2.0")
end

prepend_path("CMAKE_PREFIX_PATH", root)
prepend_path("PATH", pathJoin(root, "bin"))
prepend_path("PATH", pathJoin(root, "python/chips-env/bin"))
prepend_path("PYTHONPATH", pathJoin(root, "python/chips-env/lib/python3.10/site-packages"))

setenv("CODEDIR", pathJoin(root, "bin"))
setenv("BEAMDIR", "/fred/oz048/MWA/CODE/CHIPS/beam_files")
