*Note: This code generates the summary statistics reported in Table A.I of our Supplemental Appendix

********************************************************************************************************************
*************************Generate Summary Statistics for All Relevant Variables*************************************
********************************************************************************************************************
clear
set more off

cd "\JPR Replication Files\Data"
set more off

*load primary dataset
use "LOTL_Rep.dta", clear

*summarize relevant varaibles
summarize incidentacledfull lagcivconflagtemp lagcropland laglogpop loglagcellarea loglagppp loglagttime lagtemp loglagprec lagspi6 loglagbdist1 splincidentacledfull loglagwdi_gdpc lagp_polity2 lagpolitysq loglagmilex ter_change_bin if acled_country==1, detail
