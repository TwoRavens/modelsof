
global folder = "C:\Users\Fabian\Dropbox\Research Project 7 - Long Term Effects of Dismissal of Scientists"


*****Have to change folders ******

/********************************/
/********************************/
/* Main Results: Tables 3 and 4 */
/********************************/
/********************************/
cd "$folder\Data Temporary STATA Files\Replication Files\"
use "Data Main Results.dta", clear
cd "$folder\Outreg Files\Version Final\"


foreach outcome in pubn_avg5alt_tot citn_avg5alt_tot  {

areg `outcome' num_dis3340_1926 num_dis3340_1940 num_dis3340_1950 num_dis3340_1961 num_dis3340_1970 num_dis3340_1980 /*
*/	yeard????  if (sample_ger1990==1 | sample_aus==1), a(department) cl(uni)
outreg2 num_dis3340_1926 num_dis3340_1940 num_dis3340_1950 num_dis3340_1961 num_dis3340_1970 num_dis3340_1980 using "RF_`outcome'_40.xls", replace dec(3) 

areg `outcome' num_dis3340_1926 num_dis3340_1940 num_dis3340_1950 num_dis3340_1961 num_dis3340_1970 num_dis3340_1980 /*
*/	subject_chem_yeard???? subject_phys_yeard???? yeard???? if (sample_ger1990==1 | sample_aus==1), a(department) cl(uni)
outreg2 num_dis3340_1926 num_dis3340_1940 num_dis3340_1950 num_dis3340_1961 num_dis3340_1970 num_dis3340_1980 using "RF_`outcome'_40.xls", append dec(3)

areg `outcome' num_dis3340_1926 num_dis3340_1940 num_dis3340_1950 num_dis3340_1961 num_dis3340_1970 num_dis3340_1980 /*
*/	subject_chem_yeard???? subject_phys_yeard???? yeard???? zone_uk zone_fra zone_ussr if (sample_ger1990==1 | sample_aus==1), a(department) cl(uni)
outreg2 num_dis3340_1926 num_dis3340_1940 num_dis3340_1950 num_dis3340_1961 num_dis3340_1970 num_dis3340_1980 using "RF_`outcome'_40.xls", append dec(3)




areg `outcome' dest_sub_1926 dest_sub_1931 dest_sub_1950 dest_sub_1961 dest_sub_1970 dest_sub_1980 /*
*/	yeard???? if (sample_ger1990==1 | sample_aus==1), a(department) cl(uni)
outreg2 dest_sub_1926 dest_sub_1931 dest_sub_1950 dest_sub_1961 dest_sub_1970 dest_sub_1980 using "RF_`outcome'_40.xls", append dec(3)

areg `outcome' dest_sub_1926 dest_sub_1931 dest_sub_1950 dest_sub_1961 dest_sub_1970 dest_sub_1980 /*
*/	subject_chem_yeard???? subject_phys_yeard???? yeard???? if (sample_ger1990==1 | sample_aus==1), a(department) cl(uni)
outreg2 dest_sub_1926 dest_sub_1931 dest_sub_1950 dest_sub_1961 dest_sub_1970 dest_sub_1980 using "RF_`outcome'_40.xls", append dec(3)

areg `outcome' dest_sub_1926 dest_sub_1931 dest_sub_1950 dest_sub_1961 dest_sub_1970 dest_sub_1980 /*
*/	subject_chem_yeard???? subject_phys_yeard???? yeard???? zone_us zone_uk zone_fra zone_ussr if (sample_ger1990==1 | sample_aus==1), a(department) cl(uni)
outreg2 dest_sub_1926 dest_sub_1931 dest_sub_1950 dest_sub_1961 dest_sub_1970 dest_sub_1980 using "RF_`outcome'_40.xls", append dec(3)



areg `outcome' num_dis3340_1926 num_dis3340_1940 num_dis3340_1950 num_dis3340_1961 num_dis3340_1970 num_dis3340_1980 /*
*/	dest_sub_1926 dest_sub_1931 dest_sub_1950 dest_sub_1961 dest_sub_1970 dest_sub_1980 /*
*/	yeard???? if (sample_ger1990==1 | sample_aus==1), a(department) cl(uni)
outreg2 num_dis3340_1926 num_dis3340_1940 num_dis3340_1950 num_dis3340_1961 num_dis3340_1970 num_dis3340_1980 /*
*/	dest_sub_1926 dest_sub_1931 dest_sub_1950 dest_sub_1961 dest_sub_1970 dest_sub_1980 using "RF_`outcome'_40.xls", append dec(3)

areg `outcome' num_dis3340_1926 num_dis3340_1940 num_dis3340_1950 num_dis3340_1961 num_dis3340_1970 num_dis3340_1980 /*
*/	dest_sub_1926 dest_sub_1931 dest_sub_1950 dest_sub_1961 dest_sub_1970 dest_sub_1980 /*
*/	subject_chem_yeard???? subject_phys_yeard???? yeard???? if (sample_ger1990==1 | sample_aus==1), a(department) cl(uni)
outreg2 num_dis3340_1926 num_dis3340_1940 num_dis3340_1950 num_dis3340_1961 num_dis3340_1970 num_dis3340_1980 /*
*/	dest_sub_1926 dest_sub_1931 dest_sub_1950 dest_sub_1961 dest_sub_1970 dest_sub_1980 using "RF_`outcome'_40.xls", append dec(3)

areg `outcome' num_dis3340_1926 num_dis3340_1940 num_dis3340_1950 num_dis3340_1961 num_dis3340_1970 num_dis3340_1980 /*
*/	dest_sub_1926 dest_sub_1931 dest_sub_1950 dest_sub_1961 dest_sub_1970 dest_sub_1980 /*
*/	subject_chem_yeard???? subject_phys_yeard???? yeard???? zone_us zone_uk zone_fra zone_ussr if (sample_ger1990==1 | sample_aus==1), a(department) cl(uni)
outreg2 num_dis3340_1926 num_dis3340_1940 num_dis3340_1950 num_dis3340_1961 num_dis3340_1970 num_dis3340_1980 /*
*/	dest_sub_1926 dest_sub_1931 dest_sub_1950 dest_sub_1961 dest_sub_1970 dest_sub_1980 using "RF_`outcome'_40.xls", append dec(3)

areg `outcome' num_dis3340_1926 num_dis3340_1940 num_dis3340_1950 num_dis3340_1961 num_dis3340_1970 num_dis3340_1980 /*
*/	dest_sub_1926 dest_sub_1931 dest_sub_1950 dest_sub_1961 dest_sub_1970 dest_sub_1980 /*
*/  dest_cit_1926 dest_cit_1931 dest_cit_1950 dest_cit_1961 dest_cit_1970 dest_cit_1980 /*
*/	subject_chem_yeard???? subject_phys_yeard???? yeard???? zone_us zone_uk zone_fra zone_ussr if (sample_ger1990==1 | sample_aus==1), a(department) cl(uni)
outreg2 num_dis3340_1926 num_dis3340_1940 num_dis3340_1950 num_dis3340_1961 num_dis3340_1970 num_dis3340_1980 /*
*/	dest_sub_1926 dest_sub_1931 dest_sub_1950 dest_sub_1961 dest_sub_1970 dest_sub_1980 using "RF_`outcome'_40.xls", append dec(3)

} /* outcome */






/* Regressions that produce data for Figures 3,4,5, and A3 */

areg pubn_avg5alt_tot num_dis3340_1926 num_dis3340_1940 num_dis3340_1950 num_dis3340_1961 num_dis3340_1970 num_dis3340_1980 /*
*/	dest_sub_1926 dest_sub_1931 dest_sub_1950 dest_sub_1961 dest_sub_1970 dest_sub_1980 /*
*/  dest_cit_1926 dest_cit_1931 dest_cit_1950 dest_cit_1961 dest_cit_1970 dest_cit_1980 /*
*/	subject_chem_yeard???? subject_phys_yeard???? yeard???? zone_us zone_uk zone_fra zone_ussr if (sample_ger1990==1 | sample_aus==1), a(department) cl(uni)


areg pubn_avg5alt_tot num_dis3340_1926 num_dis3340_1940 num_dis3340_1950 num_dis3340_1961 num_dis3340_1970 num_dis3340_1980 /*
*/	dest_sub_1926 dest_sub_1931 dest_sub_1950 dest_sub_1961 dest_sub_1970 dest_sub_1980 /*
*/  dest_cit_1926 dest_cit_1931 dest_cit_1950 dest_cit_1961 dest_cit_1970 dest_cit_1980 /*
*/	subject_chem_yeard???? subject_phys_yeard???? yeard???? zone_us zone_uk zone_fra zone_ussr /*
*/	bula4*_post45  fractjew_post33 closeuni_50 dist_border_post45 uniage uniage2 sh33_firms_ind5_* sh33_firms_ind8_* sh33_firms_ind11_* if (sample_ger1990==1 | sample_aus==1), a(department) cl(uni)


areg citn_avg5alt_tot num_dis3340_1926 num_dis3340_1940 num_dis3340_1950 num_dis3340_1961 num_dis3340_1970 num_dis3340_1980 /*
	*/	dest_sub_1926 dest_sub_1931 dest_sub_1950 dest_sub_1961 dest_sub_1970 dest_sub_1980 /*
	*/  dest_cit_1926 dest_cit_1931 dest_cit_1950 dest_cit_1961 dest_cit_1970 dest_cit_1980 /*
*/	subject_chem_yeard???? subject_phys_yeard???? yeard???? zone_uk zone_fra zone_ussr if (sample_ger1990==1 | sample_aus==1), a(department) cl(uni)


areg citn_avg5alt_tot num_dis3340_1926 num_dis3340_1940 num_dis3340_1950 num_dis3340_1961 num_dis3340_1970 num_dis3340_1980 /*
*/	dest_sub_1926 dest_sub_1931 dest_sub_1950 dest_sub_1961 dest_sub_1970 dest_sub_1980 /*
*/  dest_cit_1926 dest_cit_1931 dest_cit_1950 dest_cit_1961 dest_cit_1970 dest_cit_1980 /*
*/	subject_chem_yeard???? subject_phys_yeard???? yeard???? zone_us zone_uk zone_fra zone_ussr /*
*/	bula4*_post45  fractjew_post33 closeuni_50 dist_border_post45 uniage uniage2 sh33_firms_ind5_* sh33_firms_ind8_* sh33_firms_ind11_* if (sample_ger1990==1 | sample_aus==1), a(department) cl(uni)




/********************************************************/
/********************************************************/
/* Robustness Checks - Adding Controls: Tables 5 and A4 */
/********************************************************/
/********************************************************/

foreach measure in  pubn citn {

cd "$folder\Outreg Files\Version Final\"
/* 1 */
areg `measure'_avg5alt_tot num_dis3340_1926 num_dis3340_1940 num_dis3340_1950 num_dis3340_1961 num_dis3340_1970 num_dis3340_1980 /*
*/	dest_sub_1926 dest_sub_1931 dest_sub_1950 dest_sub_1961 dest_sub_1970 dest_sub_1980 /*
*/  dest_cit_1926 dest_cit_1931 dest_cit_1950 dest_cit_1961 dest_cit_1970 dest_cit_1980 /*
*/	subject_chem_yeard???? subject_phys_yeard???? yeard???? zone_us zone_uk zone_fra zone_ussr /*
*/	bula4*_post45  if (sample_ger1990==1 | sample_aus==1), a(department) cl(uni)
outreg2 num_dis3340_1926 num_dis3340_1940 num_dis3340_1950 num_dis3340_1961 num_dis3340_1970 num_dis3340_1980 /*
*/	dest_sub_1926 dest_sub_1931 dest_sub_1950 dest_sub_1961 dest_sub_1970 dest_sub_1980 using "Robustness_`measure'.xls", replace dec(3)

/* 2 */
areg `measure'_avg5alt_tot num_dis3340_1926 num_dis3340_1940 num_dis3340_1950 num_dis3340_1961 num_dis3340_1970 num_dis3340_1980 /*
*/	dest_sub_1926 dest_sub_1931 dest_sub_1950 dest_sub_1961 dest_sub_1970 dest_sub_1980 /*
*/  dest_cit_1926 dest_cit_1931 dest_cit_1950 dest_cit_1961 dest_cit_1970 dest_cit_1980 /*
*/	subject_chem_yeard???? subject_phys_yeard???? yeard???? zone_us zone_uk zone_fra zone_ussr /*
*/	bula4*_post45 uniage uniage2 if (sample_ger1990==1 | sample_aus==1), a(department) cl(uni)
outreg2 num_dis3340_1926 num_dis3340_1940 num_dis3340_1950 num_dis3340_1961 num_dis3340_1970 num_dis3340_1980 /*
*/	dest_sub_1926 dest_sub_1931 dest_sub_1950 dest_sub_1961 dest_sub_1970 dest_sub_1980 using "Robustness_`measure'.xls", append dec(3)

/* 3 */
areg `measure'_avg5alt_tot num_dis3340_1926 num_dis3340_1940 num_dis3340_1950 num_dis3340_1961 num_dis3340_1970 num_dis3340_1980 /*
*/	dest_sub_1926 dest_sub_1931 dest_sub_1950 dest_sub_1961 dest_sub_1970 dest_sub_1980 /*
*/  dest_cit_1926 dest_cit_1931 dest_cit_1950 dest_cit_1961 dest_cit_1970 dest_cit_1980 /*
*/	subject_chem_yeard???? subject_phys_yeard???? yeard???? zone_us zone_uk zone_fra zone_ussr /*
*/	bula4*_post45 uniage uniage2 closeuni_50 if (sample_ger1990==1 | sample_aus==1), a(department) cl(uni)
outreg2 num_dis3340_1926 num_dis3340_1940 num_dis3340_1950 num_dis3340_1961 num_dis3340_1970 num_dis3340_1980 /*
*/	dest_sub_1926 dest_sub_1931 dest_sub_1950 dest_sub_1961 dest_sub_1970 dest_sub_1980 using "Robustness_`measure'.xls", append dec(3)

/* 4 */
areg `measure'_avg5alt_tot num_dis3340_1926 num_dis3340_1940 num_dis3340_1950 num_dis3340_1961 num_dis3340_1970 num_dis3340_1980 /*
*/	dest_sub_1926 dest_sub_1931 dest_sub_1950 dest_sub_1961 dest_sub_1970 dest_sub_1980 /*
*/  dest_cit_1926 dest_cit_1931 dest_cit_1950 dest_cit_1961 dest_cit_1970 dest_cit_1980 /*
*/	subject_chem_yeard???? subject_phys_yeard???? yeard???? zone_us zone_uk zone_fra zone_ussr /*
*/	bula4*_post45 uniage uniage2 closeuni_50 sh33_firms_ind5_* sh33_firms_ind8_* sh33_firms_ind11_* if (sample_ger1990==1 | sample_aus==1), a(department) cl(uni)
outreg2 num_dis3340_1926 num_dis3340_1940 num_dis3340_1950 num_dis3340_1961 num_dis3340_1970 num_dis3340_1980 /*
*/	dest_sub_1926 dest_sub_1931 dest_sub_1950 dest_sub_1961 dest_sub_1970 dest_sub_1980 using "Robustness_`measure'.xls", append dec(3)

/* 5 */
areg `measure'_avg5alt_tot num_dis3340_1926 num_dis3340_1940 num_dis3340_1950 num_dis3340_1961 num_dis3340_1970 num_dis3340_1980 /*
*/	dest_sub_1926 dest_sub_1931 dest_sub_1950 dest_sub_1961 dest_sub_1970 dest_sub_1980 /*
*/  dest_cit_1926 dest_cit_1931 dest_cit_1950 dest_cit_1961 dest_cit_1970 dest_cit_1980 /*
*/	subject_chem_yeard???? subject_phys_yeard???? yeard???? zone_us zone_uk zone_fra zone_ussr /*
*/	bula4*_post45 uniage uniage2 closeuni_50 sh33_firms_ind5_* sh33_firms_ind8_* sh33_firms_ind11_* fractjew_post33 if (sample_ger1990==1 | sample_aus==1), a(department) cl(uni)
outreg2 num_dis3340_1926 num_dis3340_1940 num_dis3340_1950 num_dis3340_1961 num_dis3340_1970 num_dis3340_1980 /*
*/	dest_sub_1926 dest_sub_1931 dest_sub_1950 dest_sub_1961 dest_sub_1970 dest_sub_1980 using "Robustness_`measure'.xls", append dec(3)

/* 6 */
areg `measure'_avg5alt_tot num_dis3340_1926 num_dis3340_1940 num_dis3340_1950 num_dis3340_1961 num_dis3340_1970 num_dis3340_1980 /*
*/	dest_sub_1926 dest_sub_1931 dest_sub_1950 dest_sub_1961 dest_sub_1970 dest_sub_1980 /*
*/  dest_cit_1926 dest_cit_1931 dest_cit_1950 dest_cit_1961 dest_cit_1970 dest_cit_1980 /*
*/	subject_chem_yeard???? subject_phys_yeard???? yeard???? zone_us zone_uk zone_fra zone_ussr /*
*/	bula4*_post45  fractjew_post33 closeuni_50 dist_border_post45 uniage uniage2 sh33_firms_ind5_* sh33_firms_ind8_* sh33_firms_ind11_* if (sample_ger1990==1 | sample_aus==1), a(department) cl(uni)
outreg2 num_dis3340_1926 num_dis3340_1940 num_dis3340_1950 num_dis3340_1961 num_dis3340_1970 num_dis3340_1980 /*
*/	dest_sub_1926 dest_sub_1931 dest_sub_1950 dest_sub_1961 dest_sub_1970 dest_sub_1980 using "Robustness_`measure'.xls", append dec(3)

/* 7 */
/* Age Adjusting Productivity */
areg resid_`measure'_avg5alt_tot num_dis3340_1926 num_dis3340_1940 num_dis3340_1950 num_dis3340_1961 num_dis3340_1970 num_dis3340_1980 /*
*/	dest_sub_1926 dest_sub_1931 dest_sub_1950 dest_sub_1961 dest_sub_1970 dest_sub_1980 /*
*/  dest_cit_1926 dest_cit_1931 dest_cit_1950 dest_cit_1961 dest_cit_1970 dest_cit_1980 /*
*/	subject_chem_yeard???? subject_phys_yeard???? yeard???? zone_us zone_uk zone_fra zone_ussr /*
*/	bula4*_post45  fractjew_post33 closeuni_50 dist_border_post45 uniage uniage2 sh33_firms_ind5_* sh33_firms_ind8_* sh33_firms_ind11_* if (sample_ger1990==1 | sample_aus==1), a(department) cl(uni)
outreg2 num_dis3340_1926 num_dis3340_1940 num_dis3340_1950 num_dis3340_1961 num_dis3340_1970 num_dis3340_1980 /*
*/	dest_sub_1926 dest_sub_1931 dest_sub_1950 dest_sub_1961 dest_sub_1970 dest_sub_1980 using "Robustness_`measure'.xls", append dec(3)

} /* measure */






/********************************************************************************************************************************************/
/********************************************************************************************************************************************/
/* Robustness Checks - Different Samples, Different Shock Measures, Controlling for University*Post1945 and Mean Reversion: Tables 6 and A5 */
/********************************************************************************************************************************************/
/********************************************************************************************************************************************/

/********************************/
/* Sample including Germany1990 */
/********************************/

foreach measure in  pubn citn {
cd "$folder\Data Temporary STATA Files\Replication Files\"
use "Data Germany1990.dta", clear
cd "$folder\Outreg Files\Version Final\"
/* 1 */ 
areg `measure'_avg5alt_tot num_dis3340_1926 num_dis3340_1940 num_dis3340_1950 num_dis3340_1961 num_dis3340_1970 num_dis3340_1980 /*
*/	dest_sub_1926 dest_sub_1931 dest_sub_1950 dest_sub_1961 dest_sub_1970 dest_sub_1980 /*
*/  dest_cit_1926 dest_cit_1931 dest_cit_1950 dest_cit_1961 dest_cit_1970 dest_cit_1980 /*
*/	subject_chem_yeard???? subject_phys_yeard???? yeard???? zone_us zone_uk zone_fra zone_ussr /*
*/	bula4*_post45  fractjew_post33 closeuni_50 dist_border_post45 uniage uniage2 sh33_firms_ind5_* sh33_firms_ind8_* sh33_firms_ind11_*  if (sample_ger1990==1), a(department) cl(uni)
outreg2 num_dis3340_1926 num_dis3340_1940 num_dis3340_1950 num_dis3340_1961 num_dis3340_1970 num_dis3340_1980 /*
*/	dest_sub_1926 dest_sub_1931 dest_sub_1950 dest_sub_1961 dest_sub_1970 dest_sub_1980 using "Robustness2_`measure'.xls", replace dec(3)


/*********************************************/
/* Sample including West Germany and Austria */
/*********************************************/
cd "$folder\Data Temporary STATA Files\Replication Files\"
use "Data GermanyWest Austria.dta", clear
cd "$folder\Outreg Files\Version Final\"
/* 2 */
areg `measure'_avg5alt_tot num_dis3340_1926 num_dis3340_1940 num_dis3340_1950 num_dis3340_1961 num_dis3340_1970 num_dis3340_1980 /*
*/	dest_sub_1926 dest_sub_1931 dest_sub_1950 dest_sub_1961 dest_sub_1970 dest_sub_1980 /*
*/  dest_cit_1926 dest_cit_1931 dest_cit_1950 dest_cit_1961 dest_cit_1970 dest_cit_1980 /*
*/	subject_chem_yeard???? subject_phys_yeard???? yeard???? zone_us zone_uk zone_fra zone_ussr /*
*/	bula4*_post45  fractjew_post33 closeuni_50 dist_border_post45 uniage uniage2 sh33_firms_ind5_* sh33_firms_ind8_* sh33_firms_ind11_* if (sample_gerwest==1 | sample_aus==1), a(department) cl(uni)
outreg2 num_dis3340_1926 num_dis3340_1940 num_dis3340_1950 num_dis3340_1961 num_dis3340_1970 num_dis3340_1980 /*
*/	dest_sub_1926 dest_sub_1931 dest_sub_1950 dest_sub_1961 dest_sub_1970 dest_sub_1980 using "Robustness2_`measure'.xls", append dec(3)



/*********************************************/
/* Robustness: Swiss Universities as Control */
/*********************************************/
cd "$folder\Data Temporary STATA Files\Replication Files\"
use "Data GermanyWest Austria Switzerland.dta", clear
cd "$folder\Outreg Files\Version Final\"
/* 3 */
areg `measure'_avg5alt_tot num_dis3340_1926 num_dis3340_1940 num_dis3340_1950 num_dis3340_1961 num_dis3340_1970 num_dis3340_1980 /*
*/	dest_sub_1926 dest_sub_1931 dest_sub_1950 dest_sub_1961 dest_sub_1970 dest_sub_1980 /*
*/	dest_cit_1926 dest_cit_1931 dest_cit_1950 dest_cit_1961 dest_cit_1970 dest_cit_1980 /*
*/	subject_chem_yeard???? subject_phys_yeard???? yeard???? zone_us zone_uk zone_fra zone_ussr zone_us /*
*/ 	bula4*_post45   closeuni_50  uniage uniage2 fractjew_post33  dist_border_post45/*
*/  if (sample_ger1990==1 | sample_aus==1 | sample_swi==1), a(department) cl(uni)
outreg2 num_dis3340_1926 num_dis3340_1940 num_dis3340_1950 num_dis3340_1961 num_dis3340_1970 num_dis3340_1980 /*
*/	dest_sub_1926 dest_sub_1931 dest_sub_1950 dest_sub_1961 dest_sub_1970 dest_sub_1980 using "Robustness2_`measure'.xls", append dec(3)


cd "$folder\Data Temporary STATA Files\Replication Files\"
use "Data Main Results.dta", clear
cd "$folder\Outreg Files\Version Final\"

/***************************************/
/* Robustness - Percentage Dismissals  */
/***************************************/
/* 4 */
areg `measure'_avg5alt_tot perc10_dis3340_1926 perc10_dis3340_1940 perc10_dis3340_1950 perc10_dis3340_1961 perc10_dis3340_1970 perc10_dis3340_1980 /*
*/	dest_sub_1926 dest_sub_1931 dest_sub_1950 dest_sub_1961 dest_sub_1970 dest_sub_1980 /*
*/  dest_cit_1926 dest_cit_1931 dest_cit_1950 dest_cit_1961 dest_cit_1970 dest_cit_1980 /*
*/	subject_chem_yeard???? subject_phys_yeard???? yeard???? zone_us zone_uk zone_fra zone_ussr /*
*/	bula4*_post45  fractjew_post33 closeuni_50 dist_border_post45 uniage uniage2 sh33_firms_ind5_* sh33_firms_ind8_* sh33_firms_ind11_*  if (sample_ger1990==1 | sample_aus==1), a(department) cl(uni)
outreg2 perc10_dis3340_1926 perc10_dis3340_1940 perc10_dis3340_1950 perc10_dis3340_1961 perc10_dis3340_1970 perc10_dis3340_1980 /*
*/	dest_sub_1926 dest_sub_1931 dest_sub_1950 dest_sub_1961 dest_sub_1970 dest_sub_1980 using "Robustness2_`measure'.xls", append dec(3)


/************************************************/
/* Robustness - Only 1933 to 1934 Dismissals   */
/************************************************/
/* 5 */
areg `measure'_avg5alt_tot num_dis3334_1926 num_dis3334_1940 num_dis3334_1950 num_dis3334_1961 num_dis3334_1970 num_dis3334_1980 /*
*/	dest_sub_1926 dest_sub_1931 dest_sub_1950 dest_sub_1961 dest_sub_1970 dest_sub_1980 /*
*/  dest_cit_1926 dest_cit_1931 dest_cit_1950 dest_cit_1961 dest_cit_1970 dest_cit_1980 /*
*/	subject_chem_yeard???? subject_phys_yeard???? yeard???? zone_us zone_uk zone_fra zone_ussr /*
*/	bula4*_post45  fractjew_post33 closeuni_50 dist_border_post45 uniage uniage2 sh33_firms_ind5_* sh33_firms_ind8_* sh33_firms_ind11_*  if (sample_ger1990==1 | sample_aus==1), a(department) cl(uni)
outreg2 num_dis3334_1926 num_dis3334_1940 num_dis3334_1950 num_dis3334_1961 num_dis3334_1970 num_dis3334_1980 /*
*/	dest_sub_1926 dest_sub_1931 dest_sub_1950 dest_sub_1961 dest_sub_1970 dest_sub_1980 using "Robustness2_`measure'.xls", append dec(3)

/**************************************/
/* Robustness - Same Effect on Output */
/**************************************/
/* Estimate Baseline Results */

areg `measure'_avg5alt_tot num_dis3340_1926 num_dis3340_1940 num_dis3340_1950 num_dis3340_1961 num_dis3340_1970 num_dis3340_1980 /*
*/	dest_sub_1926 dest_sub_1931 dest_sub_1950 dest_sub_1961 dest_sub_1970 dest_sub_1980 /*
*/  dest_cit_1926 dest_cit_1931 dest_cit_1950 dest_cit_1961 dest_cit_1970 dest_cit_1980 /*
*/	subject_chem_yeard???? subject_phys_yeard???? yeard???? zone_us zone_uk zone_fra zone_ussr /*
*/	bula4*_post45  fractjew_post33 closeuni_50 dist_border_post45 uniage uniage2 sh33_firms_ind5_* sh33_firms_ind8_* sh33_firms_ind11_* if (sample_ger1990==1 | sample_aus==1), a(department) cl(uni)

/* Save coefficients */
gen coeff_dis = _b[num_dis3340_1940]
gen coeff_bom = _b[dest_sub_1950]

/* Obtain estimated effect on output */
gen decl_output_dis = coeff_dis*num_dis3340_1940 if year==1940
bys uni subject: egen decl_output_dis_max = max(decl_output_dis)
drop decl_output_dis
rename decl_output_dis_max decl_output_dis
replace decl_output_dis = decl_output_dis*(-1)

gen decl_output_bom = coeff_bom*dest_sub_1950 if year==1950
bys uni subject: egen decl_output_bom_max = max(decl_output_bom)
drop decl_output_bom
rename decl_output_bom_max decl_output_bom
replace decl_output_bom = decl_output_bom*(-1) 

foreach year in 1926 1931 1940 1950 1961 1970 1980 {
	gen decl_output_dis_`year' = 0
	replace decl_output_dis_`year' = decl_output_dis if year==`year'

	gen decl_output_bom_`year' = 0
	replace decl_output_bom_`year' = decl_output_bom if year==`year'
}

/* 6 */
areg `measure'_avg5alt_tot decl_output_dis_1926 decl_output_dis_1940 decl_output_dis_1950 decl_output_dis_1961 decl_output_dis_1970 decl_output_dis_1980/*
*/ decl_output_bom_1926 decl_output_bom_1931 decl_output_bom_1950 decl_output_bom_1961 decl_output_bom_1970 decl_output_bom_1980 /*
*/  dest_cit_1926 dest_cit_1931 dest_cit_1950 dest_cit_1961 dest_cit_1970 dest_cit_1980 /*
*/	subject_chem_yeard???? subject_phys_yeard???? yeard???? zone_us zone_uk zone_fra zone_ussr /*
*/	bula4*_post45  fractjew_post33 closeuni_50 dist_border_post45 uniage uniage2 sh33_firms_ind5_* sh33_firms_ind8_* sh33_firms_ind11_* /*
*/	if (sample_ger1990==1 | sample_aus==1), a(department) vce(bootstrap, cl(uni) reps(100))
outreg2 decl_output_dis_1926 decl_output_dis_1940 decl_output_dis_1950 decl_output_dis_1961 decl_output_dis_1970 decl_output_dis_1980/*
*/ decl_output_bom_1926 decl_output_bom_1931 decl_output_bom_1950 decl_output_bom_1961 decl_output_bom_1970 decl_output_bom_1980 using "Robustness2_`measure'.xls", append dec(3)


/*****************************************/
/* Robustness - Avg. Science Destruction */
/*****************************************/
/* 7 */
areg `measure'_avg5alt_tot num_dis3340_1926 num_dis3340_1940 num_dis3340_1950 num_dis3340_1961 num_dis3340_1970 num_dis3340_1980 /*
*/	dest_sci_1926 dest_sci_1931 dest_sci_1950 dest_sci_1961 dest_sci_1970 dest_sci_1980 /*
*/  dest_cit_1926 dest_cit_1931 dest_cit_1950 dest_cit_1961 dest_cit_1970 dest_cit_1980 /*
*/	subject_chem_yeard???? subject_phys_yeard???? yeard???? zone_us zone_uk zone_fra zone_ussr /*
*/	bula4*_post45  fractjew_post33 closeuni_50 dist_border_post45 uniage uniage2 sh33_firms_ind5_* sh33_firms_ind8_* sh33_firms_ind11_*  if (sample_ger1990==1 | sample_aus==1), a(department) cl(uni)
outreg2 num_dis3340_1926 num_dis3340_1940 num_dis3340_1950 num_dis3340_1961 num_dis3340_1970 num_dis3340_1980 /*
*/	dest_sci_1926 dest_sci_1931 dest_sci_1950 dest_sci_1961 dest_sci_1970 dest_sci_1980 using "Robustness2_`measure'.xls", append dec(3)




/*****************************************************/
/* Robustness - Instrumenting with uni level measure */
/*****************************************************/
/* 8 */
ivreg `measure'_avg5alt_tot num_dis3340_1926 num_dis3340_1940 num_dis3340_1950 num_dis3340_1961 num_dis3340_1970 num_dis3340_1980 /*
*/	(dest_sub_1926 dest_sub_1931 dest_sub_1950 dest_sub_1961 dest_sub_1970 dest_sub_1980 = /*
*/	dest_uni_1926 dest_uni_1931 dest_uni_1950 dest_uni_1961 dest_uni_1970 dest_uni_1980) /*
*/  dest_cit_1926 dest_cit_1931 dest_cit_1950 dest_cit_1961 dest_cit_1970 dest_cit_1980 /*
*/	subject_chem_yeard???? subject_phys_yeard???? yeard???? zone_us zone_uk zone_fra zone_ussr /*
*/	bula4*_post45  fractjew_post33 closeuni_50 dist_border_post45 uniage uniage2 depd* sh33_firms_ind5_* sh33_firms_ind8_* sh33_firms_ind11_*  if (sample_ger1990==1 | sample_aus==1),cl(uni)
outreg2 num_dis3340_1926 num_dis3340_1940 num_dis3340_1950 num_dis3340_1961 num_dis3340_1970 num_dis3340_1980 /*
*/	dest_sub_1926 dest_sub_1931 dest_sub_1950 dest_sub_1961 dest_sub_1970 dest_sub_1980 using "Robustness2_`measure'.xls", append dec(3)



/**********************************/
/* Robustness: Including Uni*Post */
/**********************************/
/* 9 */
areg `measure'_avg5alt_tot num_dis3340_1926 num_dis3340_1940 num_dis3340_1950 num_dis3340_1961 num_dis3340_1970 num_dis3340_1980 /*
*/	dest_sub_1926 dest_sub_1931 dest_sub_1950 dest_sub_1961 dest_sub_1970 dest_sub_1980 /*
*/  unid?_post45 unid??_post45 /*
*/  dest_cit_1926 dest_cit_1931 dest_cit_1950 dest_cit_1961 dest_cit_1970 dest_cit_1980 /*
*/	subject_chem_yeard???? subject_phys_yeard???? yeard???? zone_us zone_uk zone_fra zone_ussr /*
*/	bula4*_post45  fractjew_post33 closeuni_50 dist_border_post45 uniage uniage2 sh33_firms_ind5_* sh33_firms_ind8_* sh33_firms_ind11_* if (sample_ger1990==1 | sample_aus==1), a(department) cl(uni)
outreg2 num_dis3340_1926 num_dis3340_1940 num_dis3340_1950 num_dis3340_1961 num_dis3340_1970 num_dis3340_1980 /*
*/	dest_sub_1926 dest_sub_1931 dest_sub_1950 dest_sub_1961 dest_sub_1970 dest_sub_1980 using "Robustness2_`measure'.xls", append dec(3)


/**********************************************/
/* Robustness: Controlling for Mean Reversion */
/**********************************************/
/* 10 */
areg `measure'_avg5alt_tot num_dis3340_1926 num_dis3340_1940 num_dis3340_1950 num_dis3340_1961 num_dis3340_1970 num_dis3340_1980 /*
*/	dest_sub_1926 dest_sub_1931 dest_sub_1950 dest_sub_1961 dest_sub_1970 dest_sub_1980 /*
*/  `measure'_avg5alt_tot_1926_yearsince /*
*/  dest_cit_1926 dest_cit_1931 dest_cit_1950 dest_cit_1961 dest_cit_1970 dest_cit_1980 /*
*/	subject_chem_yeard???? subject_phys_yeard???? yeard???? zone_us zone_uk zone_fra zone_ussr /*
*/	bula4*_post45  fractjew_post33 closeuni_50 dist_border_post45 uniage uniage2 sh33_firms_ind5_* sh33_firms_ind8_* sh33_firms_ind11_* if (sample_ger1990==1 | sample_aus==1), a(department) cl(uni)
outreg2 num_dis3340_1926 num_dis3340_1940 num_dis3340_1950 num_dis3340_1961 num_dis3340_1970 num_dis3340_1980 /*
*/	dest_sub_1926 dest_sub_1931 dest_sub_1950 dest_sub_1961 dest_sub_1970 dest_sub_1980 using "Robustness2_`measure'.xls", append dec(3)

} /* measure */






/****************************/
/****************************/
/* Top Scientists: Table 7 */
/****************************/
/****************************/
cd "$folder\Data Temporary STATA Files\Replication Files\"
use "Data Main Results.dta", clear
cd "$folder\Outreg Files\Version Final\"
/* All */
areg pubn_avg5alt_tot num_dis3340_1926 num_dis3340_1940 num_dis3340_1950 num_dis3340_1961 num_dis3340_1970 num_dis3340_1980 /*
*/	dest_sub_1926 dest_sub_1931 dest_sub_1950 dest_sub_1961 dest_sub_1970 dest_sub_1980 /*
*/  dest_cit_1926 dest_cit_1931 dest_cit_1950 dest_cit_1961 dest_cit_1970 dest_cit_1980 /*
*/	subject_chem_yeard???? subject_phys_yeard???? yeard???? zone_us zone_uk zone_fra zone_ussr /*
*/	bula4*_post45  fractjew_post33 closeuni_50 dist_border_post45 uniage uniage2 sh33_firms_ind5_* sh33_firms_ind8_* sh33_firms_ind11_* if (sample_ger1990==1 | sample_aus==1), a(department) cl(uni)
outreg2 num_dis3340_1926 num_dis3340_1940 num_dis3340_1950 num_dis3340_1961 num_dis3340_1970 num_dis3340_1980/*
*/	dest_sub_1926 dest_sub_1931 dest_sub_1950 dest_sub_1961 dest_sub_1970 dest_sub_1980 using "Top Scientists.xls", replace dec(3)
*sleep 1000

areg citn_avg5alt_tot num_dis3340_1926 num_dis3340_1940 num_dis3340_1950 num_dis3340_1961 num_dis3340_1970 num_dis3340_1980 /*
*/	dest_sub_1926 dest_sub_1931 dest_sub_1950 dest_sub_1961 dest_sub_1970 dest_sub_1980 /*
*/  dest_cit_1926 dest_cit_1931 dest_cit_1950 dest_cit_1961 dest_cit_1970 dest_cit_1980 /*
*/	subject_chem_yeard???? subject_phys_yeard???? yeard???? zone_us zone_uk zone_fra zone_ussr /*
*/	bula4*_post45  fractjew_post33 closeuni_50 dist_border_post45 uniage uniage2 sh33_firms_ind5_* sh33_firms_ind8_* sh33_firms_ind11_*  if (sample_ger1990==1 | sample_aus==1), a(department) cl(uni)
outreg2 num_dis3340_1926 num_dis3340_1940 num_dis3340_1950 num_dis3340_1961 num_dis3340_1970 num_dis3340_1980/*
*/	dest_sub_1926 dest_sub_1931 dest_sub_1950 dest_sub_1961 dest_sub_1970 dest_sub_1980 using "Top Scientists.xls", append dec(3)
*sleep 1000

/* Above Median Quality */
areg pubn_avg5alt_tot num_dis3340_citn_t50_1926 num_dis3340_citn_t50_1940 num_dis3340_citn_t50_1950 num_dis3340_citn_t50_1961 num_dis3340_citn_t50_1970 num_dis3340_citn_t50_1980 /*
*/	dest_sub_1926 dest_sub_1931 dest_sub_1950 dest_sub_1961 dest_sub_1970 dest_sub_1980 /*
*/  dest_cit_1926 dest_cit_1931 dest_cit_1950 dest_cit_1961 dest_cit_1970 dest_cit_1980 /*
*/	subject_chem_yeard???? subject_phys_yeard???? yeard???? zone_us zone_uk zone_fra zone_ussr /*
*/	bula4*_post45  fractjew_post33 closeuni_50 dist_border_post45 uniage uniage2 sh33_firms_ind5_* sh33_firms_ind8_* sh33_firms_ind11_* if (sample_ger1990==1 | sample_aus==1), a(department) cl(uni)
outreg2 num_dis3340_citn_t50_1926 num_dis3340_citn_t50_1940 num_dis3340_citn_t50_1950 num_dis3340_citn_t50_1961 num_dis3340_citn_t50_1970 num_dis3340_citn_t50_1980/*
*/	dest_sub_1926 dest_sub_1931 dest_sub_1950 dest_sub_1961 dest_sub_1970 dest_sub_1980 using "Top Scientists.xls", append dec(3)
*sleep 1000

areg citn_avg5alt_tot num_dis3340_citn_t50_1926 num_dis3340_citn_t50_1940 num_dis3340_citn_t50_1950 num_dis3340_citn_t50_1961 num_dis3340_citn_t50_1970 num_dis3340_citn_t50_1980 /*
*/	dest_sub_1926 dest_sub_1931 dest_sub_1950 dest_sub_1961 dest_sub_1970 dest_sub_1980 /*
*/  dest_cit_1926 dest_cit_1931 dest_cit_1950 dest_cit_1961 dest_cit_1970 dest_cit_1980 /*
*/	subject_chem_yeard???? subject_phys_yeard???? yeard???? zone_us zone_uk zone_fra zone_ussr /*
*/	bula4*_post45  fractjew_post33 closeuni_50 dist_border_post45 uniage uniage2 sh33_firms_ind5_* sh33_firms_ind8_* sh33_firms_ind11_* if (sample_ger1990==1 | sample_aus==1), a(department) cl(uni)

outreg2 num_dis3340_citn_t50_1926 num_dis3340_citn_t50_1940 num_dis3340_citn_t50_1950 num_dis3340_citn_t50_1961 num_dis3340_citn_t50_1970 num_dis3340_citn_t50_1980/*
*/	dest_sub_1926 dest_sub_1931 dest_sub_1950 dest_sub_1961 dest_sub_1970 dest_sub_1980 using "Top Scientists.xls", append dec(3)
*sleep 1000

/* Top 25th percentile */
areg pubn_avg5alt_tot num_dis3340_citn_t25_1926 num_dis3340_citn_t25_1940 num_dis3340_citn_t25_1950 num_dis3340_citn_t25_1961 num_dis3340_citn_t25_1970 num_dis3340_citn_t25_1980 /*
*/	dest_sub_1926 dest_sub_1931 dest_sub_1950 dest_sub_1961 dest_sub_1970 dest_sub_1980 /*
*/  dest_cit_1926 dest_cit_1931 dest_cit_1950 dest_cit_1961 dest_cit_1970 dest_cit_1980 /*
*/	subject_chem_yeard???? subject_phys_yeard???? yeard???? zone_us zone_uk zone_fra zone_ussr /*
*/	bula4*_post45  fractjew_post33 closeuni_50 dist_border_post45 uniage uniage2 sh33_firms_ind5_* sh33_firms_ind8_* sh33_firms_ind11_*  if (sample_ger1990==1 | sample_aus==1), a(department) cl(uni)

outreg2 num_dis3340_citn_t25_1926 num_dis3340_citn_t25_1940 num_dis3340_citn_t25_1950 num_dis3340_citn_t25_1961 num_dis3340_citn_t25_1970 num_dis3340_citn_t25_1980/*
*/	dest_sub_1926 dest_sub_1931 dest_sub_1950 dest_sub_1961 dest_sub_1970 dest_sub_1980 using "Top Scientists.xls", append dec(3)
*sleep 1000

areg citn_avg5alt_tot num_dis3340_citn_t25_1926 num_dis3340_citn_t25_1940 num_dis3340_citn_t25_1950 num_dis3340_citn_t25_1961 num_dis3340_citn_t25_1970 num_dis3340_citn_t25_1980 /*
*/	dest_sub_1926 dest_sub_1931 dest_sub_1950 dest_sub_1961 dest_sub_1970 dest_sub_1980 /*
*/  dest_cit_1926 dest_cit_1931 dest_cit_1950 dest_cit_1961 dest_cit_1970 dest_cit_1980 /*
*/	subject_chem_yeard???? subject_phys_yeard???? yeard???? zone_us zone_uk zone_fra zone_ussr /*
*/	bula4*_post45  fractjew_post33 closeuni_50 dist_border_post45 uniage uniage2 sh33_firms_ind5_* sh33_firms_ind8_* sh33_firms_ind11_* if (sample_ger1990==1 | sample_aus==1), a(department) cl(uni)
outreg2 num_dis3340_citn_t25_1926 num_dis3340_citn_t25_1940 num_dis3340_citn_t25_1950 num_dis3340_citn_t25_1961 num_dis3340_citn_t25_1970 num_dis3340_citn_t25_1980/*
*/	dest_sub_1926 dest_sub_1931 dest_sub_1950 dest_sub_1961 dest_sub_1970 dest_sub_1980 using "Top Scientists.xls", append dec(3)
*sleep 1000

/* Top 10th percentile */
areg pubn_avg5alt_tot num_dis3340_citn_t10_1926 num_dis3340_citn_t10_1940 num_dis3340_citn_t10_1950 num_dis3340_citn_t10_1961 num_dis3340_citn_t10_1970 num_dis3340_citn_t10_1980 /*
*/	dest_sub_1926 dest_sub_1931 dest_sub_1950 dest_sub_1961 dest_sub_1970 dest_sub_1980 /*
*/  dest_cit_1926 dest_cit_1931 dest_cit_1950 dest_cit_1961 dest_cit_1970 dest_cit_1980 /*
*/	subject_chem_yeard???? subject_phys_yeard???? yeard???? zone_us zone_uk zone_fra zone_ussr /*
*/	bula4*_post45  fractjew_post33 closeuni_50 dist_border_post45 uniage uniage2 sh33_firms_ind5_* sh33_firms_ind8_* sh33_firms_ind11_*  if (sample_ger1990==1 | sample_aus==1), a(department) cl(uni)
outreg2 num_dis3340_citn_t10_1926 num_dis3340_citn_t10_1940 num_dis3340_citn_t10_1950 num_dis3340_citn_t10_1961 num_dis3340_citn_t10_1970 num_dis3340_citn_t10_1980/*
*/	dest_sub_1926 dest_sub_1931 dest_sub_1950 dest_sub_1961 dest_sub_1970 dest_sub_1980 using "Top Scientists.xls", append dec(3)
*sleep 1000

areg citn_avg5alt_tot num_dis3340_citn_t10_1926 num_dis3340_citn_t10_1940 num_dis3340_citn_t10_1950 num_dis3340_citn_t10_1961 num_dis3340_citn_t10_1970 num_dis3340_citn_t10_1980 /*
*/	dest_sub_1926 dest_sub_1931 dest_sub_1950 dest_sub_1961 dest_sub_1970 dest_sub_1980 /*
*/  dest_cit_1926 dest_cit_1931 dest_cit_1950 dest_cit_1961 dest_cit_1970 dest_cit_1980 /*
*/	subject_chem_yeard???? subject_phys_yeard???? yeard???? zone_us zone_uk zone_fra zone_ussr /*
*/	bula4*_post45  fractjew_post33 closeuni_50 dist_border_post45 uniage uniage2 sh33_firms_ind5_* sh33_firms_ind8_* sh33_firms_ind11_*  if (sample_ger1990==1 | sample_aus==1), a(department) cl(uni)
outreg2 num_dis3340_citn_t10_1926 num_dis3340_citn_t10_1940 num_dis3340_citn_t10_1950 num_dis3340_citn_t10_1961 num_dis3340_citn_t10_1970 num_dis3340_citn_t10_1980/*
*/	dest_sub_1926 dest_sub_1931 dest_sub_1950 dest_sub_1961 dest_sub_1970 dest_sub_1980 using "Top Scientists.xls", append dec(3)
*sleep 1000


/* Top 5th percentile */
areg pubn_avg5alt_tot num_dis3340_citn_t5_1926 num_dis3340_citn_t5_1940 num_dis3340_citn_t5_1950 num_dis3340_citn_t5_1961 num_dis3340_citn_t5_1970 num_dis3340_citn_t5_1980 /*
*/	dest_sub_1926 dest_sub_1931 dest_sub_1950 dest_sub_1961 dest_sub_1970 dest_sub_1980 /*
*/  dest_cit_1926 dest_cit_1931 dest_cit_1950 dest_cit_1961 dest_cit_1970 dest_cit_1980 /*
*/	subject_chem_yeard???? subject_phys_yeard???? yeard???? zone_us zone_uk zone_fra zone_ussr /*
*/	bula4*_post45  fractjew_post33 closeuni_50 dist_border_post45 uniage uniage2 sh33_firms_ind5_* sh33_firms_ind8_* sh33_firms_ind11_* if (sample_ger1990==1 | sample_aus==1), a(department) cl(uni)
outreg2 num_dis3340_citn_t5_1926 num_dis3340_citn_t5_1940 num_dis3340_citn_t5_1950 num_dis3340_citn_t5_1961 num_dis3340_citn_t5_1970 num_dis3340_citn_t5_1980/*
*/	dest_sub_1926 dest_sub_1931 dest_sub_1950 dest_sub_1961 dest_sub_1970 dest_sub_1980 using "Top Scientists.xls", append dec(3)
*sleep 1000


areg citn_avg5alt_tot num_dis3340_citn_t5_1926 num_dis3340_citn_t5_1940 num_dis3340_citn_t5_1950 num_dis3340_citn_t5_1961 num_dis3340_citn_t5_1970 num_dis3340_citn_t5_1980 /*
*/	dest_sub_1926 dest_sub_1931 dest_sub_1950 dest_sub_1961 dest_sub_1970 dest_sub_1980 /*
*/  dest_cit_1926 dest_cit_1931 dest_cit_1950 dest_cit_1961 dest_cit_1970 dest_cit_1980 /*
*/	subject_chem_yeard???? subject_phys_yeard???? yeard???? zone_us zone_uk zone_fra zone_ussr /*
*/	bula4*_post45  fractjew_post33 closeuni_50 dist_border_post45 uniage uniage2 sh33_firms_ind5_* sh33_firms_ind8_* sh33_firms_ind11_* if (sample_ger1990==1 | sample_aus==1), a(department) cl(uni)
outreg2 num_dis3340_citn_t5_1926 num_dis3340_citn_t5_1940 num_dis3340_citn_t5_1950 num_dis3340_citn_t5_1961 num_dis3340_citn_t5_1970 num_dis3340_citn_t5_1980/*
*/	dest_sub_1926 dest_sub_1931 dest_sub_1950 dest_sub_1961 dest_sub_1970 dest_sub_1980 using "Top Scientists.xls", append dec(3)
*sleep 1000





	
/***************************/	
/***************************/
/* Hiring Results: Table 8 */
/***************************/
/***************************/
cd "$folder\Data Temporary STATA Files\Replication Files\"
use "Data Hiring.dta", clear
cd "$folder\Outreg Files\Version Final\"
	
/* Quality measured by lifetime citation-weighted publications */ 
areg newhire_qual_career_avg_norm num_dis3340_1940 num_dis3340_1950 num_dis3340_1961 num_dis3340_1970 num_dis3340_1980 /*
	*/  dest_sub_1931 dest_sub_1950 dest_sub_1961 dest_sub_1970 dest_sub_1980 /*
	*/  dest_cit_1931 dest_cit_1950 dest_cit_1961 dest_cit_1970 dest_cit_1980 /*
	*/	subject_chem_yeard???? subject_phys_yeard???? yeard???? zone_uk zone_fra zone_ussr /*
	*/	bula4*_post45  fractjew_post33 closeuni_50 dist_border_post45 uniage uniage2 sh33_firms_ind5_* sh33_firms_ind8_* sh33_firms_ind11_* if (sample_ger1990==1 | sample_aus==1), a(department) cl(uni)
outreg2 num_dis3340_1940 num_dis3340_1950 num_dis3340_1961 num_dis3340_1970 num_dis3340_1980 /* 
*/	 dest_sub_1931 dest_sub_1950 dest_sub_1961 dest_sub_1970 dest_sub_1980 using "Hire_Quality_career_norm.xls", replace dec(3)

areg newhire_qual_career_avg_norm num_dis3340_citn_t50_1940 num_dis3340_citn_t50_1950 num_dis3340_citn_t50_1961 num_dis3340_citn_t50_1970 num_dis3340_citn_t50_1980 /*
	*/ 	dest_sub_1931 dest_sub_1950 dest_sub_1961 dest_sub_1970 dest_sub_1980 /*
	*/  dest_cit_1931 dest_cit_1950 dest_cit_1961 dest_cit_1970 dest_cit_1980 /*
	*/	subject_chem_yeard???? subject_phys_yeard???? yeard???? zone_uk zone_fra zone_ussr /*
	*/	bula4*_post45  fractjew_post33 closeuni_50 dist_border_post45 uniage uniage2 sh33_firms_ind5_* sh33_firms_ind8_* sh33_firms_ind11_* if (sample_ger1990==1 | sample_aus==1), a(department) cl(uni)
outreg2 num_dis3340_citn_t50_1940 num_dis3340_citn_t50_1950 num_dis3340_citn_t50_1961 num_dis3340_citn_t50_1970 num_dis3340_citn_t50_1980 using "Hire_Quality_career_norm.xls", append dec(3)

areg newhire_qual_career_avg_norm num_dis3340_citn_t25_1940 num_dis3340_citn_t25_1950 num_dis3340_citn_t25_1961 num_dis3340_citn_t25_1970 num_dis3340_citn_t25_1980 /*
	*/	dest_sub_1931 dest_sub_1950 dest_sub_1961 dest_sub_1970 dest_sub_1980 /*
	*/  dest_cit_1931 dest_cit_1950 dest_cit_1961 dest_cit_1970 dest_cit_1980 /*
	*/	subject_chem_yeard???? subject_phys_yeard???? yeard???? zone_uk zone_fra zone_ussr /*
	*/  bula4*_post45  fractjew_post33 closeuni_50 dist_border_post45 uniage uniage2 sh33_firms_ind5_* sh33_firms_ind8_* sh33_firms_ind11_*  if (sample_ger1990==1 | sample_aus==1), a(department) cl(uni)
outreg2 num_dis3340_citn_t25_1940 num_dis3340_citn_t25_1950 num_dis3340_citn_t25_1961 num_dis3340_citn_t25_1970 num_dis3340_citn_t25_1980 using "Hire_Quality_career_norm.xls", append dec(3)

areg newhire_qual_career_avg_norm num_dis3340_citn_t10_1940 num_dis3340_citn_t10_1950 num_dis3340_citn_t10_1961 num_dis3340_citn_t10_1970 num_dis3340_citn_t10_1980 /*
	*/	dest_sub_1931 dest_sub_1950 dest_sub_1961 dest_sub_1970 dest_sub_1980 /*
	*/  dest_cit_1931 dest_cit_1950 dest_cit_1961 dest_cit_1970 dest_cit_1980 /*
	*/	subject_chem_yeard???? subject_phys_yeard???? yeard???? zone_uk zone_fra zone_ussr /*
	*/	bula4*_post45  fractjew_post33 closeuni_50 dist_border_post45 uniage uniage2 sh33_firms_ind5_* sh33_firms_ind8_* sh33_firms_ind11_*  if (sample_ger1990==1 | sample_aus==1), a(department) cl(uni)
outreg2 num_dis3340_citn_t10_1940 num_dis3340_citn_t10_1950 num_dis3340_citn_t10_1961 num_dis3340_citn_t10_1970 num_dis3340_citn_t10_1980 using "Hire_Quality_career_norm.xls", append dec(3)

areg newhire_qual_career_avg_norm num_dis3340_citn_t5_1940 num_dis3340_citn_t5_1950 num_dis3340_citn_t5_1961 num_dis3340_citn_t5_1970 num_dis3340_citn_t5_1980 /*
	*/	dest_sub_1931 dest_sub_1950 dest_sub_1961 dest_sub_1970 dest_sub_1980 /*
	*/  dest_cit_1931 dest_cit_1950 dest_cit_1961 dest_cit_1970 dest_cit_1980 /*
	*/	subject_chem_yeard???? subject_phys_yeard???? yeard???? zone_uk zone_fra zone_ussr /*
	*/	bula4*_post45  fractjew_post33 closeuni_50 dist_border_post45 uniage uniage2 sh33_firms_ind5_* sh33_firms_ind8_* sh33_firms_ind11_*  if (sample_ger1990==1 | sample_aus==1), a(department) cl(uni)
outreg2 num_dis3340_citn_t5_1940 num_dis3340_citn_t5_1950 num_dis3340_citn_t5_1961 num_dis3340_citn_t5_1970 num_dis3340_citn_t5_1980 using "Hire_Quality_career_norm.xls", append dec(3)

	
/* Quality measured by pre-hiring citation-weighted publications */
areg newhire_qual_avgmiddle5 num_dis3340_1940 num_dis3340_1950 num_dis3340_1961 num_dis3340_1970 num_dis3340_1980 /*
	*/	dest_sub_1931 dest_sub_1950 dest_sub_1961 dest_sub_1970 dest_sub_1980 /*
	*/  dest_cit_1931 dest_cit_1950 dest_cit_1961 dest_cit_1970 dest_cit_1980 /*
	*/	subject_chem_yeard???? subject_phys_yeard???? yeard???? zone_uk zone_fra zone_ussr /*
	*/	bula4*_post45  fractjew_post33 closeuni_50 dist_border_post45 uniage uniage2 sh33_firms_ind5_* sh33_firms_ind8_* sh33_firms_ind11_* if (sample_ger1990==1 | sample_aus==1), a(department) cl(uni)
outreg2 num_dis3340_1940 num_dis3340_1950 num_dis3340_1961 num_dis3340_1970 num_dis3340_1980 using "Hire_Quality_career_norm.xls", append dec(3)

areg newhire_qual_avgmiddle5 num_dis3340_citn_t50_1940 num_dis3340_citn_t50_1950 num_dis3340_citn_t50_1961 num_dis3340_citn_t50_1970 num_dis3340_citn_t50_1980 /*
	*/	dest_sub_1931 dest_sub_1950 dest_sub_1961 dest_sub_1970 dest_sub_1980 /*
	*/  dest_cit_1931 dest_cit_1950 dest_cit_1961 dest_cit_1970 dest_cit_1980 /*
	*/	subject_chem_yeard???? subject_phys_yeard???? yeard???? zone_uk zone_fra zone_ussr /*
	*/	bula4*_post45  fractjew_post33 closeuni_50 dist_border_post45 uniage uniage2 sh33_firms_ind5_* sh33_firms_ind8_* sh33_firms_ind11_* if (sample_ger1990==1 | sample_aus==1), a(department) cl(uni)
outreg2 num_dis3340_citn_t50_1940 num_dis3340_citn_t50_1950 num_dis3340_citn_t50_1961 num_dis3340_citn_t50_1970 num_dis3340_citn_t50_1980 using "Hire_Quality_career_norm.xls", append dec(3)

areg newhire_qual_avgmiddle5 num_dis3340_citn_t25_1940 num_dis3340_citn_t25_1950 num_dis3340_citn_t25_1961 num_dis3340_citn_t25_1970 num_dis3340_citn_t25_1980 /*
	*/	dest_sub_1931 dest_sub_1950 dest_sub_1961 dest_sub_1970 dest_sub_1980 /*
	*/  dest_cit_1931 dest_cit_1950 dest_cit_1961 dest_cit_1970 dest_cit_1980 /*
	*/	subject_chem_yeard???? subject_phys_yeard???? yeard???? zone_uk zone_fra zone_ussr /*
	*/  bula4*_post45  fractjew_post33 closeuni_50 dist_border_post45 uniage uniage2 sh33_firms_ind5_* sh33_firms_ind8_* sh33_firms_ind11_*  if (sample_ger1990==1 | sample_aus==1), a(department) cl(uni)
outreg2 num_dis3340_citn_t25_1940 num_dis3340_citn_t25_1950 num_dis3340_citn_t25_1961 num_dis3340_citn_t25_1970 num_dis3340_citn_t25_1980 using "Hire_Quality_career_norm.xls", append dec(3)

areg newhire_qual_avgmiddle5 num_dis3340_citn_t10_1940 num_dis3340_citn_t10_1950 num_dis3340_citn_t10_1961 num_dis3340_citn_t10_1970 num_dis3340_citn_t10_1980 /*
	*/	dest_sub_1931 dest_sub_1950 dest_sub_1961 dest_sub_1970 dest_sub_1980 /*
	*/  dest_cit_1931 dest_cit_1950 dest_cit_1961 dest_cit_1970 dest_cit_1980 /*
	*/	subject_chem_yeard???? subject_phys_yeard???? yeard???? zone_uk zone_fra zone_ussr /*
	*/	bula4*_post45  fractjew_post33 closeuni_50 dist_border_post45 uniage uniage2 sh33_firms_ind5_* sh33_firms_ind8_* sh33_firms_ind11_*  if (sample_ger1990==1 | sample_aus==1), a(department) cl(uni)
outreg2 num_dis3340_citn_t10_1940 num_dis3340_citn_t10_1950 num_dis3340_citn_t10_1961 num_dis3340_citn_t10_1970 num_dis3340_citn_t10_1980 using "Hire_Quality_career_norm.xls", append dec(3)

areg newhire_qual_avgmiddle5 num_dis3340_citn_t5_1940 num_dis3340_citn_t5_1950 num_dis3340_citn_t5_1961 num_dis3340_citn_t5_1970 num_dis3340_citn_t5_1980 /*
	*/	dest_sub_1931 dest_sub_1950 dest_sub_1961 dest_sub_1970 dest_sub_1980 /*
	*/  dest_cit_1931 dest_cit_1950 dest_cit_1961 dest_cit_1970 dest_cit_1980 /*
	*/	subject_chem_yeard???? subject_phys_yeard???? yeard???? zone_uk zone_fra zone_ussr /*
	*/	bula4*_post45  fractjew_post33 closeuni_50 dist_border_post45 uniage uniage2 sh33_firms_ind5_* sh33_firms_ind8_* sh33_firms_ind11_*  if (sample_ger1990==1 | sample_aus==1), a(department) cl(uni)
outreg2 num_dis3340_citn_t5_1940 num_dis3340_citn_t5_1950 num_dis3340_citn_t5_1961 num_dis3340_citn_t5_1970 num_dis3340_citn_t5_1980 using "Hire_Quality_career_norm.xls", append dec(3)

	
	
	
	

	


/*******************************************************/
/*******************************************************/
/* First Stage Regressions for IV regression: Table A6 */
/*******************************************************/
/*******************************************************/
cd "$folder\Data Temporary STATA Files\Replication Files\"
use "Data Main Results.dta", clear
cd "$folder\Outreg Files\Version Final\"

ivreg pubn_avg5alt_tot num_dis3340_1926 num_dis3340_1940 num_dis3340_1950 num_dis3340_1961 num_dis3340_1970 num_dis3340_1980 /*
*/	(dest_sub_1926 dest_sub_1931 dest_sub_1950 dest_sub_1961 dest_sub_1970 dest_sub_1980 = /*
*/	dest_uni_1926 dest_uni_1931 dest_uni_1950 dest_uni_1961 dest_uni_1970 dest_uni_1980) /*
*/  dest_cit_1926 dest_cit_1931 dest_cit_1950 dest_cit_1961 dest_cit_1970 dest_cit_1980 /*
*/	subject_chem_yeard???? subject_phys_yeard???? yeard???? zone_us zone_uk zone_fra zone_ussr /*
*/	bula4*_post45  fractjew_post33 closeuni_50 dist_border_post45 uniage uniage2 depd* sh33_firms_ind5_* sh33_firms_ind8_* sh33_firms_ind11_*  if (sample_ger1990==1 | sample_aus==1),cl(uni)



areg dest_sub_1926 /*
*/	dest_uni_1926 dest_uni_1931 dest_uni_1950 dest_uni_1961 dest_uni_1970 dest_uni_1980 /*
*/  dest_cit_1926 dest_cit_1931 dest_cit_1950 dest_cit_1961 dest_cit_1970 dest_cit_1980 /*
*/ num_dis3340_1926 num_dis3340_1940 num_dis3340_1950 num_dis3340_1961 num_dis3340_1970 num_dis3340_1980 /*
*/	subject_chem_yeard???? subject_phys_yeard???? yeard???? zone_us zone_uk zone_fra zone_ussr /*
*/	bula4*_post45  fractjew_post33 closeuni_50 dist_border_post45 uniage uniage2 sh33_firms_ind5_* sh33_firms_ind8_* sh33_firms_ind11_*  if (sample_ger1990==1 | sample_aus==1),cl(uni) a(department)
outreg2 dest_uni_1926 dest_uni_1931 dest_uni_1950 dest_uni_1961 dest_uni_1970 dest_uni_1980 using "First Stages.xls", replace dec(3)
testparm dest_uni_1926 dest_uni_1931 dest_uni_1950 dest_uni_1961 dest_uni_1970 dest_uni_1980 


areg dest_sub_1931 /*
*/	dest_uni_1926 dest_uni_1931 dest_uni_1950 dest_uni_1961 dest_uni_1970 dest_uni_1980 /*
*/  dest_cit_1926 dest_cit_1931 dest_cit_1950 dest_cit_1961 dest_cit_1970 dest_cit_1980 /*
*/ num_dis3340_1926 num_dis3340_1940 num_dis3340_1950 num_dis3340_1961 num_dis3340_1970 num_dis3340_1980 /*
*/	subject_chem_yeard???? subject_phys_yeard???? yeard???? zone_us zone_uk zone_fra zone_ussr /*
*/	bula4*_post45  fractjew_post33 closeuni_50 dist_border_post45 uniage uniage2 sh33_firms_ind5_* sh33_firms_ind8_* sh33_firms_ind11_*  if (sample_ger1990==1 | sample_aus==1),cl(uni) a(department)
outreg2 dest_uni_1926 dest_uni_1931 dest_uni_1950 dest_uni_1961 dest_uni_1970 dest_uni_1980 using "First Stages.xls", append dec(3)
testparm dest_uni_1926 dest_uni_1931 dest_uni_1950 dest_uni_1961 dest_uni_1970 dest_uni_1980 



areg dest_sub_1950 /*
*/	dest_uni_1926 dest_uni_1931 dest_uni_1950 dest_uni_1961 dest_uni_1970 dest_uni_1980 /*
*/  dest_cit_1926 dest_cit_1931 dest_cit_1950 dest_cit_1961 dest_cit_1970 dest_cit_1980 /*
*/ num_dis3340_1926 num_dis3340_1940 num_dis3340_1950 num_dis3340_1961 num_dis3340_1970 num_dis3340_1980 /*
*/	subject_chem_yeard???? subject_phys_yeard???? yeard???? zone_us zone_uk zone_fra zone_ussr /*
*/	bula4*_post45  fractjew_post33 closeuni_50 dist_border_post45 uniage uniage2 sh33_firms_ind5_* sh33_firms_ind8_* sh33_firms_ind11_* if (sample_ger1990==1 | sample_aus==1),cl(uni) a(department)
outreg2 dest_uni_1926 dest_uni_1931 dest_uni_1950 dest_uni_1961 dest_uni_1970 dest_uni_1980 using "First Stages.xls", append dec(3)

areg dest_sub_1961 /*
*/	dest_uni_1926 dest_uni_1931 dest_uni_1950 dest_uni_1961 dest_uni_1970 dest_uni_1980 /*
*/  dest_cit_1926 dest_cit_1931 dest_cit_1950 dest_cit_1961 dest_cit_1970 dest_cit_1980 /*
*/ num_dis3340_1926 num_dis3340_1940 num_dis3340_1950 num_dis3340_1961 num_dis3340_1970 num_dis3340_1980 /*
*/	subject_chem_yeard???? subject_phys_yeard???? yeard???? zone_us zone_uk zone_fra zone_ussr /*
*/	bula4*_post45  fractjew_post33 closeuni_50 dist_border_post45 uniage uniage2 sh33_firms_ind5_* sh33_firms_ind8_* sh33_firms_ind11_* if (sample_ger1990==1 | sample_aus==1),cl(uni) a(department)
outreg2 dest_uni_1926 dest_uni_1931 dest_uni_1950 dest_uni_1961 dest_uni_1970 dest_uni_1980 using "First Stages.xls", append dec(3)

areg dest_sub_1970 /*
*/	dest_uni_1926 dest_uni_1931 dest_uni_1950 dest_uni_1961 dest_uni_1970 dest_uni_1980 /*
*/  dest_cit_1926 dest_cit_1931 dest_cit_1950 dest_cit_1961 dest_cit_1970 dest_cit_1980 /*
*/ num_dis3340_1926 num_dis3340_1940 num_dis3340_1950 num_dis3340_1961 num_dis3340_1970 num_dis3340_1980 /*
*/	subject_chem_yeard???? subject_phys_yeard???? yeard???? zone_us zone_uk zone_fra zone_ussr /*
*/	bula4*_post45  fractjew_post33 closeuni_50 dist_border_post45 uniage uniage2 sh33_firms_ind5_* sh33_firms_ind8_* sh33_firms_ind11_* if (sample_ger1990==1 | sample_aus==1),cl(uni) a(department)
outreg2 dest_uni_1926 dest_uni_1931 dest_uni_1950 dest_uni_1961 dest_uni_1970 dest_uni_1980 using "First Stages.xls", append dec(3)

areg dest_sub_1980 /*
*/	dest_uni_1926 dest_uni_1931 dest_uni_1950 dest_uni_1961 dest_uni_1970 dest_uni_1980 /*
*/  dest_cit_1926 dest_cit_1931 dest_cit_1950 dest_cit_1961 dest_cit_1970 dest_cit_1980 /*
*/ num_dis3340_1926 num_dis3340_1940 num_dis3340_1950 num_dis3340_1961 num_dis3340_1970 num_dis3340_1980 /*
*/	subject_chem_yeard???? subject_phys_yeard???? yeard???? zone_us zone_uk zone_fra zone_ussr /*
*/	bula4*_post45  fractjew_post33 closeuni_50 dist_border_post45 uniage uniage2 sh33_firms_ind5_* sh33_firms_ind8_* sh33_firms_ind11_* if (sample_ger1990==1 | sample_aus==1),cl(uni) a(department)
outreg2 dest_uni_1926 dest_uni_1931 dest_uni_1950 dest_uni_1961 dest_uni_1970 dest_uni_1980 using "First Stages.xls", append dec(3)





/********************************************************/
/********************************************************/
/* Interactions of Human and Physical Capital: Table A7 */
/********************************************************/
/********************************************************/
cd "$folder\Data Temporary STATA Files\Replication Files\"
use "Data Main Results.dta", clear
cd "$folder\Outreg Files\Version Final\"

areg pubn_avg5alt_tot num_dis3340_1926 num_dis3340_1940 num_dis3340_1950 num_dis3340_1961 num_dis3340_1970 num_dis3340_1980 /*
*/	dest_sub_1926 dest_sub_1931 dest_sub_1950 dest_sub_1961 dest_sub_1970 dest_sub_1980 /*
*/  dest_cit_1926 dest_cit_1931 dest_cit_1950 dest_cit_1961 dest_cit_1970 dest_cit_1980 /*
*/	subject_chem_yeard???? subject_phys_yeard???? yeard???? zone_us zone_uk zone_fra zone_ussr /*
*/	bula4*_post45  fractjew_post33 closeuni_50 dist_border_post45 uniage uniage2 sh33_firms_ind5_* sh33_firms_ind8_* sh33_firms_ind11_* if (sample_ger1990==1 | sample_aus==1), a(department) cl(uni)
outreg2 num_dis3340_1926 num_dis3340_1940 num_dis3340_1950 num_dis3340_1961 num_dis3340_1970 num_dis3340_1980 /*
*/	dest_sub_1926 dest_sub_1931 dest_sub_1950 dest_sub_1961 dest_sub_1970 dest_sub_1980 using "Interactions.xls", replace dec(3)

areg pubn_avg5alt_tot num_dis3340_1926 num_dis3340_1940 num_dis3340_1950 num_dis3340_1961 num_dis3340_1970 num_dis3340_1980 /*
*/	dest_sub_1926 dest_sub_1931 dest_sub_1950 dest_sub_1961 dest_sub_1970 dest_sub_1980 /*
*/	dis_dest_1950 dis_dest_1961 dis_dest_1970 dis_dest_1980 /* 
*/  dest_cit_1926 dest_cit_1931 dest_cit_1950 dest_cit_1961 dest_cit_1970 dest_cit_1980 /*
*/	subject_chem_yeard???? subject_phys_yeard???? yeard???? zone_us zone_uk zone_fra zone_ussr /*
*/	bula4*_post45  fractjew_post33 closeuni_50 dist_border_post45 uniage uniage2 sh33_firms_ind5_* sh33_firms_ind8_* sh33_firms_ind11_*  if (sample_ger1990==1 | sample_aus==1), a(department) cl(uni)
outreg2 num_dis3340_1926 num_dis3340_1940 num_dis3340_1950 num_dis3340_1961 num_dis3340_1970 num_dis3340_1980 /*
*/	dest_sub_1926 dest_sub_1931 dest_sub_1950 dest_sub_1961 dest_sub_1970 dest_sub_1980 /*
*/	dis_dest_1950 dis_dest_1961 dis_dest_1970 dis_dest_1980 using "Interactions.xls", append dec(3)


areg citn_avg5alt_tot num_dis3340_1926 num_dis3340_1940 num_dis3340_1950 num_dis3340_1961 num_dis3340_1970 num_dis3340_1980 /*
*/	dest_sub_1926 dest_sub_1931 dest_sub_1950 dest_sub_1961 dest_sub_1970 dest_sub_1980 /*
*/  dest_cit_1926 dest_cit_1931 dest_cit_1950 dest_cit_1961 dest_cit_1970 dest_cit_1980 /*
*/	subject_chem_yeard???? subject_phys_yeard???? yeard???? zone_us zone_uk zone_fra zone_ussr /*
*/	bula4*_post45  fractjew_post33 closeuni_50 dist_border_post45 uniage uniage2 sh33_firms_ind5_* sh33_firms_ind8_* sh33_firms_ind11_*  if (sample_ger1990==1 | sample_aus==1), a(department) cl(uni)
outreg2 num_dis3340_1926 num_dis3340_1940 num_dis3340_1950 num_dis3340_1961 num_dis3340_1970 num_dis3340_1980 /*
*/	dest_sub_1926 dest_sub_1931 dest_sub_1950 dest_sub_1961 dest_sub_1970 dest_sub_1980 using "Interactions.xls", append dec(3)

areg citn_avg5alt_tot num_dis3340_1926 num_dis3340_1940 num_dis3340_1950 num_dis3340_1961 num_dis3340_1970 num_dis3340_1980 /*
*/	dest_sub_1926 dest_sub_1931 dest_sub_1950 dest_sub_1961 dest_sub_1970 dest_sub_1980 /*
*/	dis_dest_1950 dis_dest_1961 dis_dest_1970 dis_dest_1980 /*
*/  dest_cit_1926 dest_cit_1931 dest_cit_1950 dest_cit_1961 dest_cit_1970 dest_cit_1980 /*
*/	subject_chem_yeard???? subject_phys_yeard???? yeard???? zone_us zone_uk zone_fra zone_ussr /*
*/	bula4*_post45  fractjew_post33 closeuni_50 dist_border_post45 uniage uniage2 sh33_firms_ind5_* sh33_firms_ind8_* sh33_firms_ind11_* if (sample_ger1990==1 | sample_aus==1), a(department) cl(uni)
outreg2 num_dis3340_1926 num_dis3340_1940 num_dis3340_1950 num_dis3340_1961 num_dis3340_1970 num_dis3340_1980 /*
*/	dest_sub_1926 dest_sub_1931 dest_sub_1950 dest_sub_1961 dest_sub_1970 dest_sub_1980 /*
*/	dis_dest_1950 dis_dest_1961 dis_dest_1970 dis_dest_1980 using "Interactions.xls", append dec(3)





/*********************************/
/*********************************/
/* Individual Subjects: Table A8 */
/*********************************/
/*********************************/
cd "$folder\Data Temporary STATA Files\Replication Files\"
use "Data Main Results.dta", clear
cd "$folder\Outreg Files\Version Final\"

areg pubn_avg5alt_tot num_dis3340_1926 num_dis3340_1940 num_dis3340_1950 num_dis3340_1961 num_dis3340_1970 num_dis3340_1980 /*
*/	dest_sub_1926 dest_sub_1931 dest_sub_1950 dest_sub_1961 dest_sub_1970 dest_sub_1980 /*
*/  dest_cit_1926 dest_cit_1931 dest_cit_1950 dest_cit_1961 dest_cit_1970 dest_cit_1980 /*
*/	subject_chem_yeard???? subject_phys_yeard???? yeard???? zone_us zone_uk zone_fra zone_ussr /*
*/	bula4*_post45  fractjew_post33 closeuni_50 dist_border_post45 uniage uniage2 sh33_firms_ind5_* sh33_firms_ind8_* sh33_firms_ind11_* if (sample_ger1990==1 | sample_aus==1) & subject=="Physics", a(department) cl(uni)
outreg2 num_dis3340_1926 num_dis3340_1940 num_dis3340_1950 num_dis3340_1961 num_dis3340_1970 num_dis3340_1980 /*
*/	dest_sub_1926 dest_sub_1931 dest_sub_1950 dest_sub_1961 dest_sub_1970 dest_sub_1980 using "Robustness_Subject.xls", replace dec(3)


areg citn_avg5alt_tot num_dis3340_1926 num_dis3340_1940 num_dis3340_1950 num_dis3340_1961 num_dis3340_1970 num_dis3340_1980 /*
*/	dest_sub_1926 dest_sub_1931 dest_sub_1950 dest_sub_1961 dest_sub_1970 dest_sub_1980 /*
*/  dest_cit_1926 dest_cit_1931 dest_cit_1950 dest_cit_1961 dest_cit_1970 dest_cit_1980 /*
*/	subject_chem_yeard???? subject_phys_yeard???? yeard???? zone_us zone_uk zone_fra zone_ussr /*
*/	bula4*_post45  fractjew_post33 closeuni_50 dist_border_post45 uniage uniage2 sh33_firms_ind5_* sh33_firms_ind8_* sh33_firms_ind11_* if (sample_ger1990==1 | sample_aus==1) & subject=="Physics", a(department) cl(uni)
outreg2 num_dis3340_1926 num_dis3340_1940 num_dis3340_1950 num_dis3340_1961 num_dis3340_1970 num_dis3340_1980 /*
*/	dest_sub_1926 dest_sub_1931 dest_sub_1950 dest_sub_1961 dest_sub_1970 dest_sub_1980 using "Robustness_Subject.xls", append dec(3)


areg pubn_avg5alt_tot num_dis3340_1926 num_dis3340_1940 num_dis3340_1950 num_dis3340_1961 num_dis3340_1970 num_dis3340_1980 /*
*/	dest_sub_1926 dest_sub_1931 dest_sub_1950 dest_sub_1961 dest_sub_1970 dest_sub_1980 /*
*/  dest_cit_1926 dest_cit_1931 dest_cit_1950 dest_cit_1961 dest_cit_1970 dest_cit_1980 /*
*/	subject_chem_yeard???? subject_phys_yeard???? yeard???? zone_us zone_uk zone_fra zone_ussr /*
*/	bula4*_post45  fractjew_post33 closeuni_50 dist_border_post45 uniage uniage2 sh33_firms_ind5_* sh33_firms_ind8_* sh33_firms_ind11_* if (sample_ger1990==1 | sample_aus==1) & subject=="Chemistry", a(department) cl(uni)
outreg2 num_dis3340_1926 num_dis3340_1940 num_dis3340_1950 num_dis3340_1961 num_dis3340_1970 num_dis3340_1980 /*
*/	dest_sub_1926 dest_sub_1931 dest_sub_1950 dest_sub_1961 dest_sub_1970 dest_sub_1980 using "Robustness_Subject.xls", append dec(3)


areg citn_avg5alt_tot num_dis3340_1926 num_dis3340_1940 num_dis3340_1950 num_dis3340_1961 num_dis3340_1970 num_dis3340_1980 /*
*/	dest_sub_1926 dest_sub_1931 dest_sub_1950 dest_sub_1961 dest_sub_1970 dest_sub_1980 /*
*/  dest_cit_1926 dest_cit_1931 dest_cit_1950 dest_cit_1961 dest_cit_1970 dest_cit_1980 /*
*/	subject_chem_yeard???? subject_phys_yeard???? yeard???? zone_us zone_uk zone_fra zone_ussr /*
*/	bula4*_post45  fractjew_post33 closeuni_50 dist_border_post45 uniage uniage2 sh33_firms_ind5_* sh33_firms_ind8_* sh33_firms_ind11_* if (sample_ger1990==1 | sample_aus==1) & subject=="Chemistry", a(department) cl(uni)
outreg2 num_dis3340_1926 num_dis3340_1940 num_dis3340_1950 num_dis3340_1961 num_dis3340_1970 num_dis3340_1980 /*
*/	dest_sub_1926 dest_sub_1931 dest_sub_1950 dest_sub_1961 dest_sub_1970 dest_sub_1980 using "Robustness_Subject.xls", append dec(3)



areg pubn_avg5alt_tot num_dis3340_1926 num_dis3340_1940 num_dis3340_1950 num_dis3340_1961 num_dis3340_1970 num_dis3340_1980 /*
*/	dest_sub_1926 dest_sub_1931 dest_sub_1950 dest_sub_1961 dest_sub_1970 dest_sub_1980 /*
*/  dest_cit_1926 dest_cit_1931 dest_cit_1950 dest_cit_1961 dest_cit_1970 dest_cit_1980 /*
*/	subject_chem_yeard???? subject_phys_yeard???? yeard???? zone_us zone_uk zone_fra zone_ussr /*
*/	bula4*_post45  fractjew_post33 closeuni_50 dist_border_post45 uniage uniage2 sh33_firms_ind5_* sh33_firms_ind8_* sh33_firms_ind11_* if (sample_ger1990==1 | sample_aus==1) & subject=="Mathematics", a(department) cl(uni)
outreg2 num_dis3340_1926 num_dis3340_1940 num_dis3340_1950 num_dis3340_1961 num_dis3340_1970 num_dis3340_1980 /*
*/	dest_sub_1926 dest_sub_1931 dest_sub_1950 dest_sub_1961 dest_sub_1970 dest_sub_1980 using "Robustness_Subject.xls", append dec(3)


areg citn_avg5alt_tot num_dis3340_1926 num_dis3340_1940 num_dis3340_1950 num_dis3340_1961 num_dis3340_1970 num_dis3340_1980 /*
*/	dest_sub_1926 dest_sub_1931 dest_sub_1950 dest_sub_1961 dest_sub_1970 dest_sub_1980 /*
*/  dest_cit_1926 dest_cit_1931 dest_cit_1950 dest_cit_1961 dest_cit_1970 dest_cit_1980 /*
*/	subject_chem_yeard???? subject_phys_yeard???? yeard???? zone_us zone_uk zone_fra zone_ussr /*
*/	bula4*_post45  fractjew_post33 closeuni_50 dist_border_post45 uniage uniage2 sh33_firms_ind5_* sh33_firms_ind8_* sh33_firms_ind11_* if (sample_ger1990==1 | sample_aus==1) & subject=="Mathematics", a(department) cl(uni)
outreg2 num_dis3340_1926 num_dis3340_1940 num_dis3340_1950 num_dis3340_1961 num_dis3340_1970 num_dis3340_1980 /*
*/	dest_sub_1926 dest_sub_1931 dest_sub_1950 dest_sub_1961 dest_sub_1970 dest_sub_1980 using "Robustness_Subject.xls", append dec(3)





/****************************************************/
/****************************************************/
/* Dismissals in Different Quality Groups: Table A9 */
/****************************************************/
/****************************************************/
cd "$folder\Data Temporary STATA Files\Replication Files\"
use "Data Main Results.dta", clear
cd "$folder\Outreg Files\Version Final\"

areg pubn_avg5alt_tot num_dis3340_citn_b50_1926 num_dis3340_citn_b50_1940 num_dis3340_citn_b50_1950 num_dis3340_citn_b50_1961 num_dis3340_citn_b50_1970 num_dis3340_citn_b50_1980 /*
*/	num_dis3340_citn_t5010_1926 num_dis3340_citn_t5010_1940 num_dis3340_citn_t5010_1950 num_dis3340_citn_t5010_1961 num_dis3340_citn_t5010_1970 num_dis3340_citn_t5010_1980 /*
*/	num_dis3340_citn_t10_1926 num_dis3340_citn_t10_1940 num_dis3340_citn_t10_1950 num_dis3340_citn_t10_1961 num_dis3340_citn_t10_1970 num_dis3340_citn_t10_1980 /*
*/	dest_sub_1926 dest_sub_1931 dest_sub_1950 dest_sub_1961 dest_sub_1970 dest_sub_1980 /*
*/  dest_cit_1926 dest_cit_1931 dest_cit_1950 dest_cit_1961 dest_cit_1970 dest_cit_1980 /*
*/	subject_chem_yeard???? subject_phys_yeard???? yeard???? zone_us zone_uk zone_fra zone_ussr /*
*/	bula4*_post45  fractjew_post33 closeuni_50 dist_border_post45 uniage uniage2 sh33_firms_ind5_* sh33_firms_ind8_* sh33_firms_ind11_* if (sample_ger1990==1 | sample_aus==1), a(department) cl(uni)
outreg2 num_dis3340_citn_b50_1926 num_dis3340_citn_b50_1940 num_dis3340_citn_b50_1950 num_dis3340_citn_b50_1961 num_dis3340_citn_b50_1970 num_dis3340_citn_b50_1980 /*
*/	num_dis3340_citn_t5010_1926 num_dis3340_citn_t5010_1940 num_dis3340_citn_t5010_1950 num_dis3340_citn_t5010_1961 num_dis3340_citn_t5010_1970 num_dis3340_citn_t5010_1980 /*
*/	num_dis3340_citn_t10_1926 num_dis3340_citn_t10_1940 num_dis3340_citn_t10_1950 num_dis3340_citn_t10_1961 num_dis3340_citn_t10_1970 num_dis3340_citn_t10_1980 /*
*/	dest_sub_1926 dest_sub_1931 dest_sub_1950 dest_sub_1961 dest_sub_1970 dest_sub_1980 using "Top Scientists_separate.xls", replace dec(3)


areg citn_avg5alt_tot num_dis3340_citn_b50_1926 num_dis3340_citn_b50_1940 num_dis3340_citn_b50_1950 num_dis3340_citn_b50_1961 num_dis3340_citn_b50_1970 num_dis3340_citn_b50_1980 /*
*/	num_dis3340_citn_t5010_1926 num_dis3340_citn_t5010_1940 num_dis3340_citn_t5010_1950 num_dis3340_citn_t5010_1961 num_dis3340_citn_t5010_1970 num_dis3340_citn_t5010_1980 /*
*/	num_dis3340_citn_t10_1926 num_dis3340_citn_t10_1940 num_dis3340_citn_t10_1950 num_dis3340_citn_t10_1961 num_dis3340_citn_t10_1970 num_dis3340_citn_t10_1980 /*
*/	dest_sub_1926 dest_sub_1931 dest_sub_1950 dest_sub_1961 dest_sub_1970 dest_sub_1980 /*
*/  dest_cit_1926 dest_cit_1931 dest_cit_1950 dest_cit_1961 dest_cit_1970 dest_cit_1980 /*
*/	subject_chem_yeard???? subject_phys_yeard???? yeard???? zone_us zone_uk zone_fra zone_ussr /*
*/	bula4*_post45  fractjew_post33 closeuni_50 dist_border_post45 uniage uniage2 sh33_firms_ind5_* sh33_firms_ind8_* sh33_firms_ind11_* if (sample_ger1990==1 | sample_aus==1), a(department) cl(uni)
outreg2 num_dis3340_citn_b50_1926 num_dis3340_citn_b50_1940 num_dis3340_citn_b50_1950 num_dis3340_citn_b50_1961 num_dis3340_citn_b50_1970 num_dis3340_citn_b50_1980 /*
*/	num_dis3340_citn_t5010_1926 num_dis3340_citn_t5010_1940 num_dis3340_citn_t5010_1950 num_dis3340_citn_t5010_1961 num_dis3340_citn_t5010_1970 num_dis3340_citn_t5010_1980 /*
*/	num_dis3340_citn_t10_1926 num_dis3340_citn_t10_1940 num_dis3340_citn_t10_1950 num_dis3340_citn_t10_1961 num_dis3340_citn_t10_1970 num_dis3340_citn_t10_1980 /*
*/	dest_sub_1926 dest_sub_1931 dest_sub_1950 dest_sub_1961 dest_sub_1970 dest_sub_1980 using "Top Scientists_separate.xls", append dec(3)




/******************************/
/******************************/
/* Department Size: Table A10 */
/******************************/
/******************************/
cd "$folder\Data Temporary STATA Files\Replication Files\"
use "Data Main Results.dta", clear
cd "$folder\Outreg Files\Version Final\"
areg depsize num_dis3340_1926 num_dis3340_1940 num_dis3340_1950 num_dis3340_1961 num_dis3340_1970 num_dis3340_1980 /*
*/  dest_cit_1926 dest_cit_1931 dest_cit_1950 dest_cit_1961 dest_cit_1970 dest_cit_1980 /*
*/	subject_chem_yeard???? subject_phys_yeard???? yeard???? zone_us zone_uk zone_fra zone_ussr /*
*/	bula4*_post45  fractjew_post33 closeuni_50 dist_border_post45 uniage uniage2 sh33_firms_ind5_* sh33_firms_ind8_* sh33_firms_ind11_* if (sample_ger1990==1 | sample_aus==1), a(department) cl(uni)
outreg2 num_dis3340_1926 num_dis3340_1940 num_dis3340_1950 num_dis3340_1961 num_dis3340_1970 num_dis3340_1980 /*
*/	dest_sub_1926 dest_sub_1931 dest_sub_1950 dest_sub_1961 dest_sub_1970 dest_sub_1980 using "RF_depsize_40.xls", replace dec(3)	
	

areg depsize /*
*/	dest_sub_1926 dest_sub_1931 dest_sub_1950 dest_sub_1961 dest_sub_1970 dest_sub_1980 /*
*/  dest_cit_1926 dest_cit_1931 dest_cit_1950 dest_cit_1961 dest_cit_1970 dest_cit_1980 /*
*/	subject_chem_yeard???? subject_phys_yeard???? yeard???? zone_us zone_uk zone_fra zone_ussr /*
*/	bula4*_post45  fractjew_post33 closeuni_50 dist_border_post45 uniage uniage2 sh33_firms_ind5_* sh33_firms_ind8_* sh33_firms_ind11_* if (sample_ger1990==1 | sample_aus==1), a(department) cl(uni)
outreg2 num_dis3340_1926 num_dis3340_1940 num_dis3340_1950 num_dis3340_1961 num_dis3340_1970 num_dis3340_1980 /*
*/	dest_sub_1926 dest_sub_1931 dest_sub_1950 dest_sub_1961 dest_sub_1970 dest_sub_1980 using "RF_depsize_40.xls", append dec(3)	


areg depsize num_dis3340_1926 num_dis3340_1940 num_dis3340_1950 num_dis3340_1961 num_dis3340_1970 num_dis3340_1980 /*
*/	dest_sub_1926 dest_sub_1931 dest_sub_1950 dest_sub_1961 dest_sub_1970 dest_sub_1980 /*
*/  dest_cit_1926 dest_cit_1931 dest_cit_1950 dest_cit_1961 dest_cit_1970 dest_cit_1980 /*
*/	subject_chem_yeard???? subject_phys_yeard???? yeard???? zone_us zone_uk zone_fra zone_ussr /*
*/	bula4*_post45  fractjew_post33 closeuni_50 dist_border_post45 uniage uniage2 sh33_firms_ind5_* sh33_firms_ind8_* sh33_firms_ind11_* if (sample_ger1990==1 | sample_aus==1), a(department) cl(uni)
outreg2 num_dis3340_1926 num_dis3340_1940 num_dis3340_1950 num_dis3340_1961 num_dis3340_1970 num_dis3340_1980 /*
*/	dest_sub_1926 dest_sub_1931 dest_sub_1950 dest_sub_1961 dest_sub_1970 dest_sub_1980 using "RF_depsize_40.xls", append dec(3)	
		
	






/***********************************************/
/***********************************************/
/* Young versus old - Hiring Results: Table A11 */
/***********************************************/
/***********************************************/
cd "$folder\Data Temporary STATA Files\Replication Files\"
use "Data Hiring.dta", clear
cd "$folder\Outreg Files\Version Final\"

areg newhire_qual_career_avg_norm num_dis3340_citn_yng_1940 num_dis3340_citn_yng_1950 num_dis3340_citn_yng_1961 num_dis3340_citn_yng_1970 num_dis3340_citn_yng_1980 /*
	*/	num_dis3340_citn_old_1940 num_dis3340_citn_old_1950 num_dis3340_citn_old_1961 num_dis3340_citn_old_1970 num_dis3340_citn_old_1980 /*
	*/	dest_sub_1931 dest_sub_1950 dest_sub_1961 dest_sub_1970 dest_sub_1980 /*
	*/  dest_cit_1931 dest_cit_1950 dest_cit_1961 dest_cit_1970 dest_cit_1980 /*
	*/	subject_chem_yeard???? subject_phys_yeard???? yeard???? zone_uk zone_fra zone_ussr /*
	*/	bula4*_post45  fractjew_post33 closeuni_50 dist_border_post45 uniage uniage2 sh33_firms_ind5_* sh33_firms_ind8_* sh33_firms_ind11_* if (sample_ger1990==1 | sample_aus==1), a(department) cl(uni)
outreg2 num_dis3340_citn_yng_1940 num_dis3340_citn_yng_1950 num_dis3340_citn_yng_1961 num_dis3340_citn_yng_1970 num_dis3340_citn_yng_1980 /*
	*/	num_dis3340_citn_old_1940 num_dis3340_citn_old_1950 num_dis3340_citn_old_1961 num_dis3340_citn_old_1970 num_dis3340_citn_old_1980 using "Hire_Quality_career_norm_age.xls", replace dec(3)

areg newhire_qual_career_avg_norm  num_dis3340_citn_t50_yng_1940 num_dis3340_citn_t50_yng_1950 num_dis3340_citn_t50_yng_1961 num_dis3340_citn_t50_yng_1970 num_dis3340_citn_t50_yng_1980 /*
	*/	num_dis3340_citn_t50_old_1940 num_dis3340_citn_t50_old_1950 num_dis3340_citn_t50_old_1961 num_dis3340_citn_t50_old_1970 num_dis3340_citn_t50_old_1980 /*
	*/	dest_sub_1931 dest_sub_1950 dest_sub_1961 dest_sub_1970 dest_sub_1980 /*
	*/  dest_cit_1931 dest_cit_1950 dest_cit_1961 dest_cit_1970 dest_cit_1980 /*
	*/	subject_chem_yeard???? subject_phys_yeard???? yeard???? zone_uk zone_fra zone_ussr /*
	*/	bula4*_post45  fractjew_post33 closeuni_50 dist_border_post45 uniage uniage2 sh33_firms_ind5_* sh33_firms_ind8_* sh33_firms_ind11_* if (sample_ger1990==1 | sample_aus==1), a(department) cl(uni)
outreg2 num_dis3340_citn_t50_yng_1940 num_dis3340_citn_t50_yng_1950 num_dis3340_citn_t50_yng_1961 num_dis3340_citn_t50_yng_1970 num_dis3340_citn_t50_yng_1980 /*
	*/	num_dis3340_citn_t50_old_1940 num_dis3340_citn_t50_old_1950 num_dis3340_citn_t50_old_1961 num_dis3340_citn_t50_old_1970 num_dis3340_citn_t50_old_1980 using "Hire_Quality_career_norm_age.xls", append dec(3)

areg newhire_qual_career_avg_norm num_dis3340_citn_t25_yng_1940 num_dis3340_citn_t25_yng_1950 num_dis3340_citn_t25_yng_1961 num_dis3340_citn_t25_yng_1970 num_dis3340_citn_t25_yng_1980 /*
	*/	num_dis3340_citn_t25_old_1940 num_dis3340_citn_t25_old_1950 num_dis3340_citn_t25_old_1961 num_dis3340_citn_t25_old_1970 num_dis3340_citn_t25_old_1980 /*
	*/	dest_sub_1931 dest_sub_1950 dest_sub_1961 dest_sub_1970 dest_sub_1980 /*
	*/ 	dest_cit_1931 dest_cit_1950 dest_cit_1961 dest_cit_1970 dest_cit_1980 /*
	*/	subject_chem_yeard???? subject_phys_yeard???? yeard???? zone_uk zone_fra zone_ussr /*
	*/	bula4*_post45  fractjew_post33 closeuni_50 dist_border_post45 uniage uniage2 sh33_firms_ind5_* sh33_firms_ind8_* sh33_firms_ind11_* if (sample_ger1990==1 | sample_aus==1), a(department) cl(uni)
outreg2 num_dis3340_citn_t25_yng_1940 num_dis3340_citn_t25_yng_1950 num_dis3340_citn_t25_yng_1961 num_dis3340_citn_t25_yng_1970 num_dis3340_citn_t25_yng_1980 /*
	*/	num_dis3340_citn_t25_old_1940 num_dis3340_citn_t25_old_1950 num_dis3340_citn_t25_old_1961 num_dis3340_citn_t25_old_1970 num_dis3340_citn_t25_old_1980 using "Hire_Quality_career_norm_age.xls", append dec(3)

areg newhire_qual_career_avg_norm num_dis3340_citn_t10_yng_1940 num_dis3340_citn_t10_yng_1950 num_dis3340_citn_t10_yng_1961 num_dis3340_citn_t10_yng_1970 num_dis3340_citn_t10_yng_1980 /*
	*/	num_dis3340_citn_t10_old_1940 num_dis3340_citn_t10_old_1950 num_dis3340_citn_t10_old_1961 num_dis3340_citn_t10_old_1970 num_dis3340_citn_t10_old_1980 /*
	*/	dest_sub_1931 dest_sub_1950 dest_sub_1961 dest_sub_1970 dest_sub_1980 /*
	*/  dest_cit_1931 dest_cit_1950 dest_cit_1961 dest_cit_1970 dest_cit_1980 /*
	*/	subject_chem_yeard???? subject_phys_yeard???? yeard???? zone_uk zone_fra zone_ussr /*
	*/	bula4*_post45  fractjew_post33 closeuni_50 dist_border_post45 uniage uniage2 sh33_firms_ind5_* sh33_firms_ind8_* sh33_firms_ind11_* if (sample_ger1990==1 | sample_aus==1), a(department) cl(uni)
outreg2 num_dis3340_citn_t10_yng_1940 num_dis3340_citn_t10_yng_1950 num_dis3340_citn_t10_yng_1961 num_dis3340_citn_t10_yng_1970 num_dis3340_citn_t10_yng_1980 /*
	*/ num_dis3340_citn_t10_old_1940 num_dis3340_citn_t10_old_1950 num_dis3340_citn_t10_old_1961 num_dis3340_citn_t10_old_1970 num_dis3340_citn_t10_old_1980 using "Hire_Quality_career_norm_age.xls", append dec(3)

areg newhire_qual_career_avg_norm num_dis3340_citn_t5_yng_1940 num_dis3340_citn_t5_yng_1950 num_dis3340_citn_t5_yng_1961 num_dis3340_citn_t5_yng_1970 num_dis3340_citn_t5_yng_1980 /*
	*/	num_dis3340_citn_t5_old_1940 num_dis3340_citn_t5_old_1950 num_dis3340_citn_t5_old_1961 num_dis3340_citn_t5_old_1970 num_dis3340_citn_t5_old_1980 /*
	*/	dest_sub_1931 dest_sub_1950 dest_sub_1961 dest_sub_1970 dest_sub_1980 /*
	*/  dest_cit_1931 dest_cit_1950 dest_cit_1961 dest_cit_1970 dest_cit_1980 /*
	*/	subject_chem_yeard???? subject_phys_yeard???? yeard???? zone_uk zone_fra zone_ussr /*
	*/	bula4*_post45  fractjew_post33 closeuni_50 dist_border_post45 uniage uniage2 sh33_firms_ind5_* sh33_firms_ind8_* sh33_firms_ind11_* if (sample_ger1990==1 | sample_aus==1), a(department) cl(uni)
outreg2 num_dis3340_citn_t5_yng_1940 num_dis3340_citn_t5_yng_1950 num_dis3340_citn_t5_yng_1961 num_dis3340_citn_t5_yng_1970 num_dis3340_citn_t5_yng_1980 /*
	*/	num_dis3340_citn_t5_old_1940 num_dis3340_citn_t5_old_1950 num_dis3340_citn_t5_old_1961 num_dis3340_citn_t5_old_1970 num_dis3340_citn_t5_old_1980 using "Hire_Quality_career_norm_age.xls", append dec(3)


/* Measure based on 5 years in the middle of a change  */
areg newhire_qual_avgmiddle5 num_dis3340_citn_yng_1940 num_dis3340_citn_yng_1950 num_dis3340_citn_yng_1961 num_dis3340_citn_yng_1970 num_dis3340_citn_yng_1980 /*
	*/	num_dis3340_citn_old_1940 num_dis3340_citn_old_1950 num_dis3340_citn_old_1961 num_dis3340_citn_old_1970 num_dis3340_citn_old_1980 /*
	*/	dest_sub_1931 dest_sub_1950 dest_sub_1961 dest_sub_1970 dest_sub_1980 /*
	*/  dest_cit_1931 dest_cit_1950 dest_cit_1961 dest_cit_1970 dest_cit_1980 /*
	*/	subject_chem_yeard???? subject_phys_yeard???? yeard???? zone_uk zone_fra zone_ussr /*
	*/	bula4*_post45  fractjew_post33 closeuni_50 dist_border_post45 uniage uniage2 sh33_firms_ind5_* sh33_firms_ind8_* sh33_firms_ind11_* if (sample_ger1990==1 | sample_aus==1), a(department) cl(uni)
outreg2 num_dis3340_citn_yng_1940 num_dis3340_citn_yng_1950 num_dis3340_citn_yng_1961 num_dis3340_citn_yng_1970 num_dis3340_citn_yng_1980 /*
	*/	num_dis3340_citn_old_1940 num_dis3340_citn_old_1950 num_dis3340_citn_old_1961 num_dis3340_citn_old_1970 num_dis3340_citn_old_1980 using "Hire_Quality_avgmiddle5_age.xls", replace dec(3)

areg newhire_qual_avgmiddle5 num_dis3340_citn_t50_yng_1940 num_dis3340_citn_t50_yng_1950 num_dis3340_citn_t50_yng_1961 num_dis3340_citn_t50_yng_1970 num_dis3340_citn_t50_yng_1980 /*
	*/	num_dis3340_citn_t50_old_1940 num_dis3340_citn_t50_old_1950 num_dis3340_citn_t50_old_1961 num_dis3340_citn_t50_old_1970 num_dis3340_citn_t50_old_1980 /*
	*/	dest_sub_1931 dest_sub_1950 dest_sub_1961 dest_sub_1970 dest_sub_1980 /*
	*/  dest_cit_1931 dest_cit_1950 dest_cit_1961 dest_cit_1970 dest_cit_1980 /*
	*/	subject_chem_yeard???? subject_phys_yeard???? yeard???? zone_uk zone_fra zone_ussr /*
	*/	bula4*_post45  fractjew_post33 closeuni_50 dist_border_post45 uniage uniage2 sh33_firms_ind5_* sh33_firms_ind8_* sh33_firms_ind11_* if (sample_ger1990==1 | sample_aus==1), a(department) cl(uni)
outreg2 num_dis3340_citn_t50_yng_1940 num_dis3340_citn_t50_yng_1950 num_dis3340_citn_t50_yng_1961 num_dis3340_citn_t50_yng_1970 num_dis3340_citn_t50_yng_1980 /*
	*/	num_dis3340_citn_t50_old_1940 num_dis3340_citn_t50_old_1950 num_dis3340_citn_t50_old_1961 num_dis3340_citn_t50_old_1970 num_dis3340_citn_t50_old_1980 using "Hire_Quality_avgmiddle5_age.xls", append dec(3)

areg newhire_qual_avgmiddle5 num_dis3340_citn_t25_yng_1940 num_dis3340_citn_t25_yng_1950 num_dis3340_citn_t25_yng_1961 num_dis3340_citn_t25_yng_1970 num_dis3340_citn_t25_yng_1980 /*
	*/	num_dis3340_citn_t25_old_1940 num_dis3340_citn_t25_old_1950 num_dis3340_citn_t25_old_1961 num_dis3340_citn_t25_old_1970 num_dis3340_citn_t25_old_1980 /*
	*/	dest_sub_1931 dest_sub_1950 dest_sub_1961 dest_sub_1970 dest_sub_1980 /*
	*/  dest_cit_1931 dest_cit_1950 dest_cit_1961 dest_cit_1970 dest_cit_1980 /*
	*/	subject_chem_yeard???? subject_phys_yeard???? yeard???? zone_uk zone_fra zone_ussr /*
	*/	bula4*_post45  fractjew_post33 closeuni_50 dist_border_post45 uniage uniage2 sh33_firms_ind5_* sh33_firms_ind8_* sh33_firms_ind11_* if (sample_ger1990==1 | sample_aus==1), a(department) cl(uni)
outreg2 num_dis3340_citn_t25_yng_1940 num_dis3340_citn_t25_yng_1950 num_dis3340_citn_t25_yng_1961 num_dis3340_citn_t25_yng_1970 num_dis3340_citn_t25_yng_1980 /*
	*/	num_dis3340_citn_t25_old_1940 num_dis3340_citn_t25_old_1950 num_dis3340_citn_t25_old_1961 num_dis3340_citn_t25_old_1970 num_dis3340_citn_t25_old_1980 using "Hire_Quality_avgmiddle5_age.xls", append dec(3)

areg newhire_qual_avgmiddle5 num_dis3340_citn_t10_yng_1940 num_dis3340_citn_t10_yng_1950 num_dis3340_citn_t10_yng_1961 num_dis3340_citn_t10_yng_1970 num_dis3340_citn_t10_yng_1980 /*
	*/	num_dis3340_citn_t10_old_1940 num_dis3340_citn_t10_old_1950 num_dis3340_citn_t10_old_1961 num_dis3340_citn_t10_old_1970 num_dis3340_citn_t10_old_1980 /*
	*/	dest_sub_1931 dest_sub_1950 dest_sub_1961 dest_sub_1970 dest_sub_1980 /*
	*/  dest_cit_1931 dest_cit_1950 dest_cit_1961 dest_cit_1970 dest_cit_1980 /*
	*/	subject_chem_yeard???? subject_phys_yeard???? yeard???? zone_uk zone_fra zone_ussr /*
	*/	bula4*_post45  fractjew_post33 closeuni_50 dist_border_post45 uniage uniage2 sh33_firms_ind5_* sh33_firms_ind8_* sh33_firms_ind11_* if (sample_ger1990==1 | sample_aus==1), a(department) cl(uni)
outreg2 num_dis3340_citn_t10_yng_1940 num_dis3340_citn_t10_yng_1950 num_dis3340_citn_t10_yng_1961 num_dis3340_citn_t10_yng_1970 num_dis3340_citn_t10_yng_1980 /*
	*/	num_dis3340_citn_t10_old_1940 num_dis3340_citn_t10_old_1950 num_dis3340_citn_t10_old_1961 num_dis3340_citn_t10_old_1970 num_dis3340_citn_t10_old_1980 using "Hire_Quality_avgmiddle5_age.xls", append dec(3)

areg newhire_qual_avgmiddle5 num_dis3340_citn_t5_yng_1940 num_dis3340_citn_t5_yng_1950 num_dis3340_citn_t5_yng_1961 num_dis3340_citn_t5_yng_1970 num_dis3340_citn_t5_yng_1980 /*
	*/	num_dis3340_citn_t5_old_1940 num_dis3340_citn_t5_old_1950 num_dis3340_citn_t5_old_1961 num_dis3340_citn_t5_old_1970 num_dis3340_citn_t5_old_1980 /*
	*/	dest_sub_1931 dest_sub_1950 dest_sub_1961 dest_sub_1970 dest_sub_1980 /*
	*/  dest_cit_1931 dest_cit_1950 dest_cit_1961 dest_cit_1970 dest_cit_1980 /*
	*/	subject_chem_yeard???? subject_phys_yeard???? yeard???? zone_uk zone_fra zone_ussr /*
	*/	bula4*_post45  fractjew_post33 closeuni_50 dist_border_post45 uniage uniage2 sh33_firms_ind5_* sh33_firms_ind8_* sh33_firms_ind11_* if (sample_ger1990==1 | sample_aus==1), a(department) cl(uni)
outreg2 num_dis3340_citn_t5_yng_1940 num_dis3340_citn_t5_yng_1950 num_dis3340_citn_t5_yng_1961 num_dis3340_citn_t5_yng_1970 num_dis3340_citn_t5_yng_1980 /*
	*/	num_dis3340_citn_t5_old_1940 num_dis3340_citn_t5_old_1950 num_dis3340_citn_t5_old_1961 num_dis3340_citn_t5_old_1970 num_dis3340_citn_t5_old_1980 using "Hire_Quality_avgmiddle5_age.xls", append dec(3)

	
	



