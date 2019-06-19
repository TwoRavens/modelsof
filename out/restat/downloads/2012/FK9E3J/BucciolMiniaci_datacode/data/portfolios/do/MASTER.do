* MASTER.do FILE

* RUN THIS PROGRAM TO CREATE THE DATASET OF HOUSEHOLD PORTFOLIOS
* Change the path below with your own path

* Alessandro Bucciol (alessandro.bucciol@univr.it)
* University of Verona
* March 2010

********************************************************************



cd "D:\Research\Risk preference\Data\Portfolios"

set more off
clear
set mem 400m
set maxvar 10000
use "SCF\scf2004" /* The full SCF dataset */
do "Do\datakeep"
do "Do\datalabel"
do "Do\portall" /* It calls the do-file "hwealth.do" */
do "Do\portall_exp"
do "Do\aggrport" /* TABLE 1 */


********************************************************************

* The command below simply counts the number of those in the sample with rollover or refinancing debt

* use "SCF\scf2004.dta", clear

* bysort y1: egen mx7137 = mean(x7137)
* bysort y1: egen mx820 = mean(x820)

* gen dx7137 = (mx7137 == 1 | mx7137 == 3)
* gen dx820 = (mx820 == 1)

* sum dx7137 [fw = int(x42001)] if mx7137 > 0 /* Rollover or refinancing debt */
* sum dx820 [fw = int(x42001)] if mx820 > 0 /* Adjustable rate */
* sum dx820 [fw = int(x42001)] if mx820 > 0 & mx7137 >= 2 /* Not refinancing debt and Adjustable rate */
