/*Full dataset: directory DATA*/
clear
capture log close
set matsize 800
set memory 900m
set more off
log using datarev.log, replace

use data200rev, clear
drop if edad<16
drop if edad>65
local quarters "300 400 101 201 301 401 102 202 302 402 103 203 303 403 104 204 304 404"
foreach quarter of local quarters {
	append using data`quarter'rev
	drop if edad<16
	drop if edad>65
} 

compress
save datashortrev, replace
