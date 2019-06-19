clear all

global d1="${col_remediation}program/program_paco/publication/"
global d2="${col_remediation}program/program_paco/publication/do/"

log using ${d1}log/master.log, replace

do ${d2}top_program.do
do ${d2}newreport1jr.do
do ${d2}newreport2.do
do ${d2}newreport1sr.do
do ${d2}get_first_report3.do
do ${d2}process_report1_report2.do
do ${d2}process_report9.do
do ${d2}get_taas.do 
do ${d2}readin_nes2.do
do ${d2}get_sample_de2.do 
do ${d2}mrgalloutcomes.do 
do ${d2}uniqenroll.do 
do ${d2}get_analysis_sample.do
do ${d2}readin_twc_2003_2004.do
do ${d2}twc_for_remediation.do
do ${d2}tasp_earnings_paco.do

log close 
exit


