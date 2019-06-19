*Description: This file generates the summary statistics as reported
*		  in Table 1 of the paper

*Preliminaries: You need to have the following data files in your current directory
*	1. data3d.txt
*	2. data2d.txt
*	3. abbgh_data_new.dta

clear

set more off

*** Open the log file ***
log using table01.log, replace

*-------------------------------------------------------------------

*** Import the US 3-digit data ***
insheet c1 c1a c1b c2 cwp gap1 gap2 industry inst1_f inst2_ip inst3_t instf_1 instf_2 instf_3 instf_4 no_of_firms pat rnd rndint year empty using data3d.txt, tab

drop empty
drop if year<1976
drop if year>2001

*** Label variables ***
label var c1 "Competition (1 - LI)"
label var c1a "c1 allowing for LI as low as -1"
label var c1b "c1 based on median LI"
label var c2 "Competition (1 - H)"
label var cwp "Citation-weighted Patents"
label var gap1 "Technological Gap based on Labor Productivity"
label var gap2 "Technological Gap based on TFP"
label var industry "3-Digit SIC codes"
label var inst1_f "Freight as percentage of Import Value"
label var inst2_ip "Import Penetration"
label var inst3_t "Tariffs as percentage of Import Value"
label var instf_1 "Weighted Forex 1"
label var instf_2 "Weighted Forex 2"
label var instf_3 "Weighted Forex 3"
label var instf_4 "Weighted Forex 4"
label var no_of_firms "Number of Firms"
label var pat "Patents"
label var rnd "Research and Development Expenditure"
label var rndint "Research Intensity"
label var year "Year"

*** Calculate the summary statistics ***
sum c1 cwp gap2 year
centile c1 cwp gap2, centile(10 50 90) 

*** Count the number of industries ***
by industry, sort: gen nvals = _n == 1
count if nvals

*-------------------------------------------------------------------

*** Import the US 2-digit data ***
clear
insheet c1 c1a c1b c2 cwp gap1 gap2 industry inst1_f inst2_ip inst3_t instf_1 instf_2 instf_3 instf_4 no_of_firms pat rnd rndint year empty using data2d.txt, tab

drop empty
drop if year<1976
drop if year>2001

*** Label variables ***
label var c1 "Competition (1 - LI)"
label var c1a "c1 allowing for LI as low as -1"
label var c1b "c1 based on median LI"
label var c2 "Competition (1 - H)"
label var cwp "Citation-weighted Patents"
label var gap1 "Technological Gap based on Labor Productivity"
label var gap2 "Technological Gap based on TFP"
label var industry "2-Digit SIC codes"
label var inst1_f "Freight as percentage of Import Value"
label var inst2_ip "Import Penetration"
label var inst3_t "Tariffs as percentage of Import Value"
label var instf_1 "Weighted Forex 1"
label var instf_2 "Weighted Forex 2"
label var instf_3 "Weighted Forex 3"
label var instf_4 "Weighted Forex 4"
label var no_of_firms "Number of Firms"
label var pat "Patents"
label var rnd "Research and Development Expenditure"
label var rndint "Research Intensity"
label var year "Year"

*** Calculate the summary statistics ***
sum c1 cwp gap2 year
centile c1 cwp gap2, centile(10 50 90)

*** Count the number of industries ***
by industry, sort: gen nvals = _n == 1
count if nvals

*-------------------------------------------------------------------

*** Import the UK 2-digit data ***
clear
use abbgh_data_new
sum Lc patcw NN year
centile Lc patcw NN, centile(10 50 90)

*** Count the number of industries ***
by sic2, sort: gen nvals = _n == 1
count if nvals

*-------------------------------------------------------------------

log close




