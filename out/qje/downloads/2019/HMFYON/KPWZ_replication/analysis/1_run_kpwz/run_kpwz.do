*******************************************************************************
* make.do: Patents Build master stata file.
*******************************************************************************

*******************************************************************************
* 0. Initialize environment.
*******************************************************************************
* Environment variables.
global localdir "/bod/OTA14/t3gqb/patents/stata2"
global dodir    "$localdir/do_replication"
global dtadir   "$localdir/dta"
global rawdir   "$localdir/raw"
global dumpdir  "$localdir/dump"
global logdir   "$localdir/log"
global outdir   "$localdir/out"

capture log close
log using "$logdir/run_kpwz.log", text replace
display "$S_TIME  $S_DATE"
set more off
set matsize 10000
set maxvar 10000
clear all 
clear matrix 
clear 
 
*******************************************************************************
*ANALYSIS
*******************************************************************************

do $dodir/QJEtables1.do
do $dodir/QJEtables2.do
do $dodir/QJEtables_ret.do
do $dodir/QJEtables_rent.do
do $dodir/QJEtables_officers.do
do $dodir/QJEtables_balance.do
do $dodir/ES30.do
do $dodir/ES30_ret.do
do $dodir/QJE_dose_dollar.do
do $dodir/QJEtables_form.do
do $dodir/prep_summ_stats_v6.do
do $dodir/summstats_v6.do
do $dodir/gen_industries.do

cd $dodir2
display "$S_TIME  $S_DATE"
capture log close

