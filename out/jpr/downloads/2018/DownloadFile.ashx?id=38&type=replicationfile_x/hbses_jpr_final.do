*REPLICATION DO FOR BARTUSEVICIUS AND SKAANING (2018) REVISITING DEMOCRATIC CIVIL PEACE. JOURNAL OF PEACE RESEARCH 55(5)
*The file needed for the replication analysis below is in the downloaded replication folder. 
*To directly run the analysis, keep this file together with the current do-file in the same folder.  
log using "hbses_jpr.txt", text replace
clear
version 14.2
set more off

*Load the main dataset
use "hbses_jpr_final.dta", clear

*Write out Table I
gen period = 0
replace period = 1 if year < 1881
replace period = 2 if year < 1946 & year > 1880
replace period = 3 if year > 1945
label define period 1 "1817-1880" 2 "1881-1945" 3 "1946-2006"
estpost tabulate lied4 cow_cw_on if period == 1
est store c1
estpost tabulate lied4 cow_cw_on if period == 2
est store c2
estpost tabulate lied4 cow_cw_on if period == 3
est store c3
estpost tabulate lied4 cow_cw_on
est store c4
esttab c1 c2 c3 c4 using tables.rtf, cell(b) unstack nonumbers nogap noobs nomtitle collabels(none) replace ///
coeflabel (0 "L0" 1 "L1" 2 "L2" 3 "L3" 4 "L4") drop("Total") ///
mlabels ("1817-1880" "1881-1945" "1946-2006" "1817-2006") ///
title ("Table I. Cross-tabulation: LIED and Civil War by historical periods")

*Write out Table OA1
estpost summarize cow_cw_on ucdp_cw_on ucdp_mac_on lied4 lnpop lngdp_pc lnigdp_pc gdp_pc_g igdp_pc_g oil_income /// 
cinc_a lnmilper polity2 instability3 instability cdem03 caut03 cdem caut mgini_intx ethfrac max_rdiscl NHIxl
esttab using online_appendix.rtf, cells("count mean sd min max") nonumbers noobs nomtitle replace ///
coeflabel (cow_cw_on "COW civil war" ucdp_cw_on "UCDP/PRIO civil war"  ucdp_mac_on "UCDP/PRIO minor armed conflict" ///
lied4 "LIED" lnpop "Population" lngdp_pc "GDP/capita" lnigdp_pc "GDP/capita(ipol)" gdp_pc_g "GDP growth" ///
igdp_pc_g "GDP growth(ipol)" oil_income "Oil income" cinc_a "CINC" lnmilper "Personnel" polity2 "Polity2" ///
instability3 "Instability(3y)" instability "Instability" cdem03 "Democratization(3y)" ///
caut03 "Autocratization(3y)" cdem "Democratization" caut "Autocratization" mgini_intx "Gini" ///
ethfrac "Fractionalization" max_rdiscl "Max discrimination" NHIxl "Max low ratio") ///
title ("Table OA1. Summary statistics")

*Test for collinearity
collin cow_cw_on lied4 lngdp_pc gdp_pc_g oil_income cinc_a polity2 instability3 lnpop 


*Main analyses

*1817-2016
logit cow_cw_on l.lied4 lnpop peaceyrs_cow peaceyrs_cow_2 peaceyrs_cow_3
estimates store m1
logit cow_cw_on l.lied4 l.lnigdp_pc lnpop peaceyrs_cow peaceyrs_cow_2 peaceyrs_cow_3
estimates store m2
logit cow_cw_on l.lied4 l.lnigdp_pc l.igdp_pc_g lnpop peaceyrs_cow peaceyrs_cow_2 peaceyrs_cow_3
estimates store m3
logit cow_cw_on l.lied4 l.lnigdp_pc l.igdp_pc_g l.oil_income lnpop peaceyrs_cow peaceyrs_cow_2 peaceyrs_cow_3
estimates store m4
logit cow_cw_on l.lied4 l.lnigdp_pc l.igdp_pc_g l.oil_income l.cinc_a lnpop peaceyrs_cow peaceyrs_cow_2 peaceyrs_cow_3
estimates store m5
*Alternative capacity measure (not reported)
logit cow_cw_on l.lied4 l.lnigdp_pc l.igdp_pc_g l.oil_income l.lnmilper lnpop peaceyrs_cow peaceyrs_cow_2 peaceyrs_cow_3
*Results: Same
logit cow_cw_on l.lied4 l.lnigdp_pc l.igdp_pc_g l.oil_income l.cinc_a l.polity2 lnpop peaceyrs_cow peaceyrs_cow_2 peaceyrs_cow_3
estimates store m6
logit cow_cw_on l.lied4 l.lnigdp_pc l.igdp_pc_g l.oil_income l.cinc_a l.polity2 l.instability3 lnpop peaceyrs_cow peaceyrs_cow_2 peaceyrs_cow_3
estimates store m7
*Alternative instability measure (not reported)
logit cow_cw_on l.lied4 l.lnigdp_pc l.igdp_pc_g l.oil_income l.cinc_a l.polity2 l.instability lnpop peaceyrs_cow peaceyrs_cow_2 peaceyrs_cow_3
*Results: Same
logit cow_cw_on i.l.lied4 l.lnigdp_pc l.igdp_pc_g l.oil_income l.cinc_a l.polity2 l.instability3 lnpop peaceyrs_cow peaceyrs_cow_2 peaceyrs_cow_3
estimates store m8
*Increasing analysis N
logit cow_cw_on l.lied4 l.oil_income l.cinc_a l.polity2 l.instability3 lnpop peaceyrs_cow peaceyrs_cow_2 peaceyrs_cow_3
estimates store m9
logit cow_cw_on i.l.lied4 l.oil_income l.cinc_a l.polity2 l.instability3 lnpop peaceyrs_cow peaceyrs_cow_2 peaceyrs_cow_3
estimates store m10

*Write out Table II
esttab m1 m2 m3 m4 m5 m6 m7 m8 m9 m10 using tables.rtf, star(+ 0.10 * 0.05 ** 0.01 *** 0.001) se b(%9.2f) scalars(chi2) nogaps onecell unstack append ///
nodepvars nonumbers eqlabels(none) coeflabels(L.lied4 "LIED" 1L.lied4 "L1" 2L.lied4 "L2" 3L.lied4 "L3" 4L.lied4 "L4" lnpop "Population" ///
L.lnigdp_pc "GDP/capita(ipol)" L.igdp_pc_g "GDP growth(ipol)" L.oil_income "Oil income" L.cinc_a "CINC" L.polity2 "Polity2" L.instability3 "Instability(3y)" /// 
_cons Constant) drop(0bL.lied4 peaceyrs_cow peaceyrs_cow_2 peaceyrs_cow_3) addnotes ("Peace years with time polynomials not reported") ///
title ("Table II. Logistic regression estimates of civil war onset: 1817-2006")

*Testing H1a-H1e
logit cow_cw_on b0.l.lied4 l.lnigdp_pc l.igdp_pc_g l.oil_income l.cinc_a l.polity2 l.instability3 lnpop peaceyrs_cow peaceyrs_cow_2 peaceyrs_cow_3
logit cow_cw_on b1.l.lied4 l.lnigdp_pc l.igdp_pc_g l.oil_income l.cinc_a l.polity2 l.instability3 lnpop peaceyrs_cow peaceyrs_cow_2 peaceyrs_cow_3
logit cow_cw_on b2.l.lied4 l.lnigdp_pc l.igdp_pc_g l.oil_income l.cinc_a l.polity2 l.instability3 lnpop peaceyrs_cow peaceyrs_cow_2 peaceyrs_cow_3
logit cow_cw_on b3.l.lied4 l.lnigdp_pc l.igdp_pc_g l.oil_income l.cinc_a l.polity2 l.instability3 lnpop peaceyrs_cow peaceyrs_cow_2 peaceyrs_cow_3
*Create m11 in Table II and add coeficients for particular levels
*Increasing analysis N (not reported)
logit cow_cw_on b0.l.lied4 l.oil_income l.cinc_a l.polity2 l.instability3 lnpop peaceyrs_cow peaceyrs_cow_2 peaceyrs_cow_3
logit cow_cw_on b1.l.lied4 l.oil_income l.cinc_a l.polity2 l.instability3 lnpop peaceyrs_cow peaceyrs_cow_2 peaceyrs_cow_3
logit cow_cw_on b2.l.lied4 l.oil_income l.cinc_a l.polity2 l.instability3 lnpop peaceyrs_cow peaceyrs_cow_2 peaceyrs_cow_3
logit cow_cw_on b3.l.lied4 l.oil_income l.cinc_a l.polity2 l.instability3 lnpop peaceyrs_cow peaceyrs_cow_2 peaceyrs_cow_3
*Results: stronger


*Robustness analyses

*1946-2006
logit cow_cw_on l.lied4 l.lngdp_pc l.gdp_pc_g l.oil_income l.cinc_a l.polity2 l.instability3 lnpop peaceyrs_cow1946 peaceyrs_cow1946_2 peaceyrs_cow1946_3
estimates store m12
logit cow_cw_on i.l.lied4 l.lngdp_pc l.gdp_pc_g l.oil_income l.cinc_a l.polity2 l.instability3 lnpop peaceyrs_cow1946 peaceyrs_cow1946_2 peaceyrs_cow1946_3
estimates store m13
logit cow_cw_on l.lied4 l.lngdp_pc l.gdp_pc_g l.oil_income l.cinc_a l.polity2 l.instability3 l.mgini_intx ethfrac l.max_rdiscl l.NHIxl lnpop peaceyrs_cow1946 peaceyrs_cow1946_2 peaceyrs_cow1946_3
estimates store m14
logit cow_cw_on i.l.lied4 l.lngdp_pc l.gdp_pc_g l.oil_income l.cinc_a l.polity2 l.instability3 l.mgini_intx ethfrac l.max_rdiscl l.NHIxl lnpop peaceyrs_cow1946 peaceyrs_cow1946_2 peaceyrs_cow1946_3
estimates store m15

*Write out Table OA2
esttab m12 m13 m14 m15 using online_appendix.rtf, star(+ 0.10 * 0.05 ** 0.01 *** 0.001) se b(%9.2f) scalars(chi2) nogaps onecell unstack append ///
nodepvars nonumbers eqlabels(none) coeflabels(L.lied4 "LIED" 1L.lied4 "L1" 2L.lied4 "L2" 3L.lied4 "L3" 4L.lied4 "L4" lnpop "Population" /// 
L.lngdp_pc "GDP/capita" L.gdp_pc_g "GDP growth" L.oil_income "Oil income" L.cinc_a "CINC" L.polity2 "Polity2" L.instability3 "Instability(3y)" /// 
L.mgini_intx "Gini" ethfrac "Fractionalization" L.max_rdiscl "Max discrimination" L.NHIxl "Max low ratio"_cons Constant) /// 
drop(0bL.lied4 peaceyrs_cow1946 peaceyrs_cow1946_2 peaceyrs_cow1946_3) addnotes ("Peace years with time polynomials not reported") ///
title ("Table OA2. Logistic regression estimates of civil war onset: 1946-2006")

*Testing H1a-H1e
logit cow_cw_on b0.l.lied4 l.lngdp_pc l.gdp_pc_g l.oil_income l.cinc_a l.polity2 l.instability3 l.mgini_intx ethfrac l.max_rdiscl l.NHIxl lnpop peaceyrs_cow1946 peaceyrs_cow1946_2 peaceyrs_cow1946_3
logit cow_cw_on b1.l.lied4 l.lngdp_pc l.gdp_pc_g l.oil_income l.cinc_a l.polity2 l.instability3 l.mgini_intx ethfrac l.max_rdiscl l.NHIxl lnpop peaceyrs_cow1946 peaceyrs_cow1946_2 peaceyrs_cow1946_3
logit cow_cw_on b2.l.lied4 l.lngdp_pc l.gdp_pc_g l.oil_income l.cinc_a l.polity2 l.instability3 l.mgini_intx ethfrac l.max_rdiscl l.NHIxl lnpop peaceyrs_cow1946 peaceyrs_cow1946_2 peaceyrs_cow1946_3
logit cow_cw_on b3.l.lied4 l.lngdp_pc l.gdp_pc_g l.oil_income l.cinc_a l.polity2 l.instability3 l.mgini_intx ethfrac l.max_rdiscl l.NHIxl lnpop peaceyrs_cow1946 peaceyrs_cow1946_2 peaceyrs_cow1946_3
*Create m16 in Table II and add coeficients for particular levels

*Alternative measures of instability (not reported)
logit cow_cw_on l.lied4 cdem03 caut03 l.lnigdp_pc l.igdp_pc_g l.oil_income l.cinc_a l.polity2 l.mgini_intx ethfrac l.max_rdiscl l.NHIxl lnpop epeaceyrs_cow1946, robust
logit cow_cw_on i.l.lied4 cdem03 caut03 l.lnigdp_pc l.igdp_pc_g l.oil_income l.cinc_a l.polity2 l.mgini_intx ethfrac l.max_rdiscl l.NHIxl lnpop epeaceyrs_cow1946, robust
logit cow_cw_on l.lied4 cdem caut l.lnigdp_pc l.igdp_pc_g l.oil_income l.cinc_a l.polity2 l.mgini_intx ethfrac l.max_rdiscl l.NHIxl lnpop epeaceyrs_cow1946, robust
logit cow_cw_on i.l.lied4 cdem caut l.lnigdp_pc l.igdp_pc_g l.oil_income l.cinc_a l.polity2 l.mgini_intx ethfrac l.max_rdiscl l.NHIxl lnpop epeaceyrs_cow1946, robust

*Create Figure 1
*Interval
*1817-2006
logit cow_cw_on l_lied4 l.oil_income l.cinc_a l.polity2 l.instability3 lnpop peaceyrs_cow peaceyrs_cow_2 peaceyrs_cow_3
margins, atmeans at(l_lied4=(0(1)4)) level(95)
marginsplot, scheme(s1mono) title("Full sample") ytitle("") xtitle(LIED) recastci(rarea) ciopts(fcolor(gs13) lcolor(gs13)) recast(line)
graph save first, replace
*1946-2006
logit cow_cw_on l_lied4 l.lngdp_pc l.gdp_pc_g l.oil_income l.cinc_a l.polity2 l.instability3 l.mgini_intx ethfrac l.max_rdiscl l.NHIxl lnpop peaceyrs_cow1946 peaceyrs_cow1946_2 peaceyrs_cow1946_3
margins, atmeans at(l_lied4=(0(1)4)) level(95)
marginsplot, scheme(s1mono) title("Post-1945") ytitle("") xtitle(LIED) recastci(rarea) ciopts(fcolor(gs13) lcolor(gs13)) recast(line)
graph save second, replace

*Dummy
*1817-2006
logit cow_cw_on i.l_lied4 l.oil_income l.cinc_a l.polity2 l.instability3 lnpop peaceyrs_cow peaceyrs_cow_2 peaceyrs_cow_3
margins, atmeans at(l_lied4=(0(1)4)) level(95)
marginsplot, scheme(s1mono) title("") ytitle("") xtitle(LIED) recastci(rarea) ciopts(fcolor(gs13) lcolor(gs13)) recast(line)
graph save third, replace
*1946-2006
logit cow_cw_on i.l_lied4 l.lngdp_pc l.gdp_pc_g l.oil_income l.cinc_a l.polity2 l.instability3 l.mgini_intx ethfrac l.max_rdiscl l.NHIxl lnpop peaceyrs_cow1946 peaceyrs_cow1946_2 peaceyrs_cow1946_3
margins, atmeans at(l_lied4=(0(1)4)) level(95)
marginsplot, scheme(s1mono) title("") ytitle("") xtitle(LIED) recastci(rarea) ciopts(fcolor(gs13) lcolor(gs13)) recast(line)
graph save fourth, replace
graph combine first.gph second.gph third.gph fourth.gph, ycommon ysize(10) xsize(12) scheme(s1mono) iscale(0.5)

*Alternative DVs
*UCDP/PRIO war
logit ucdp_cw_on l.lied4 l.lngdp_pc l.gdp_pc_g l.oil_income l.cinc_a l.polity2 l.instability3 l.mgini_intx ethfrac l.max_rdiscl l.NHIxl lnpop peaceyrs_ucdp_mac peaceyrs_ucdp_mac_2 peaceyrs_ucdp_mac_3
estimates store m17
logit ucdp_cw_on i.l.lied4 l.lngdp_pc l.gdp_pc_g l.oil_income l.cinc_a l.polity2 l.instability3 l.mgini_intx ethfrac l.max_rdiscl l.NHIxl lnpop peaceyrs_ucdp_mac peaceyrs_ucdp_mac_2 peaceyrs_ucdp_mac_3
estimates store m18
*UCDP/PRIO minor
logit ucdp_mac_on l.lied4 l.lngdp_pc l.gdp_pc_g l.oil_income l.cinc_a l.polity2 l.instability3 l.mgini_intx ethfrac l.max_rdiscl l.NHIxl lnpop peaceyrs_ucdp_mac peaceyrs_ucdp_mac_2 peaceyrs_ucdp_mac_3
estimates store m20
logit ucdp_mac_on i.l.lied4 l.lngdp_pc l.gdp_pc_g l.oil_income l.cinc_a l.polity2 l.instability3 l.mgini_intx ethfrac l.max_rdiscl l.NHIxl lnpop peaceyrs_ucdp_mac peaceyrs_ucdp_mac_2 peaceyrs_ucdp_mac_3
estimates store m21
*UCDP/PRIO war governmental
logit ucdp_cw_gov_on l.lied4 l.lngdp_pc l.gdp_pc_g l.oil_income l.cinc_a l.polity2 l.instability3 l.mgini_intx ethfrac l.max_rdiscl l.NHIxl lnpop peaceyrs_ucdp_mac peaceyrs_ucdp_mac_2 peaceyrs_ucdp_mac_3
estimates store m17g
logit ucdp_cw_gov_on i.l.lied4 l.lngdp_pc l.gdp_pc_g l.oil_income l.cinc_a l.polity2 l.instability3 l.mgini_intx ethfrac l.max_rdiscl l.NHIxl lnpop peaceyrs_ucdp_mac peaceyrs_ucdp_mac_2 peaceyrs_ucdp_mac_3
estimates store m18g

*Write out Table OA3
esttab m17 m18 m20 m21 m17g m18g using online_appendix.rtf, star(+ 0.10 * 0.05 ** 0.01 *** 0.001) se b(%9.2f) scalars(chi2) nogaps onecell unstack append ///
nodepvars nonumbers eqlabels(none) coeflabels(l.lied4 "LIED" 1L.lied4 "L1" 2L.lied4 "L2" 3L.lied4 "L3" 4L.lied4 "L4" lnpop "Population" /// 
L.lngdp_pc "GDP/capita" L.gdp_pc_g "GDP growth" L.oil_income "Oil income" L.cinc_a "CINC" L.polity2 "Polity2" L.instability3 "Instability(3y)" /// 
L.mgini_intx "Gini" ethfrac "Fractionalization" L.max_rdiscl "Max discrimination" L.NHIxl "Max low ratio"_cons Constant) /// 
drop(0bL.lied4 peaceyrs_ucdp_mac peaceyrs_ucdp_mac_2 peaceyrs_ucdp_mac_3) addnotes ("Peace years with time polynomials not reported") ///
title ("Table OA3. Logistic regression estimates of civil war onset: Alternative measures of civil conflict")
*Add coeficients for particular levels from below

*Testing H1a-H1e (UCDP/PRIO war)
logit ucdp_cw_on b0.l.lied4 l.lngdp_pc l.gdp_pc_g l.oil_income l.cinc_a l.polity2 l.instability3 l.mgini_intx ethfrac l.max_rdiscl l.NHIxl lnpop peaceyrs_ucdp_mac peaceyrs_ucdp_mac_2 peaceyrs_ucdp_mac_3
logit ucdp_cw_on b1.l.lied4 l.lngdp_pc l.gdp_pc_g l.oil_income l.cinc_a l.polity2 l.instability3 l.mgini_intx ethfrac l.max_rdiscl l.NHIxl lnpop peaceyrs_ucdp_mac peaceyrs_ucdp_mac_2 peaceyrs_ucdp_mac_3
logit ucdp_cw_on b2.l.lied4 l.lngdp_pc l.gdp_pc_g l.oil_income l.cinc_a l.polity2 l.instability3 l.mgini_intx ethfrac l.max_rdiscl l.NHIxl lnpop peaceyrs_ucdp_mac peaceyrs_ucdp_mac_2 peaceyrs_ucdp_mac_3
logit ucdp_cw_on b3.l.lied4 l.lngdp_pc l.gdp_pc_g l.oil_income l.cinc_a l.polity2 l.instability3 l.mgini_intx ethfrac l.max_rdiscl l.NHIxl lnpop peaceyrs_ucdp_mac peaceyrs_ucdp_mac_2 peaceyrs_ucdp_mac_3
*Create m19 in Table OA3 and add coeficients for particular levels
*Testing H1a-H1e (UCDP/PRIO minor)
logit ucdp_mac_on b0.l.lied4 l.lngdp_pc l.gdp_pc_g l.oil_income l.cinc_a l.polity2 l.instability3 l.mgini_intx ethfrac l.max_rdiscl l.NHIxl lnpop peaceyrs_ucdp_mac peaceyrs_ucdp_mac_2 peaceyrs_ucdp_mac_3
logit ucdp_mac_on b1.l.lied4 l.lngdp_pc l.gdp_pc_g l.oil_income l.cinc_a l.polity2 l.instability3 l.mgini_intx ethfrac l.max_rdiscl l.NHIxl lnpop peaceyrs_ucdp_mac peaceyrs_ucdp_mac_2 peaceyrs_ucdp_mac_3
logit ucdp_mac_on b2.l.lied4 l.lngdp_pc l.gdp_pc_g l.oil_income l.cinc_a l.polity2 l.instability3 l.mgini_intx ethfrac l.max_rdiscl l.NHIxl lnpop peaceyrs_ucdp_mac peaceyrs_ucdp_mac_2 peaceyrs_ucdp_mac_3
logit ucdp_mac_on b3.l.lied4 l.lngdp_pc l.gdp_pc_g l.oil_income l.cinc_a l.polity2 l.instability3 l.mgini_intx ethfrac l.max_rdiscl l.NHIxl lnpop peaceyrs_ucdp_mac peaceyrs_ucdp_mac_2 peaceyrs_ucdp_mac_3
*Create m22 in Table OA3 and add coeficients for particular levels
*Testing H1a-H1e (UCDP/PRIO war governmental)
logit ucdp_cw_gov_on b0.l.lied4 l.lngdp_pc l.gdp_pc_g l.oil_income l.cinc_a l.polity2 l.instability3 l.mgini_intx ethfrac l.max_rdiscl l.NHIxl lnpop peaceyrs_ucdp_mac peaceyrs_ucdp_mac_2 peaceyrs_ucdp_mac_3
logit ucdp_cw_gov_on b1.l.lied4 l.lngdp_pc l.gdp_pc_g l.oil_income l.cinc_a l.polity2 l.instability3 l.mgini_intx ethfrac l.max_rdiscl l.NHIxl lnpop peaceyrs_ucdp_mac peaceyrs_ucdp_mac_2 peaceyrs_ucdp_mac_3
logit ucdp_cw_gov_on b2.l.lied4 l.lngdp_pc l.gdp_pc_g l.oil_income l.cinc_a l.polity2 l.instability3 l.mgini_intx ethfrac l.max_rdiscl l.NHIxl lnpop peaceyrs_ucdp_mac peaceyrs_ucdp_mac_2 peaceyrs_ucdp_mac_3
logit ucdp_cw_gov_on b3.l.lied4 l.lngdp_pc l.gdp_pc_g l.oil_income l.cinc_a l.polity2 l.instability3 l.mgini_intx ethfrac l.max_rdiscl l.NHIxl lnpop peaceyrs_ucdp_mac peaceyrs_ucdp_mac_2 peaceyrs_ucdp_mac_3
*Create m19g in Table OA3 and add coeficients for particular levels

*Fixed-effects
*Interval
clogit cow_cw_on l.lied4 l.lnigdp_pc l.igdp_pc_g l.oil_income l.cinc_a l.polity2 l.instability3 lnpop peaceyrs_cow peaceyrs_cow_2 peaceyrs_cow_3, group(cow)
estimates store m23
clogit cow_cw_on l.lied4 l.lngdp_pc l.gdp_pc_g l.oil_income l.cinc_a l.polity2 l.instability3 l.mgini_intx ethfrac l.max_rdiscl l.NHIxl lnpop peaceyrs_cow1946 peaceyrs_cow1946_2 peaceyrs_cow1946_3, group(cow)
estimates store m24
clogit ucdp_cw_on l.lied4 l.lngdp_pc l.gdp_pc_g l.oil_income l.cinc_a l.polity2 l.instability3 l.mgini_intx ethfrac l.max_rdiscl l.NHIxl lnpop peaceyrs_ucdp_mac peaceyrs_ucdp_mac_2 peaceyrs_ucdp_mac_3, group(cow)
estimates store m25
clogit ucdp_mac_on l.lied4 l.lngdp_pc l.gdp_pc_g l.oil_income l.cinc_a l.polity2 l.instability3 l.mgini_intx ethfrac l.max_rdiscl l.NHIxl lnpop peaceyrs_ucdp_mac peaceyrs_ucdp_mac_2 peaceyrs_ucdp_mac_3, group(cow)
estimates store m26
*Dummy
clogit cow_cw_on l.i.lied4 l.lnigdp_pc l.igdp_pc_g l.oil_income l.cinc_a l.polity2 l.instability3 lnpop peaceyrs_cow peaceyrs_cow_2 peaceyrs_cow_3, group(cow)
estimates store m27
clogit cow_cw_on l.i.lied4 l.lngdp_pc l.gdp_pc_g l.oil_income l.cinc_a l.polity2 l.instability3 l.mgini_intx ethfrac l.max_rdiscl l.NHIxl lnpop peaceyrs_cow1946 peaceyrs_cow1946_2 peaceyrs_cow1946_3, group(cow)
estimates store m28
clogit ucdp_cw_on i.l.lied4 l.lngdp_pc l.gdp_pc_g l.oil_income l.cinc_a l.polity2 l.instability3 l.mgini_intx ethfrac l.max_rdiscl l.NHIxl lnpop peaceyrs_ucdp_mac peaceyrs_ucdp_mac_2 peaceyrs_ucdp_mac_3, group(cow)
estimates store m29
clogit ucdp_mac_on i.l.lied4 l.lngdp_pc l.gdp_pc_g l.oil_income l.cinc_a l.polity2 l.instability3 l.mgini_intx ethfrac l.max_rdiscl l.NHIxl lnpop peaceyrs_ucdp_mac peaceyrs_ucdp_mac_2 peaceyrs_ucdp_mac_3, group(cow)
estimates store m30

*Write out Table OA4
esttab m23 m24 m25 m26 m27 m28 m29 m30 using online_appendix.rtf, star(+ 0.10 * 0.05 ** 0.01 *** 0.001) se b(%9.2f) scalars(chi2) nogaps onecell unstack append ///
nodepvars nonumbers eqlabels(none) coeflabels(L.lied4 "LIED" 1L.lied4 "L1" 2L.lied4 "L2" 3L.lied4 "L3" 4L.lied4 "L4" lnpop "Population" /// 
L.lnigdp_pc "GDP/capita(ipol)" L.lngdp_pc "GDP/capita" L.igdp_pc_g "GDP growth(ipol)" L.gdp_pc_g "GDP growth" L.oil_income "Oil income" L.cinc_a "CINC" L.polity2 "Polity2" L.instability3 "Instability(3y)" /// 
L.mgini_intx "Gini" ethfrac "Fractionalization" L.max_rdiscl "Max discrimination" L.NHIxl "Max low ratio"_cons Constant) /// 
drop(0bL.lied4 peaceyrs_cow peaceyrs_cow_2 peaceyrs_cow_3 peaceyrs_cow1946 peaceyrs_cow1946_2 peaceyrs_cow1946_3 peaceyrs_ucdp_mac peaceyrs_ucdp_mac_2 peaceyrs_ucdp_mac_3) addnotes ("Peace years with time polynomials not reported") ///
title ("Table OA4. Logistic regression estimates of civil war onset: Country fixed-effects")

*Testing H1a-H1e
clogit cow_cw_on b0.l.lied4 l.lnigdp_pc l.igdp_pc_g l.oil_income l.cinc_a l.polity2 l.instability3 lnpop peaceyrs_cow peaceyrs_cow_2 peaceyrs_cow_3, group(cow)
estimates store m31
clogit cow_cw_on b1.l.lied4 l.lnigdp_pc l.igdp_pc_g l.oil_income l.cinc_a l.polity2 l.instability3 lnpop peaceyrs_cow peaceyrs_cow_2 peaceyrs_cow_3, group(cow)
clogit cow_cw_on b2.l.lied4 l.lnigdp_pc l.igdp_pc_g l.oil_income l.cinc_a l.polity2 l.instability3 lnpop peaceyrs_cow peaceyrs_cow_2 peaceyrs_cow_3, group(cow)
clogit cow_cw_on b3.l.lied4 l.lnigdp_pc l.igdp_pc_g l.oil_income l.cinc_a l.polity2 l.instability3 lnpop peaceyrs_cow peaceyrs_cow_2 peaceyrs_cow_3, group(cow)

clogit cow_cw_on b0.l.lied4 l.lngdp_pc l.gdp_pc_g l.oil_income l.cinc_a l.polity2 l.instability3 l.mgini_intx ethfrac l.max_rdiscl l.NHIxl lnpop peaceyrs_cow1946 peaceyrs_cow1946_2 peaceyrs_cow1946_3, group(cow)
estimates store m32
clogit cow_cw_on b1.l.lied4 l.lngdp_pc l.gdp_pc_g l.oil_income l.cinc_a l.polity2 l.instability3 l.mgini_intx ethfrac l.max_rdiscl l.NHIxl lnpop peaceyrs_cow1946 peaceyrs_cow1946_2 peaceyrs_cow1946_3, group(cow)
clogit cow_cw_on b2.l.lied4 l.lngdp_pc l.gdp_pc_g l.oil_income l.cinc_a l.polity2 l.instability3 l.mgini_intx ethfrac l.max_rdiscl l.NHIxl lnpop peaceyrs_cow1946 peaceyrs_cow1946_2 peaceyrs_cow1946_3, group(cow)
clogit cow_cw_on b3.l.lied4 l.lngdp_pc l.gdp_pc_g l.oil_income l.cinc_a l.polity2 l.instability3 l.mgini_intx ethfrac l.max_rdiscl l.NHIxl lnpop peaceyrs_cow1946 peaceyrs_cow1946_2 peaceyrs_cow1946_3, group(cow)

clogit ucdp_cw_on b0.l.lied4 l.lngdp_pc l.gdp_pc_g l.oil_income l.cinc_a l.polity2 l.instability3 l.mgini_intx ethfrac l.max_rdiscl l.NHIxl lnpop peaceyrs_ucdp_mac peaceyrs_ucdp_mac_2 peaceyrs_ucdp_mac_3, group(cow)
estimates store m33
clogit ucdp_cw_on b1.l.lied4 l.lngdp_pc l.gdp_pc_g l.oil_income l.cinc_a l.polity2 l.instability3 l.mgini_intx ethfrac l.max_rdiscl l.NHIxl lnpop peaceyrs_ucdp_mac peaceyrs_ucdp_mac_2 peaceyrs_ucdp_mac_3, group(cow)
clogit ucdp_cw_on b2.l.lied4 l.lngdp_pc l.gdp_pc_g l.oil_income l.cinc_a l.polity2 l.instability3 l.mgini_intx ethfrac l.max_rdiscl l.NHIxl lnpop peaceyrs_ucdp_mac peaceyrs_ucdp_mac_2 peaceyrs_ucdp_mac_3, group(cow)
clogit ucdp_cw_on b3.l.lied4 l.lngdp_pc l.gdp_pc_g l.oil_income l.cinc_a l.polity2 l.instability3 l.mgini_intx ethfrac l.max_rdiscl l.NHIxl lnpop peaceyrs_ucdp_mac peaceyrs_ucdp_mac_2 peaceyrs_ucdp_mac_3, group(cow)

clogit ucdp_mac_on b0.l.lied4 l.lngdp_pc l.gdp_pc_g l.oil_income l.cinc_a l.polity2 l.instability3 l.mgini_intx ethfrac l.max_rdiscl l.NHIxl lnpop peaceyrs_ucdp_mac peaceyrs_ucdp_mac_2 peaceyrs_ucdp_mac_3, group(cow)
estimates store m34
clogit ucdp_mac_on b1.l.lied4 l.lngdp_pc l.gdp_pc_g l.oil_income l.cinc_a l.polity2 l.instability3 l.mgini_intx ethfrac l.max_rdiscl l.NHIxl lnpop peaceyrs_ucdp_mac peaceyrs_ucdp_mac_2 peaceyrs_ucdp_mac_3, group(cow)
clogit ucdp_mac_on b2.l.lied4 l.lngdp_pc l.gdp_pc_g l.oil_income l.cinc_a l.polity2 l.instability3 l.mgini_intx ethfrac l.max_rdiscl l.NHIxl lnpop peaceyrs_ucdp_mac peaceyrs_ucdp_mac_2 peaceyrs_ucdp_mac_3, group(cow)
clogit ucdp_mac_on b3.l.lied4 l.lngdp_pc l.gdp_pc_g l.oil_income l.cinc_a l.polity2 l.instability3 l.mgini_intx ethfrac l.max_rdiscl l.NHIxl lnpop peaceyrs_ucdp_mac peaceyrs_ucdp_mac_2 peaceyrs_ucdp_mac_3, group(cow)

*Write out Table OA5
esttab m31 m32 m33 m34 using online_appendix.rtf, star(+ 0.10 * 0.05 ** 0.01 *** 0.001) se b(%9.2f) scalars(chi2) nogaps onecell unstack append ///
nodepvars nonumbers eqlabels(none) coeflabels(L.lied4 "LIED" 1L.lied4 "L1" 2L.lied4 "L2" 3L.lied4 "L3" 4L.lied4 "L4" lnpop "Population" /// 
L.lnigdp_pc "GDP/capita(ipol)" L.lngdp_pc "GDP/capita" L.igdp_pc_g "GDP growth(ipol)" L.gdp_pc_g "GDP growth" L.oil_income "Oil income" L.cinc_a "CINC" L.polity2 "Polity2" L.instability3 "Instability(3y)" /// 
L.mgini_intx "Gini" ethfrac "Fractionalization" L.max_rdiscl "Max discrimination" L.NHIxl "Max low ratio"_cons Constant) /// 
drop(0bL.lied4 peaceyrs_cow peaceyrs_cow_2 peaceyrs_cow_3 peaceyrs_cow1946 peaceyrs_cow1946_2 peaceyrs_cow1946_3 peaceyrs_ucdp_mac peaceyrs_ucdp_mac_2 peaceyrs_ucdp_mac_3) addnotes ("Peace years with time polynomials not reported") ///
title ("Table OA5. Logistic regression estimates of civil war onset: Country fixed-effects: Comparing LIED levels")
*Add coeficients for particular levels from above

*Predict LIED: OLS
reg lied4 lnpop, cluster(cow)
estimates store m35
reg lied4 l.lnigdp_pc lnpop, cluster(cow)
estimates store m36
reg lied4 l.lnigdp_pc l.igdp_pc_g lnpop, cluster(cow)
estimates store m37
reg lied4 l.lnigdp_pc l.igdp_pc_g l.oil_income lnpop, cluster(cow)
estimates store m38
reg lied4 l.lnigdp_pc l.igdp_pc_g l.oil_income l.cinc_a lnpop, cluster(cow)
estimates store m39
reg lied4 l.lnigdp_pc l.igdp_pc_g l.oil_income l.cinc_a l.instability3 lnpop, cluster(cow)
estimates store m40
reg lied4 l.lngdp_pc l.gdp_pc_g l.oil_income l.cinc_a l.instability3 l.mgini_intx lnpop, cluster(cow) 
estimates store m41
reg lied4 l.lngdp_pc l.gdp_pc_g l.oil_income l.cinc_a l.instability3 l.mgini_intx ethfrac lnpop, cluster(cow) 
estimates store m42
reg lied4 l.lngdp_pc l.gdp_pc_g l.oil_income l.cinc_a l.instability3 l.mgini_intx ethfrac l.max_rdiscl lnpop, cluster(cow) 
estimates store m43
reg lied4 l.lngdp_pc l.gdp_pc_g l.oil_income l.cinc_a l.instability3 l.mgini_intx ethfrac l.max_rdiscl l.NHIxl lnpop, cluster(cow) 
estimates store m44

*Write out Table OA6
esttab m35 m36 m37 m38 m39 m40 m41 m42 m43 m44 using online_appendix.rtf, star(+ 0.10 * 0.05 ** 0.01 *** 0.001) se b(%9.2f) r2 nogaps onecell unstack append ///
nodepvars nonumbers eqlabels(none) coeflabels(L.lied4 "LIED" 1L.lied4 "L1" 2L.lied4 "L2" 3L.lied4 "L3" 4L.lied4 "L4" lnpop "Population" /// 
L.lnigdp_pc "GDP/capita(ipol)" L.lngdp_pc "GDP/capita" L.igdp_pc_g "GDP growth(ipol)" L.gdp_pc_g "GDP growth" L.oil_income "Oil income" L.cinc_a "CINC" L.polity2 "Polity2" L.instability3 "Instability(3y)" /// 
L.mgini_intx "Gini" ethfrac "Fractionalization" L.max_rdiscl "Max discrimination" L.NHIxl "Max low ratio"_cons Constant) /// 
addnotes ("Peace years with time polynomials not reported") ///
title ("Table OA6. OLS regression estimates of LIED")

*Predict LIED: OLS fixed-effects
xtset cow year
xtreg lied4 lnpop, fe cluster(cow)
estimates store m45
xtreg lied4 l.lnigdp_pc lnpop, fe cluster(cow)
estimates store m46
xtreg lied4 l.lnigdp_pc l.igdp_pc_g lnpop, fe cluster(cow)
estimates store m47
xtreg lied4 l.lnigdp_pc l.igdp_pc_g l.oil_income lnpop, fe cluster(cow)
estimates store m48
xtreg lied4 l.lnigdp_pc l.igdp_pc_g l.oil_income l.cinc_a lnpop, fe cluster(cow)
estimates store m49
xtreg lied4 l.lnigdp_pc l.igdp_pc_g l.oil_income l.cinc_a l.instability3 lnpop, fe cluster(cow)
estimates store m50
xtreg lied4 l.lngdp_pc l.gdp_pc_g l.oil_income l.cinc_a l.instability3 l.mgini_intx lnpop, fe cluster(cow)
estimates store m51
xtreg lied4 l.lngdp_pc l.gdp_pc_g l.oil_income l.cinc_a l.instability3 l.mgini_intx ethfrac lnpop, fe cluster(cow)
estimates store m52
xtreg lied4 l.lngdp_pc l.gdp_pc_g l.oil_income l.cinc_a l.instability3 l.mgini_intx ethfrac l.max_rdiscl lnpop, fe cluster(cow)
estimates store m53
xtreg lied4 l.lngdp_pc l.gdp_pc_g l.oil_income l.cinc_a l.instability3 l.mgini_intx ethfrac l.max_rdiscl l.NHIxl lnpop, fe cluster(cow)
estimates store m54

*Write out Table OA7
esttab m45 m46 m47 m48 m49 m50 m51 m52 m53 m54 using online_appendix.rtf, star(+ 0.10 * 0.05 ** 0.01 *** 0.001) se b(%9.2f) r2 nogaps onecell append ///
nodepvars nonumbers eqlabels(none) coeflabels(L.lied4 "LIED" 1L.lied4 "L1" 2L.lied4 "L2" 3L.lied4 "L3" 4L.lied4 "L4" lnpop "Population" /// 
L.lnigdp_pc "GDP/capita(ipol)" L.lngdp_pc "GDP/capita" L.igdp_pc_g "GDP growth(ipol)" L.gdp_pc_g "GDP growth" L.oil_income "Oil income" L.cinc_a "CINC" L.polity2 "Polity2" L.instability3 "Instability(3y)" /// 
L.mgini_intx "Gini" ethfrac "Fractionalization" L.max_rdiscl "Max discrimination" L.NHIxl "Max low ratio"_cons Constant) /// 
addnotes ("Peace years with time polynomials not reported") ///
title ("Table OA7. OLS regression estimates of LIED: Country fixed-effects")

*Plot bar charts for LIED
graph bar gdp_pc, over(lied4, gap(5)) ytitle("GDP/capita (Bolt & van Zanden, 2013)") name(one, replace) scheme(s1mono) bar(1, fcolor(white)) ylabel(, nogrid) 
graph bar gdp_pc_g, over(lied4, gap(5)) ytitle("GDP growth (Bolt & van Zanden, 2013)") name(two, replace) scheme(s1mono) bar(1, fcolor(white)) ylabel(, nogrid) 
graph bar oil_income, over(lied4, gap(5)) ytitle("Total oil income/capita (Haber & Menaldo, 2011)") name(three, replace) scheme(s1mono) bar(1, fcolor(white)) ylabel(, nogrid) 
graph combine one two three, ysize(3) xsize(9) col(3) iscale(1) scheme(s1mono) 
*note ("Figure OA1. GDP/capita, GDP growth and oil income by LIED")

graph bar cinc_a, over(lied4, gap(5)) ytitle("Composite Index of National Capability (Singer, 1987)") name(four, replace) scheme(s1mono) bar(1, fcolor(white)) ylabel(, nogrid) 
graph bar instability3, over(lied4, gap(5)) ytitle("Instability in last 3 years") name(five, replace) scheme(s1mono) bar(1, fcolor(white)) ylabel(, nogrid) 
graph bar mgini_intx, over(lied4, gap(5)) ytitle("Gini index (Buhaug, Cederman, & Gleditsch, 2014)") name(six, replace) scheme(s1mono) bar(1, fcolor(white)) ylabel(, nogrid) 
graph combine four five six, ysize(3) xsize(9) col(3) iscale(1) scheme(s1mono)
*note ("Figure OA2. CINC, Instability, and Gini by LIED")

graph bar ethfrac, over(lied4, gap(5)) ytitle("Fractionalization (Buhaug, Cederman, & Gleditsch, 2014)") name(seven, replace) scheme(s1mono) bar(1, fcolor(white)) ylabel(, nogrid) 
graph bar max_rdiscl, over(lied4, gap(5)) ytitle("Max discrimination (Buhaug, Cederman, & Gleditsch, 2014)") name(eight, replace) scheme(s1mono) bar(1, fcolor(white)) ylabel(, nogrid) 
graph bar NHIxl, over(lied4, gap(5)) ytitle("Max low ratio (Buhaug, Cederman, & Gleditsch, 2014)") name(nine, replace) scheme(s1mono) bar(1, fcolor(white)) ylabel(, nogrid) 
graph combine seven eight nine, ysize(3) xsize(9) col(3) iscale(1) scheme(s1mono)
*note ("Figure OA3. Fractionalization, Max discrimination, and Max low ratio by LIED")

log close
