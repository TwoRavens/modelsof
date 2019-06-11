
*************************************************************
* Political representation and effects of municipal mergers *
* Harjunen, Saarimaa & Tukiainen                            *
* Main text                                                 *
*************************************************************

clear all
global data : pwd

log using "$data\HST_PSRM_log", replace

*Figure 1
use "$data\fig1data.dta", clear

la var number "Number of municipalties"
la var year "Year"

twoway line number year if year>1979, graphregion(color(white)) xline(2008 2009, lcolor(black)) ylabel(250(50)500) xlabel(1980(10)2020)

*Table 1
use "$data\merger_level_data_PSRM.dta", clear

global desc "cosize copop comeddist3 coexpenpc conetexpenpc cotaxrate coinctaxbasepc cograntspc cocoop subsidypc colhprice"

sum $desc if year==2006 & merger==1
sum $desc if year==2006 & merger==0

ttest copop if year==2006, by(merger) 
ttest comeddist3 if year==2006, by(merger) 
ttest coexpenpc if year==2006, by(merger) 
ttest conetexpenpc if year==2006, by(merger) 
ttest cotaxrate if year==2006, by(merger) 
ttest coinctaxbasepc if year==2006, by(merger) 
ttest cograntspc if year==2006, by(merger) 
ttest cocoop if year==2006, by(merger) 
ttest subsidypc if year==2006, by(merger) 
ttest colhprice if year==2006, by(merger) 

*Table 2
use "$data\municipality_level_data_PSRM.dta", clear

global treat "seatsha08 population popshadesc" 
global outcomes "gov_jobspc school_jobspc health_jobspc oth_jobspc"

sum $treat $outcomes if treatgroup==0 & year==2007
sum $treat $outcomes if treatgroup==3 & year==2007
sum $treat $outcomes if treatgroup==2 & year==2007
sum $treat $outcomes if treatgroup==1 & year==2007

*Figure 2
use "$data\merger_level_data_PSRM.dta", clear

by year merger, sort: egen expenmean=mean(coexpenpc)
by year merger, sort: egen nexpenmean=mean(conetexpenpc)
by year merger, sort: egen taxratemean=mean(cotaxrate)
by year merger, sort: egen lhpricemean=mean(colhprice)

gen expenmean0=expenmean
gen expenmean1=expenmean

gen nexpenmean0=nexpenmean
gen nexpenmean1=nexpenmean

gen taxratemean0=taxratemean
gen taxratemean1=taxratemean

gen lhpricemean0=lhpricemean
gen lhpricemean1=lhpricemean

la var expenmean0 "No merger"
la var expenmean1 "Merger"

la var nexpenmean0 "No merger"
la var nexpenmean1 "Merger"

la var taxratemean0 "No merger"
la var taxratemean1 "Merger"

la var lhpricemean0 "No merger"
la var lhpricemean1 "Merger"

global cond0 "if merger==0"
global cond1 "if merger==1"

global figspecexp "xline(2008.5, lcolor(blue)) xline(2013.5, lcolor(red)) mcolor(black) connect(l) lpattern(dash) lcolor(black) msize(large) xlabel(2000(2)2016, angle(45)) ylabel(2000(2000)7000) ytitle(Expenditures) xtitle("") legend(size(small))"
global figspecnetexp "xline(2008.5, lcolor(blue)) xline(2013.5, lcolor(red)) mcolor(black) connect(l) lpattern(dash) lcolor(black) msize(large) xlabel(2000(2)2016, angle(45)) ylabel(-2500(1000)-6000) ytitle(Operating margin) xtitle("") legend(size(small))"
global figspectaxrate "xline(2008.5, lcolor(blue)) xline(2013.5, lcolor(red)) mcolor(black) connect(l) lpattern(dash) lcolor(black) msize(large) xlabel(2000(2)2016, angle(45)) ylabel(16(2)22) ytitle(Tax rate) xtitle("") legend(size(small))"
global figspectotlhprice "xline(2008.5, lcolor(blue)) xline(2013.5, lcolor(red)) mcolor(black) connect(l) lpattern(dash) lcolor(black) msize(large) xlabel(2000(2)2016, angle(45)) ylabel(6.4(0.4)7.6) ytitle(Log house price) xtitle("") legend(size(small))"

twoway (scatter expenmean0 year $cond0, $figspecexp msymbol(x)) /// 
(scatter expenmean1 year $cond1, $figspecexp msymbol(o) graphregion(color(white)))
graph save Graph "$data\exp.gph", replace

twoway (scatter nexpenmean0 year $cond0, $figspecnetexp msymbol(x)) ///
(scatter nexpenmean1 year $cond1, $figspecnetexp msymbol(o) graphregion(color(white)))
graph save Graph "$data\netexp.gph", replace

twoway (scatter taxratemean0 year $cond0, $figspectaxrate msymbol(x)) ///
(scatter taxratemean1 year $cond1, $figspectaxrate msymbol(o) graphregion(color(white)))
graph save Graph "$data\taxrate.gph", replace

twoway (scatter lhpricemean0 year $cond0, $figspectotlhprice msymbol(x)) ///
(scatter lhpricemean1 year $cond1, $figspectotlhprice msymbol(o) graphregion(color(white)))
graph save Graph "$data\lhprice.gph", replace

grc1leg "$data\exp.gph" "$data\netexp.gph" "$data\taxrate.gph" "$data\lhprice.gph", graphregion(color(white))

*Table 3
use "$data\merger_level_data_PSRM.dta", clear

global tab "se(%9.3f) b(%9.3f) r2(%9.3f) nogaps star(* 0.05 ** 0.01) mtitles brackets order(_cons)"
global did "merger mergery09 mergery10 mergery11 mergery12 mergery13 mergery14 mergery15 mergery16" 

est clear
regress coexpenpc y2001-y2016 $did, cluster(coid)
est sto exp1
regress conetexpenpc y2001-y2016 $did, cluster(coid)
est sto netexp1
regress cotaxrate y2001-y2016 $did, cluster(coid)
est sto tax1
regress colhprice y2001-y2016 $did, cluster(coid)
est sto price1
esttab exp1 netexp1 tax1 price1, $tab keep(_cons $did)

global tab "se(%9.2f) b(%9.2f) r2(%9.2f) nogaps star(* 0.05 ** 0.01) mtitles brackets order(_cons)"
esttab exp1 netexp1, $tab keep(_cons $did)
global tab "se(%9.3f) b(%9.3f) r2(%9.2f) nogaps star(* 0.05 ** 0.01) mtitles brackets order(_cons)"
esttab tax1 price1, $tab keep(_cons $did)

*Figure 3
*Left panel
use "$data\municipality_level_data_PSRM.dta", clear

by year treatgroup, sort: egen meangovg=mean(gov_jobspc)
by year treatgroup, sort: egen meanschoolg=mean(school_jobspc)
by year treatgroup, sort: egen meanhealthg=mean(health_jobspc)

global cond0 "if treatgroup==0"
global cond1 "if treatgroup==1"
global cond2 "if treatgroup==2"
global cond3 "if treatgroup==3"

gen meangovg0=meangovg
gen meangovg1=meangovg
gen meangovg2=meangovg
gen meangovg3=meangovg

gen meanschoolg0=meanschoolg
gen meanschoolg1=meanschoolg
gen meanschoolg2=meanschoolg
gen meanschoolg3=meanschoolg

gen meanhealthg0=meanhealthg
gen meanhealthg1=meanhealthg
gen meanhealthg2=meanhealthg
gen meanhealthg3=meanhealthg

la var meangovg0 "No merger"
la var meangovg1 "Strong"
la var meangovg2 "Medium"
la var meangovg3 "Weak"

la var meanschoolg0 "No merger"
la var meanschoolg1 "Strong"
la var meanschoolg2 "Medium"
la var meanschoolg3 "Weak"

la var meanhealthg0 "No merger"
la var meanhealthg1 "Strong"
la var meanhealthg2 "Medium"
la var meanhealthg3 "Weak"

global figspecgov "xline(2008.5, lcolor(blue)) xline(2013.5) connect(l) lpattern(dash) mcolor(black) lcolor(black) msize(large) xlabel(2000(1)2015, angle(45)) ylabel(0(0.01)0.03) ytitle(Administration and defence) xtitle("") legend(size(small))"
global figspecschool "xline(2008.5, lcolor(blue)) xline(2013.5) connect(l) lpattern(dash) mcolor(black) lcolor(black) msize(large) xlabel(2000(1)2015, angle(45)) ylabel(0(0.01)0.05) ytitle(Schooling) xtitle("") legend(size(small))"
global figspechealth "xline(2008.5, lcolor(blue)) xline(2013.5) connect(l) lpattern(dash) mcolor(black) lcolor(black) msize(large) xlabel(2000(1)2015, angle(45)) ylabel(0(0.02)0.1) ytitle(Health and social care) xtitle("") legend(size(small))"

twoway (scatter meangovg0 year $cond0, $figspecgov msymbol(x)) ///
(scatter meangovg1 year $cond1, $figspecgov msymbol(o)) ///
(scatter meangovg2 year $cond2, $figspecgov msymbol(oh)) ///
(scatter meangovg3 year $cond3, $figspecgov msymbol(d) graphregion(color(white))) 
graph save Graph "$data\govgL.gph", replace

twoway (scatter meanhealthg0 year $cond0, $figspechealth msymbol(x)) ///
(scatter meanhealthg1 year $cond1, $figspechealth msymbol(o)) ///
(scatter meanhealthg2 year $cond2, $figspechealth msymbol(oh)) ///
(scatter meanhealthg3 year $cond3, $figspechealth msymbol(d) graphregion(color(white))) 
graph save Graph "$data\healthgL.gph", replace

twoway (scatter meanschoolg0 year $cond0, $figspecschool msymbol(x)) ///
(scatter meanschoolg1 year $cond1, $figspecschool msymbol(o)) ///
(scatter meanschoolg2 year $cond2, $figspecschool msymbol(oh)) ///
(scatter meanschoolg3 year $cond3, $figspecschool msymbol(d) graphregion(color(white))) 
graph save Graph "$data\schoolgL.gph", replace

*Right panel
use "$data\municipality_level_data_PSRM.dta", clear

by year treatgpop, sort: egen meangovg=mean(gov_jobspc)
by year treatgpop, sort: egen meanschoolg=mean(school_jobspc)
by year treatgpop, sort: egen meanhealthg=mean(health_jobspc)

gen meangovg1=meangovg
gen meangovg2=meangovg
gen meangovg3=meangovg

gen meanschoolg1=meanschoolg
gen meanschoolg2=meanschoolg
gen meanschoolg3=meanschoolg

gen meanhealthg1=meanhealthg
gen meanhealthg2=meanhealthg
gen meanhealthg3=meanhealthg

global condpop1 "if treatgpop==1"
global condpop2 "if treatgpop==2"
global condpop3 "if treatgpop==3"

la var meangovg1 "Strong"
la var meangovg2 "Medium"
la var meangovg3 "Weak"

la var meanschoolg1 "Strong"
la var meanschoolg2 "Medium"
la var meanschoolg3 "Weak"

la var meanhealthg1 "Strong"
la var meanhealthg2 "Medium"
la var meanhealthg3 "Weak"

global figspecgov "xline(2008.5, lcolor(blue)) xline(2013.5) connect(l) lpattern(dash) mcolor(black) lcolor(black) msize(large) xlabel(2000(1)2015, angle(45)) ylabel(0(0.01)0.03) ytitle(Administration and defence) xtitle("") legend(size(small))"
global figspecschool "xline(2008.5, lcolor(blue)) xline(2013.5) connect(l) lpattern(dash) mcolor(black) lcolor(black) msize(large) xlabel(2000(1)2015, angle(45)) ylabel(0(0.01)0.05) ytitle(Schooling) xtitle("") legend(size(small))"
global figspechealth "xline(2008.5, lcolor(blue)) xline(2013.5) connect(l) lpattern(dash) mcolor(black) lcolor(black) msize(large) xlabel(2000(1)2015, angle(45)) ylabel(0(0.02)0.1) ytitle(Health and social care) xtitle("") legend(size(small))"

twoway (scatter meangovg1 year $condpop1, $figspecgov msymbol(o)) ///
(scatter meangovg2 year $condpop2, $figspecgov msymbol(oh)) ///
(scatter meangovg3 year $condpop3, $figspecgov msymbol(d) graphregion(color(white))) 
graph save Graph "$data\govgR.gph", replace

twoway (scatter meanhealthg1 year $condpop1, $figspechealth msymbol(o)) ///
(scatter meanhealthg2 year $condpop2, $figspechealth msymbol(oh)) ///
(scatter meanhealthg3 year $condpop3, $figspechealth msymbol(d) graphregion(color(white))) 
graph save Graph "$data\healthgR.gph", replace

twoway (scatter meanschoolg1 year $condpop1, $figspecschool msymbol(o)) ///
(scatter meanschoolg2 year $condpop2, $figspecschool msymbol(oh)) ///
(scatter meanschoolg3 year $condpop3, $figspecschool msymbol(d) graphregion(color(white))) 
graph save Graph "$data\schoolgR.gph", replace

*Table 4
use "$data\municipality_level_data_PSRM.dta", clear

global tab "se(%9.3f) b(%9.3f) r2(%9.3f) nogaps star(* 0.05 ** 0.01) mtitles brackets order(_cons)"
global did "merger seatsha08 mer2009 mer2010 mer2012 mer2014 mer2015 merseat2009 merseat2010 merseat2012 merseat2014 merseat2015" 

est clear
xi: ivreg2 gov_jobspc i.year $did, cluster(coid kuntaid)
est sto govpc
xi: ivreg2 school_jobspc i.year $did, cluster(coid kuntaid)
est sto schoolpc
xi: ivreg2 health_jobspc i.year $did, cluster(coid kuntaid)
est sto healthpc
esttab govpc schoolpc healthpc, $tab keep(_cons $did)

*Figure 4
use "$data\municipality_level_data_PSRM.dta", clear

*combine weak and medium groups
replace treatgroup=2 if treatgroup==3
replace treatgpop=2 if treatgpop==3

by year treatgroup, sort: egen lhpricemeang=mean(logmunsqprice)
by year treatgpop, sort: egen lhpricemeanpop=mean(logmunsqprice)

global cond0 "if treatgroup==0"
global cond1 "if treatgroup==1"
global cond2 "if treatgroup==2"

global condpop1 "if treatgpop==1"
global condpop2 "if treatgpop==2 | treatgpop==3"

gen lhpricemeang0=lhpricemeang
gen lhpricemeang1=lhpricemeang
gen lhpricemeang2=lhpricemeang

gen lhpricemeangpop1=lhpricemeanpop
gen lhpricemeangpop2=lhpricemeanpop
gen lhpricemeangpop3=lhpricemeanpop

la var lhpricemeang0 "No merger"
la var lhpricemeang1 "Strong"
la var lhpricemeang2 "Medium + Weak"

la var lhpricemeangpop1 "Strong"
la var lhpricemeangpop2 "Medium + Weak"

global figspeclog "xline(2008.5, lcolor(blue)) xline(2013.5) mcolor(black) connect(l) lpattern(dash) lcolor(black) msize(large) xlabel(2000(1)2015, angle(45)) ylabel(6.4(0.4)7.6) ytitle(Log house price) xtitle("") legend(size(small))"

*Left panel
twoway (scatter lhpricemeang0 year $cond0, $figspeclog msymbol(x)) ///
(scatter lhpricemeang1 year $cond1, $figspeclog msymbol(o)) ///
(scatter lhpricemeang2 year $cond2, $figspeclog msymbol(oh) graphregion(color(white)))
graph save Graph "$data\priceL.gph", replace

*Right panel
twoway (scatter lhpricemeangpop1 year $condpop1, $figspeclog msymbol(o)) ///
(scatter lhpricemeangpop2 year $condpop2, $figspeclog msymbol(oh) graphregion(color(white))) 
graph save Graph "$data\priceR.gph", replace

log close
