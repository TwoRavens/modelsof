drop _all
*change into your working directory:
cd "/Users/`=c(username)'/"
use "BW_replicationuntil2016.dta"

gen pvoteshift=ldrile*ldvote

*OVerview of measurements:
label variable adams "Adams et al."
label variable nicheness_two "Nicheness (Bischof)"
label variable dmean_lrs "public opinion shift"
label variable ldrile "previous policy shift"
label variable ldvote "previous change in votes"
label variable pvoteshift "previous policy shift $\times$ previous change in votes"

sutex adams nicheness_two adams dmean_lrs ldrile ldvote pvoteshift, labels minmax

*Some analysis to check if things seem trustable:
xtset partydan edate

* let's run the Adams 2006 model on those countries:
eststo clear
eststo: reg drile ldrile ldvote pvoteshift i.adams##c.dmean_lrs i.country, cluster(clnum)
keep if e(sample)
eststo: reg drile ldrile ldvote pvoteshift c.nicheness_two##c.dmean_lrs i.country, cluster(clnum)
eststo: reg drile ldrile ldvote pvoteshift i.adams c.nicheness_two##c.dmean_lrs i.country, cluster(clnum)
eststo: reg drile ldrile ldvote pvoteshift i.adams##c.dmean_lrs c.nicheness_two##c.dmean_lrs i.country, cluster(clnum)
esttab using extendedmodels.tex, replace se nobaselevels ///
stats(r2 cluster N) drop(*.country) label ///
title("Nicheness models extended, 1976-2015") ///
mtitles("Adams" "Bischof" "Bischof + Adams" "Bischof $\times# Adams")  ///
note("Clustered standard errors by election;} \\ \multicolumn{5}{l}{\footnotesize all models include country fixed effect omitted from table") 


