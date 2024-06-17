help([==[

Description
===========
fv is built and distributed as a standard component of the large HEASOFT 
package of programs for manipulating and analyzing FITS data file

More information
================
 - Homepage: https://heasarc.gsfc.nasa.gov/ftools/fv

]==])

whatis([==[Description: 
fv is built and distributed as a standard component of the large HEASOFT 
package of programs for manipulating and analyzing FITS data file
]==])
whatis([==[Homepage: https://heasarc.gsfc.nasa.gov/ftools/fv]==])
whatis([==[URL: https://heasarc.gsfc.nasa.gov/ftools/fv]==])

local tool = 'fv'
local version = '5.5.2'
local root = "/fred/oz048/achokshi/software/"..tool.."/"..tool..""..version.."/"

conflict("fv")

prepend_path("PATH", root)
