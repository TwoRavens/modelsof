capture log close
capture log using "e:\a\jv\jv_redo_base.scml", replace

*This do-file puts together and formats the original 2% 1851 and 100% 1881 British Census sample. 
*It groups the individuals according to their birth decade and county of birth.
*It also classifies occupational information and assigns earnings to those occupations.
*grain price data are added from the Laim Brunt data set, and grain growing area, poor law and 
*other regional evidenceare added from the George Boyer data set.
*Finally, it the Tables Figures of the Baten, Crayen and Voth (2013) paper.

/*This global redo file needs the following sub-redo files in a directory  e:\a\jv
copy  e:\a\jv\add_explan.do		 e:\a\jv\add_explan.do, replace
copy  e:\a\jv\r_ncht.do		 e:\a\jv\r_ncht.do, replace
copy  e:\a\jv\r_htct.do		 e:\a\jv\r_htct.do, replace
copy "e:\a\jv\add_earn.do" "e:\a\jv\add_earn.do", replace
copy g:\a\jv\r_vuln_farm.do e:\a\jv\r_vuln_farm.do, replace

*Input files are
*the following file was created by login into NAPP on March 11th, 2013, and retrieving the variables age, sex, bplctygb and occstrng
*from the UK 1851 sample
copy  e:\a\jv\uk51_1303.dta  	 e:\a\jv\uk51_1303.dta, replace
copy  e:\a\jv\uk81_1303.dta  	 e:\a\jv\uk81_1303.dta, replace
copy  e:\a\jv\ukallht_jv.dta 	 e:\a\jv\ukallht_jv.dta, replace

copy "e:\a\jv\grain data from Liam Brunt.csv" "e:\a\jv\grain data from Liam Brunt.csv", replace
copy "e:\a\dh\wandsworth smallpox study.dta" "e:\a\dh\wandsworth smallpox study.dta", replace
copy "e:\a\dh\nsw smallpox study.dta" "e:\a\dh\nsw smallpox study.dta" , replace
copy "e:\a\dh\unionarmybrian.dta" "e:\a\dh\unionarmybrian.dta" , replace
copy "e:\a\jv\france2362_040206.dta" "e:\a\jv\france2362_040206.dta" , replace
*/

clear
set matsize 650
set mem 910m
*set mem 1250m

*##1
*********Table 1-new Numeracy differences by height
*********Table 1-A England Wandsworth
clear 
use "e:\a\jv\wandsworth smallpox study.dta", clear
g tall=0
*sum height
replace tall=1 if height>64.57419
g numerate=0
replace numerate=1 if floor(age/5)~=age/5
drop if age<23 | age>72
drop if year10<1800 | year10>1849
logit numerate tall 
g mult5=0
replace mult5=1 if numerate==0
collapse (mean) height mult5, by(tall)
g wi=mult5*500
edit height wi
*********Table 1-B Ireland
use "e:\a\jv\nsw smallpox study.dta", clear
keep if fwgborn==6
drop if age<23 | age>62
drop if birth<1790 | birth>1819
sum height
g tall=0
replace tall=1 if height> 65.66262
*64.53553 
g numerate=0
replace numerate=1 if floor(age/5)~=age/5
logit numerate tall 
g mult5=0
replace mult5=1 if numerate==0
collapse (mean) height mult5, by(tall)
g wi=mult5*500
edit height wi

*********Table 1-C US
use "e:\a\jv\unionarmybrian.dta", clear
destring age, gen(age_n)
g numerate=0
replace numerate=1 if floor(age_n/5)~=age_n/5
g byear= enlyr -age_n
keep if byear>=10 & byear<=30
*the following restricts to US-born
*keep if length(birthst )==2 & birthst~="--" 
*military ages below 33 in the U.S. were counter-checked, hence we restrict here to older soldiers
drop if age_n<33 | age_n>62
drop if ht<60
destring height, gen(height_n)
sum ht
g tall=0
replace tall=1 if ht>  67.91272
logit numerate tall 
capture drop mult5
g mult5=0
replace mult5=1 if numerate==0
collapse (mean) height_n mult5, by(tall)
g wi=mult5*500
edit height_n wi

*********Table 1-D France
*--Paris
use "e:\a\jv\france2362_040206.dta", clear
g tallparis=0
replace tallparis=1 if heightcm>1697.926 
logit numerate tall_all if provinc=="ILE DE FRANCE"
collapse (mean) h_trunc2 mult5 if provinc=="ILE DE FRANCE", by(tallparis)
g wi=mult5*500
edit tallparis h_trunc2 wi
*---northeast
use "e:\a\jv\france2362_040206.dta", clear
g northeast=0
replace northeast=1 if region<=4 & region~=0 & region~=. & provinc~="ILE DE FRANCE"
g tallne=0
replace tallne=1 if heightcm> 1706.073
logit numerate tallne if northeast==1
collapse (mean) h_trunc2 mult5 if northeast==1, by(tallne)
g wi=mult5*500
edit tallne h_trunc2 wi
*---southwest
use "e:\a\jv\france2362_040206.dta", clear
g southwest=0
replace southwest=1 if region>=6 & region~=0 & region~=. & provinc~="ILE DE FRANCE"
g tallsw=0
replace tallsw=1 if heightcm>1695.291
logit numerate tallsw if southwest==1
collapse (mean) h_trunc2 mult5 if southwest==1, by(tallsw)
g wi=mult5*500
edit tallsw h_trunc2 wi
*--France total
use "e:\a\jv\france2362_040206.dta", clear
*g tall_all=0
*replace tall_all=1 if heightcm>1700.785
logit numerate tall_all
collapse (mean) h_trunc2 mult5, by(tall_all)
g wi=mult5*500
edit tall_all h_trunc2 wi

/*
*The following part is not executed, because the data sets uk51_1303.dta and uk81_1303.dta
*are proprietary data which may be downloaded from the North Atlantic Population project (NAPP) internet
*page, but they may not be distributed by us. Hence we made sure that all steps following the 
*download of the UK 1851 and UK 1881a datasets are carefully documented. We downloaded on March 11, 2013,
*the following variables: age, sex, bplctygb and occstrng.
*The dofile contionues to run with paragraph #12

*------------the following part preprocesses the data
*#2
use "e:\a\jv\uk51_1303.dta", replace
*After removing all counties for which not all explanatory variables
*are available in sufficient measurement quality, we are left with the following 34 counties: 
keep if bplctygb==017 | bplctygb==018 | bplctygb==021 | bplctygb==025 | bplctygb==028 | ///
bplctygb==030 | bplctygb==031 | bplctygb==033 | bplctygb==034 | bplctygb==037 | bplctygb==038 | ///
bplctygb==039 | bplctygb==040 | bplctygb==044 | bplctygb==046 | bplctygb==048 | bplctygb==054 | ///
bplctygb==057 | bplctygb==058 | bplctygb==059 | bplctygb==062 | bplctygb==068 | bplctygb==069 | ///
bplctygb==070 | bplctygb==071 | bplctygb==073 | bplctygb==082 | bplctygb==085 | bplctygb==087 | ///
bplctygb==088 | bplctygb==089 | bplctygb==090 | bplctygb==092 | bplctygb==095 | bplctygb==097 | ///
bplctygb==100 

g ct=""
replace ct="BDF" if bplctygb == 17
replace ct="BEK" if bplctygb == 18
replace ct="BUK" if bplctygb == 21
replace ct="CAM" if bplctygb == 25
replace ct="CHS" if bplctygb == 28
replace ct="CON" if bplctygb == 30
replace ct="CUL" if bplctygb == 31
replace ct="DBY" if bplctygb == 33
replace ct="DEV" if bplctygb == 34
replace ct="DOR" if bplctygb == 37
replace ct="DUR" if bplctygb == 38
replace ct="ESS" if bplctygb == 40
replace ct="GLS" if bplctygb == 44
replace ct="HAM" if bplctygb == 46
replace ct="HRT" if bplctygb == 48
replace ct="KEN" if bplctygb == 54
replace ct="LAN" if bplctygb == 57
replace ct="LEI" if bplctygb == 58
replace ct="LIN" if bplctygb == 59
replace ct="MDX" if bplctygb == 62
replace ct="NBL" if bplctygb == 70
replace ct="NFK" if bplctygb == 68
replace ct="NTT" if bplctygb == 71
replace ct="OXF" if bplctygb == 73
replace ct="SAL" if bplctygb == 82
replace ct="SOM" if bplctygb == 85
replace ct="STA" if bplctygb == 87
replace ct="SUF" if bplctygb == 88
replace ct="SUR" if bplctygb == 89
replace ct="SUS" if bplctygb == 90
replace ct="WAR" if bplctygb == 92
replace ct="WIL" if bplctygb == 95
replace ct="WOR" if bplctygb == 97
replace ct="YKS" if bplctygb == 100
replace ct=lower(ct)
drop if ct==""
drop bplctygb

*#3 restructure male and female cases into cases denoted with dummies, standardize birth county names
g female=0
replace female=1 if sex==2
drop sex
drop if age<23 | age>72
*drop if ct=="MDX"

*#4 generate agegroups and birth decades via age groups (in which decade most birth years?), in order to mitigate mortality bias 
g agegroup=.
replace agegroup=23 if age>=23 & age<33
replace agegroup=33 if age>=33 & age<43
replace agegroup=43 if age>=43 & age<53
replace agegroup=53 if age>=53 & age<63
replace agegroup=63 if age>=63 & age<73
gen year10=.
replace year10=1820 if agegroup==23
replace year10=1810 if agegroup==33
replace year10=1800 if agegroup==43
replace year10=1790 if agegroup==53
replace year10=1780 if agegroup==63

*#5 generate Whipple-base variable mult5 (1, if multiple of 5) 
gen mult5=0
replace mult5=1 if floor(age/5)==age/5
gen cyear=1851
save "e:\a\jv\bc1851orx.dta", replace

*#6 restructure the 1881 raw fil g: age, county of birth, reduce to those countries for which we have poor law data
* and add cyear variable for the year of the census
clear 
use "e:\a\jv\uk81_1303.dta", replace
*After removing all counties for which not all explanatory variables
*are available in sufficient measurement quality, we are left with the following 34 counties: 
keep if bplctygb==017 | bplctygb==018 | bplctygb==021 | bplctygb==025 | bplctygb==028 | ///
bplctygb==030 | bplctygb==031 | bplctygb==033 | bplctygb==034 | bplctygb==037 | bplctygb==038 | ///
bplctygb==039 | bplctygb==040 | bplctygb==044 | bplctygb==046 | bplctygb==048 | bplctygb==054 | ///
bplctygb==057 | bplctygb==058 | bplctygb==059 | bplctygb==062 | bplctygb==068 | bplctygb==069 | ///
bplctygb==070 | bplctygb==071 | bplctygb==073 | bplctygb==082 | bplctygb==085 | bplctygb==087 | ///
bplctygb==088 | bplctygb==089 | bplctygb==090 | bplctygb==092 | bplctygb==095 | bplctygb==097 | ///
bplctygb==100 
g ct=""
replace ct="BDF" if bplctygb == 17
replace ct="BEK" if bplctygb == 18
replace ct="BUK" if bplctygb == 21
replace ct="CAM" if bplctygb == 25
replace ct="CHS" if bplctygb == 28
replace ct="CON" if bplctygb == 30
replace ct="CUL" if bplctygb == 31
replace ct="DBY" if bplctygb == 33
replace ct="DEV" if bplctygb == 34
replace ct="DOR" if bplctygb == 37
replace ct="DUR" if bplctygb == 38
replace ct="ESS" if bplctygb == 40
replace ct="GLS" if bplctygb == 44
replace ct="HAM" if bplctygb == 46
replace ct="HRT" if bplctygb == 48
replace ct="KEN" if bplctygb == 54
replace ct="LAN" if bplctygb == 57
replace ct="LEI" if bplctygb == 58
replace ct="LIN" if bplctygb == 59
replace ct="MDX" if bplctygb == 62
replace ct="NBL" if bplctygb == 70
replace ct="NFK" if bplctygb == 68
replace ct="NTT" if bplctygb == 71
replace ct="OXF" if bplctygb == 73
replace ct="SAL" if bplctygb == 82
replace ct="SOM" if bplctygb == 85
replace ct="STA" if bplctygb == 87
replace ct="SUF" if bplctygb == 88
replace ct="SUR" if bplctygb == 89
replace ct="SUS" if bplctygb == 90
replace ct="WAR" if bplctygb == 92
replace ct="WIL" if bplctygb == 95
replace ct="WOR" if bplctygb == 97
replace ct="YKS" if bplctygb == 100
replace ct=lower(ct)
drop if ct==""
drop bplctygb
keep if age>=23 & age<=72
g female=0
replace female=1 if sex==2
*ren occup 

*#7 generate age groups x3-(x+1)2, and define birth decades via age groups (in which decade most birth years?), in order to minimize mortality bias 
g agegroup=.
replace agegroup=23 if age>=23 & age<33
replace agegroup=33 if age>=33 & age<43
replace agegroup=43 if age>=43 & age<53
replace agegroup=53 if age>=53 & age<63
replace agegroup=63 if age>=63 & age<73
gen year10=.
replace year10=1850 if agegroup==23
replace year10=1840 if agegroup==33
replace year10=1830 if agegroup==43
replace year10=1820 if agegroup==53
replace year10=1810 if agegroup==63

*#8 generate Whipple-base variable mult5 (1, if multiple of 5) 
gen mult5=0
replace mult5=1 if floor(age/5)*5==age
save "e:\a\jv\bc1881orx.dta", replace

*#9 Table 1: Whipple scores, by birth decade, census date, and gender
use "e:\a\jv\bc1881orx.dta",clear
collapse (mean) mult5 (count) nc=age, by(ct female year10)
replace nc=nc/50
g cyear=1881
save "e:\a\jv\bc1881ctx.dta", replace
use "e:\a\jv\bc1851orx.dta", clear
*ren cntybrth ct
collapse (mean) mult5 (count) nc=age, by(ct female year10)
g cyear=1851
save "e:\a\jv\bc1851ctx.dta", replace
append using "e:\a\jv\bc1881ctx.dta"
save "e:\a\jv\bc1851and1881orx.dta", replace
gen whipple=500*mult5
table female year10 cyear if year10==1810|year10==1820, c(mean whipple)

*#10 calculate the Whipple Index by gender, county and birth decade. No differentiation by census year anymore. 
use "e:\a\jv\bc1851and1881orx.dta", clear
keep if nc>=250 
*the following would allow to use the same cases as 
*with download of 2008: keep if nc>=250 | (ct=="nbl" & year10==1780 & female==1)
replace ct="nbl" if ct=="nth"
gen whipple=500*mul
sort ct year10 cyear 
collapse (mean) mult (sum) nc, by(female ct year10)
gen whipple=500*mul
drop if ct==""


*#11 add relief and other information on county level
quietly do "e:\a\jv\add_explan.do"
save "e:\a\jv\bc1881u1851agg_collx.dta", replace

*/

*#12 add national grain price 
use "e:\a\jv\bc1881u1851agg_collx.dta", clear
*the following data was obtained by averaging the grain prices by decade across all counties:
tabstat gp, by(year)
*    1780 |   68.9047
*    1790 |  84.61335
*    1800 |   124.841
*    1810 |   134.534
*    1820 |  89.02578
*    1830 |  87.15375
*    1840 |    98.568

g wpric=.
replace wpric=68.9047 if year10==1780
replace wpric=84.61335	if year10==1790
replace wpric=124.841	if year10==1800
replace wpric=134.534	if year10==1810
replace wpric=89.02578	if year10==1820
replace wpric=87.15375	if year10==1830
replace wpric=98.568	if year10==1840

*#13 calculate relieflack and interaction term relieflack_gprice, generate numeric code for counties
g reliefhigh=0
replace reliefhigh=1 if relief>=.6253819
g relieflack=2.012946-relief
egen county_no=group(ct)
gen relieflack_gp=relieflack*gp
save "e:\a\jv\bc18811851x.dta", replace

*#14 ------------------------------Generate data for Figure 5-new:
table year10 reliefhigh, c(mean whipple) 

*#15 ---------------
g ctfem=ct+string(female)
egen ctfeno=group(ctfem)
tsset  ctfeno year10
label	variable	gp	"county grain price"
label	variable	wpric	"national grain price"
save "e:\a\jv\bc18811851panelx.dta", replace

*#16 ----------------------Table 2-New, Column 1 to 5: Regression Analysis: Whipple Scores and Grain Prices
use "e:\a\jv\bc18811851panelx.dta", clear
cd "e:\a\jv"
quiet reg whipple gp female  , r cl(ct)
estimates store m1
quiet reg whipple gp female reliefhigh   , r cl(ct)
estimates store m2
quiet reg whipple gp female relieflack  , r cl(ct)
estimates store m5
quiet reg whipple wpric female relieflack  , r cl(ct)
estimates store m6
quiet qreg whipple female relieflack gp
estimates store m7
esttab m1 m2 m5 m6 m7 using "e:\a\jv\Table 2_1-5.csv",replace star(* 0.1 ** 0.05 *** 0.001) stats(N)  constant title("Table 2, Column 1 to 5")
set more on
*the same again without , r and cl(ct) to obtain the adj. R-sq
use "e:\a\jv\bc18811851panelx.dta", clear
set more off 
quiet reg whipple gp female  , 
estimates store m1
quiet reg whipple gp female reliefhigh   , 
estimates store m2
quiet reg whipple gp female relieflack  , 
estimates store m5
quiet reg whipple wpric female relieflack  , 
estimates store m6
esttab m1 m2 m5 m6 using "e:\a\jv\Table 2_1-4w.csv",replace star(* 0.1 ** 0.05 *** 0.001) stats(N r2)  constant title("Table 2, Adj. Rsq for Column 1 to 4")
set more on

/*
*The following part is not executed, because the data sets uk51_1303.dta and uk81_1303.dta
*are proprietary data which may be downloaded from the North Atlantic Population project (NAPP) internet
*page, but they may not be distributed by us. Hence we made sure that all steps following the 
*download of the UK 1851 and UK 1881a datasets are carefully documented. We downloaded on March 11, 2013,
*the following variables: age, sex, bplctygb and occstrng.
*The dofile contionues to run with paragraph #18

*----------------------here new data set, organized by census
*#17 
use "e:\a\jv\bc1881orx.dta",clear
collapse (mean) mult5 (count) nc=age, by(ct female year10)
replace nc=nc/50
g cyear=1881
saveold "e:\a\jv\bc1881ctx.dta", replace
use "e:\a\jv\bc1851orx.dta", clear
*ren cntybrth ct
collapse (mean) mult5 (count) nc=age, by(ct female year10)
g cyear=1851
saveold "e:\a\jv\bc1851ctx.dta", replace
append using "e:\a\jv\bc1881ctx.dta"
saveold "e:\a\jv\bc1851and1881orx.dta", replace
*/

*#18
use "e:\a\jv\bc1851and1881orx.dta", clear
gen whipple=500*mult5
table female year10 cyear if year10==1810|year10==1820, c(mean whipple)

*#19 calculate the Whipple Index by gender, county and birth decade. Differentiation by census year 
drop if nc<250
replace ct="nbl" if ct=="nth"
sort ct year10 cyear 
drop if ct==""


*#20 add relief and other information on county level
quietly do "e:\a\jv\add_explan.do"

*#21 add national grain price 
g wpric=.
replace wpric=68.9047 if year10==1780
replace wpric=84.61335	if year10==1790
replace wpric=124.841	if year10==1800
replace wpric=134.534	if year10==1810
replace wpric=89.02578	if year10==1820
replace wpric=87.15375	if year10==1830
replace wpric=98.568	if year10==1840

*#22 calculate relieflack and interaction term relieflack_gprice, generate numeric code for counties
g reliefhigh=0
replace reliefhigh=1 if relief>=.6253819
g relieflack=2.012946-relief
egen county_no=group(ct)
gen relieflack_gp=relieflack*gp
g ctfem=ct+string(female)+string(cyear)
egen ctfeno=group(ctfem)
tsset  ctfeno year10
label	variable	gp	"county grain price"
label	variable	wpric	"national grain price"
save e:\a\jv\tmp.dta, replace
use e:\a\jv\tmp.dta, clear

*#23---------------------Table 2, Column 6 to 8: base regressions and quantile regr with census fixed effects
quiet xi: reg whipple gp female reliefhigh  i.cyear  , r cl(ct)
estimates store m6
quiet xi: reg whipple gp female relieflack i.cyear  , r cl(ct)
estimates store m7
quiet xi: qreg whipple female relieflack gp 
estimates store m8
esttab m6 m7 m8 using "e:\a\jv\Table 2_6-8.csv",replace star(* 0.1 ** 0.05 *** 0.001) stats(N r2)  constant title("Table 2, Column 6 to 8")
*and the same again without clustering, to obtain adj. R-sq
xi: reg whipple gp female reliefhigh  i.cyear  , 
estimates store m6
xi: reg whipple gp female relieflack i.cyear  , r
estimates store m7
esttab m6 m7 using "e:\a\jv\Table 2_6-7w.csv",replace star(* 0.1 ** 0.05 *** 0.001) stats(N r2)  constant title("Table 2, Adj. Rsq for Column 6 to 7")

*#24--------------------Vulnerability analysis
use "e:\a\jv\bc18811851x.dta", clear
g ctfem=ct+string(female)
egen ctfeno=group(ctfem)
tsset  ctfeno year10
label	variable	gp	"county grain price"
label	variable	wpric	"national grain price"
g vulnerable=.
replace ct=lower(ct)
do e:\a\jv\r_vuln_farm.do
replace ct=upper(ct)
g dummy_vuln=.
replace dummy_vuln=1 if vulnerable>.5149576& vulnerable~=.
replace dummy_vuln=0 if vulnerable<=.5149576 & vulnerable~=.
capture drop gpvulnerab
g gpvulnerab=gp*dummy_vuln
qreg whipple female relieflack gp gpvulnerab vulnerab
estimates store m9
esttab m9 using "e:\a\jv\Table 2_9.csv",replace star(* 0.1 ** 0.05 *** 0.001) stats(N r2) constant title("Table 2, Column 9")


/*
*The following part is not executed, because the data sets uk51_1303.dta and uk81_1303.dta
*are proprietary data which may be downloaded from the North Atlantic Population project (NAPP) internet
*page, but they may not be distributed by us. Hence we made sure that all steps following the 
*download of the UK 1851 and UK 1881a datasets are carefully documented. We downloaded on March 11, 2013,
*the following variables: age, sex, bplctygb and occstrng.
*The dofile continues to run with paragraph #27

*#25%%%%%%%%%%%%%%%%%%  high-frequency analysis - preparations
set mem 2G
use "e:\a\jv\bc1851orx.dta", clear
append using "e:\a\jv\bc1881orx.dta"
replace cyear = 1881 if cyear == .
generate birthyear = cyear - age
quietly do e:\a\jv\countygrainprice
save e:\a\jv\bc1851and1881orx_not_collapsed, replace
set more off

*#26 Fit a gender-census year specific age line by county
collapse (count) N=birthyear, by(ct age female cyear)

// non-parametric 
gen expected_N=.
levelsof ct, local(county)
foreach x in `county' {
	foreach y in 0 1 {
		foreach z in 1851 1881 {
			qui lowess N age if ct=="`x'"&female==`y'&cyear==`z', gen(exp_N_`x'`y'`z')
			replace expected_N=exp_N_`x'`y'`z' if ct=="`x'"&female==`y'&cyear==`z'
			drop exp_N_`x'`y'`z'
		}
	}
}

gen residual=abs(N-expected_N)
gen residual_norm=(residual/expected_N)*100

// a linear fit
gen residual_linear=.
levelsof ct, local(county)
foreach x in `county' {
	foreach y in 0 1 {
		foreach z in 1851 1881 {
			qui reg N age if ct=="`x'"&female==`y'&cyear==`z'
			predict res`x'`y'`z', r
			replace residual_linear=res`x'`y'`z' if ct=="`x'"&female==`y'&cyear==`z'
			drop res`x'`y'`z'
		}
	}
}

gen residual_linear_norm=(residual_linear/expected_N)*100
collapse (mean) residual*, by(ct female age)
merge 1:m ct age female using "bc1851and1881orx_not_collapsed"
drop _merge
collapse (mean) mult5 year10 agegroup countygrain* national* resid*, by(birthyear female ct)

*#27 Add relief and other information on county level
quietly do "e:\a\jv\add_explan.do"
// label variables
la var birthyear "Birth year"
la var ct "County"
la var countygrainprice_year0 "County grainprice at the year of birth"
forvalues x=5(5)15 {
	la var countygrainprice_year`x' "County grainprice at age `x'"
}
la var countygrainprice_2bf "County grain price 2 years before reported birth year"
la var countygrainprice_2aft "County grain price 2 years after reported birth year"
la var national_price_year0 "National grain price at the year of birth"
la var national_price_2bf "National grain price 2 years before reported birth year"
la var national_price_2aft "National grain price 2 years after reported birth year"
la var year10 "Birth decade"
la var mult5 "Age is multiple of 5"
la var agegroup "Age group - 10 year intervals"
la var residual "Residuals from non-parametric fit"
la var residual_norm "Residuals, percentage deviation from expected"
la var residual_linear "Residuals, linear fit"
la var residual_linear_norm ""
la var gp "County grain price in the birth decade"
la var relief "County poor relief in birth decade"
replace ct=lower(ct)
save "e:\a\jv\bc1851and1881orx_n-with grain-v_col.dta", replace
*/

*#28
use "e:\a\jv\bc1851and1881orx_n-with grain-v_col.dta",clear
set more off
**calculate relieflack, crisis, and interaction term relieflack_gprice, generate numeric code for counties
/*g reliefhigh=0
replace reliefhigh=1 if relief>=.6253819
g relieflack=2.012946-relief
egen county_no=group(ct)
gen relieflack_gp=relieflack*gp
*national grain price
g wpric=.
replace wpric=68.9047 if year10==1780
replace wpric=84.61335	if year10==1790
replace wpric=124.841	if year10==1800
replace wpric=134.534	if year10==1810
replace wpric=89.02578	if year10==1820
replace wpric=87.15375	if year10==1830
replace wpric=98.568	if year10==1840
**squared county grain price
gen countp2=countygrainprice_year0^2
**extreme grain, top quintile of prices
egen highestquintile = pctile(countygrainprice_year0), p(80)
gen extreme_grain = 0
replace extreme_grain = 1 if countygrainprice_year0 > highestquintile
*/

*#29***----------------------------Table 3-new
estimates clear
qui reg residual_norm countygrainprice_year0 female relieflack  , r 
eststo m1
qui xi: reg residual_norm countygrainprice_year0 extreme_grain  female , r 
eststo m2
qui xi: reg residual_norm countygrainprice_year0 female  countp2, r 
eststo m3
quietly xi: reg residual_norm countygrainprice_year0 female i.ct, r 
eststo m4
quietly xi: reg residual_norm countygrainprice_year0 female grain density cottind, r 
eststo m5
esttab m1 m2 m3 m4 m5 using "e:\a\jv\Table 3.csv",replace star(* 0.1 ** 0.05 *** 0.001) stats(N r2) keep(relieflack extreme_grain countp2 female grain density cottind countygrainprice_year0) beta title("Table 3")

/*
*The following part is not executed, because the data set ukallht_jv_9.dta
*are proprietary data which may be downloaded from the Essex Data Archive (or successor) internet
*page, but they may not be distributed by us. Hence we made sure that all steps following the 
*download are carefully documented. The download was eprformed on March 11, 1996,
*The dofile continues to run with paragraph #33

*#30-------------------------height and numeracy
use "e:\a\jv\ukallht_jv_9.dta", clear
*e:\a\dh\ukallpc.dta is a proprietary data set##
*the only changes which we made compare to e:\a\dh\ukallpc.dta was to rename some of the variables,
*and to switch age and ht in the section of cases no. 2988-3416, where obviously age was erroneously
*typed into the ht field and vice versa
g age18=0
replace age18=1 if age==18
g age19=0
replace age19=1 if age==19
g age20=0
replace age20=1 if age==20
g bdf=0
replace bdf=1 if ct3=="bdf"
g bek=0
replace bek=1 if ct3=="bek"
g buk=0
replace buk=1 if ct3=="buk"
g cam=0
replace cam=1 if ct3=="cam"
g chs=0
replace chs=1 if ct3=="chs"
g con=0
replace con=1 if ct3=="con"
g cul=0
replace cul=1 if ct3=="cul"
g dby=0
replace dby=1 if ct3=="dby"
g dev=0
replace dev=1 if ct3=="dev"
g dor=0
replace dor=1 if ct3=="dor"
g dur=0
replace dur=1 if ct3=="dur"
g ess=0
replace ess=1 if ct3=="ess"
g gls=0
replace gls=1 if ct3=="gls"
g ham=0
replace ham=1 if ct3=="ham"
g her=0
replace her=1 if ct3=="her"
g hrt=0
replace hrt=1 if ct3=="hrt"
g hun=0
replace hun=1 if ct3=="hun"
g ken=0
replace ken=1 if ct3=="ken"
g lan=0
replace lan=1 if ct3=="lan"
g lin=0
replace lin=1 if ct3=="lin"
g mnm=0
replace mnm=1 if ct3=="mnm"
g nbl=0
replace nbl=1 if ct3=="nbl"
g nfk=0
replace nfk=1 if ct3=="nfk"
g oxf=0
replace oxf=1 if ct3=="oxf"
g rut=0
replace rut=1 if ct3=="rut"
g sal=0
replace sal=1 if ct3=="sal"
g som=0
replace som=1 if ct3=="som"
g sta=0
replace sta=1 if ct3=="sta"
g suf=0
replace suf=1 if ct3=="suf"
g sur=0
replace sur=1 if ct3=="sur"
g sus=0
replace sus=1 if ct3=="sus"
g war=0
replace war=1 if ct3=="war"
g wil=0
replace wil=1 if ct3=="wil"
save e:\a\jv\ukallren.dta, replace
*Cinnirella (2009) finds that Minimum height requirements varied strongly by region in the UK. The overwhelming
*majority used 64 inches or lower before the recruitment year of 1820, and 65 inches or lower thereafter, i.e. 162.56 and 165.1 cm
*This quite high MHR stands for a relatively conservative estimate, so the estimates are on the safe side.
set more off 
*truncreg htcm if bdec==1780 & qdec<1820 & htcm>120 & htcm<200 & age>=18 & age<55, ll(162.56)
truncreg htcm age18 age19 age20 bdf bek buk cam chs con cul dby dev dor dur ess gls ham her hrt hun ken lin mnm nbl nfk oxf rut sal som sta suf sur sus war wil if bdec==1780 & qdec<1820 & htcm>120 & htcm<200 & age>=18 & age<55, ll(162.56)
truncreg htcm age18 age19 age20 bdf bek buk cam chs con cul dby dev dor dur ess gls ham her hrt hun ken lin mnm nbl nfk oxf rut sal som sta suf sur sus war wil if bdec==1790 & qdec<1820 & htcm>120 & htcm<200 & age>=18 & age<55, ll(162.56)
truncreg htcm age18 age19 age20 bdf bek buk cam chs con cul dby dev dor dur ess gls ham her hrt hun ken lin mnm nbl nfk oxf rut sal som sta suf sur sus war wil if bdec==1800 & qdec>1820 & htcm>120 & htcm<200 & age>=18 & age<55, ll(165.1)
truncreg htcm age18 age19 age20 bdf bek buk cam chs con cul dby dev dor dur ess gls ham her hrt hun ken lin mnm nbl nfk oxf rut sal som sta suf sur sus war wil if bdec==1810 & qdec>1820 & htcm>120 & htcm<200 & age>=18 & age<55, ll(165.1)
truncreg htcm age18 age19 age20 bdf bek buk cam chs con cul dby dev dor dur ess gls ham her hrt hun ken lin mnm nbl nfk oxf rut sal som sta suf sur sus war wil if bdec==1820 & qdec>1820 & htcm>120 & htcm<200 & age>=18 & age<55, ll(165.1)
truncreg htcm age18 age19 age20 bdf bek buk cam chs con cul dby dev dor dur ess gls ham her hrt hun ken lin mnm nbl nfk oxf rut sal som sta suf sur sus war wil if bdec==1830 & qdec>1820 & htcm>120 & htcm<200 & age>=18 & age<55, ll(165.1)
set more on
clear
*The results are then copied into the file e:\a\jv\r_htct.do. See also the note at the beginning of this do-file

*#31
use "e:\a\jv\bc18811851panelx.dta", clear
replace ct=lower(ct)
do e:\a\jv\r_htct.do
save "e:\a\jv\bc18811851panel_with_htx.dta", replace 

*#32 calculation of numbers of cases
use "e:\a\jv\ukallht_jv_9.dta", clear
collapse (count) nc=age if bdec>=1780 & bdec<1830 & htcm>120 & htcm<200 & age>=18 & age<55, by(ct3 bdec)
drop if ct==""
save e:\a\jv\ukct3bdecx.dta, replace
*then this is used for adding the nc variable in the do-file e:\a\jv\r_ncht.do executed below
use "e:\a\jv\bc18811851panel_with_htx.dta", clear
*the 1830s values should be dropped, as the Floud/Wachter dataset contain too few observations
g htincl1830 = ht
replace ht=. if year10==1830
capture drop ncht
do e:\a\jv\r_ncht.do
gen heighthigh=.
recode heighthigh .=1 if ht >170.98
recode heighthigh .=0
recode heighth 1=. if ht==.
label variable ht "height"
save "e:\a\jv\bc18811851panel_with_ht_finalx.dta", replace
*/

use "e:\a\jv\bc18811851panel_with_ht_finalx.dta", clear
*#33----------------Figure 6-new, density plots
mdensity whipple, by(heighth) s(OT) c(m[-]m) xlabel ylabel w(8) key1(s(O) c(m[-]) "below average height") key2(s(T) c(m) "above average height")
*descriptives
set more off
sum whipple ht gp relieflack if ncht>=20 & whipple~=. & ht~=. &  gp~=. &  relieflack ~=. 

*#34----------------Table 4-new 
*regression of ht -> numeracy
set more off
xi: reg whipple ht if ncht>=20, r cl(ct)
estimates store m1
xi: reg whipple ht i.year10 if ncht>=20, r cl(ct)
estimates store m2
xi: reg whipple ht i.ct i.year10 if ncht>=20, r cl(ct)
estimates store m3
esttab  m1 m2 m3 using e:\a\jv\table4x.csv, ar2 star(* 0.10 ** 0.05 *** 0.01) csv replace label 

/*
*The following part is not executed, because the data sets uk51_1303.dta and uk81_1303.dta
*are proprietary data which may be downloaded from the North Atlantic Population project (NAPP) internet
*page, but they may not be distributed by us. Hence we made sure that all steps following the 
*download of the UK 1851 and UK 1881a datasets are carefully documented. We downloaded on March 11, 2013,
*the following variables: age, sex, bplctygb and occstrng.
*The dofile continues to run with paragraph #36
*-------------------------------------------preparing earnings regr
*#35 
use "e:\a\jv\bc1851orx.dta", clear
append using "e:\a\jv\bc1881orx.dta"
replace cyear = 1881 if cyear == .
capture g earn=.
ren  occstrng occuname
*the following do file takes long
do "e:\a\jv\add_earn.do"
replace earn=earn/100
collapse (mean) earn (count) nc_earn=cyear, by (female ct year10)
replace year10=1780 if year==8
replace year10=1790 if year==9
replace year10=1800 if year==0
replace year10=1810 if year==1
replace year10=1820 if year==2
replace year10=1830 if year==3
replace year10=1840 if year==4
replace year10=1850 if year==5
sort ct year10 female
replace ct=upper(ct)
sort ct year10 female
saveold "e:\a\jv\earn5181ax.dta", replace
*/

*#36
use "e:\a\jv\bc1881u1851agg_collx.dta", clear
keep ct year10 female whipple gp
sort ct year10 female
merge ct year10 female using "e:\a\jv\earn5181ax.dta"
g wpric=.
replace wpric=67.18288 if year10==1780
replace wpric=84.36111	if year10==1790
replace wpric=124.803	if year10==1800
replace wpric=134.195	if year10==1810
replace wpric=88.70466	if year10==1820
replace wpric=86.81541	if year10==1830
replace wpric=98.32946	if year10==1840
saveold "e:\a\jv\bc18811851earnax.dta", replace

*#37-----------Table 5-new 
use "e:\a\jv\bc18811851earnax.dta", clear
drop if nc_earn<500
g lnearn=ln(earn)
set more off
g logearn=ln(earn)
save e:\a\jv\tmp1.dta, replace
use e:\a\jv\tmp1.dta, clear
estimates clear
set more off
xi: ivreg28 logearn (whipple=wpric) female if nc_earn>1000, cl(ct)
estimates store m1
xi: ivreg28 logearn (whipple=wpric) female i.ct if nc_earn>500, cl(ct)
estimates store m2
xi: ivreg28 logearn (whipple=wpric) female i.ct i.year if nc_earn>500, cl(ct)
estimates store m3
xi: ivreg28 logearn (whipple=gp) female if nc_earn>500, cl(ct)
estimates store m4
xi: ivreg28 logearn (whipple=gp) female i.ct if nc_earn>500, cl(ct)
estimates store m5
xi: ivreg28 logearn (whipple=gp) female i.ct i.year if nc_earn>500, cl(ct)
estimates store m6
esttab   m1 m2 m3 m4 m5  m6 using table5x.csv, ar2 star(* 0.10 ** 0.05 *** 0.01) csv replace label 

/*
*The following part is not executed, because the data sets uk51_1303.dta and uk81_1303.dta
*are proprietary data which may be downloaded from the North Atlantic Population project (NAPP) internet
*page, but they may not be distributed by us. Hence we made sure that all steps following the 
*download of the UK 1851 and UK 1881a datasets are carefully documented. We downloaded on March 11, 2013,
*the following variables: age, sex, bplctygb and occstrng.
*The dofile continues to run with paragraph #27
*#38*-------------Figure 1
clear
set matsize 650
use "e:\a\jv\uk81_1303.dta", clear
drop if ct != "sus" | age < 23 | age >72
histogram age , discrete frequency 
use "e:\a\jv\uk51_1303.dta", clear
drop if ct != "som" | age < 23 | age >72
histogram age , discrete frequency 
*/

*#39*--------------preparing data for Figure 2, 3 and 4
clear all
insheet using "e:\a\jv\grain data from Liam Brunt.csv", names
**not all of this is necessary for the figures
rename wheatprice year
foreach x in bedford berks bucks cambridge cheshire	cornwall cumberland	derby devon ///
		   	dorset	durham	essex	gloucester	hampshire	hertford	///
		   	kent	lancashire	leicester	lincoln	 middlesex	monmouth	norfolk	northampton	///
		   	northumberland	nottingham	oxford	salop	somerset stafford	suffolk	 ///
		   	surrey	sussex	warwick	wilts	worcester	york	london	northwales	southwales {
	rename `x' countygrainprice_`x'
}
reshape long countygrainprice_, i(year) j(ct) string
rename countygrainprice_ countygrainprice_year0
save "e:\a\jv\grain data from Liam Brunt.dat", replace

*#40----------------Figure 3
**this part generates the categorical data used in the choropleth maps. It does not create the maps per se
egen float category_1794 = cut(countygrainprice_year0) if year == 1794, at(67.5,70.1,72.6,75.1,77.6,80.1,82.6,85.1,100) icodes
egen float category_1800 = cut(countygrainprice_year0) if year == 1800, at(138,156,161,166,171,176,181,186,200) icodes
*edit if category_1794 ~=.
*edit if category_1800~=.

*#41----------------Figure 4
graph box countygrainprice_year0 if year > 1790 & year < 1821, over(year)

*#42-----------------Figure 2
collapse (mean) countygrainprice_year0 , by(year)
twoway (connected countygrainprice_year0 year)

log close

