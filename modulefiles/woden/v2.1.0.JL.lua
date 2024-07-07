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

local tool = "woden"
local version = "v2.1.0.JL"
local root = "/fred/oz048/achokshi/software/" .. tool .. "/" .. version .. "/"

conflict("woden")

if not (isloaded("cuda/12.0.0")) then
	load("cuda/12.0.0")
end

if not (isloaded("gcc/12.3.0")) then
	load("gcc/12.3.0")
end

if not (isloaded("python/3.11.3")) then
	load("python/3.11.3")
end

prepend_path("PATH", pathJoin(root, "woden-0.2.1/python/woden-env/bin"))
prepend_path("PYTHONPATH", pathJoin(root, "woden-0.2.1/python/woden-env/lib/python3.11/site-packages"))
