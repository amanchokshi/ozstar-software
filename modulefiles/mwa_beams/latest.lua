local tool = "mwa_beams"
help("MWA beam model files")
whatis([[MWA beam model files]])

local root = "/fred/oz048/achokshi/software/mwa_beams/"

setenv("MWA_FEE_HDF5", pathJoin(root, "mwa_full_embedded_element_pattern.h5"))
setenv("MWA_BEAM_FILE", pathJoin(root, "MWA_embedded_element_pattern_rev2_interp_167_197MHz.h5"))
setenv("MWA_FEE_HDF5_INTERP", pathJoin(root, "MWA_embedded_element_pattern_rev2_interp_167_197MHz.h5"))
