set more off
clear

cd [directory]

global list 1 2 3 4 5

global fmonth = m(2007m1)

cap log close
log using crism_cleaning.log, replace

do 0_read_crism.do
do 0_clean_hpi.do 

do 1_clean_crism.do
do 2_clean_efx_moves.do
do 2_second_lien_balances.do
do 2_merge_hpi_lps_zip.do 
do 3_clean_efx_loan_level.do
do 3_clean_lps_loan_level.do
do 4_match_efx_lps.do
 
do 5_lps_outstanding.do
do 5_link_new_lps_loans.do
do 5_link_old_lps_loans.do
do 5_piggybackseconds.do

do 6_cashout_panel.do
do 6_refi_panel.do
do 6_create_panels.do 
do 6_compute_cltvs.do 

do 7_clean_panel.do

do 8_init_rate.do

log close
