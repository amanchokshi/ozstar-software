help([==[

Description
===========
pyuvsim is a comprehensive simulation package for radio interferometers in python.

More information
================
 - Homepage: https://pyuvsim.readthedocs.io

]==])

whatis([==[
pyuvsim is a comprehensive simulation package for radio interferometers in python.
]==])
whatis([==[Homepage: https://pyuvsim.readthedocs.io/]==])
whatis([==[URL: https://pyuvsim.readthedocs.io/]==])

local tool = "pyuvsim"
local version = "1.4.0"
local root = "/fred/oz048/achokshi/software/" .. tool .. "/" .. version .. "/"

conflict("pyuvsim")

if not (isloaded("python-scientific/3.11.3-foss-2023a")) then
	load("python-scientific/3.11.3-foss-2023a")
end

prepend_path("CMAKE_PREFIX_PATH", root)
prepend_path("LIBRARY_PATH", pathJoin(root, "lib"))
prepend_path("PATH", pathJoin(root, "bin"))
prepend_path("PYTHONPATH", pathJoin(root, "lib/python3.11/site-packages"))
