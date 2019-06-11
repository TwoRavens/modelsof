set more off
clear
log using bechtel_scheve_rep.smcl, replace
* Set path to working directory here
global path = "/Users/mbechtel/A. Dateien MB/01 Dienstlich/01 Projekte u Publ/01 Projekte/03 Accepted/11 SocDemNorms/Replication"

do "$path/01 create data.do"
do "$path/02 create pooled data.do"
do "$path/03 create vars.do"
do "$path/04 results.do"

log close
