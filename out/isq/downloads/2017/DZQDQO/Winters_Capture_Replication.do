/* Replication file for "Targeting, Accountability and Capture in Development Projects" */
/* Matthew S. Winters (University of Illinois at Urbana-Champaign */
/* mwinters@illinois.edu */
/* January 2013 */

use Capture_Replication_January2013.dta

/***********/
/* Table 3 */
/***********/

tab capture outcome, chi2

/***********/
/* Table 4 */
/***********/

reg capture corruptcontrol, vce(cluster countryperiod)
reg capture ti, vce(cluster countryperiod)
reg capture getthingsdonegifts, vce(cluster countryperiod)

/***********/
/* Table 5 */
/***********/

tab targetconc2 capture, row chi2

/***********/
/* Table 6 */
/***********/

 *** Column 1: Logistic Regrssion Model
logit capture targetconc2 logtotprojamt ibrd blend, vce(cluster country)

 *** Column 2: Conditional Logit Model Including Country and Year FEs
clogit capture targetconc2 logtotprojamt ibrd blend ib2003.closeyear, group(countryid) vce(cluster country)

 *** Column 3: Conditional Logit Model Including Country, Year, Sector and Theme FEs
clogit capture targetconc2 logtotprojamt ibrd blend ib2.mjthemecat i.mjsectorcat ib2003.closeyear, group(countryid) vce(cluster country)

 *** Column 4: Same Model But Substitute World Bank Amount for Total Project Amount
clogit capture targetconc2 logwbamt ibrd blend ib2.mjthemecat i.regioncat i.mjsectorcat ib2003.closeyear, group(countryid) vce(cluster country)

 *** Column 5: Alt DV: No Financial
clogit capturenofin targetconc2 logtotprojamt ibrd blend ib2.mjthemecat i.regioncat i.mjsectorcat ib2003.closeyear, group(countryid) vce(cluster country)

 *** Column 6: Alt DV: No Procurement
clogit capturenoproc targetconc2 logtotprojamt ibrd blend ib2.mjthemecat i.regioncat i.mjsectorcat ib2003.closeyear, group(countryid) vce(cluster country)

 *** Column 7: Alt DV: No Audit
clogit capturenoaudit targetconc2 logtotprojamt ibrd blend ib2.mjthemecat i.regioncat i.mjsectorcat ib2003.closeyear, group(countryid) vce(cluster country)

 *** Column 8: Alt DV: No Political
clogit capturenopol targetconc2 logtotprojamt ibrd blend ib2.mjthemecat i.regioncat i.mjsectorcat ib2003.closeyear, group(countryid) vce(cluster country)

 *** Column 9: Ordered Logit Model -- No Country or Year FEs
ologit capturescale targetconc2 logtotprojamt ibrd blend, vce(cluster country)

/***********/
/* Table 7 */
/***********/

/* Group Data into Country-Periods and Set Those as the Groups */
encode countryperiod, gen(cperiodid)
xtset cperiodid

 *** Column 1: Only Control of Corruption
xtlogit capture targetconc2 logtotprojamt ibrd blend corruptcontrol, re

 *** Column 2: Control of Corruption Plus GDP PC
xtlogit capture targetconc2 logtotprojamt ibrd blend corruptcontrol loggdppc, re
 
 *** Column 3: Control of Coruption, GDPPC and Democracy
xtlogit capture targetconc2 logtotprojamt ibrd blend corruptcontrol loggdppc cgv, re
 


/* END OF FILE */
