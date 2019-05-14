

cd  "C:\Users\ejm5\Dropbox\District People Councils\Statafiles" 

use randomization_inference.dta, clear



#delimit;
histogram sig_10, bin(10) frequency fcolor(gs12) xlab(0(1)16, labsize(vsmall)) ylab(, labsize(vsmall)) xtitle("Number of Significant Outcomes", size(small) margin(medium)) 
ytitle(, margin(medsmall))  title("P-Value<0.10 - All Results", size(medsmall) margin(small)) xline(10, lpattern(longdash) lwidth(medthick) lcolor(black)) 
xline(8, lpattern(shortdash) lwidth(medthick) lcolor(gs8)) normal
graphregion(fcolor(white) ifcolor(white)) plotregion(fcolor(white) ifcolor(white)) ;
graph save sig_10.gph, replace;

#delimit;
histogram sig_pos_10, bin(10) frequency fcolor(gs12) xlab(0(1)16, labsize(vsmall)) ylab(, labsize(vsmall)) xtitle("Number of Significant Outcomes", size(small) margin(medium)) 
ytitle(, margin(medsmall)) title("P-Value<0.10 & Positive", size(medsmall) margin(small)) xline(9, lpattern(longdash) lwidth(medthick) lcolor(black)) 
xline(3, lpattern(shortdash) lwidth(medthick) lcolor(gs8)) normal
graphregion(fcolor(white) ifcolor(white)) plotregion(fcolor(white) ifcolor(white)) ;
graph save sig_pos_10.gph, replace;


#delimit;
histogram sig_5, bin(10) frequency fcolor(gs12) xlab(0(1)16, labsize(vsmall)) ylab(, labsize(vsmall)) xtitle("Number of Significant Outcomes", size(small) margin(medium)) 
ytitle(, margin(medsmall)) title("P-Value<0.05 - All Results", size(medsmall) margin(small)) xline(6, lpattern(longdash) lwidth(medthick) lcolor(black)) 
xline(6, lpattern(shortdash) lwidth(medthick) lcolor(gs8)) normal
graphregion(fcolor(white) ifcolor(white)) plotregion(fcolor(white) ifcolor(white)) ;
graph save sig_5.gph, replace;

#delimit;
histogram sig_pos_5, bin(10) frequency fcolor(gs12) xlab(0(1)16, labsize(vsmall)) ylab(, labsize(vsmall)) xtitle("Number of Significant Outcomes", size(small) margin(medium)) 
ytitle(, margin(medsmall)) title("P-Value<0.05 & Positive", size(medsmall) margin(small)) xline(5, lpattern(longdash) lwidth(medthick) lcolor(black))
xline(2, lpattern(shortdash) lwidth(medthick) lcolor(gs8)) normal
graphregion(fcolor(white) ifcolor(white)) plotregion(fcolor(white) ifcolor(white)) ;
graph save sig_pos_5.gph, replace;


#delimit;
histogram sig_1, bin(10) frequency fcolor(gs12) xlab(0(1)16, labsize(vsmall)) ylab(, labsize(vsmall)) xtitle("Number of Significant Outcomes", size(small) margin(medium)) 
ytitle(, margin(medsmall)) title("P-Value<0.01 - All Results", size(medsmall) margin(small)) xline(3, lpattern(longdash) lwidth(medthick) lcolor(black)) 
xline(1, lpattern(shortdash) lwidth(medthick) lcolor(gs8)) normal
graphregion(fcolor(white) ifcolor(white)) plotregion(fcolor(white) ifcolor(white)) ;
graph save sig_1.gph, replace;

#delimit;
histogram sig_pos_1, bin(10) frequency fcolor(gs12) xlab(0(1)16, labsize(vsmall)) ylab(, labsize(vsmall)) xtitle("Number of Significant Outcomes", size(small) margin(medium)) 
ytitle(, margin(medsmall)) title("P-Value<0.01 & Positive", size(medsmall) margin(small)) xline(3, lpattern(longdash) lwidth(medthick) lcolor(black)) 
xline(1, lpattern(shortdash) lwidth(medthick) lcolor(gs8)) normal
graphregion(fcolor(white) ifcolor(white)) plotregion(fcolor(white) ifcolor(white)) ;
graph save sig_pos_1.gph, replace;

#delimit;
graph combine sig_10.gph sig_pos_10.gph sig_5.gph sig_pos_5.gph sig_1.gph sig_pos_1.gph, rows(2) cols(2) xcommon
graphregion(fcolor(white) ifcolor(white)) plotregion(fcolor(white) ifcolor(white)) ;
graph save randomization_inference1.gph, replace;

/**********************************Graph of P and T Values************************/

#delimit;
use randomization_inference_tstats.dta, clear;
stack t_*, into(t);
generate id=_n;
generate variable=1;

drop if t<-10;
drop if t>10;

#delimit;
replace variable=32 if id<32000;
replace variable=31 if id<31000;
replace variable=30 if id<30000;

replace variable=29 if id<29000;
replace variable=28 if id<28000;
replace variable=27 if id<27000;
replace variable=26 if id<26000;
replace variable=25 if id<25000;
replace variable=24 if id<24000;
replace variable=23 if id<23000;
replace variable=22 if id<22000;
replace variable=21 if id<21000;
replace variable=20 if id<20000;

replace variable=19 if id<19000;
replace variable=18 if id<18000;
replace variable=17 if id<17000;
replace variable=16 if id<16000;
replace variable=15 if id<15000;
replace variable=14 if id<14000;
replace variable=13 if id<13000;
replace variable=12 if id<12000;
replace variable=11 if id<11000;
replace variable=10 if id<10000;

replace variable=9 if id<9000;
replace variable=8 if id<8000;
replace variable=7 if id<7000;
replace variable=6 if id<6000;
replace variable=5 if id<5000;
replace variable=4 if id<4000;
replace variable=3 if id<3000;
replace variable=2 if id<2000;
replace variable=1 if id<1000;

generate p=ttail(4414,  t);

#delimit;
generate mc=1;
lab var mc "Randomization Inference";
label define MonteCarlo 1 "Monte Carlo Simulation" 0 "Actual Treatment";
label values mc MonteCarlo;
sort mc variable;
merge m:1 mc variable using treatmenteffect32_May162012.dta;
replace t= beta2/ se2 if mc==0;
replace p=ttail(4126,  t) if mc==0;

#delimit;
histogram t, percent by(mc) subtitle(, size(medium))  ylab(0(2)16, labsize(small))  
fcolor(navy) lcolor(white) xtitle("T-Statistic of Outcome Variable", size(large)) ytitle("Proportion of Outcomes (%)", size(medium))
xline(-1.6 1.6, lcolor(red) lwidth(medium) lpattern(dash));
graph save tstat.gph, replace;

#delimit;
histogram p, percent by(mc) subtitle(, size(medium)) xlab(0(.2)1, labsize(small)) 
fcolor(navy) lcolor(white) xtitle("P-Value of Outcome Variable", size(large)) ytitle("Proportion of Outcomes (%)", size(medium)) 
xline(.1, lcolor(red) lwidth(medium) lpattern(dash));
graph save pval.gph, replace;

graph combine tstat.gph pval.gph, rows(2);
graph save randomization_inference2.gph, replace;

/*******************************************Bar Graphs***********************************************/
#delimit cr
use "treatmenteffect32_May162012.dta", clear
 

sort variable
replace  beta2=beta2/100 if  variable==14
replace  se2=se2/100 if  variable==14
replace  beta2006=beta2006/100 if  variable==14
replace  se2006=se2006/100 if  variable==14

drop t p

generate t=beta2/se2
generate p=ttail(4126,  t)
generate t2006=beta2006/se2006
generate p2006=ttail(4220,  t2006)

generate low2010= beta2-(1.6*se2)
generate high2010= beta2+(1.6*se2)
generate low2006= beta2006-(1.6*se2006)
generate high2006= beta2006+(1.6*se2006)

#delimit;

label define variables 1 "All Year Road (Prob)"  2 "Public Transport (Prob)" 3 "Socio-Development Project (Prob)" 4 "Supported Crop (HH Share)" 5 "Agr. Extension Support (HH Share)" 
6 "Healthcare Fee (HH Share)"  7 "Public Health Project (Prob)"  8	"Education/Culture Project (Prob)"  9	"Local Broadcast (Prob)"  10 "Tax Exemption (Agr. HH Share)" 
11	"Credit Support (HH Share)"  12 "Veterinarian (Prob)"  13 "Cultural House (Prob)" 14 "Extension Staff Visits (100s)"  15 "Clean Water (Prob)" 
16 "Support Tuition Fee (HH Share)"	  17 "Tax Exemption (Biz, Prob)"   18 "Agr. Extension Ctr. (Prob)"  19	"Village has Road (Prob)"  20 "Commune Post Office (Prob)"  21 "Commune Mkt. (Prob)"
22 "Irrigation Plants (Prob)"  23 "Commune Secondary School (Prob)"  24 "Commune Kindergarten (Prob)"  25 "Nonfarm Business (Prob)"  26 "Nonfarm Biz w/Local Labor"	27 "Commune Crop Support (Prob)"
28 "Vill. Market (Daily)" 29 "Vill. Market (Occasional)" 30 "Vill. Market (Wholesale)" 31 "Vill. Post Office (Prob)" 32 "Vill. Primary School",  replace;

label values variable variables;



#delimit;
gsort + variable;
twoway (rcap  low2010 high2010 variable, lcolor(navy) mcolor(navy)  horizontal msize(small) lwidth(medthin) lcolor(navy))
(scatter variable beta2 , msymbol(diamond) mcolor(purple) msize(small)), 
xline(0, lcolor(red) lwidth(medium) lpattern(shortdash))
ylab(1(1)32, valuelabel angle(horizontal) labsize(vsmall)) yscale(reverse) ytitle("") xtitle("Average Treatment Effect ('08-'10)", size(medsmall) margin(medsmall)) xlab(-.18(.05).18, labsize(vsmall)) 
legend(rows(2) size(vsmall) label(1 90% CI) label(2 Coefficient) ring(0)  position(11)) legend(off);
;

graph save ate_2010.gph, replace;


#delimit;
gsort + variable;
twoway (rcap  low2006 high2006 variable, lcolor(navy) mcolor(navy)  horizontal msize(small) lwidth(medthin) lcolor(navy))
(scatter variable beta2006 , msymbol(diamond) mcolor(purple) msize(small)), 
xline(0, lcolor(red) lwidth(medium) lpattern(shortdash))
ylab(1(1)32, nolabels) yscale(reverse) ytitle("") xtitle("Pre-Treatment Trend ('06-'08)", size(medsmall) margin(medsmall)) xlab(-.18(.05).18, labsize(vsmall)) 
legend(rows(2) size(vsmall) label(1 90% CI) label(2 Coefficient)  position(3)) ;


graph save trend_2006.gph, replace;

#delimit;
graph combine ate_2010.gph trend_2006.gph, xcommon ycommon;
graph save combine_ate_pre.gph, replace;
