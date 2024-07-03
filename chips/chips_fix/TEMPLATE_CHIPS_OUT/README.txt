Template directory for CHIPS outputs

1) Copy this directory and rename it <your initials>_CHIPS_OUT

2) Open ozstar_env_variables.sh in your CHIPS_OUT directory and change the OUTPUTDIR to
	OUTPUTDIR=/fred/oz048/MWA/CODE/CHIPS/<your initials>_CHIPS_OUT/

3) Open your run_CHIPS.py script and change line ~300 from
         ENV_VARIABLES = '/fred/oz048/MWA/CODE/CHIPS/chips/ozstar_env_variables.sh'
to
         ENV_VARIABLES = '/fred/oz048/MWA/CODE/CHIPS/<your initials>_CHIPS_OUT/ozstar_env_variables.sh'
