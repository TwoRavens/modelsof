use  "C:\Users\ejm5\Dropbox\District People Councils\Statafiles\results_Sept_17_2012.dta", clear

replace beta=beta/100 if id==12
replace se=se/100 if id==12
replace beta=beta/10 if id==7
replace se=se/10 if id==7

generate low= beta-(1.6*se)
generate high= beta+(1.6*se)

#delimit;

label define id 1 "INFRASTRUCTURE INDEX"  2 "All Year Road (Prob)" 3 "Public Transport (Prob)" 4 "Socio-Development Project (Prob)" 5 "Tap Water (Prob)" 
6 "Village w/Road (Prob)"  7 "AGR. SERVICES INDEX"  8 "Supported Crop (HH Share)"  9	"Agr. Extension Support (HH Share)"  10 "Agr. Tax Exemption (HH Share)"
11	"Veterinarian (Prob)"  12	"Extension Staff Visits (100s)"  13	"Supported Crops (Prob)"  14	"Extension Center (Prob)"  15	"Irrigation Plants Managed(Prob)"
16	"HEALTH SERVICES INDEX"  17	"Healthcare Fee (HH Share)"  18 "Public Health Project (Prob)" 19	"EDUCATION INDEX"  20	"Education/Culture Project (Prob) "  21	"Supported Tuition Fee  (HH Share)"
22	"Secondary School (Prob)"  23 "Kindergarten (Prob)"  24 "Primary School (Prob)"  25	"COMMUNICATIONS INDEX"  26 "Local Broadcast (Prob)" 27 "Post Office (Village, Prob)" 
28 "Post Office (Commune, Prob)" 29 " HH BIZ DEV'T INDEX" 30 "Credit Support (HH Share)" 31 "Biz Tax Exemption (HH Share)" 32 "Intercommune Market (Prob)" 33 "Non-Farm Business (Prob)" 34 "Daily Market (Prob)" 
35 "Periodic Market (Prob)" 36 "Wholesale Market (Prob)" , replace;

label values id id;

/*Indicators*/

#delimit;
gsort - id;
twoway (rcap  low high id if analysis==1 & id!=1 & id!=7 & id!=16 & id!=19 & id!=25 & id!=29  , lcolor(gs12) mcolor(gs12)  horizontal msize(small) lwidth(medthin) lcolor(navy))
(scatter id beta if analysis==1 & id!=1 & id!=7 & id!=16 & id!=19 & id!=25 & id!=29 , msymbol(diamond) mcolor(black) msize(small)),
xline(0, lcolor(gs7) lwidth(medium) lpattern(shortdash))
ylab(1(1)36, valuelabel angle(horizontal) labsize(vsmall)) yscale(reverse) ytitle("") xtitle("Avg. Treatment Effect ('08-'10)", size(medsmall) margin(medsmall)) xlab(-.20(.05).20, labsize(vsmall)) 
legend(rows(2) size(vsmall) label(1 90% CI) label(2 Coefficient) ring(0)  position(5)) legend(off)
graphregion(fcolor(white) ifcolor(white)) plotregion(fcolor(white) ifcolor(white)) ;

graph save ate_range_0810.gph, replace;


#delimit;
gsort - id;
twoway (rcap  low high id if analysis==2 & id!=1 & id!=7 & id!=16 & id!=19 & id!=25 & id!=29, lcolor(navy) mcolor(navy)  horizontal msize(small) lwidth(medthin) lcolor(navy))
(scatter id beta if analysis==2 & id!=1 & id!=7 & id!=16 & id!=19 & id!=25 & id!=29, msymbol(diamond) mcolor(purple) msize(small)),
xline(0, lcolor(red) lwidth(medium) lpattern(shortdash))
ylab(1(1)36, nolabels) yscale(reverse) ytitle("") xtitle("Pre-Treatment Trend ('06-'08)", size(medsmall) margin(medsmall)) xlab(-.20(.05).20, labsize(vsmall)) 
legend(rows(2) size(vsmall) label(1 90% CI) label(2 Coefficient)  position(3)) ;

graph save ate_range_0608.gph, replace;


#delimit;
graph combine ate_range_0810.gph ate_range_0608.gph, xcommon ycommon;
graph save combine_ate.gph, replace;



/*Indices*/

generate id2=id if id==1 | id==7 | id==16 | id==19 | id==25 | id==29;
replace id2=2 if id2==7;
replace id2=3 if id2==16;
replace id2=4 if id2==19;
replace id2=5 if id2==25;
replace id2=6 if id2==29;

label define id2 1 "INFRASTRUCTURE INDEX"  2 "AGR. SERVICES INDEX"  3 "HEALTH SERVICES INDEX" 4 "EDUCATION INDEX"  5	"COMMUNICATIONS INDEX"  6 "HH BIZ DEV'T INDEX", replace;
label values id2 id2;



#delimit;
gsort - id2;
twoway (rcap  low high id2 if analysis==1, lcolor(navy) mcolor(navy)  horizontal msize(medium) lwidth(thick) lcolor(navy))
(scatter id2 beta if analysis==1, msymbol(diamond) mcolor(purple) msize(medium)),
xline(0, lcolor(red) lwidth(medium) lpattern(shortdash))
ylab(1(1)6, valuelabel angle(horizontal) labsize(medsmall)) yscale(reverse) ytitle("") xtitle("ATE('08-'10)", size(medsmall) margin(medsmall)) xlab(-.40(.1).40, labsize(vsmall)) 
legend(rows(2) size(vsmall) label(1 90% CI) label(2 Coefficient) ring(0)  position(5)) legend(off);

graph save ate_range_0810_index.gph, replace;


#delimit;
gsort - id;
twoway (rcap  low high id2 if analysis==2, lcolor(navy) mcolor(navy)  horizontal msize(medium) lwidth(thick) lcolor(navy))
(scatter id2 beta if analysis==2, msymbol(diamond) mcolor(purple) msize(medium)),
xline(0, lcolor(red) lwidth(medium) lpattern(shortdash))
ylab(1(1)6, nolabels) yscale(reverse) ytitle("") xtitle("Pre-Treatment('06-'08)", size(medsmall) margin(medsmall)) xlab(-.40(.1).40, labsize(vsmall)) 
legend(rows(2) size(medium) label(1 90% CI) label(2 Coefficient)  position(3)) ;

graph save ate_range_0608_index.gph, replace;


#delimit;
graph combine ate_range_0810_index.gph ate_range_0608_index.gph, xcommon ycommon;
graph save combine_ate_index.gph, replace;


/*Hawthorne*/
#delimit;
gsort - id;
twoway (rcap  low high id if analysis==3 & id!=1 & id!=7 & id!=16 & id!=19 & id!=25 & id!=29  , lcolor(navy) mcolor(navy)  horizontal msize(small) lwidth(medthin) lcolor(navy))
(scatter id beta if analysis==3 & id!=1 & id!=7 & id!=16 & id!=19 & id!=25 & id!=29 , msymbol(diamond) mcolor(purple) msize(small)),
xline(0, lcolor(red) lwidth(medium) lpattern(shortdash))
ylab(1(1)36, valuelabel angle(horizontal) labsize(vsmall)) yscale(reverse) ytitle("") xtitle("ATE w/in Surveyed", size(medsmall) margin(medsmall)) xlab(-.40(.05).40, labsize(vsmall)) 
legend(rows(2) size(vsmall) label(1 90% CI) label(2 Coefficient) ring(0)  position(5)) legend(off);

graph save ate_range_treatsurvey.gph, replace;


#delimit;
gsort - id;
twoway (rcap  low high id if analysis==4 & id!=1 & id!=7 & id!=16 & id!=19 & id!=25 & id!=29  , lcolor(navy) mcolor(navy)  horizontal msize(small) lwidth(medthin) lcolor(navy))
(scatter id beta if analysis==4 & id!=1 & id!=7 & id!=16 & id!=19 & id!=25 & id!=29 , msymbol(diamond) mcolor(purple) msize(small)),
xline(0, lcolor(red) lwidth(medium) lpattern(shortdash))
ylab(1(1)36, valuelabel angle(horizontal) labsize(vsmall)) yscale(reverse) ytitle("") xtitle("Effect of Survey in Treated", size(medsmall) margin(medsmall)) xlab(-.40(.05).40, labsize(vsmall)) 
legend(rows(2) size(vsmall) label(1 90% CI) label(2 Coefficient) ring(0)  position(5)) legend(off);

graph save ate_range_survey.gph, replace;


#delimit;
gsort - id;
twoway (rcap  low high id if analysis==5 & id!=1 & id!=7 & id!=16 & id!=19 & id!=25 & id!=29  , lcolor(navy) mcolor(navy)  horizontal msize(small) lwidth(medthin) lcolor(navy))
(scatter id beta if analysis==5 & id!=1 & id!=7 & id!=16 & id!=19 & id!=25 & id!=29 , msymbol(diamond) mcolor(purple) msize(small)),
xline(0, lcolor(red) lwidth(medium) lpattern(shortdash))
ylab(1(1)36, valuelabel angle(horizontal) labsize(vsmall)) yscale(reverse) ytitle("") xtitle("Effect of Steering Committee in Treated", size(medsmall) margin(medsmall)) xlab(-.40(.05).40, labsize(vsmall)) 
legend(rows(2) size(vsmall) label(1 90% CI) label(2 Coefficient) ring(0)  position(5)) legend(off);

graph save ate_range_steering.gph, replace;
























