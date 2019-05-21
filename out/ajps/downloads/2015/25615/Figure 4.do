
cd "~/Dropbox/Attribution Analysis Feb 2012/"
*cd "C:\Users\randy\Dropbox\Attribution Analysis Feb 2012\"
set more off
drop _all


use CIdata_dist_1_prop5.dta


foreach jj of numlist 2 3 4 {

	append using CIdata_dist_`jj'_prop5.dta
}


/* ignore the "prop" variable. The proposer is given my the # in the labels for the variables high# low# and mean#. so use these
along with the dm designation and the dist designation. */


/* get the average mean for the times DM 5 was not proposer */

egen DM5nonprop_mean=rowmean(mean1 mean2 mean3 mean4) if dm==5
egen DM5nonprop_low=rowmean(low1 low2 low3 low4) if dm==5
egen DM5nonprop_high=rowmean(high1 high2 high3 high4) if dm==5
*list DM5nonprop_low DM5nonprop_mean DM5nonprop_high

/* get the numbers for when DM5 was proposer */

gen DM5prop_mean=mean5 if dm==5
gen DM5prop_low=low5 if dm==5
gen DM5prop_high=high5 if dm==5


keep DM5* dist
keep if DM5prop_mean~=.
gen newlab=.
replace newlab=23 if dist==4
replace newlab=38 if dist==3
replace newlab=48 if dist==2
replace newlab=53 if dist==1

list


	


	
	twoway lfit DM5prop_mean newlab || lfit DM5nonprop_mean newlab || ///
			rbar DM5prop_low DM5prop_high newlab, mwidth msize(4.5) color(gs10) || scatter DM5prop_mean newlab, msymbol(Oh) mcolor(black) ///
	        || rbar DM5nonprop_low DM5nonprop_high newlab, mwidth msize(6.5) color(gs5) || scatter DM5nonprop_mean newlab, msymbol(Oh) mcolor(black) ///
			xtitle(" " "Voting Weight", size(small)) ///
			ytitle(" " "Predicted Share of Punishment" " ", size(small)) ///
			legend(off) ///
			plotregion(margin(l+3 r+3)) graphregion(fcolor(none)) ///
			xlabel(23 38 48 53, labsize(small))  scheme(s1mono)
			
			
			
			
			
			
			
			
			
			
			
			
			
			
