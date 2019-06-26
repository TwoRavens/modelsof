*clear workspace
clear

*set more off
set more off

*set working directory to location of full.grid.dta
cd "JPR Replication Files\Supplemental Appendix\Figure A.2"

*read in main data
use "full.grid.dta", clear 

*drop years that are not included in the analysis
drop if year>2009
drop if year<1995

*collapse mean level of cropland, by grid/lat/long
collapse (mean) cropland, by(gid longitude latitude)

*save dataset in old format for analysis in R
saveold  "collapsed.grid.dta", replace


