/*do file name: gender_main.do*/



******************Figure 1*******************
clear
use merge_clean.dta

/*All Streams*/
# delimit ;
twoway kdensity total if gender==1  || kdensity total if gender==0,  
lp(dash)  ||,xtitle("Total score on Mock Exam (April)", size(small)) 
ytitle("Density", size(small)) legend(label(1 "male") label(2 "female") size(vsmall)) title("All Streams", size(small)) scheme(s2mono) xlabel(100(100)700, labsize(small)) ylabel(,labsize(small));
graph save fig1a, replace;

# delimit ;
twoway kdensity gtotal if gender==1  || kdensity gtotal if gender==0,  
lp(dash)  ||,xtitle("Total score on Gaokao (June)", size(small)) 
ytitle("Density", size(small)) legend(label(1 "male") label(2 "female") size(small)) title("All Streams", size(small)) scheme(s2mono) xlabel(100(100)700, labsize(small)) ylabel(,labsize(small));
graph save fig1b, replace;

/*Science Stream*/

# delimit ;
sum total if gender==1 & type==1;
local mmean = r(mean);
sum total if gender==0 & type==1;
local fmean = r(mean);
twoway kdensity total if gender==1 & type==1  || kdensity total if gender==0 & type==1,  
lp(dash)  ||,xtitle("Total score on Mock Exam (April)", size(small)) 
ytitle("Density", size(small)) legend(label(1 "male") label(2 "female") size(small)) scheme(s2mono) xlabel(100(100)700, labsize(small)) ylabel(,labsize(small))
title("Science Stream", size(small));
graph save fig1a_sci, replace;

# delimit ;
sum gtotal if gender==1 & type==1;
local mmean = r(mean);
sum gtotal if gender==0 & type==1;
local fmean = r(mean);
twoway kdensity gtotal if gender==1 & type==1  || kdensity gtotal if gender==0 & type==1,  
lp(dash)  ||,xtitle("Total score on Gaokao (June)", size(small)) 
ytitle("Density", size(small)) legend(label(1 "male") label(2 "female") size(small)) scheme(s2mono) xlabel(100(100)700, labsize(small)) ylabel(,labsize(small))
title("Science Stream", size(small));
graph save fig1b_sci, replace;

/*Arts Stream*/
# delimit ;
sum total if gender==1 & type==0;
local mmean = r(mean);
sum total if gender==0 & type==0;
local fmean = r(mean);
twoway kdensity total if gender==1 & type==0  || kdensity total if gender==0 & type==0,  
lp(dash)  ||,xtitle("Total score on Mock Exam (April)", size(small)) 
ytitle("Density", size(small)) legend(label(1 "male") label(2 "female") size(small)) scheme(s2mono) xlabel(100(100)700, labsize(small)) ylabel(,labsize(small))
title("Arts Stream", size(small));
graph save fig1a_art, replace;

# delimit ;
sum gtotal if gender==1 & type==0;
local mmean = r(mean);
sum gtotal if gender==0 & type==0;
local fmean = r(mean);
twoway kdensity gtotal if gender==1 & type==0  || kdensity gtotal if gender==0 & type==0,  
lp(dash)  ||,xtitle("Total score on Gaokao (June)", size(small)) 
ytitle("Density", size(small)) legend(label(1 "male") label(2 "female") size(small)) scheme(s2mono) xlabel(100(100)700, labsize(small)) ylabel(,labsize(small))
title("Arts Stream", size(small));
graph save fig1b_art, replace;


# delimit ;
grc1leg fig1a.gph fig1b.gph fig1a_sci.gph fig1b_sci.gph fig1a_art.gph fig1b_art.gph, col(2) scheme(s2mono) iscale(0.7) imargin(tiny) ycommon xcommon;
graph export fig1_bytype.tif, replace;


******************Figure 2A*******************
clear
use merge_clean.dta

# delimit ;
graph twoway lowess zdzmath zdzchinese if gender==1 || lowess zdzmath zdzchinese if gender==0,  lp(dash) 
title("Standardized Difference between Gaokao and Mock Exam", size(small)) xtitle("Morning Exam: Chinese", size(small)) ytitle("Afternoon Exam: Math", size(small)) 
xlabel(,labsize(small)) ylabel(,labsize(small)) legend(label(1 "male") label(2 "female")) scheme(s2mono);
graph export F2a.tif, replace;

******************Figure 2B*******************
clear
use merge_clean.dta

# delimit ;
graph twoway lowess zdzmath zdzchinese if gender==1 & cutoff3==1 || lowess zdzmath zdzchinese if gender==0 & cutoff3==1,  lp(dash) 
title("Within (-3,+3) of Reference Cutoff on Mock Exam", size(small)) xtitle("Morning Exam: Chinese", size(small)) ytitle("Afternoon Exam: Math", size(small)) 
xlabel(,labsize(small)) ylabel(,labsize(small)) legend(label(1 "male") label(2 "female") size(small)) scheme(s2mono);
graph save F2a_cutoff3, replace;

# delimit ;
graph twoway lowess zdzmath zdzchinese if gender==1 & cutoff5==1 || lowess zdzmath zdzchinese if gender==0 & cutoff5==1,  lp(dash) 
title("Within (-5,+5) of Reference Cutoff on Mock Exam", size(small)) xtitle("Morning Exam: Chinese", size(small)) ytitle("Afternoon Exam: Math", size(small)) 
xlabel(,labsize(small)) ylabel(,labsize(small)) legend(label(1 "male") label(2 "female")) scheme(s2mono);
graph save F2a_cutoff5, replace;

# delimit ;
graph twoway lowess zdzmath zdzchinese if gender==1 & cutoff610==1 || lowess zdzmath zdzchinese if gender==0 & cutoff610==1,  lp(dash) 
title("Within (-10,-6) & (+6,+10) of Reference Cutoff on Mock Exam", size(small)) xtitle("Morning Exam: Chinese", size(small)) ytitle("Afternoon Exam: Math", size(small)) 
xlabel(,labsize(small)) ylabel(,labsize(small)) legend(label(1 "male") label(2 "female")) scheme(s2mono);
graph save F2a_cutoff610, replace;

# delimit ;
graph twoway lowess zdzmath zdzchinese if gender==1 & cutoff1120==1 || lowess zdzmath zdzchinese if gender==0 & cutoff1120==1,  lp(dash) 
title("Within (-20,-11) & (+11,+20) of Reference Cutoff on Mock Exam", size(small)) xtitle("Morning Exam: Chinese", size(small)) ytitle("Afternoon Exam: Math", size(small)) 
xlabel(,labsize(small)) ylabel(,labsize(small)) legend(label(1 "male") label(2 "female")) scheme(s2mono);
graph save F2a_cutoff1120, replace;

# delimit ;
grc1leg F2a_cutoff3.gph F2a_cutoff5.gph F2a_cutoff610.gph F2a_cutoff1120.gph, iscale(0.8) scheme(s2mono);
graph export F2a_bycutoff.tif, replace;


******************table 1*******************
clear
use merge_clean.dta

set more off

/*table 1 part A full sample*/

foreach var of varlist total chinese math integrate english{
xi: reg zdz`var' female, robust
outreg2 female using t1_a, bdec(3) se br excel append
xi: areg zdz`var' female i.schoolcode month, absorb(postcode) robust
outreg2 female using t1_a, bdec(3) se br excel append
}


/*table 1 part B science stream*/

foreach var of varlist total chinese math integrate english{
xi: reg zdz`var' female if type==1, robust
outreg2 female using t1_b, bdec(3) se br excel append
xi: areg zdz`var' female i.schoolcode month if type==1, absorb(postcode) robust
outreg2 female using t1_b, bdec(3) se br excel append
}

/*table 1 part C arts stream*/

foreach var of varlist total chinese math integrate english{
xi: reg zdz`var' female if type==0, robust
outreg2 female using t1_c, bdec(3) se br excel append
xi: areg zdz`var' female i.schoolcode month if type==0, absorb(postcode) robust
outreg2 female using t1_c, bdec(3) se br excel append
}


******************table 2*******************
clear
use merge_clean.dta

set more off

gen t1 = 0
replace t1 = 1 if total>=540 & type==1
replace t1 = 1 if total>=570 & type==0

gen t2 = 0
replace t2 = 1 if total>=470 & total<540 & type==1
replace t2 = 1 if total>=500 & total<570 & type==0

gen t3 = 0
replace t3 = 1 if total>=420 & total<470 & type==1
replace t3 = 1 if total>=460 & total<500 & type==0

gen t4 = 0
replace t4 = 1 if total>=300 & total<420 & type==1
replace t4 = 1 if total>=340 & total<460 & type==0

gen none = 0
replace none = 1 if total<300 & type==1
replace none = 1 if total<340 & type==0

assert t1+t2+t3+t4+none==1


gen gt1 = 0
replace gt1 = 1 if gtotal>=534 & type==1
replace gt1 = 1 if gtotal>=547 & type==0

gen gt2 = 0
replace gt2 = 1 if gtotal>=471 & gtotal<534 & type==1
replace gt2 = 1 if gtotal>=487 & gtotal<547 & type==0

gen gt3 = 0
replace gt3 = 1 if gtotal>=428 & gtotal<471 & type==1
replace gt3 = 1 if gtotal>=452 & gtotal<487 & type==0

gen gt4 = 0
replace gt4 = 1 if gtotal>=320 & gtotal<428 & type==1
replace gt4 = 1 if gtotal>=332 & gtotal<452 & type==0

gen gnone = 0
replace gnone = 1 if gtotal<320 & type==1
replace gnone = 1 if gtotal<332 & type==0

assert gt1+gt2+gt3+gt4+gnone==1


gen t12 = t1+t2
gen gt12 = gt1+gt2

gen dgt12 = gt12 - t12
gen dgt1 = gt1 - t1
gen dgt2 = gt2 - t2

/*table 2 column (1)*/
capture log close
set logtype text
log using t2_1, replace
sum  t1 t2 t12 
log close

/*table 2 column (2)*/
capture log close
set logtype text
log using t2_2, replace
sum  t1 t2 t12 if female==0
log close


/*table 2 column (3)*/
capture log close
set logtype text
log using t2_2, replace
sum  t1 t2 t12 if female==1
log close

/*table 2 column (4)*/
reg t1 female, robust
outreg2 female using t2_4, se br bdec(3) excel replace
reg t2 female, robust
outreg2 female using t2_4, se br bdec(3) excel append
reg t12 female, robust
outreg2 female using t2_4, se br bdec(3) excel append

/*table 2 column (5)*/
capture log close
set logtype text
log using t2_1, replace
sum  gt1 gt2 gt12 
log close

/*table 2 column (6)*/
capture log close
set logtype text
log using t2_2, replace
sum  gt1 gt2 gt12 if female==0
log close


/*table 2 column (7)*/
capture log close
set logtype text
log using t2_2, replace
sum  gt1 gt2 gt12 if female==1
log close

/*table 2 column (8)*/
reg gt1 female, robust
outreg2 female using t2_8, se br bdec(3) excel replace
reg gt2 female, robust
outreg2 female using t2_8, se br bdec(3) excel append
reg gt12 female, robust
outreg2 female using t2_8, se br bdec(3) excel append

/*table 2 column (9)*/
reg dgt1 female, robust	
outreg2 female using t2_9, se br bdec(3) excel replace
reg dgt2 female, robust	
outreg2 female using t2_9, se br bdec(3) excel append
reg dgt12 female, robust		
outreg2 female using t2_9, se br bdec(3) excel append


/*table 2 column (10)*/
xi: areg dgt1 female i.schoolcode month, absorb(postcode) robust
outreg2 female using t2_10, se br bdec(3) excel replace
xi: areg dgt2 female i.schoolcode month, absorb(postcode) robust
outreg2 female using t2_10, se br bdec(3) excel append
xi: areg dgt12 female i.schoolcode month, absorb(postcode) robust
outreg2 female using t2_10, se br bdec(3) excel append


******************table 3*******************
clear
use merge_clean.dta
set more off

/*table 3 part A total*/
xi: areg zdztotal female i.schoolcode month if cutoff3==1, absorb(postcode) robust
outreg2 female using t3_1, bdec(3) se br excel replace
xi: areg zdztotal female i.schoolcode month if cutoff5==1, absorb(postcode) robust
outreg2 female using t3_1, bdec(3) se br excel append
xi: areg zdztotal female i.schoolcode month if cutoff610==1, absorb(postcode) robust
outreg2 female using t3_1, bdec(3) se br excel append
xi: areg zdztotal female i.schoolcode month if cutoff1115==1, absorb(postcode) robust
outreg2 female using t3_1, bdec(3) se br excel append
xi: areg zdztotal female i.schoolcode month if cutoff1620==1, absorb(postcode) robust
outreg2 female using t3_1, bdec(3) se br excel append
xi: reg zdztotal cutoff3xfemale cutoff3 female i.school*cutoff3 i.cutoff3*month i.postcode*cutoff3 if (cutoff3==1 | cutoff1620==1), robust
outreg2 cutoffxfemale using t3_1, bdec(3) se br excel append

/*table 3 part B,C,D,E*/
set more off
foreach var of varlist chinese math integrate english{
xi: areg zdz`var' female i.schoolcode month if cutoff3==1, absorb(postcode) robust
outreg2 female using t3_2, bdec(3) se br excel append
xi: areg zdz`var' female i.schoolcode month if cutoff5==1, absorb(postcode) robust
outreg2 female using t3_2, bdec(3) se br excel append
xi: areg zdz`var' female i.schoolcode month if cutoff610==1, absorb(postcode) robust
outreg2 female using t3_2, bdec(3) se br excel append
xi: areg zdz`var' female i.schoolcode month if cutoff1115==1, absorb(postcode) robust
outreg2 female using t3_2, bdec(3) se br excel append
xi: areg zdz`var' female i.schoolcode month if cutoff1620==1, absorb(postcode) robust
outreg2 female using t3_2, bdec(3) se br excel append
xi: reg zdz`var' cutoff3xfemale cutoff3 female i.school*cutoff3 i.cutoff3*month i.postcode*cutoff3 if (cutoff3==1 | cutoff1620==1), robust
outreg2 cutoffxfemale using t3_2, bdec(3) se br excel append
}


******************table 4*******************
clear
use merge_clean.dta

bysort gender type: egen meantotal=mean(total)
bysort gender type: egen sdtotal = sd(total)

bysort gender type: egen meangtotal=mean(gtotal)
bysort gender type: egen sdgtotal = sd(gtotal)

bysort type: gen ztotal_f = (total - meantotal)/sdtotal if female==1
bysort type: gen zgtotal_f = (gtotal - meangtotal)/sdgtotal if female==1
bysort type: gen ztotal_m = (total - meantotal)/sdtotal if female==0
bysort type: gen zgtotal_m = (gtotal - meangtotal)/sdgtotal if female==0

tabstat ztotal_f, by(type) statistics(mean sd)
tabstat ztotal_m, by(type) statistics(mean sd)
tabstat zgtotal_f, by(type) statistics(mean sd)
tabstat zgtotal_m, by(type) statistics(mean sd)

gen dztotal_f = zgtotal_f - ztotal_f
gen dztotal_m = zgtotal_m - ztotal_m

egen zdztotal_f = std(dztotal_f)
egen zdztotal_m = std(dztotal_m)

gen zdztotal_fm = .
replace zdztotal_fm = zdztotal_f if female==1
replace zdztotal_fm = zdztotal_m if female==0

gen cutoff3pxfemale=cutoff3p*female
gen cutoff3nxfemale=cutoff3n*female
gen cutoff1115xfemale =cutoff1115*female  
egen postcodexfemale = group(postcode female)


set more off
reg zdztotal_f cutoff3n cutoff3p cutoff410 cutoff1115 if female==1 & (cutoff3==1 | cutoff410==1 | cutoff1120==1), robust
outreg2 using t4, bdec(3) se br excel replace
reg zdztotal_m cutoff3n cutoff3p cutoff410 cutoff1115 if female==0 & (cutoff3==1 | cutoff410==1 | cutoff1120==1), robust
outreg2 using t4, bdec(3) se br excel append
reg zdztotal_fm cutoff3nxfemale cutoff3pxfemale cutoff410xfemale cutoff1115xfemale cutoff3n cutoff3p cutoff410 cutoff1115 female if (cutoff3==1 | cutoff410==1 | cutoff1120==1), robust
outreg2 using t4, bdec(3) se br excel append

**including controls**
xi: areg zdztotal_f cutoff3n cutoff3p cutoff410 cutoff1115 month i.schoolcode if female==1 & (cutoff3==1 | cutoff410==1 | cutoff1120==1), robust absorb(postcode)
outreg2 using t4, bdec(3) se br excel append
xi: areg zdztotal_m cutoff3n cutoff3p cutoff410 cutoff1115 month i.schoolcode if female==0 & (cutoff3==1 | cutoff410==1 | cutoff1120==1), robust absorb(postcode)
outreg2 using t4, bdec(3) se br excel append
xi: areg zdztotal_fm cutoff3nxfemale cutoff3pxfemale cutoff410xfemale cutoff1115xfemale cutoff3n cutoff3p cutoff410 cutoff1115 i.female*month i.female*i.schoolcode if (cutoff3==1 | cutoff410==1 | cutoff1120==1), robust absorb(postcodexfemale)
outreg2 using t4, bdec(3) se br excel append


******************table 5*******************
clear
use merge_clean.dta

foreach var of varlist chinese math integrate english{
gen femalexzdz`var' = female*zdz`var'
}

foreach var of varlist chinese math integrate english{
gen femalexzg`var' = female*zg`var'
}

egen postcodexfemale = group(postcode female)

set more off
xi: areg zdzmath femalexzdzchinese zdzchinese female i.schoolcode month, absorb(postcode) robust
outreg2 femalexzdzchinese zdzchinese female using t5, bdec(3) se br excel replace
xi: areg zdzmath femalexzdzchinese zdzchinese female i.schoolcode*female i.female*month, absorb(postcodexfemale) robust
outreg2 femalexzdzchinese zdzchinese female  using t5, bdec(3) se br excel append

xi: areg zdzmath femalexzdzchinese zdzchinese female i.schoolcode*female i.female*month if cutoff3==1, absorb(postcodexfemale) robust
outreg2 femalexzdzchinese zdzchinese female  using t5, bdec(3) se br excel append
xi: areg zdzmath femalexzdzchinese zdzchinese female i.schoolcode*female i.female*month if cutoff5==1, absorb(postcodexfemale) robust
outreg2 femalexzdzchinese zdzchinese female  using t5, bdec(3) se br excel append
xi: areg zdzmath femalexzdzchinese zdzchinese female i.schoolcode*female i.female*month if cutoff610==1, absorb(postcodexfemale) robust
outreg2 femalexzdzchinese zdzchinese female  using t5, bdec(3) se br excel append
xi: areg zdzmath femalexzdzchinese zdzchinese female i.schoolcode*female i.female*month if cutoff1120==1, absorb(postcodexfemale) robust
outreg2 femalexzdzchinese zdzchinese female  using t5, bdec(3) se br excel append
******************************************************************************************************
************************************END***************************************************************
******************************************************************************************************

