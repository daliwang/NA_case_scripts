#!/bin/bash

set -e

# Create a test case uELM_AKSP_I1850uELMCNPRDCTCBC

E3SM_DIN="/gpfs/alpine2/cli180/proj-shared/wangd/inputdata"
E3SM_SRCROOT="/gpfs/alpine2/cli180/proj-shared/wangd/uELM"

EXPID="NADaymet"
CASEDIR="/gpfs/alpine2/cli180/proj-shared/wangd/e3sm_cases/uELM_${EXPID}_I1850uELMCNPRDCTCBC"

DATA_ROOT="/gpfs/alpine2/cli180/proj-shared/wangd/kiloCraft/NA_AOI_datasets/"
CASE_DATA="${DATA_ROOT}/${EXPID}"

DOMAIN_FILE="NADaymet_domain.lnd.Daymet_NA.1km.1d.c240521.nc"
SURFDATA_FILE="NADaymet_surfdata.Daymet_NA.1km.1d.c240327.nc"

PECOUNT="44"

\rm -rf "${CASEDIR}"

#${E3SM_SRCROOT}/cime/scripts/create_newcase --case "${CASEDIR}" --mach summitPlus --compiler pgi --mpilib spectrum-mpi --compset I1850uELMCNPRDCTCBC --res ELM_USRDAT --pecount "${PECOUNT}" --handle-preexisting-dirs r --srcroot "${E3SM_SRCROOT}"

${E3SM_SRCROOT}/cime/scripts/create_newcase --case "${CASEDIR}" --mach summitplus --compiler pgi --mpilib spectrum-mpi --compset I1850uELMCNPRDCTCBC --res ELM_USRDAT  --handle-preexisting-dirs r --srcroot "${E3SM_SRCROOT}"

cd "${CASEDIR}"

./xmlchange DIN_LOC_ROOT="${E3SM_DIN}"

./xmlchange DIN_LOC_ROOT_CLMFORC="${CASE_DATA}"

./xmlchange ELM_FORCE_COLDSTART=on

./xmlchange DATM_MODE=uELM_NADaymet

./xmlchange DATM_CLMNCEP_YR_START=2014

./xmlchange DATM_CLMNCEP_YR_END=2014

./xmlchange ATM_NCPL=8

./xmlchange STOP_N=5

./xmlchange STOP_OPTION=ndays

./xmlchange ATM_DOMAIN_PATH="${CASE_DATA}/domain_surfdata/"

./xmlchange ATM_DOMAIN_FILE="${DOMAIN_FILE}"

./xmlchange LND_DOMAIN_PATH="${CASE_DATA}/domain_surfdata/"

./xmlchange LND_DOMAIN_FILE="${DOMAIN_FILE}"

./xmlchange JOB_WALLCLOCK_TIME="1:00"

./xmlchange USER_REQUESTED_WALLTIME="1:00"

echo "fsurdat = '${CASE_DATA}/domain_surfdata/${SURFDATA_FILE}'
      hist_nhtfrq=-24
      hist_mfilt=31
     " >> user_nl_elm

./case.setup --reset

./case.setup

#./case.build --clean

#./case.build

