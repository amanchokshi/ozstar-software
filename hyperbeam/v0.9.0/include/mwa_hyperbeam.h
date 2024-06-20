#pragma once

#include <stdarg.h>
#include <stdbool.h>
#include <stdint.h>
#include <stdlib.h>

/**
 * The main struct to be used for calculating analytic pointings.
 */
typedef struct AnalyticBeam AnalyticBeam;

/**
 * A GPU beam object ready to calculate beam responses.
 */
typedef struct AnalyticBeamGpu AnalyticBeamGpu;

/**
 * The main struct to be used for calculating Jones matrices.
 */
typedef struct FEEBeam FEEBeam;

/**
 * A GPU beam object ready to calculate beam responses.
 */
typedef struct FEEBeamGpu FEEBeamGpu;

#ifdef __cplusplus
extern "C" {
#endif // __cplusplus

/**
 * Create a new MWA analytic beam.
 *
 * # Arguments
 *
 * * `rts_style` - a boolean to indicate whether to use RTS-style beam
 *   responses. If this is true (a value of 1), RTS-style responses are
 *   generated. The default is to use mwa_pb-style responses.
 * * `dipole_height_metres` - an optional pointer to a `double`. If this is not
 *   null, the pointer is dereferenced and used as the dipole height (units of
 *   metres). If it is null, then a default is used; the default depends on
 *   whether this beam object is mwa_pb- or RTS-style.
 * * `bowties_per_row` - an optional pointer to an 8-bit unsigned int. If this
 *   is not null, the pointer is dereferenced and used as the number of bowties
 *   in a single row of a tile. If it is null, a default of 4 is used. Most MWA
 *   tiles have 4 bowties per row for a total of 16 bowties per tile, but the
 *   CRAM tile has 8 bowties per row.
 * * `analytic_beam` - a double pointer to the `AnalyticBeam` struct
 *   which is set by this function. This struct must be freed by calling
 *   `free_analytic_beam`.
 *
 * # Returns
 *
 * * An exit code integer. If this is non-zero then an error occurred; the
 *   details can be obtained by (1) getting the length of the error string by
 *   calling `hb_last_error_length` and (2) calling `hb_last_error_message`
 *   with a string buffer with a length at least equal to the error length.
 *
 */
int32_t new_analytic_beam(uint8_t rts_style,
                          const double *dipole_height_metres,
                          const uint8_t *bowties_per_row,
                          struct AnalyticBeam **analytic_beam);

/**
 * Get the beam response Jones matrix for the given direction and pointing.
 *
 * `delays` and `amps` apply to each bowtie in a given MWA tile, and *must*
 * have 16 elements (each corresponds to an MWA dipole in a tile, in the M&C
 * order; see
 * <https://wiki.mwatelescope.org/pages/viewpage.action?pageId=48005139>).
 * `amps` being dipole gains (usually 1 or 0), not digital gains.
 *
 * 16 or 32 elements can be supplied for `amps`. If there are 16, then the
 * dipole gains apply to both X and Y elements of dipoles. If there are 32, the
 * first 16 amps are for the X elements, the next 16 the Y elements.
 *
 * Note the type of `jones` (`*double`); we can't pass complex numbers across
 * the FFI boundary, so the real and imaginary components are unpacked into
 * doubles. The output contains 8 doubles, where the j00 is the first pair, j01
 * is the second pair, etc.
 *
 * # Arguments
 *
 * * `analytic_beam` - A pointer to a `AnalyticBeam` struct created with the
 *   `new_analytic_beam` function
 * * `az_rad` - The azimuth direction to get the beam response (units of
 *   radians)
 * * `za_rad` - The zenith angle direction to get the beam response (units of
 *   radians)
 * * `freq_hz` - The frequency used for the beam response in Hertz
 * * `delays` - A pointer to a 16-element array of dipole delays for an MWA
 *   tile
 * * `amps` - A pointer to a 16- or 32-element array of dipole gains for an MWA
 *   tile. The number of elements is indicated by `num_amps`.
 * * `num_amps` - The number of dipole gains used (either 16 or 32).
 * * `latitude_rad` - The telescope latitude to use in beam calculations.
 * * `norm_to_zenith` - A boolean indicating whether the beam response should
 *   be normalised with respect to zenith.
 * * `jones` - A pointer to a buffer with at least `8 * sizeof(double)`
 *   allocated. The Jones matrix beam response is written here.
 *
 * # Returns
 *
 * * An exit code integer. If this is non-zero then an error occurred; the
 *   details can be obtained by (1) getting the length of the error string by
 *   calling `hb_last_error_length` and (2) calling `hb_last_error_message`
 *   with a string buffer with a length at least equal to the error length.
 *
 */
int32_t analytic_calc_jones(struct AnalyticBeam *analytic_beam,
                            double az_rad,
                            double za_rad,
                            uint32_t freq_hz,
                            const uint32_t *delays,
                            const double *amps,
                            uint32_t num_amps,
                            double latitude_rad,
                            uint8_t norm_to_zenith,
                            double *jones);

/**
 * Get the beam response Jones matrix for several az/za directions for the
 * given pointing. The Jones matrix elements for each direction are put into a
 * single array (made available with the output pointer `jones`).
 *
 * `delays` and `amps` apply to each dipole in a given MWA tile, and *must*
 * have 16 elements (each corresponds to an MWA dipole in a tile, in the M&C
 * order; see
 * <https://wiki.mwatelescope.org/pages/viewpage.action?pageId=48005139>).
 * `amps` being dipole gains (usually 1 or 0), not digital gains.
 *
 * As there are 8 elements per Jones matrix, there must be at least `8 *
 * num_azza * sizeof(double)` allocated in the array. Rust will calculate the
 * Jones matrices in parallel. See the documentation for `calc_jones` for more
 * info.
 *
 * # Arguments
 *
 * * `analytic_beam` - A pointer to a `AnalyticBeam` struct created with the
 *   `new_analytic_beam` function
 * * `num_azza` - The number of directions within `az_rad` and `za_rad`
 * * `az_rad` - The azimuth direction to get the beam response (units of
 *   radians)
 * * `za_rad` - The zenith angle direction to get the beam response (units of
 *   radians)
 * * `freq_hz` - The frequency used for the beam response in Hertz
 * * `delays` - A pointer to a 16-element array of dipole delays for an MWA
 *   tile
 * * `amps` - A pointer to a 16- or 32-element array of dipole gains for an MWA
 *   tile. The number of elements is indicated by `num_amps`.
 * * `num_amps` - The number of dipole gains used (either 16 or 32).
 * * `latitude_rad` - The telescope latitude to use in beam calculations.
 * * `norm_to_zenith` - A boolean indicating whether the beam response should
 *   be normalised with respect to zenith.
 * * `jones` - A pointer to a buffer with at least `8 * num_azza *
 *   sizeof(double)` bytes allocated. The Jones matrix beam responses are
 *   written here.
 *
 * # Returns
 *
 * * An exit code integer. If this is non-zero then an error occurred; the
 *   details can be obtained by (1) getting the length of the error string by
 *   calling `hb_last_error_length` and (2) calling `hb_last_error_message`
 *   with a string buffer with a length at least equal to the error length.
 *
 */
int32_t analytic_calc_jones_array(struct AnalyticBeam *analytic_beam,
                                  uint32_t num_azza,
                                  const double *az_rad,
                                  const double *za_rad,
                                  uint32_t freq_hz,
                                  const uint32_t *delays,
                                  const double *amps,
                                  uint32_t num_amps,
                                  double latitude_rad,
                                  uint8_t norm_to_zenith,
                                  double *jones);

/**
 * Free the memory associated with an `AnalyticBeam`.
 *
 * # Arguments
 *
 * * `analytic_beam` - the pointer to the `AnalyticBeam` struct.
 *
 */
void free_analytic_beam(struct AnalyticBeam *analytic_beam);

/**
 * Get a `AnalyticBeamGpu` struct, which is used to calculate beam responses on
 * a GPU (CUDA- or HIP-capable device).
 *
 * # Arguments
 *
 * * `analytic_beam` - a pointer to a previously set `AnalyticBeam` struct.
 * * `delays` - a pointer to two-dimensional array of dipole delays. There must
 *   be 16 delays per row; each row corresponds to a tile.
 * * `amps` - a pointer to two-dimensional array of dipole amplitudes. There
 *   must be 16 or 32 amps per row; each row corresponds to a tile. The number
 *   of amps per row is specified by `num_amps`.
 * * `num_freqs` - the number of frequencies in the array pointed to by
 *   `freqs_hz`.
 * * `num_tiles` - the number of tiles in both `delays` and `amps`.
 * * `num_amps` - either 16 or 32. See the documentation for `calc_jones` for
 *   more explanation.
 * * `norm_to_zenith` - A boolean indicating whether the beam responses should
 *   be normalised with respect to zenith.
 * * `gpu_analytic_beam` - a double pointer to the `AnalyticBeamGpu` struct
 *   which is set by this function. This struct must be freed by calling
 *   `free_gpu_analytic_beam`.
 *
 * # Returns
 *
 * * An exit code integer. If this is non-zero then an error occurred; the
 *   details can be obtained by (1) getting the length of the error string by
 *   calling `hb_last_error_length` and (2) calling `hb_last_error_message`
 *   with a string buffer with a length at least equal to the error length.
 *
 */
int32_t new_gpu_analytic_beam(struct AnalyticBeam *analytic_beam,
                              const uint32_t *delays,
                              const double *amps,
                              int32_t num_tiles,
                              int32_t num_amps,
                              struct AnalyticBeamGpu **gpu_analytic_beam);

/**
 * Get beam response Jones matrices for the given directions, using a GPU. The
 * Jones matrix elements for each direction are put into a host-memory buffer
 * `jones`.
 *
 * # Arguments
 *
 * * `gpu_beam` - A pointer to a `AnalyticBeamGpu` struct created with the
 *   `new_gpu_analytic_beam` function
 * * `az_rad` - The azimuth directions to get the beam response (units of
 *   radians)
 * * `za_rad` - The zenith angle directions to get the beam response (units of
 *   radians)
 * * `jones` - A pointer to a buffer with at least `num_unique_tiles *
 *   num_freqs * num_azza * 8 * sizeof(FLOAT)` bytes allocated.
 *   `FLOAT` is either `float` or `double`, depending on how `hyperbeam` was
 *   compiled. The Jones matrix beam responses are written here. This should be
 *   set up with the `get_num_unique_tiles` function; see the examples for
 *   more help.
 *
 * # Returns
 *
 * * An exit code integer. If this is non-zero then an error occurred; the
 *   details can be obtained by (1) getting the length of the error string by
 *   calling `hb_last_error_length` and (2) calling `hb_last_error_message`
 *   with a string buffer with a length at least equal to the error length.
 *
 */
int32_t analytic_calc_jones_gpu(struct AnalyticBeamGpu *gpu_analytic_beam,
                                uint32_t num_azza,
                                const double *az_rad,
                                const double *za_rad,
                                uint32_t num_freqs,
                                const uint32_t *freqs_hz,
                                double latitude_rad,
                                uint8_t norm_to_zenith,
                                double *jones);

/**
 * Get beam response Jones matrices for the given directions, using a GPU. The
 * Jones matrix elements for each direction are left on the device (the device
 * pointer is communicated via `d_jones`).
 *
 * # Arguments
 *
 * * `gpu_analytic_beam` - A pointer to a `AnalyticBeamGpu` struct created with
 *   the `new_gpu_analytic_beam` function
 * * `az_rad` - The azimuth directions to get the beam response (units of
 *   radians)
 * * `za_rad` - The zenith angle directions to get the beam response (units of
 *   radians)
 * * `d_jones` - A pointer to a device buffer with at least `8 *
 *   num_unique_tiles * num_freqs * num_azza * sizeof(FLOAT)` bytes
 *   allocated. `FLOAT` is either `float` or `double`, depending on how
 *   `hyperbeam` was compiled. The Jones matrix beam responses are written
 *   here. This should be set up with the `get_num_unique_tiles` function; see
 *   the examples for more help.
 *
 * # Returns
 *
 * * An exit code integer. If this is non-zero then an error occurred; the
 *   details can be obtained by (1) getting the length of the error string by
 *   calling `hb_last_error_length` and (2) calling `hb_last_error_message`
 *   with a string buffer with a length at least equal to the error length.
 *
 */
int32_t analytic_calc_jones_gpu_device(struct AnalyticBeamGpu *gpu_analytic_beam,
                                       int32_t num_azza,
                                       const double *az_rad,
                                       const double *za_rad,
                                       int32_t num_freqs,
                                       const uint32_t *freqs_hz,
                                       double latitude_rad,
                                       uint8_t norm_to_zenith,
                                       double *d_jones);

/**
 * The same as `calc_jones_gpu_device`, but with the directions already
 * allocated on the device. As with `d_jones`, the precision of the floats
 * depends on how `hyperbeam` was compiled.
 *
 * # Arguments
 *
 * * `gpu_analytic_beam` - A pointer to a `AnalyticBeamGpu` struct created with
 *   the `new_gpu_analytic_beam` function
 * * `d_az_rad` - The azimuth directions to get the beam response (units of
 *   radians)
 * * `d_za_rad` - The zenith angle directions to get the beam response (units
 *   of radians)
 * * `d_jones` - A pointer to a device buffer with at least `8 *
 *   num_unique_tiles * num_freqs * num_azza * sizeof(FLOAT)` bytes
 *   allocated. `FLOAT` is either `float` or `double`, depending on how
 *   `hyperbeam` was compiled. The Jones matrix beam responses are written
 *   here. This should be set up with the `get_num_unique_tiles` function; see
 *   the examples for more help.
 *
 * # Returns
 *
 * * An exit code integer. If this is non-zero then an error occurred; the
 *   details can be obtained by (1) getting the length of the error string by
 *   calling `hb_last_error_length` and (2) calling `hb_last_error_message`
 *   with a string buffer with a length at least equal to the error length.
 *
 */
int32_t analytic_calc_jones_gpu_device_inner(struct AnalyticBeamGpu *gpu_analytic_beam,
                                             int32_t num_azza,
                                             const double *d_az_rad,
                                             const double *d_za_rad,
                                             int32_t num_freqs,
                                             const uint32_t *d_freqs_hz,
                                             double latitude_rad,
                                             uint8_t norm_to_zenith,
                                             double *d_jones);

/**
 * Get a pointer to the tile map. This is necessary to access de-duplicated
 * beam Jones matrices.
 *
 * # Arguments
 *
 * * `gpu_analytic_beam` - the pointer to the `AnalyticBeamGpu` struct.
 *
 * # Returns
 *
 * * A pointer to the tile map. The const annotation is deliberate; the caller
 *   does not own the map.
 *
 */
const int32_t *get_analytic_tile_map(struct AnalyticBeamGpu *gpu_analytic_beam);

/**
 * Get a pointer to the device tile map. This is necessary to access
 * de-duplicated beam Jones matrices on the device.
 *
 * # Arguments
 *
 * * `gpu_analytic_beam` - the pointer to the `AnalyticBeamGpu` struct.
 *
 * # Returns
 *
 * * A pointer to the device tile map. The const annotation is deliberate; the
 *   caller does not own the map.
 *
 */
const int32_t *get_analytic_device_tile_map(struct AnalyticBeamGpu *gpu_analytic_beam);

/**
 * Get the number of de-duplicated tiles associated with this `AnalyticBeamGpu`.
 *
 * # Arguments
 *
 * * `gpu_analytic_beam` - the pointer to the `AnalyticBeamGpu` struct.
 *
 * # Returns
 *
 * * The number of de-duplicated tiles associated with this `AnalyticBeamGpu`.
 *
 */
int32_t get_num_unique_analytic_tiles(struct AnalyticBeamGpu *gpu_analytic_beam);

/**
 * Free the memory associated with an `AnalyticBeamGpu` beam.
 *
 * # Arguments
 *
 * * `gpu_analytic_beam` - the pointer to the `AnalyticBeamGpu` struct.
 *
 */
void free_gpu_analytic_beam(struct AnalyticBeamGpu *analytic_beam);

/**
 * Create a new MWA FEE beam.
 *
 * # Arguments
 *
 * * `hdf5_file` - the path to the MWA FEE beam file.
 * * `fee_beam` - a double pointer to the `FEEBeam` struct which is set by this
 *   function. This struct must be freed by calling `free_fee_beam`.
 *
 * # Returns
 *
 * * An exit code integer. If this is non-zero then an error occurred; the
 *   details can be obtained by (1) getting the length of the error string by
 *   calling `hb_last_error_length` and (2) calling `hb_last_error_message`
 *   with a string buffer with a length at least equal to the error length.
 *
 */
int32_t new_fee_beam(const char *hdf5_file, struct FEEBeam **fee_beam);

/**
 * Create a new MWA FEE beam. Requires the HDF5 beam file path to be specified
 * by the environment variable `MWA_BEAM_FILE`.
 *
 * # Arguments
 *
 * * `fee_beam` - a double pointer to the `FEEBeam` struct which is set by this
 *   function. This struct must be freed by calling `free_fee_beam`.
 *
 * # Returns
 *
 * * An exit code integer. If this is non-zero then an error occurred; the
 *   details can be obtained by (1) getting the length of the error string by
 *   calling `hb_last_error_length` and (2) calling `hb_last_error_message`
 *   with a string buffer with a length at least equal to the error length.
 *
 */
int32_t new_fee_beam_from_env(struct FEEBeam **fee_beam);

/**
 * Get the beam response Jones matrix for the given direction and pointing. Can
 * optionally re-define the X and Y polarisations and apply a parallactic-angle
 * correction; see
 * <https://github.com/MWATelescope/mwa_hyperbeam/blob/main/fee_pols.pdf>
 *
 * `delays` and `amps` apply to each dipole in a given MWA tile, and *must*
 * have 16 elements (each corresponds to an MWA dipole in a tile, in the M&C
 * order; see
 * <https://wiki.mwatelescope.org/pages/viewpage.action?pageId=48005139>).
 * `amps` being dipole gains (usually 1 or 0), not digital gains.
 *
 * 16 or 32 elements can be supplied for `amps`. If there are 16, then the
 * dipole gains apply to both X and Y elements of dipoles. If there are 32, the
 * first 16 amps are for the X elements, the next 16 the Y elements.
 *
 * Note the type of `jones` (`*double`); we can't pass complex numbers across
 * the FFI boundary, so the real and imaginary components are unpacked into
 * doubles. The output contains 8 doubles, where the j00 is the first pair, j01
 * is the second pair, etc.
 *
 * # Arguments
 *
 * * `fee_beam` - A pointer to a `FEEBeam` struct created with the
 *   `new_fee_beam` function
 * * `az_rad` - The azimuth direction to get the beam response (units of
 *   radians)
 * * `za_rad` - The zenith angle direction to get the beam response (units of
 *   radians)
 * * `freq_hz` - The frequency used for the beam response in Hertz
 * * `delays` - A pointer to a 16-element array of dipole delays for an MWA
 *   tile
 * * `amps` - A pointer to a 16- or 32-element array of dipole gains for an MWA
 *   tile. The number of elements is indicated by `num_amps`.
 * * `num_amps` - The number of dipole gains used (either 16 or 32).
 * * `norm_to_zenith` - A boolean indicating whether the beam response should
 *   be normalised with respect to zenith.
 * * `latitude_rad` - A pointer to a telescope latitude to use for the
 *   parallactic-angle correction. If the pointer is null, no correction is
 *   done.
 * * `iau_order` - A boolean indicating whether the Jones matrix should be
 *   arranged [NS-NS NS-EW EW-NS EW-EW] (true) or not (false).
 * * `jones` - A pointer to a buffer with at least `8 * sizeof(double)`
 *   allocated. The Jones matrix beam response is written here.
 *
 * # Returns
 *
 * * An exit code integer. If this is non-zero then an error occurred; the
 *   details can be obtained by (1) getting the length of the error string by
 *   calling `hb_last_error_length` and (2) calling `hb_last_error_message`
 *   with a string buffer with a length at least equal to the error length.
 *
 */
int32_t fee_calc_jones(struct FEEBeam *fee_beam,
                       double az_rad,
                       double za_rad,
                       uint32_t freq_hz,
                       const uint32_t *delays,
                       const double *amps,
                       uint32_t num_amps,
                       uint8_t norm_to_zenith,
                       const double *latitude_rad,
                       uint8_t iau_order,
                       double *jones);

/**
 * Get the beam response Jones matrix for several az/za directions for the
 * given pointing. The Jones matrix elements for each direction are put into a
 * single array (made available with the output pointer `jones`). Can
 * optionally re-define the X and Y polarisations and apply a parallactic-angle
 * correction; see
 * <https://github.com/MWATelescope/mwa_hyperbeam/blob/main/fee_pols.pdf>
 *
 * `delays` and `amps` apply to each dipole in a given MWA tile, and *must*
 * have 16 elements (each corresponds to an MWA dipole in a tile, in the M&C
 * order; see
 * <https://wiki.mwatelescope.org/pages/viewpage.action?pageId=48005139>).
 * `amps` being dipole gains (usually 1 or 0), not digital gains.
 *
 * As there are 8 elements per Jones matrix, there must be at least `8 *
 * num_azza * sizeof(double)` allocated in the array. Rust will calculate the
 * Jones matrices in parallel. See the documentation for `calc_jones` for more
 * info.
 *
 * # Arguments
 *
 * * `fee_beam` - A pointer to a `FEEBeam` struct created with the
 *   `new_fee_beam` function
 * * `num_azza` - The number of directions within `az_rad` and `za_rad`
 * * `az_rad` - The azimuth direction to get the beam response (units of
 *   radians)
 * * `za_rad` - The zenith angle direction to get the beam response (units of
 *   radians)
 * * `freq_hz` - The frequency used for the beam response in Hertz
 * * `delays` - A pointer to a 16-element array of dipole delays for an MWA
 *   tile
 * * `amps` - A pointer to a 16- or 32-element array of dipole gains for an MWA
 *   tile. The number of elements is indicated by `num_amps`.
 * * `num_amps` - The number of dipole gains used (either 16 or 32).
 * * `norm_to_zenith` - A boolean indicating whether the beam response should
 *   be normalised with respect to zenith.
 * * `latitude_rad` - A pointer to a telescope latitude to use for the
 *   parallactic-angle correction. If the pointer is null, no correction is
 *   done.
 * * `iau_order` - A boolean indicating whether the Jones matrix should be
 *   arranged [NS-NS NS-EW EW-NS EW-EW] (true) or not (false).
 * * `jones` - A pointer to a buffer with at least `8 * num_azza *
 *   sizeof(double)` bytes allocated. The Jones matrix beam responses are
 *   written here.
 *
 * # Returns
 *
 * * An exit code integer. If this is non-zero then an error occurred; the
 *   details can be obtained by (1) getting the length of the error string by
 *   calling `hb_last_error_length` and (2) calling `hb_last_error_message`
 *   with a string buffer with a length at least equal to the error length.
 *
 */
int32_t fee_calc_jones_array(struct FEEBeam *fee_beam,
                             uint32_t num_azza,
                             const double *az_rad,
                             const double *za_rad,
                             uint32_t freq_hz,
                             const uint32_t *delays,
                             const double *amps,
                             uint32_t num_amps,
                             uint8_t norm_to_zenith,
                             const double *latitude_rad,
                             uint8_t iau_order,
                             double *jones);

/**
 * Get the available frequencies inside the HDF5 file.
 *
 * # Arguments
 *
 * * `fee_beam` - the pointer to the `FEEBeam` struct.
 * * `freqs_ptr` - a double pointer to the FEE beam frequencies. The `const`
 *   annotation is deliberate; the caller does not own the frequencies.
 * * `num_freqs` - a pointer to a `size_t` whose contents are set.
 *
 */
void get_fee_beam_freqs(struct FEEBeam *fee_beam, const uint32_t **freqs_ptr, uintptr_t *num_freqs);

/**
 * Given a frequency in Hz, get the closest available frequency inside the HDF5
 * file.
 *
 * # Arguments
 *
 * * `fee_beam` - the pointer to the `FEEBeam` struct.
 *
 * # Returns
 *
 * * The closest frequency to the specified frequency in Hz.
 *
 */
uint32_t fee_closest_freq(struct FEEBeam *fee_beam, uint32_t freq);

/**
 * Free the memory associated with an `FEEBeam`.
 *
 * # Arguments
 *
 * * `fee_beam` - the pointer to the `FEEBeam` struct.
 *
 */
void free_fee_beam(struct FEEBeam *fee_beam);

/**
 * Get a `FEEBeamGpu` struct, which is used to calculate beam responses on a
 * GPU (CUDA- or HIP-capable device).
 *
 * # Arguments
 *
 * * `fee_beam` - a pointer to a previously set `FEEBeam` struct.
 * * `freqs_hz` - a pointer to an array of frequencies (units of Hz) at which
 *   the beam responses will be calculated.
 * * `delays` - a pointer to two-dimensional array of dipole delays. There must
 *   be 16 delays per row; each row corresponds to a tile.
 * * `amps` - a pointer to two-dimensional array of dipole amplitudes. There
 *   must be 16 or 32 amps per row; each row corresponds to a tile. The number
 *   of amps per row is specified by `num_amps`.
 * * `num_freqs` - the number of frequencies in the array pointed to by
 *   `freqs_hz`.
 * * `num_tiles` - the number of tiles in both `delays` and `amps`.
 * * `num_amps` - either 16 or 32. See the documentation for `calc_jones` for
 *   more explanation.
 * * `norm_to_zenith` - A boolean indicating whether the beam responses should
 *   be normalised with respect to zenith.
 * * `gpu_fee_beam` - a double pointer to the `FEEBeamGpu` struct which is set
 *   by this function. This struct must be freed by calling
 *   `free_gpu_fee_beam`.
 *
 * # Returns
 *
 * * An exit code integer. If this is non-zero then an error occurred; the
 *   details can be obtained by (1) getting the length of the error string by
 *   calling `hb_last_error_length` and (2) calling `hb_last_error_message`
 *   with a string buffer with a length at least equal to the error length.
 *
 */
int32_t new_gpu_fee_beam(struct FEEBeam *fee_beam,
                         const uint32_t *freqs_hz,
                         const uint32_t *delays,
                         const double *amps,
                         uint32_t num_freqs,
                         uint32_t num_tiles,
                         uint32_t num_amps,
                         uint8_t norm_to_zenith,
                         struct FEEBeamGpu **gpu_fee_beam);

/**
 * Get beam response Jones matrices for the given directions, using a GPU. The
 * Jones matrix elements for each direction are put into a host-memory buffer
 * `jones`. Can optionally re-define the X and Y polarisations and apply a
 * parallactic-angle correction; see
 * <https://github.com/MWATelescope/mwa_hyperbeam/blob/main/fee_pols.pdf>
 *
 * # Arguments
 *
 * * `gpu_fee_beam` - A pointer to a `FEEBeamGpu` struct created with the
 *   `new_gpu_fee_beam` function
 * * `az_rad` - The azimuth directions to get the beam response (units of
 *   radians)
 * * `za_rad` - The zenith angle directions to get the beam response (units of
 *   radians)
 * * `latitude_rad` - A pointer to a telescope latitude to use for the
 *   parallactic-angle correction. If the pointer is null, no correction is
 *   done.
 * * `iau_order` - A boolean indicating whether the Jones matrix should be
 *   arranged [NS-NS NS-EW EW-NS EW-EW] (true) or not (false).
 * * `jones` - A pointer to a buffer with at least `num_unique_tiles *
 *   num_unique_fee_freqs * num_azza * 8 * sizeof(FLOAT)` bytes allocated.
 *   `FLOAT` is either `float` or `double`, depending on how `hyperbeam` was
 *   compiled. The Jones matrix beam responses are written here. This should be
 *   set up with the `get_num_unique_tiles` and `get_num_unique_fee_freqs`
 *   functions; see the examples for more help.
 *
 * # Returns
 *
 * * An exit code integer. If this is non-zero then an error occurred; the
 *   details can be obtained by (1) getting the length of the error string by
 *   calling `hb_last_error_length` and (2) calling `hb_last_error_message`
 *   with a string buffer with a length at least equal to the error length.
 *
 */
int32_t fee_calc_jones_gpu(struct FEEBeamGpu *gpu_fee_beam,
                           uint32_t num_azza,
                           const double *az_rad,
                           const double *za_rad,
                           const double *latitude_rad,
                           uint8_t iau_order,
                           double *jones);

/**
 * Get beam response Jones matrices for the given directions, using a GPU. The
 * Jones matrix elements for each direction are left on the device (the device
 * pointer is communicated via `d_jones`). Can optionally re-define the X and Y
 * polarisations and apply a parallactic-angle correction; see
 * <https://github.com/MWATelescope/mwa_hyperbeam/blob/main/fee_pols.pdf>
 *
 * # Arguments
 *
 * * `gpu_fee_beam` - A pointer to a `FEEBeamGpu` struct created with the
 *   `new_gpu_fee_beam` function
 * * `az_rad` - The azimuth directions to get the beam response (units of
 *   radians)
 * * `za_rad` - The zenith angle directions to get the beam response (units of
 *   radians)
 * * `latitude_rad` - A pointer to a telescope latitude to use for the
 *   parallactic-angle correction. If the pointer is null, no correction is
 *   done.
 * * `iau_order` - A boolean indicating whether the Jones matrix should be
 *   arranged [NS-NS NS-EW EW-NS EW-EW] (true) or not (false).
 * * `d_jones` - A pointer to a device buffer with at least `8 *
 *   num_unique_tiles * num_unique_fee_freqs * num_azza * sizeof(FLOAT)` bytes
 *   allocated. `FLOAT` is either `float` or `double`, depending on how
 *   `hyperbeam` was compiled. The Jones matrix beam responses are written
 *   here. This should be set up with the `get_num_unique_tiles` and
 *   `get_num_unique_fee_freqs` functions; see the examples for more help.
 *
 * # Returns
 *
 * * An exit code integer. If this is non-zero then an error occurred; the
 *   details can be obtained by (1) getting the length of the error string by
 *   calling `hb_last_error_length` and (2) calling `hb_last_error_message`
 *   with a string buffer with a length at least equal to the error length.
 *
 */
int32_t fee_calc_jones_gpu_device(struct FEEBeamGpu *gpu_fee_beam,
                                  int32_t num_azza,
                                  const double *az_rad,
                                  const double *za_rad,
                                  const double *latitude_rad,
                                  uint8_t iau_order,
                                  double *d_jones);

/**
 * The same as `calc_jones_gpu_device`, but with the directions already
 * allocated on the device. As with `d_jones`, the precision of the floats
 * depends on how `hyperbeam` was compiled.
 *
 * # Arguments
 *
 * * `gpu_fee_beam` - A pointer to a `FEEBeamGpu` struct created with the
 *   `new_gpu_fee_beam` function
 * * `d_az_rad` - The azimuth directions to get the beam response (units of
 *   radians)
 * * `d_za_rad` - The zenith angle directions to get the beam response (units
 *   of radians)
 * * `latitude_rad` - A pointer to a telescope latitude to use for the
 *   parallactic-angle correction. If the pointer is null, no correction is
 *   done.
 * * `iau_order` - A boolean indicating whether the Jones matrix should be
 *   arranged [NS-NS NS-EW EW-NS EW-EW] (true) or not (false).
 * * `d_jones` - A pointer to a device buffer with at least `8 *
 *   num_unique_tiles * num_unique_fee_freqs * num_azza * sizeof(FLOAT)` bytes
 *   allocated. `FLOAT` is either `float` or `double`, depending on how
 *   `hyperbeam` was compiled. The Jones matrix beam responses are written
 *   here. This should be set up with the `get_num_unique_tiles` and
 *   `get_num_unique_fee_freqs` functions; see the examples for more help.
 *
 * # Returns
 *
 * * An exit code integer. If this is non-zero then an error occurred; the
 *   details can be obtained by (1) getting the length of the error string by
 *   calling `hb_last_error_length` and (2) calling `hb_last_error_message`
 *   with a string buffer with a length at least equal to the error length.
 *
 */
int32_t fee_calc_jones_gpu_device_inner(struct FEEBeamGpu *gpu_fee_beam,
                                        int32_t num_azza,
                                        const double *d_az_rad,
                                        const double *d_za_rad,
                                        const double *d_latitude_rad,
                                        uint8_t iau_order,
                                        double *d_jones);

/**
 * Get a pointer to the tile map. This is necessary to access de-duplicated
 * beam Jones matrices.
 *
 * # Arguments
 *
 * * `gpu_fee_beam` - the pointer to the `FEEBeamGpu` struct.
 *
 * # Returns
 *
 * * A pointer to the tile map. The const annotation is deliberate; the caller
 *   does not own the map.
 *
 */
const int32_t *get_fee_tile_map(struct FEEBeamGpu *gpu_fee_beam);

/**
 * Get a pointer to the tile map. This is necessary to access de-duplicated
 * beam Jones matrices on the device.
 *
 * # Arguments
 *
 * * `gpu_fee_beam` - the pointer to the `FEEBeamGpu` struct.
 *
 * # Returns
 *
 * * A pointer to the device tile map. The const annotation is deliberate; the
 *   caller does not own the map.
 *
 */
const int32_t *get_fee_device_tile_map(struct FEEBeamGpu *gpu_fee_beam);

/**
 * Get a pointer to the freq map. This is necessary to access de-duplicated
 * beam Jones matrices.
 *
 * # Arguments
 *
 * * `gpu_fee_beam` - the pointer to the `FEEBeamGpu` struct.
 *
 * # Returns
 *
 * * A pointer to the freq map. The const annotation is deliberate; the caller
 *   does not own the map.
 *
 */
const int32_t *get_fee_freq_map(struct FEEBeamGpu *gpu_fee_beam);

/**
 * Get a pointer to the device freq map. This is necessary to access
 * de-duplicated beam Jones matrices on the device.
 *
 * # Arguments
 *
 * * `gpu_fee_beam` - the pointer to the `FEEBeamGpu` struct.
 *
 * # Returns
 *
 * * A pointer to the device freq map. The const annotation is deliberate; the
 *   caller does not own the map.
 *
 */
const int32_t *get_fee_device_freq_map(struct FEEBeamGpu *gpu_fee_beam);

/**
 * Get the number of de-duplicated tiles associated with this `FEEBeamGpu`.
 *
 * # Arguments
 *
 * * `gpu_fee_beam` - the pointer to the `FEEBeamGpu` struct.
 *
 * # Returns
 *
 * * The number of de-duplicated tiles associated with this `FEEBeamGpu`.
 *
 */
int32_t get_num_unique_fee_tiles(struct FEEBeamGpu *gpu_fee_beam);

/**
 * Get the number of de-duplicated frequencies associated with this
 * `FEEBeamGpu`.
 *
 * # Arguments
 *
 * * `gpu_fee_beam` - the pointer to the `FEEBeamGpu` struct.
 *
 * # Returns
 *
 * * The number of de-duplicated frequencies associated with this
 *   `FEEBeamGpu`.
 *
 */
int32_t get_num_unique_fee_freqs(struct FEEBeamGpu *gpu_fee_beam);

/**
 * Free the memory associated with an `FEEBeamGpu` beam.
 *
 * # Arguments
 *
 * * `gpu_fee_beam` - the pointer to the `FEEBeamGpu` struct.
 *
 */
void free_gpu_fee_beam(struct FEEBeamGpu *fee_beam);

/**
 * Calculate the number of bytes in the last error's error message **not**
 * including any trailing `null` characters.
 */
int hb_last_error_length(void);

/**
 * Write the most recent error message into a caller-provided buffer as a UTF-8
 * string, returning the number of bytes written.
 *
 * # Note
 *
 * This writes a **UTF-8** string into the buffer. Windows users may need to
 * convert it to a UTF-16 "unicode" afterwards.
 *
 * If there are no recent errors then this returns `0` (because we wrote 0
 * bytes). `-1` is returned if there are any errors, for example when passed a
 * null pointer or a buffer of insufficient size.
 */
int hb_last_error_message(char *buffer, int length);

#ifdef __cplusplus
} // extern "C"
#endif // __cplusplus
