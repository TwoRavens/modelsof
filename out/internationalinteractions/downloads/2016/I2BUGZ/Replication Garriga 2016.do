
***  Replication codes for figures and tables in
***  Garriga, Ana Carolina. 2016.  Central Bank Independence in the World. A New Dataset
***  Stata 12


* use CBI dataset Garriga.dta

tsset cowcode year

*  Table 1

sum year creation reform direction direction_pol direction_bh ///
increase decrease lvaw_garriga lvaw_cuk lvaw_polillo lvaw_crowe lvaw_sadeh lvaw_bh ///
lvau_garriga regional if creation!=.


*   Table 2

tab reform 
tab reform direction
sum reform if direction==.  // 11 cases in which I cannot determine direction
tab direction

tab direction_pol
tab direction_bh


* in text references

pwcorr lvaw_garriga lvaw_cuk lvaw_polillo lvaw_crowe lvaw_sadeh lvaw_bh, sig obs  // Appendix 5, Table 5.1

pwcorr lvaw_garriga lvaw_cuk lvaw_polillo lvaw_crowe lvaw_sadeh lvaw_bh if regional==0, sig obs  // Appendix 5, Table 5.2

tab regional

tab regional if lvaw_cuk==. & lvaw_polillo==. & lvaw_crowe==. & lvaw_sadeh==. & lvaw_bh==. 

tab reform if year<1990
tab direction if year<1990

tab reform if year<1990 & reform_bh==.
tab reform if year<1990 & reform_bh!=.
tab direction if year<1990 & direction_bh==.
tab direction if year<1990 & direction_bh!=.

tab reform_bh if year<1990
tab direction_bh if year<1990

gen change=d.lvaw_garriga
   replace change=change*(-1) if change<0
gen change_pc=(change/l.lvaw_garriga)*100

sum change change_pc if year<1990 & change!=0 & change!=.  
sum change change_pc if year<1990 & change!=0 & change!=. & cowcode!=630
sum change change_pc if year>1989 & change!=0 & change!=.


* Reforms per country and per year

*  Tables and figures: Reforms and averages per year  

* use CBI dataset Garriga.dta

*  Prepare the data 

gen reform_pol=direction_pol
recode reform_pol (-1=1)

rename cowcode count_garriga
gen count_cuk= lvaw_cuk
gen count_bh=reform_bh
gen count_pol=reform_pol
gen count_sadeh=lvaw_sadeh

gen lowinc=.
 replace lowinc=lvaw_garriga if incgr==1
gen lminc=.
 replace lminc= lvaw_garriga if incgr==2
gen hminc=.
 replace hminc= lvaw_garriga if incgr==3
gen highinc=.
 replace highinc= lvaw_garriga if incgr==4
 
gen lowinc_lvau=.
 replace lowinc_lvau=lvau_garriga if incgr==1
gen lminc_lvau=.
 replace lminc_lvau= lvau_garriga if incgr==2
gen hminc_lvau=.
 replace hminc_lvau= lvau_garriga if incgr==3
gen highinc_lvau=.
 replace highinc_lvau= lvau_garriga if incgr==4
 
gen lowinc_ceo=.
 replace lowinc_ceo= cuk_ceo if incgr==1
gen lminc_ceo=.
 replace lminc_ceo= cuk_ceo if incgr==2
gen hminc_ceo=.
 replace hminc_ceo= cuk_ceo if incgr==3
gen highinc_ceo=.
 replace highinc_ceo= cuk_ceo if incgr==4
 
gen lowinc_pol=.
 replace lowinc_pol= cuk_pol if incgr==1
gen lminc_pol=.
 replace lminc_pol= cuk_pol if incgr==2
gen hminc_pol=.
 replace hminc_pol= cuk_pol if incgr==3
gen highinc_pol=.
 replace highinc_pol= cuk_pol if incgr==4
 
gen lowinc_obj=.
 replace lowinc_obj= cuk_obj if incgr==1
gen lminc_obj=.
 replace lminc_obj= cuk_obj if incgr==2
gen hminc_obj=.
 replace hminc_obj= cuk_obj if incgr==3
gen highinc_obj=.
 replace highinc_obj= cuk_obj if incgr==4
 
gen lowinc_limlen=.
 replace lowinc_limlen= cuk_limlen if incgr==1
gen lminc_limlen=.
 replace lminc_limlen= cuk_limlen if incgr==2
gen hminc_limlen=.
 replace hminc_limlen= cuk_limlen if incgr==3
gen highinc_limlen=.
 replace highinc_limlen= cuk_limlen if incgr==4
  
 
gen we_na=.
 replace we_na=lvaw_garriga if ht_region==5 // Western Europe and North America
gen ee_ps=.
 replace ee_ps =lvaw_garriga if ht_region==1 // Eastern Europe and post Soviet Union 
gen lam=.
 replace lam=lvaw_garriga if ht_region==2 | ht_region==10 // Latin America & the Caribbean
gen na_me=.
 replace na_me =lvaw_garriga if ht_region==3 // North Africa & the Middle East 
gen ssa=.
 replace ssa=lvaw_garriga if ht_region==4 // Sub-Saharan Africa 
gen asia=.
 replace asia=lvaw_garriga if ht_region==6 | ht_region==7 | ht_region==8 // East Asia, South-East Asia & South Asia 
gen pac=.
 replace pac=lvaw_garriga if ht_region==9 // The Pacific 

gen e_asia=.
 replace e_asia=lvaw_garriga if ht_region==6 // East Asia 
gen sse_asia=.
 replace sse_asia=lvaw_garriga if ht_region==7| ht_region==8 //  South-East Asia  

 
gen other=.
replace other=0 if reform!=.
replace other=1 if reform==1 & direction==.
replace other=1 if reform==1 & direction==0

gen lvaw_garriganew=lvaw_garriga if lvaw_bh==.
gen lvaw_garrigarecod=lvaw_garriga if lvaw_bh!=.

gen reform_new=reform if reform_bh==.
gen reform_old=reform if reform_bh!=.

collapse (count) count_garriga count_cuk count_pol count_bh count_sadeh (sum) reform increase decrease other reform_bh increase_bh decrease_bh reform_pol reform_old reform_new ///
         (mean) lvaw_garriga lvaw_garriganew lvaw_garrigarecod lvaw_cuk lvaw_polillo lvaw_bh lvaw_crowe lvaw_sadeh lvau_garriga lowinc lminc hminc highinc lowinc_lvau lminc_lvau hminc_lvau ///
         highinc_lvau lowinc_ceo lminc_ceo hminc_ceo highinc_ceo lowinc_pol lminc_pol hminc_pol highinc_pol lowinc_obj lminc_obj hminc_obj ///
         highinc_obj lowinc_limlen lminc_limlen hminc_limlen highinc_limlen we_na ee_ps lam na_me ssa asia pac e_asia sse_asia cuk_ceo cuk_pol ///
         cuk_obj cuk_limlen, by (year)
         
replace reform_bh= lvaw_bh if lvaw_bh==.  // missing data is summed as 0
replace increase_bh = lvaw_bh if lvaw_bh==.  // missing data is summed as 0
replace decrease_bh = lvaw_bh if lvaw_bh==.  // missing data is summed as 0
replace reform_pol= lvaw_polillo if lvaw_polillo ==.  // missing data is summed as 0

recode count_cuk (0=.)
recode count_bh (0=.)
recode count_pol (0=.)
recode count_sadeh (0=.)

label variable count_garriga "Garriga"
label variable count_cuk  "CWN"
label variable count_pol  "Polillo&Guillen"
label variable count_bh  "Bodea&Hicks"
label variable count_sadeh  "Sadeh"

label variable lvaw_garriga "Garriga"
label variable lvaw_cuk  "CWN"
label variable lvaw_polillo  "Polillo&Guillen"
label variable lvaw_bh  "Bodea&Hicks"
label variable lvaw_crowe  "Crowe&Meade"
label variable lvaw_sadeh  "Sadeh"

label variable reform "Garriga"
label variable reform_new "Garriga (new)"
label variable reform_old "Garriga (recoded)"
label variable reform_pol  "Polillo&Guillen"
label variable reform_bh  "Bodea&Hicks"

label variable lowinc "Low income"
label variable lminc "Lower middle income"
label variable hminc "Upper middle income"
label variable highinc "High income"
label variable we_na "W. Europe and N. America"
label variable ee_ps "E. Europe and post Soviet"
label variable lam "Latin Am. & Caribbean"
label variable na_me "N. Africa & Middle East"
label variable ssa "Sub-Saharan Africa"
label variable asia "Asia"
label variable e_asia "East Asia"
label variable sse_asia "S&SE. Asia"
label variable pac "The Pacific"

label variable lvaw_garriga "Weighted index"
label variable lvau_garriga "Unweighted index"
label variable cuk_ceo "Personnel indep."
label variable cuk_pol "Policy indep."
label variable cuk_obj "CB objectives"
label variable cuk_limlen "Financial indep."



* Figure 1: number of countries per year

twoway (line count_garriga year, sort) (line count_cuk year, lcolor(gs7) lpattern(solid) sort cmissing(n)) (line count_pol year, lpattern(vshortdash) sort) ///
(line count_sadeh year, lcolor(gs3) lpattern(dash) sort cmissing(n)) (line count_bh year, lcolor(gs2) lpattern(dash_dot) sort), ytitle(Number of countries) legend(rows(2)) xtitle(Year) 

   graph save Graph "/Users/.../Count.gph", replace  /// save for Figure 4.2


* Figure 3: old and newly coded countries

    graph bar (sum) reform_old reform_new, over(year, label(labsize(vsmall) angle(45))) ///
    bar(1, color(black)) bar(2, color(gs8)) stack nolabel  ytitle(Number of reforms) legend(rows(1) on order(1 "Previously coded countries" 2 "New countries") size(medsmall))


* Figure 4: number of reforms per year

   gen reform_d=.
   label variable reform_d "Daunfeldt&al"
   replace reform_d=0 if year>1979 & year<2006
   replace reform_d=2 if year==1989
   replace reform_d=3 if year==1991
   replace reform_d=5 if year==1992
   replace reform_d=8 if year==1993
   replace reform_d=5 if year==1994
   replace reform_d=9 if year==1995
   replace reform_d=3 if year==1996
   replace reform_d=3 if year==1997
   replace reform_d=11 if year==1998
   replace reform_d=3 if year==1999
   replace reform_d=4 if year==2000
   replace reform_d=4 if year==2001
   replace reform_d=9 if year==2002
   replace reform_d=4 if year==2003
   replace reform_d=7 if year==2004
   replace reform_d=6 if year==2005


twoway (line reform year, sort) (line reform_pol year, sort lwidth(medthick)), ytitle(Number of reforms) xtitle(Year)
   graph save Graph "/Users/.../Graph.gph", replace
twoway (line reform year, sort) (line reform_bh year, sort lwidth(medthick)), ytitle(Number of reforms) xtitle(Year)
   graph save Graph "/Users/.../Graph1.gph", replace
twoway (line reform year, sort) (line reform_d year, sort lwidth(medthick)), ytitle(Number of reforms) xtitle(Year)
   graph save Graph "/Users/.../Graph2.gph", replace
   graph combine "/Users/.../Graph.gph" "/Users/.../Graph1.gph" "/Users/.../Graph2.gph"



* Figure 5: CBI increases and decreases
rename decrease CBI_decreases
rename increase CBI_increases
rename other CBI_other
gen Year=.
replace Year=year if year==1970|year==1980|year==1990|year==2000|year==2010

graph bar (sum) CBI_decreases CBI_increases CBI_other, over(year,  label(labsize(vsmall) angle(45))) ///
bar(1, color(black)) bar(2, color(gs6)) bar(3, color(gs11)) stack nolabel  ytitle(Number of reforms)legend(rows(1) size(medsmall))


* Figure 6 average CBI in the world per year

  label variable lvaw_garriga "Garriga"

twoway (line lvaw_garriga year, lwidth(medthick) sort)(line lvaw_cuk year, lcolor(gs7) lpattern(solid) sort)(line lvaw_polillo year, sort lwidth(medthick) lpattern(vshortdash)) ///
(line lvaw_sadeh year, sort lwidth(medthick) lcolor(gs6) lpattern(dash)) ///
(line lvaw_bh year, sort lwidth(medthick) lcolor(gs3) lpattern(dash_dot))(scatter lvaw_crowe year, sort mcolor(black) msymbol(smdiamond)), ///
ytitle(CBI World Average) xtitle(Year)legend(rows(2) size(medsmall))


   
*  Figure 7 average CBI in the world per year - new and recoded data

  label variable lvaw_garriga "Garriga (full dataset)"
  label variable lvaw_garriganew "Garriga (new data)"
  label variable lvaw_garrigarecod "Garriga (recoded data)"

    twoway (line lvaw_garriga year, lwidth(medthick) sort)(line lvaw_garriganew year, lcolor(gs7) lpattern(solid) sort)(line lvaw_garrigarecod year, sort lwidth(medthick) lpattern(vshortdash)) ///
    (line lvaw_bh year, sort lwidth(medthick) lcolor(gs3) lpattern(dash_dot)), ///
    ytitle(CBI World Average) xtitle(Year)legend(rows(2) size(medsmall))


* Figure 8: average CBI in the world per income groups
twoway (line highinc year, sort) (line hminc year, sort lpattern(dash)) (line lminc year, sort lpattern(dash_dot) lcolor(gs6)) ///
(line lowinc year, sort lpattern(solid) lcolor(gs6)), ytitle(CBI Group Average) xtitle(Year)


* Figure 9: average regional CBI 

twoway (line ee_ps year, sort)(line we_na year, sort), ytitle(CBI group Average) xtitle(Year) legend(rows(2) size(small))
    graph save Graph "/Users/.../Graph6.gph", replace
twoway (line e_asia year, sort)(line sse_asia year, sort)(line lam year, sort), yscale(range(.2 .8)) xtitle(Year)legend(size(small))
    graph save Graph "/Users/.../Graph7.gph", replace
twoway (line na_me year, sort)(line pac year, sort)(line ssa year, sort), ytitle(CBI group Average) yscale(range(.2 .8)) xtitle(Year)legend(size(small))
    graph save Graph "/Users/.../Graph8.gph", replace

	graph combine  "/Users/.../Graph6.gph" "/Users/.../Graph7.gph" "/Users/.../Graph8.gph", ycommon
    

* Figure 10: average CBI in the world per year (total and components)

label variable lvaw_garriga "Weighted index"
label variable lvau_garriga "Unweighted index"
label variable cuk_ceo "Personnel indep."
label variable cuk_pol "Policy indep."
label variable cuk_obj "CB objectives"
label variable cuk_limlen "Financial indep."


twoway (line lvaw_garriga year, sort)(line lvau_garriga year, sort lpattern(solid) lcolor(gs6)) (line cuk_ceo year, sort) (line cuk_pol year, sort ) ///
(line cuk_obj year, sort lpattern(longdash_shortdash)) (line cuk_limlen year, sort lcolor(gs5)), ytitle(World Average) xtitle(Year) legend(rows(2)) legend(size(small))


*    Figure 11:  all income gr, by components

label variable lowinc_ceo "Low income"
label variable lowinc_pol "Low income"
label variable lowinc_obj "Low income"
label variable lowinc_limlen "Low income"
label variable lminc_ceo "Lower middle income"
label variable lminc_pol "Lower middle income"
label variable lminc_obj "Lower middle income"
label variable lminc_limlen "Lower middle income"
label variable hminc_ceo "Upper middle income"
label variable hminc_pol "Upper middle income"
label variable hminc_obj "Upper middle income"
label variable hminc_limlen "Upper middle income"
label variable highinc_ceo "High income"
label variable highinc_pol "High income"
label variable highinc_obj "High income"
label variable highinc_limlen "High income"


twoway (line lowinc_limlen year, sort)(line lminc_limlen year, sort lpattern(solid) lcolor(gs6)) (line hminc_limlen year, sort) (line highinc_limlen year, sort ), ///
    ytitle(Group ave.) xtitle(Year) title(Financial indep.) legend(off)
    graph save Graph "/Users/.../Graph10.gph", replace

twoway (line lowinc_pol year, sort)(line lminc_pol year, sort lpattern(solid) lcolor(gs6)) (line hminc_pol year, sort) (line highinc_pol year, sort ), ///
    xtitle(Year) title(Policy indep.) legend(off)
    graph save Graph "/Users/.../Graph11.gph", replace

twoway (line lowinc_ceo year, sort)(line lminc_ceo year, sort lpattern(solid) lcolor(gs6)) (line hminc_ceo year, sort) (line highinc_ceo year, sort ), ///
    xtitle(Year) title(Personnel indep.)  legend(rows(2)) legend(size(small)) legend(span)
    graph save Graph "/Users/.../Graph12.gph", replace

twoway (line lowinc_obj year, sort)(line lminc_obj year, sort lpattern(solid) lcolor(gs6)) (line hminc_obj year, sort) (line highinc_obj year, sort ), ///
    ytitle( ) xtitle(Year) title(CB objectives) legend(off)
    graph save Graph "/Users/.../Graph13.gph", replace

	graph combine  "/Users/.../Graph10.gph" "/Users/.../Graph11.gph" "/Users/.../Graph12.gph" "/Users/.../Graph13.gph", ycommon
 
    
*Figure 2 - excel + bar.dta

    * use CBI dataset Garriga.dta

    collapse (mean) lvaw_garriga lvaw_cuk lvaw_polillo lvaw_bh lvaw_sadeh lvau_garriga ///
            (firstnm) incgr1 income_gr ht_region region1, by (cowcode)

    sum // total countries for reform and lvaw

    sum if incgr==1 // low income
    sum if incgr==2 | incgr==3 // middle income
    sum if incgr==2 // lower middle income
    sum if incgr==3 // upper middle income
    sum if incgr==4 // high income
 
    sum if ht_region==5 // Western Europe and North America
    sum if ht_region==1 // Eastern Europe and post Soviet Union 
    sum if ht_region==2 | ht_region==10 // Latin America & the Caribbean
    sum if ht_region==3 // North Africa & the Middle East 
    sum if ht_region==4 // Sub-Saharan Africa 
    sum if ht_region==6 | ht_region==7 | ht_region==8 // East Asia, South-East Asia & South Asia 
    sum if ht_region==9 // The Pacific 


    * these data are saved in bar.dta

    use "/Users/.../bar.dta"


** income groups with Sadeh
   graph bar (mean) Garriga CWN P_G Sadeh B_H in 2/5, over(Name, sort(CWN) descending label(labsize(small)))bar(1, fcolor(gs2) lcolor(gs2))  ///
   bar(2, fcolor(gs5) lcolor(gs5)) bar(3, fcolor(gs10) lcolor(gs9)) bar(4, fcolor(gs12) lcolor(gs11)) bar(5, fcolor(gs14) lcolor(gs11)) ylabel(, angle(horizontal)) ///
   legend(on order(1 "Garriga" 2 "CWN" 3 "Polillo&Guillen" 4 "Sadeh" 5 "Bodea&Hicks") notextfirst symplacement(default) nostack rows(1) ///
   rowgap(tiny) size(small) color(black) margin(zero) nobox linegap(half_tiny) region(fcolor(white) lcolor(white))) clegend(region(fcolor(none))) ///
   ytitle(Number of countries) legend(rows(1) size(medsmall)) legend(span)scheme(sj) 
     graph save Graph "/Users/.../Bar4.gph", replace
  
   * geographic regions

   graph bar (mean) Garriga CWN P_G Sadeh B_H in 6/12, over(Name, sort(CWN) descending label(angle(stdarrow) labsize(small)))bar(1, fcolor(gs2) ///
   lcolor(gs2)) bar(2, fcolor(gs5) lcolor(gs5)) bar(3, fcolor(gs10) lcolor(gs9)) bar(4, fcolor(gs12) lcolor(gs11)) bar(5, fcolor(gs14) lcolor(gs11)) ylabel(, angle(horizontal)) ///
   legend(on order(1 "Garriga" 2 "CWN" 3 "Polillo&Guillen" 4 "Sadeh" 5 "Bodea&Hicks") notextfirst symplacement(default) nostack rows(1) ///
   rowgap(tiny) size(small) color(black) margin(zero) nobox linegap(half_tiny) region(fcolor(white) lcolor(white))) clegend(region(fcolor(none))) ///
   ytitle(Number of countries) legend(off) scheme(sj) 
     graph save Graph "/Users/.../Bar5.gph", replace
  
   	graph combine  "/Users/.../Bar4.gph" "/Users/.../Bar5.gph", rows(2) iscale(*.9)

  
*** Simple regressions

* use CBI dataset_regressions.dta

tsset cowcode year


* Table 3

xtreg inflation_i l.inflation_i l.lvaw_garriga,fe
   xtreg inflation_i l.inflation_i l.lvaw_garriga if income_gr==1 |income_gr==2,fe
   xtreg inflation_i l.inflation_i l.lvaw_garriga if income_gr==3 |income_gr==4|income_gr==5,fe


xtreg inflation_i l.inflation_i l.lvaw_cuk if l.lvaw_garriga!=.,fe
   xtreg inflation_i l.inflation_i l.lvaw_garriga if e(sample),fe
   

xtreg inflation_i l.inflation_i l.lvaw_pol if l.lvaw_garriga!=.,fe
   xtreg inflation_i l.inflation_i l.lvaw_garriga if e(sample),fe

xtreg inflation_i l.inflation_i l.lvaw_bh if l.lvaw_garriga!=.,fe
   xtreg inflation_i l.inflation_i l.lvaw_garriga if e(sample),fe

   xtreg inflation_i l.inflation_i l.lvaw_bh if l.lvaw_garriga!=.,fe
   xtreg inflation_i l.inflation_i l.lvaw_garriga if e(sample) & income_gr==1 |e(sample) & income_gr==2,fe
   
   xtreg inflation_i l.inflation_i l.lvaw_bh if l.lvaw_garriga!=.,fe
   xtreg inflation_i l.inflation_i l.lvaw_garriga if e(sample) & income_gr==3 |e(sample) & income_gr==4|e(sample) & income_gr==5,fe


* unemp
xtreg unemp_i l.unemp_i l.lvaw_garriga if year>1990,fe
   xtreg unemp_i l.unemp_i l.lvaw_garriga if year>1990 & income_gr==1 |year>1990 & income_gr==2,fe
   xtreg unemp_i l.unemp_i l.lvaw_garriga if year>1990 & income_gr==3 |year>1990 & income_gr==4|year>1990 & income_gr==5,fe


xtreg unemp_i l.unemp_i l.lvaw_cuk if l.lvaw_garriga!=. & year>1990,fe
   xtreg unemp_i l.unemp_i l.lvaw_garriga if e(sample),fe

   xtreg unemp_i l.unemp_i l.lvaw_garriga if e(sample) & income_gr==1 |e(sample) & income_gr==2,fe
   xtreg unemp_i l.unemp_i l.lvaw_garriga if e(sample) & income_gr==3 |e(sample) & income_gr==4|e(sample) & income_gr==5,fe


xtreg unemp_i l.unemp_i l.lvaw_pol if l.lvaw_garriga!=. & year>1990,fe
   xtreg unemp_i l.unemp_i  l.lvaw_garriga if e(sample),fe

   xtreg unemp_i l.unemp_i l.lvaw_garriga if e(sample) & income_gr==1 |e(sample) & income_gr==2,fe
   xtreg unemp_i l.unemp_i l.lvaw_garriga if e(sample) & income_gr==3 |e(sample) & income_gr==4|e(sample) & income_gr==5,fe


xtreg unemp_i l.unemp_i l.lvaw_bh if l.lvaw_garriga!=. & year>1990,fe
   xtreg unemp_i l.unemp_i l.lvaw_garriga if e(sample),fe

   xtreg unemp_i l.unemp_i l.lvaw_garriga if e(sample) & income_gr==1 |e(sample) & income_gr==2,fe
   xtreg unemp_i l.unemp_i l.lvaw_garriga if e(sample) & income_gr==3 |e(sample) & income_gr==4|e(sample) & income_gr==5,fe



* growth
xtreg GDP_growth l.GDP_growth l.lvaw_garriga,fe
   xtreg GDP_growth l.GDP_growth l.lvaw_garriga if income_gr==1 |income_gr==2,fe
   xtreg GDP_growth l.GDP_growth l.lvaw_garriga if income_gr==3 |income_gr==4|income_gr==5,fe


xtreg GDP_growth l.GDP_growth l.lvaw_cuk if l.lvaw_garriga!=.,fe
   xtreg GDP_growth l.GDP_growth l.lvaw_garriga if e(sample),fe

xtreg GDP_growth l.GDP_growth l.lvaw_pol if l.lvaw_garriga!=.,fe
   xtreg GDP_growth l.GDP_growth l.lvaw_garriga if e(sample),fe

   xtreg GDP_growth l.GDP_growth l.lvaw_garriga if e(sample) & income_gr==1 |e(sample) & income_gr==2,fe
   
   xtreg GDP_growth l.GDP_growth l.lvaw_garriga if e(sample) & income_gr==3 |e(sample) & income_gr==4|e(sample) & income_gr==5,fe

xtreg GDP_growth l.GDP_growth l.lvaw_bh if l.lvaw_garriga!=.,fe
   xtreg GDP_growth l.GDP_growth l.lvaw_garriga if e(sample),fe

   xtreg GDP_growth l.GDP_growth l.lvaw_garriga if e(sample) & income_gr==1 |e(sample) & income_gr==2,fe
   
   xtreg GDP_growth l.GDP_growth l.lvaw_garriga if e(sample) & income_gr==3 |e(sample) & income_gr==4|e(sample) & income_gr==5,fe

