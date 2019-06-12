/* Notes: 
- Table 2 requires my_ols_spatial_HAC, kindly provided by Nicolas Berman, Mathieu Couttenier, Dominic Rohner, and Mathias Thoenig,
amended version of original ado file ols_spatial_hac by Solomon Hsiang.
- Spatial regressions are run with the xsmle command (by Federico Belotti, Gordon Hughes, Andrea Piano Mortari), September 2016 version - included in "dofiles/ado" file folder.
- Figure 1 is created interactively in ArcGis. Instructions are provided in Figure1.do.
*/

*===============================================================================
* set up
*===============================================================================

clear all
set more off
cap log close
set matsize 11000
set maxvar 32000

*global terminal "put your diretory here"
global terminal "C:\Users\harari\Dropbox\Geoconflict\Replication"

global data "${terminal}/dataset"
global temp "${data}/temp"
global output "${terminal}/output"
global dofiles "${terminal}/dofiles"
global logs "${dofiles}/Logs"

cap mkdir "${output}"
cap mkdir "${logs}"
cap mkdir "${temp}"

*install necessary packages

cap ssc install spwmatrix
cap ssc install xtbalance
cap ssc install outreg2
cap ssc install moremata
cap ssc install spmap
cap net install dm88_1.pkg
adopath + "${dofiles}/ado/"

*===============================================================================
* table1 
*===============================================================================
do "${dofiles}/table1.do"

*===============================================================================
* table2
*===============================================================================
do "${dofiles}/table2.do"

*===============================================================================
* table3 
*===============================================================================
do "${dofiles}/table3.do"

*===============================================================================
* table4 
*===============================================================================
do "${dofiles}/table4.do"

*===============================================================================
* table5 
*===============================================================================
do "${dofiles}/table5.do"

*===============================================================================
* table6 
*===============================================================================
do "${dofiles}/table6.do"

*===============================================================================
* figure1 
*===============================================================================
do "${dofiles}/figure1.do"

*===============================================================================
* figure2 
*===============================================================================
do "${dofiles}/figure2.do"
