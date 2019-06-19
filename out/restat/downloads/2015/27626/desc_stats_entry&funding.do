#delimit;
clear all;
version 12.1;
pause on;
program drop _all;
capture log close;
set more off;

/*INSERT FOLDER PATH*/
cd /;

use pmra_level_freq.dta, clear;
estimates drop _all;
quietly estpost tabstat nb_pmra nb_pmra_pct20 nb_pmra_rnk10, stat(N mean sd) c(v) by(rtrct);
esttab, cells("nb_pmra(label(Nb. of Rltd. Articles) fmt(%8.2fc))" "nb_pmra_pct20(label(Nb. of Closely Rltd. Articles [cardinal]) fmt(%8.2fc))" "nb_pmra_rnk10(label(Nb. of Closely Rltd. Articles [ordinal]) fmt(%8.2fc))") noobs nomtitle nonumber;
esttab using tables/desc_stats_pmra_freq.rtf, cells("nb_pmra(label(Nb. of Rltd. Articles) fmt(%8.2fc))" "nb_pmra_pct20(label(Nb. of Closely Rltd. Articles [cardinal]) fmt(%8.2fc))" "nb_pmra_rnk10(label(Nb. of Closely Rltd. Articles [ordinal]) fmt(%8.2fc))") noobs nomtitle nonumber replace;
keep if year==rtrct_year;
tab rtrct;

use pmra_level_funding.dta, clear;
estimates drop _all;
quietly estpost tabstat nbgrants amount, stat(N mean sd) c(v) by(rtrct);
esttab, cells("nbgrants(label(Nb. of NIH Grants) fmt(%8.2fc))" "amount(label(NIH $) fmt(%15.0fc))") noobs nomtitle nonumber;
esttab using tables/desc_stats_pmra_funding.rtf, cells("nbgrants(label(Nb. of NIH Grants) fmt(%8.2fc))" "amount(label(NIH $) fmt(%15.0fc))") noobs nomtitle nonumber append;
keep if year==rtrct_year;
tab rtrct;