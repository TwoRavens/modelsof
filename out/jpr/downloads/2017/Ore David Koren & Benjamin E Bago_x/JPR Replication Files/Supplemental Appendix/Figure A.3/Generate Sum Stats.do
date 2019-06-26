*This code generates the proportion values that are used in "PlotProportions.R" to generate Figure A.3,
*	which is reported in the Supplemental Appendix

*clear stata session
clear
set more off

*read in data
use "JPR Replication Files\Data\LOTL_Rep.dta", clear 

*drop nuisance years
drop if year>2009
drop if year<1997

*In the two cases below, we collapse our atrocities DV into summed counts, by the relevant conflict variable,
*	these are commented out here since each collaps command should be run separately on the main dataset that is read in above.

*collapse (sum) incidentacledfull, by(civil_conflict)
*civil_conflict	incidentacledfull
*0	6798
*1	5408


*collapse (sum) incidentacledfull, by(civconf)
*civconf	incidentacledfull
*0	7012
*1	4202




