***This file contains replication commands (Stata 13 was used) for the paper, entiltled, "Trade and terrorism: A disaggregated approach" 
***by Subhayu Bandyopadhyay, Todd Sandler, and Javed Younas
***forthcoming in Journal of Peace Research 
***upload trade-terrorism.dta stata data set for running these regressions.
***See excel file for the description of variables. Refer to the paper for more information.

****This do file replicates results for Tables I, II, III. For replicating results for Table IV, run placebo-trade-terrorism.do    

set matsize 800
xtset pairid year

***Domestic Terrorism Incidents***
*** incdr = Domestic terrorism incidents in country i
*** c2incdr = Domestic terrorism incidents in country j
*** totid = Total number of domestic terrorism incidents
gen totid=(1+incdr)*(1+c2incdr)
gen ltotid=ln(totid)
gen domt=l.ltotid 

***Transnational Terrorism Incidents
*** incdr = Transnational terrorism incidents in country i
*** c2incdr = Transnational terrorism incidents in country j
*** totid = Total number of transnational terrorism incidents
gen totit=(1+inctr)*(1+c2inctr)
gen ltotit=ln(totit)
gen trat=l.ltotit 

***Trade variables***
***Exports
replace iex_v1=. if iex_v1<=0 /*Total exports*/
replace iex_v4=. if iex_v4<=0 /*Primary exports*/
replace iex_v5=. if iex_v5<=0 /*Primary exports excluding fuel*/
replace iex_v14=. if iex_v14<=0 /*Manfactured exports*/

***Imports
replace iim_v1=. if iim_v1<=0 /*Total imports*/
replace iim_v4=. if iim_v4<=0 /*Primary imports*/
replace iim_v5=. if iim_v5<=0 /*Primary imports excluding fuel*/
replace iim_v14=. if iim_v14<=0 /*Manfactured imports*/

***Converting trade variable into real values, summing exports and imports and taking log***
***exp_index = export value index
***imp_index = import value index

replace exp_index=. if exp_index>8000 /*One Observation where somalia has some outlier value for export value index in 2012*/

***Trade variable are in thousnad of US dollars
***Total Goods Trade
gen iex_v1r=(iex_v1*1000)/(exp_index/100)
gen iim_v1r=(iim_v1*1000)/(imp_index/100)
egen trv1=rowtotal(iex_v1r iim_v1r), missing
gen ltrv1=ln(1+trv1)

***Total Primary Goods Trade
gen iex_v4r=(iex_v4*1000)/(exp_index/100)
gen iim_v4r=(iim_v4*1000)/(imp_index/100)
egen trv4=rowtotal(iex_v4r iim_v4r), missing
gen ltrv4=ln(1+trv4)

***Total Primary Goods Trade Withour Fuel Values
gen iex_v5r=(iex_v5*1000)/(exp_index/100)
gen iim_v5r=(iim_v5*1000)/(imp_index/100)
egen trv5=rowtotal(iex_v5r iim_v5r), missing
gen ltrv5=ln(1+trv5)

***Total Manufacured Goods Trade
gen iex_v14r=(iex_v14*1000)/(exp_index/100)
gen iim_v14r=(iim_v14*1000)/(imp_index/100)
egen trv14=rowtotal(iex_v14r iim_v14r), missing
gen ltrv14=ln(1+trv14)

***log exports
gen ltrv1_e=ln(1+iex_v1r)
gen ltrv4_e=ln(1+iex_v4r)
gen ltrv5_e=ln(1+iex_v5r)
gen ltrv14_e=ln(1+iex_v14r)

***log imports
gen ltrv1_i=ln(1+iim_v1r)
gen ltrv4_i=ln(1+iim_v4r)
gen ltrv5_i=ln(1+iim_v5r)
gen ltrv14_i=ln(1+iim_v14r)


/** TABLE I**/			
***DOMESTIC plus TRANSNATIONAL TERRORISM
***POOLED CROSS SECTION
***Total trade (exp+imp)

reg ltrv1 domt trat lgdp lgdppc border comlang ldist landl regional custrict11 colony comcol island i.year, cl(pairid)
est sto m1
test domt=trat

reg ltrv4 domt trat lgdp lgdppc border comlang ldist landl regional custrict11 colony comcol island i.year, cl(pairid)
est sto m2
test domt=trat

reg ltrv14 domt trat lgdp lgdppc border comlang ldist landl regional custrict11 colony comcol island i.year, cl(pairid)
est sto m3
test domt=trat

esttab m1 m2 m3, b(%7.3f) se(%7.3f) star stats(N) title("Terrorism Effect on Total Trade") keep(domt trat lgdp lgdppc border comlang ldist landl regional custrict11 colony comcol island) 

***Fixed EFFECTS

xi: xtreg ltrv1 domt trat lgdp lgdppc regional custrict11 i.year, fe cl(pairid)
est sto m1
test domt=trat

xi: xtreg ltrv4 domt trat lgdp lgdppc regional custrict11 i.year, fe cl(pairid)
est sto m2
test domt=trat

xi: xtreg ltrv14 domt trat lgdp lgdppc regional custrict11 i.year, fe cl(pairid)
est sto m3
test domt=trat

esttab m1 m2 m3, b(%7.3f) se(%7.3f) star stats(N) title("Terrorism Effect on Total Trade") keep(domt trat lgdp lgdppc regional custrict11) 

/** TABLE II**/
***Fixed EFFECTS
***Total exp

xi: xtreg ltrv1_e domt trat lgdp lgdppc regional custrict11 i.year, fe cl(pairid)
est sto m1
test domt=trat

xi: xtreg ltrv4_e domt trat lgdp lgdppc regional custrict11 i.year, fe cl(pairid)
est sto m2
test domt=trat

xi: xtreg ltrv14_e domt trat lgdp lgdppc regional custrict11 i.year, fe cl(pairid)
est sto m3
test domt=trat

esttab m1 m2 m3, b(%7.3f) se(%7.3f) star stats(N) title("Terrorism Effect on Exports and Imports, Separately") keep(domt trat lgdp lgdppc regional custrict11) 

*****Total imp

xi: xtreg ltrv1_i domt trat lgdp lgdppc regional custrict11 i.year, fe cl(pairid)
est sto m1
test domt=trat

xi: xtreg ltrv4_i domt trat lgdp lgdppc regional custrict11 i.year, fe cl(pairid)
est sto m2
test domt=trat

xi: xtreg ltrv14_i domt trat lgdp lgdppc regional custrict11 i.year, fe cl(pairid)
est sto m3
test domt=trat

esttab m1 m2 m3, b(%7.3f) se(%7.3f) star stats(N) title("Terrorism Effect on Exports and Imports, Separately") keep(domt trat lgdp lgdppc regional custrict11) 


/**Table III**/
***Furthering Investigation by Excluding Fuel Values from Primary Exports
***POOLED CROSS SECTION

reg ltrv5 domt trat lgdp lgdppc border comlang ldist landl regional custrict11 colony comcol island i.year, cl(pairid)
est sto m1
test domt=trat

esttab m1, b(%7.3f) se(%7.3f) star stats(N) title("Further Investigation on Terrorism's Effect on Export of Primary Commodities") keep(domt trat lgdp lgdppc border comlang ldist landl regional custrict11 colony comcol island) 

***FIXED EFFECTS

xi: xtreg ltrv5_e domt trat lgdp lgdppc regional custrict11 i.year, fe cl(pairid)
est sto m1
test domt=trat

esttab m1, b(%7.3f) se(%7.3f) star stats(N) title("Further Investigation on Terrorism's Effect on Export of Primary Commodities") keep(domt trat lgdp lgdppc regional custrict11) 

log close

