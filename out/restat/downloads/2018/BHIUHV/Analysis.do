
set more off

cd "..\RESTAT_WorkersBeneathTheFloodgates_Utar"


use "CumVars9901.dta", clear
append using "CumVars0210.dta"


xtset pid time

gen wto=0 if time==1
replace wto=1 if time==2

gen comp=affwd*wto

gen comprs=affwd_rs*wto


label var comp"COMP_D"
label var wto"Post-Shock"
label var comprs"COMP_C"



gen dhf=dhf99
qui do "MSVoc"


gen ocreg=1 if disc1_99==1
replace ocreg=2 if disc1_99==2 | disc1_99==3
replace ocreg=3 if disc1_99==4 | disc1_99==5
replace ocreg=4 if disc1_99==7 
replace ocreg=5 if disc1_99==8
replace ocreg=6 if disc1_99==9 & disc2_99~=99

replace ocreg=. if disc2_99==99
label define occat 1 "Managers" 2 "Professionals and Technicians" 3 "Clerks and Service Workers" 4 "Craft Workers" 5 "Operators" 6 "Labourers"
label value ocreg occat
***

gen comp_tspec4=affwd*tcspec4*wto
gen comprs_tspec4=affwd_rs*tcspec4*wto
gen tspec4_wto=tcspec4*wto

gen comp_mspec4=affwd*manspec4*wto
gen comprs_mspec4=affwd_rs*manspec4*wto
gen mspec4_wto=manspec4*wto

gen comp_rti=affwd*stdRTI*wto
gen comprs_rti=affwd_rs*stdRTI*wto
gen rti_wto=wto*stdRTI

gen comp_texp=affwd*tc_exp*wto
gen comprs_texp=affwd_rs*tc_exp*wto
gen texp_wto=wto*tc_exp

gen comp_mexp=affwd*manu_exp*wto
gen comprs_mexp=affwd_rs*manu_exp*wto
gen mexp_wto=wto*manu_exp

gen comp_ocexp=affwd*disc2_exp*wto
gen comprs_ocexp=affwd_rs*disc2_exp*wto
gen ocexp_wto=wto*disc2_exp

*Table 3 Panel A in the online appendix
**Summary Statistics**

 

 
foreach v of var  CInc  CPerInc CEmp CHrs CUnEmpA PYInc PYHrs LHW CNUI CNEDU  CPenInc CSickBen CUI CUIBen CEduAll COtBen {
qui su `v', detail
di "`v'" "{col 24}" %5.3f  r(mean)  "{col 34}" %5.3f r(sd) "{col 44}" %5.0f r(N)
}
 
foreach v of var  CInc  CPerInc CEmp CHrs CUnEmpA PYInc PYHrs LHW CNUI CNEDU  CPenInc CSickBen CUI CUIBen CEduAll COtBen{
qui su `v', detail
di "`v'" "{col 24}" %5.2f  r(mean)  "{col 34}" %5.2f r(sd) "{col 44}" %5.0f r(N)
}


 
label var CInc"Cumulative Earnings"
label var CPerInc"Cumulative Personal Income"
label var CEmp"Cumulative Employment"
label var CHrs"Cumulative Hours worked"
label var CNEDU"Number of Years with Education Allowance"
label var CUnEmpA"Cumulative Unemployment Spells"
label var PYHrs"Hours per year of emp"
label var PYInc"Earnings per year of emp"
label var CPenInc"Cumulative Pension Income (in initial personal income)"
label var CSickBen"Cumulative Sickness Benefit (in initial personal income)"
label var age99"Age as of 1999"
label var Fem"Female(=1)"
label var Imm"Immigrant(=1)"
label var ET1"College Edu(=1)"
label var ET2"Vocational Education(=1)"
label var ET3"High-school(=1)"
label var rsalary99"Annual(Primary)Wage"
label var rtotwage99"Total Annual Wages" 
label var normsal9699"1996-1999 Avg. Annual Wage"
label var yunemp99 "Past Unemp Spells in years " //summation of past spells as of 1999 measured in years
label var ntrend99"Negative Trend at Workplace"
label var experience99"Labor Mkt Experience" //measured in years //
g MacOp=0
replace MacOp=1 if disc2_99==82
label var MacOp"Machine Operator"

gen ImportCompetition="Exposed" if affwd==1
replace ImportCompetition="Non-Exposed" if affwd==0

global list1 "age99 Fem Imm union99 UImem99 ET1 ET2 CPerInc CInc CEmp CHrs  CNEDU PYHrs PYInc CUnEmpA"

estpost tabstat $list1 , columns(statistics) stats(mean sd N)
esttab using Table1.rtf, cells("mean(fmt(%5.3f)) sd count(fmt(%5.0f))") not nostar unstack nomtitle nonumber nonote noobs label replace
 
 
 
global list2 "age99 Imm experience99 yunemp99 ntrend99 ET1 ET2 MacOp rsalary99 rtotwage99 normsal9699"
estpost tabstat $list2 , by(ImportCompetition) columns(statistics) stats(mean sd N)
esttab using Table1.rtf, cells("mean(fmt(%11.2f)) sd") not nostar unstack nomtitle nonumber nonote noobs label append


estpost ttest age99 Imm experience99  yunemp99 ntrend99 ET1 ET2 MacOp, by(ImportCompetition)

esttab  .,  wide cells(" mu_2(fmt(%9.3f)) mu_1(fmt(%9.3f))   N_2(fmt(%9.0f)) N_1(fmt(%9.0f)) b(star fmt(%9.3f)) t(fmt(%9.3f))") 

esttab  .,  wide cells(" mu_2(fmt(%9.2f)) mu_1(fmt(%9.2f))   N_2(fmt(%9.0f)) N_1(fmt(%9.0f)) b(star fmt(%9.2f)) t(fmt(%9.2f))") 

estpost ttest rsalary99 rtotwage99 normsal9699 , by(ImportCompetition)

esttab  .,  wide cells(" mu_2(fmt(%9.3f)) mu_1(fmt(%9.3f))  N_2(fmt(%9.0f)) N_1(fmt(%9.0f))  b(star fmt(%9.3f)) t(fmt(%9.3f))") 

esttab  .,  wide cells(" mu_2(fmt(%9.2f)) mu_1(fmt(%9.2f))   N_2(fmt(%9.0f)) N_1(fmt(%9.0f)) b(star fmt(%9.2f)) t(fmt(%9.2f))") 






**Table 3 : Workers Recovery across Jobs within and between Sectors

local ylist "Inc Emp  Hrs"
foreach y of local ylist {
qui xtreg C`y' comprs wto , fe robust cl(pid)
est store c`y'2
qui xtreg C`y' comp wto , fe robust cl(pid)
est store c`y'
local xlist " I T M S R"
foreach x of local xlist {
qui xtreg C`y'_`x' comprs wto , fe robust cl(pid)
est store c`y'2_`x'
qui xtreg C`y'_`x' comp wto , fe robust cl(pid)
est store c`y'_`x'
}

}





capture log using "Table 3", replace
**earnings
estout cInc2 cInc2_I cInc2_T cInc2_M cInc2_S cInc2_R,  style(tex)  keep(comprs wto) stats(r2  F N N_clust, fmt(3 0)) cells(b(star fmt(%9.3f)) se(par)) legend starlevel(+ 0.10 * 0.05 ** 0.01 *** 0.001) 
estout cInc cInc_I cInc_T cInc_M cInc_S cInc_R,  style(tex)  keep(comp wto) stats(r2  F N N_clust, fmt(3  0)) cells(b(star fmt(%9.3f)) se(par)) legend starlevel(+ 0.10 * 0.05 ** 0.01 *** 0.001) 

**employment
estout cEmp2 cEmp2_I cEmp2_T cEmp2_M cEmp2_S cEmp2_R,  style(tex)  keep(comprs wto) stats(r2  F N N_clust, fmt(3  0)) cells(b(star fmt(%9.3f)) se(par)) legend starlevel(+ 0.10 * 0.05 ** 0.01 *** 0.001) 
estout cEmp cEmp_I cEmp_T cEmp_M cEmp_S cEmp_R,  style(tex)  keep(comp wto) stats(r2  F N N_clust, fmt(3  0)) cells(b(star fmt(%9.3f)) se(par)) legend starlevel(+ 0.10 * 0.05 ** 0.01 *** 0.001) 

**hours worked
estout cHrs2 cHrs2_I cHrs2_T cHrs2_M cHrs2_S cHrs2_R,  style(tex)  keep(comprs wto) stats(r2  F N N_clust, fmt(3  0)) cells(b(star fmt(%9.3f)) se(par)) legend starlevel(+ 0.10 * 0.05 ** 0.01 *** 0.001) 
estout cHrs cHrs_I cHrs_T cHrs_M cHrs_S cHrs_R,  style(tex)  keep(comp wto) stats(r2  F N N_clust, fmt(3  0)) cells(b(star fmt(%9.3f)) se(par)) legend starlevel(+ 0.10 * 0.05 ** 0.01 *** 0.001) 

capture log close

loc notes "Robust standard errors reported in parentheses are clustered at worker-level. All regressions include worker fixed effects and post-shock period indicator and a constant. Superscripts 'a, b, c' indicate significance at the 5%, 1% and 0.1% levels respectively."

esttab cInc2 cInc2_I cInc2_T cInc2_M cInc2_S cInc2_R using Table3.rtf, ///
replace compress label nogap b(%9.3f) se(%9.3f) nonote  ///
title({\b Table 3.} {\i Workers' Recovery across Jobs within and between Sectors } \line {\b Panel A} {\i Cumulative Labor Earnings  (in initial annual wage)}) ///
mtitles("All" "Initial"  "otTC" "otMan" "Service" "Ot") star(a 0.05 b 0.01 c 0.001) varwidth(11) modelwidth(8)
esttab cInc cInc_I cInc_T cInc_M cInc_S cInc_R using Table3.rtf, append  compress label nogap keep(comp)  b(%9.3f) se(%9.3f) nonote star(a 0.05 b 0.01 c 0.001) ///
nomtitles varwidth(11) modelwidth(8)

esttab cEmp2 cEmp2_I cEmp2_T cEmp2_M cEmp2_S cEmp2_R using Table3.rtf, append compress label nogap b(%9.3f) se(%9.3f) nonote  title({\b B} {\i Cumulative employment  }) ///
mtitles("All" "Initial"  "otTC" "otMan" "Service" "Ot") star(a 0.05 b 0.01 c 0.001) varwidth(11) modelwidth(8)
esttab  cEmp cEmp_I cEmp_T cEmp_M cEmp_S cEmp_R using Table3.rtf, append  compress label nogap keep(comp)  b(%9.3f) se(%9.3f) nonote star(a 0.05 b 0.01 c 0.001) ///
nomtitles varwidth(11) modelwidth(8)

esttab cHrs2 cHrs2_I cHrs2_T cHrs2_M cHrs2_S cHrs2_R using Table3.rtf, append compress label nogap b(%9.3f) se(%9.3f) nonote /// 
title({\b C} {\i Cumulative hours worked (in initial annual hours) }) ///
mtitles("All" "Initial"  "otTC" "otMan" "Service" "Ot") star(a 0.05 b 0.01 c 0.001) varwidth(11) modelwidth(8)
esttab cHrs cHrs_I cHrs_T cHrs_M cHrs_S cHrs_R using Table3.rtf, append  compress label nogap keep(comp)  b(%9.3f) se(%9.3f) nonote addnote(`notes') star(a 0.05 b 0.01 c 0.001) ///
nomtitles varwidth(11) modelwidth(8)




local ylist "Inc Hrs"
foreach y of local ylist {
qui xtreg PY`y' comprs wto , fe robust cl(pid)
est store py`y'2
qui xtreg PY`y' comp wto , fe robust cl(pid)
est store py`y'
 
local xlist " I T M S R"
foreach x of local xlist {
qui xtivreg2 PY`y'_`x' comprs wto , fe robust cl(pid)
est store py`y'2_`x'
qui xtivreg2 PY`y'_`x' comp wto , fe robust cl(pid)
est store py`y'_`x'
}

}

xtivreg2 LHW comprs wto , fe robust cl(pid)
est store lhw2
xtivreg2 LHW comp wto , fe robust cl(pid)
est store lhw 
local xlist " I T M S R"
foreach x of local xlist {
qui xtreg LHW_`x' comprs wto , fe robust cl(pid)
est store lhw2_`x'
qui xtreg LHW_`x' comp wto , fe robust cl(pid)
est store lhw_`x'
}

capture log using "Table 5 in the online appendix", replace


**per year earnings
estout pyInc pyInc_I pyInc_T pyInc_M pyInc_S pyInc_R,  style(tex)  keep(comp wto) stats(r2 F N N_clust, fmt(3  3 0)) cells(b(star fmt(%9.3f)) se(par)) legend starlevel(+ 0.10 * 0.05 ** 0.01 *** 0.001) 
estout pyInc2 pyInc2_I pyInc2_T pyInc2_M pyInc2_S pyInc2_R,  style(tex)  keep(comprs wto) stats(r2  F N N_clust, fmt(3  3 0)) cells(b(star fmt(%9.3f)) se(par)) legend starlevel(+ 0.10 * 0.05 ** 0.01 *** 0.001) 

**per year hours worked
estout pyHrs pyHrs_I pyHrs_T pyHrs_M pyHrs_S pyHrs_R,  style(tex)  keep(comp wto) stats(r2  F N N_clust, fmt(3  3 0)) cells(b(star fmt(%9.3f)) se(par)) legend starlevel(+ 0.10 * 0.05 ** 0.01 *** 0.001) 
estout pyHrs2 pyHrs2_I pyHrs2_T pyHrs2_M pyHrs2_S pyHrs2_R,  style(tex)  keep(comprs wto) stats(r2  F N N_clust, fmt(3  3 0)) cells(b(star fmt(%9.3f)) se(par)) legend starlevel(+ 0.10 * 0.05 ** 0.01 *** 0.001) 

**log avg hourly wage
estout lhw lhw_I lhw_T lhw_M lhw_S lhw_R,  style(tex)  keep(comp wto) stats(r2  F N N_clust, fmt(3  3 0)) cells(b(star fmt(%9.3f)) se(par)) legend starlevel(+ 0.10 * 0.05 ** 0.01 *** 0.001) 
estout lhw2 lhw2_I lhw2_T lhw2_M lhw2_S lhw2_R,  style(tex)  keep(comprs wto) stats(r2  F N N_clust, fmt(3  3 0)) cells(b(star fmt(%9.3f)) se(par)) legend starlevel(+ 0.10 * 0.05 ** 0.01 *** 0.001) 

capture log close


esttab pyInc2 pyInc2_I pyInc2_T pyInc2_M pyInc2_S pyInc2_R using OnlineApp_Table5.rtf, replace compress label nogap keep(comprs wto ) coeflabel(comprs "COMP_C" wto "Post_Shock") b(%9.3f) se(%9.3f) nonote  ///
title({\b Panel A.}  {\i Labor Earnings per year of employment (in initial annual wage)}) mtitles("All" "Initial"  "otTC" "otMan" "Service" "Ot")  ///
star(a 0.05 b 0.01 c 0.001)  varwidth(11) modelwidth(8) noobs
esttab pyInc pyInc_I pyInc_T pyInc_M pyInc_S pyInc_R using OnlineApp_Table5.rtf, append  compress label nogap keep(comp wto) coeflabel(comp "COMP_D" wto "Post_Shock")  b(%9.3f) se(%9.3f) nonote noobs ///
star(a 0.05 b 0.01 c 0.001) nomtitles  varwidth(11) modelwidth(8)

esttab pyHrs2 pyHrs2_I pyHrs2_T pyHrs2_M pyHrs2_S pyHrs2_R using OnlineApp_Table5.rtf, append compress label nogap keep(comprs wto) coeflabel(comprs "COMP_C" wto "Post_Shock") b(%9.3f) se(%9.3f) nonote ///
title({\b Panel B.} {\i Hours worked per year of employment (in initial annual hours)  }) star(a 0.05 b 0.01 c 0.001) nomtitles  varwidth(11) modelwidth(8) noobs
esttab pyHrs pyHrs_I pyHrs_T pyHrs_M pyHrs_S pyHrs_R using OnlineApp_Table5.rtf, append  compress label nogap keep(comp wto) coeflabel(comp "COMP_D" wto "Post_Shock") b(%9.3f) se(%9.3f) nonote noobs ///
star(a 0.05 b 0.01 c 0.001) nomtitles  varwidth(11) modelwidth(8)

esttab lhw2 lhw2_I lhw2_T lhw2_M lhw2_S lhw2_R using OnlineApp_Table5.rtf, append compress label nogap keep(comprs wto) coeflabel(comprs "COMP_C" wto "Post_Shock") b(%9.3f) se(%9.3f) nonote  ///
title({\b Panel C.} {\i Log hourly wage per year of employment}) star(a 0.05 b 0.01 c 0.001) nomtitles  varwidth(11) modelwidth(8) noobs
esttab lhw lhw_I lhw_T lhw_M lhw_S lhw_R using OnlineApp_Table5.rtf, append  compress label nogap keep(comp wto) coeflabel(comp "COMP_D" wto "Post_Shock") b(%9.3f) se(%9.3f) nonote noobs ///
star(a 0.05 b 0.01 c 0.001) nomtitles  varwidth(11) modelwidth(8)  addnote(`notes')




*Table 4-part-time, full-time service jobs

local ylist "Inc Emp TWag"
foreach y of local ylist {
local xlist "S SFT SPST SUK"
foreach x of local xlist {
qui xtivreg2 C`y'_`x' comprs wto , fe robust cl(pid)
est store c2`y'_`x'
}
}

xtivreg2 CUnEmpA comprs wto , fe robust cl(pid)
est store cunempa2
local xlist "ini xT T M S R "
foreach x of local xlist {
qui xtivreg2 CUnEmpA_l`x' comprs wto , fe robust cl(pid)
est store cunempa2_l`x'
}

capture log using "Table 4", replace

**Table 4-Panel A

estout c2Inc_S c2Inc_SFT c2Inc_SPST c2Inc_SUK using Table4.tex, replace style(tex)  keep(comprs wto) stats(r2  F N N_clust, fmt(3  0)) cells(b(star fmt(%9.3f)) se(par)) legend starlevel(+ 0.10 * 0.05 ** 0.01 *** 0.001) 

estout c2Emp_S c2Emp_SFT c2Emp_SPST c2Emp_SUK using Table4.tex, append style(tex)  keep(comprs wto) stats(r2  F N N_clust, fmt(3  0)) cells(b(star fmt(%9.3f)) se(par)) legend starlevel(+ 0.10 * 0.05 ** 0.01 *** 0.001) 

estout c2TWag_S c2TWag_SFT c2TWag_SPST c2TWag_SUK using Table4.tex, append style(tex)  keep(comprs wto) stats(r2  F N N_clust, fmt(3  0)) cells(b(star fmt(%9.3f)) se(par)) legend starlevel(+ 0.10 * 0.05 ** 0.01 *** 0.001) 

*Table 4-Panel B

estout cunempa2  cunempa2_lT cunempa2_lM cunempa2_lS  using Table4.tex, append  style(tex)  keep(comprs wto) stats(r2  F N N_clust, fmt(3  0)) cells(b(star fmt(%9.3f)) se(par)) legend starlevel(+ 0.10 * 0.05 ** 0.01 *** 0.001) 

capture log close



**Table 4-part-Time Jobs or Frequent Unemployment Disruptions in the Service Sector?

esttab c2Inc_S c2Inc_SFT c2Inc_SPST c2Inc_SUK using Table4.rtf, ///
replace compress label keep(comprs) b(%9.3f) se(%9.3f) nonote star(a 0.05 b 0.01 c 0.001) /// 
title({\b Panel A} \line {\i Cumulative Earnings in the Service Sector (in initial annual wage)}) ///
mtitles("Service" "Full-time Service" "Part-time Service" "Unknown") varwidth(14) modelwidth(12)

esttab c2Emp_S c2Emp_SFT c2Emp_SPST c2Emp_SUK using Table4.rtf,  ///
append compress label keep(comprs) b(%9.3f) se(%9.3f) nonote star(a 0.05 b 0.01 c 0.001) ///
title({\i Cumulative Employment in the Service Sector}) nomtitles varwidth(14) modelwidth(12)

esttab c2TWag_S c2TWag_SFT c2TWag_SPST c2TWag_SUK using Table4.rtf,  ///
append compress label keep(comprs) b(%9.3f) se(%9.3f) nonote star(a 0.05 b 0.01 c 0.001) ///
title({\i Cumulative Total Labor Earnings in the Service Sector}) nomtitles varwidth(14) modelwidth(12)

esttab cunempa2  cunempa2_lT cunempa2_lM cunempa2_lS  using Table4.rtf,   ///
append compress label keep(comprs)  b(%9.3f) se(%9.3f) nonote star(a 0.05 b 0.01 c 0.001) title({\b Panel B} {\i Cumulative Unemployment Spells (in months) }) ///
mtitles("All Spells" "Textile" "Manufac" "Service") addnote(`notes') varwidth(14) modelwidth(12)




**************************************************
**** Workers Adjustment by Education
************************************************

local ylist "Inc Hrs Emp"
foreach y of local ylist {

qui xtreg C`y' comprs wto if ET1==1, fe robust cl(pid)
est store coll_`y'2

local xlist " I T M S R"
foreach x of local xlist {

qui xtreg C`y'_`x' comprs wto if ET1==1, fe robust cl(pid)
est store coll_`y'_`x'2
}


qui xtreg C`y' comprs wto if ET2==1, fe robust cl(pid)
est store voc_`y'2
local xlist " I T M S R"
foreach x of local xlist {

qui xtreg C`y'_`x' comprs wto if ET2==1, fe robust cl(pid)
est store voc_`y'_`x'2
}
**mvoc

qui xtreg C`y' comprs wto if MVoc==1, fe robust cl(pid)
est store mvoc_`y'2
local xlist " I T M S R"
foreach x of local xlist {

qui xtreg C`y'_`x' comprs wto if MVoc==1, fe robust cl(pid)
est store mvoc_`y'_`x'2
}

**svoc

qui xtreg C`y' comprs wto if SVoc==1, fe robust cl(pid)
est store svoc_`y'2
local xlist " I T M S R"
foreach x of local xlist {

qui xtreg C`y'_`x' comprs wto if SVoc==1, fe robust cl(pid)
est store svoc_`y'_`x'2
}



qui xtreg C`y' comprs wto if ET3==1, fe robust cl(pid)
est store hs_`y'2
local xlist " I T M S R"
foreach x of local xlist {

qui xtreg C`y'_`x' comprs wto if ET3==1, fe robust cl(pid)
est store hs_`y'_`x'2
}

}

***********************
******Figure 3
*************************
local ylist "UnEmpA"
foreach y of local ylist {

qui xtreg C`y' comprs wto if ET1==1, fe robust cl(pid)
est store coll_`y'2

qui xtreg C`y' comprs wto if ET2==1, fe robust cl(pid)
est store voc_`y'2

**mvoc
qui xtreg C`y' comprs wto if MVoc==1, fe robust cl(pid)
est store mvoc_`y'2

**svoc
qui xtreg C`y' comprs wto if SVoc==1, fe robust cl(pid)
est store svoc_`y'2

qui xtreg C`y' comprs wto if ET3==1, fe robust cl(pid)
est store hs_`y'2

}




local i 0
local ylist"ET1 ET2 ET3 MVoc SVoc"
local xlist "T M S"
foreach y of local ylist{
local ++i
foreach x of local xlist{

qui xtreg CUnEmpA_l`x' comprs wto if `y'==1, fe robust cl(pid)
est store UE`i'_l`x'


}
}

local i 0
local ylist"ET1 ET2 ET3 MVoc SVoc"
local xlist "I T M S R"
foreach y of local ylist{
local ++i
qui xtreg PYInc comprs wto if `y'==1, fe robust cl(pid)
est store PYI`i'
foreach x of local xlist{
qui xtreg PYInc_`x' comprs wto if `y'==1, fe robust cl(pid)
est store PYI`i'_`x'

}
}


capture log using "Table 5.log"

*college
estout coll_Inc2 coll_Inc_I2 coll_Inc_T2 coll_Inc_M2 coll_Inc_S2 coll_Inc_R2,  style(tex)  keep(comprs wto) stats(r2 r2_a F N N_clust, fmt(3 3 3 0)) cells(b(star fmt(%9.4f)) se(par)) legend
estout coll_Hrs2 coll_Hrs_I2 coll_Hrs_T2 coll_Hrs_M2 coll_Hrs_S2 coll_Hrs_R2,  style(tex)  keep(comprs wto) stats(r2 r2_a F N N_clust, fmt(3 3 3 0)) cells(b(star fmt(%9.4f)) se(par)) legend


*vocational sch

estout voc_Inc2 voc_Inc_I2 voc_Inc_T2 voc_Inc_M2 voc_Inc_S2 voc_Inc_R2,  style(tex)  keep(comprs wto) stats(r2 r2_a F N N_clust, fmt(3 3 3 0)) cells(b(star fmt(%9.4f)) se(par)) legend
estout voc_Hrs2 voc_Hrs_I2 voc_Hrs_T2 voc_Hrs_M2 voc_Hrs_S2 voc_Hrs_R2,  style(tex)  keep(comprs wto) stats(r2 r2_a F N N_clust, fmt(3 3 3 0)) cells(b(star fmt(%9.4f)) se(par)) legend


estout hs_Inc2 hs_Inc_I2 hs_Inc_T2 hs_Inc_M2 hs_Inc_S2 hs_Inc_R2,  style(tex)  keep(comprs wto) stats(r2 r2_a F N N_clust, fmt(3 3 3 0)) cells(b(star fmt(%9.4f)) se(par)) legend
estout hs_Hrs2 hs_Hrs_I2 hs_Hrs_T2 hs_Hrs_M2 hs_Hrs_S2 hs_Hrs_R2,  style(tex)  keep(comprs wto) stats(r2 r2_a F N N_clust, fmt(3 3 3 0)) cells(b(star fmt(%9.4f)) se(par)) legend


*man specific vocational sch
estout mvoc_Inc2 mvoc_Inc_I2 mvoc_Inc_T2 mvoc_Inc_M2 mvoc_Inc_S2 mvoc_Inc_R2,  style(tex)  keep(comprs wto) stats(r2 r2_a F N N_clust, fmt(3 3 3 0)) cells(b(star fmt(%9.4f)) se(par)) legend
estout mvoc_Hrs2 mvoc_Hrs_I2 mvoc_Hrs_T2 mvoc_Hrs_M2 mvoc_Hrs_S2 mvoc_Hrs_R2,  style(tex)  keep(comprs wto) stats(r2 r2_a F N N_clust, fmt(3 3 3 0)) cells(b(star fmt(%9.4f)) se(par)) legend

*service specific voc sch
estout svoc_Inc2 svoc_Inc_I2 svoc_Inc_T2 svoc_Inc_M2 svoc_Inc_S2 svoc_Inc_R2,  style(tex)  keep(comprs wto) stats(r2 r2_a F N N_clust, fmt(3 3 3 0)) cells(b(star fmt(%9.4f)) se(par)) legend
estout svoc_Hrs2 svoc_Hrs_I2 svoc_Hrs_T2 svoc_Hrs_M2 svoc_Hrs_S2 svoc_Hrs_R2,  style(tex)  keep(comprs wto) stats(r2 r2_a F N N_clust, fmt(3 3 3 0)) cells(b(star fmt(%9.4f)) se(par)) legend

capture log close

******************************************************
**Table 5: Workers' Adjustment by (Initial) Education
*****************************************************
esttab coll_Inc2 coll_Inc_I2 coll_Inc_T2 coll_Inc_M2 coll_Inc_S2 coll_Inc_R2 using Table5.rtf, ///
replace compress label keep(comprs) b(%9.3f) se(%9.3f) nonote ///
title( {\b Table 5} {\i Workers' Adjustment by Education} \line {\b College Educated Workers } \line {\i Cumulative Labor Earnings  (in initial annual wage)}) ///
mtitles("All" "Initial"  "otTC" "otMan" "Service" "Ot") star(a 0.05 b 0.01 c 0.001) varwidth(11) modelwidth(8)

esttab coll_Hrs2 coll_Hrs_I2 coll_Hrs_T2 coll_Hrs_M2 coll_Hrs_S2 coll_Hrs_R2 using Table5.rtf,  ///
append compress label keep(comprs) b(%9.3f) se(%9.3f) nonote noobs title( {\i Cumulative Hours (in initial annual hours worked)}) ///
mtitles("All" "Initial"  "otTC" "otMan" "Service" "Ot") star(a 0.05 b 0.01 c 0.001) varwidth(11) modelwidth(8)

esttab voc_Inc2 voc_Inc_I2 voc_Inc_T2 voc_Inc_M2 voc_Inc_S2 voc_Inc_R2 using Table5.rtf,  ///
append compress label keep(comprs) b(%9.3f) se(%9.3f) nonote  title({\b Workers w/ Vocational Education } \line {\i Cumulative Labor Earnings  (in initial annual wage)}) ///
mtitles("All" "Initial"  "otTC" "otMan" "Service" "Ot") star(a 0.05 b 0.01 c 0.001) varwidth(11) modelwidth(8)

esttab voc_Hrs2 voc_Hrs_I2 voc_Hrs_T2 voc_Hrs_M2 voc_Hrs_S2 voc_Hrs_R2 using Table5.rtf,   ///
append compress label keep(comprs)  b(%9.3f) se(%9.3f) nonote noobs title({\i Cumulative Hours (in initial annual hours worked) }) ///
mtitles("All" "Initial"  "otTC" "otMan" "Service" "Ot") star(a 0.05 b 0.01 c 0.001) varwidth(11) modelwidth(8)

esttab hs_Inc2 hs_Inc_I2 hs_Inc_T2 hs_Inc_M2 hs_Inc_S2 hs_Inc_R2 using Table5.rtf,  ///
append compress label keep(comprs) b(%9.3f) se(%9.3f) nonote  title({\b Workers w/ High-School Education } \line {\i Cumulative Labor Earnings  (in initial annual wage)}) ///
mtitles("All" "Initial"  "otTC" "otMan" "Service" "Ot") star(a 0.05 b 0.01 c 0.001) varwidth(11) modelwidth(8)

esttab hs_Hrs2 hs_Hrs_I2 hs_Hrs_T2 hs_Hrs_M2 hs_Hrs_S2 hs_Hrs_R2 using Table5.rtf,   ///
append compress label keep(comprs)  b(%9.3f) se(%9.3f) nonote noobs title({\i Cumulative Hours (in initial annual hours worked) }) ///
mtitles("All" "Initial"  "otTC" "otMan" "Service" "Ot") star(a 0.05 b 0.01 c 0.001) varwidth(11) modelwidth(8)

esttab mvoc_Inc2 mvoc_Inc_I2 mvoc_Inc_T2 mvoc_Inc_M2 mvoc_Inc_S2 mvoc_Inc_R2 using Table5.rtf,  ///
append compress label keep(comprs) b(%9.3f) se(%9.3f) nonote  title({\b Workers w/ Manufacturing-Specific Vocational Education } \line {\i Cumulative Labor Earnings  (in initial annual wage)}) ///
mtitles("All" "Initial"  "otTC" "otMan" "Service" "Ot") star(a 0.05 b 0.01 c 0.001) varwidth(11) modelwidth(8)

esttab mvoc_Hrs2 mvoc_Hrs_I2 mvoc_Hrs_T2 mvoc_Hrs_M2 mvoc_Hrs_S2 mvoc_Hrs_R2 using Table5.rtf,   ///
append compress label keep(comprs)  b(%9.3f) se(%9.3f) nonote noobs title({\i Cumulative Hours (in initial annual hours worked) }) ///
mtitles("All" "Initial"  "otTC" "otMan" "Service" "Ot") star(a 0.05 b 0.01 c 0.001) varwidth(11) modelwidth(8)

esttab svoc_Inc2 svoc_Inc_I2 svoc_Inc_T2 svoc_Inc_M2 svoc_Inc_S2 svoc_Inc_R2 using Table5.rtf,  ///
append compress label keep(comprs) b(%9.3f) se(%9.3f) nonote  title({\b Workers w/ Service Specific Vocational Education } \line {\i Cumulative Labor Earnings  (in initial annual wage)}) ///
mtitles("All" "Initial"  "otTC" "otMan" "Service" "Ot") star(a 0.05 b 0.01 c 0.001) varwidth(11) modelwidth(8)

esttab svoc_Hrs2 svoc_Hrs_I2 svoc_Hrs_T2 svoc_Hrs_M2 svoc_Hrs_S2 svoc_Hrs_R2 using Table5.rtf,   ///
append compress label keep(comprs)  b(%9.3f) se(%9.3f) nonote noobs title({\i Cumulative Hours (in initial annual hours worked) }) ///
mtitles("All" "Initial"  "otTC" "otMan" "Service" "Ot") star(a 0.05 b 0.01 c 0.001) varwidth(11) modelwidth(8) addnote(`notes')



capture log using "Figure3Data.log"

**** unemployment by education--Figure 3


estout coll_UnEmpA2 voc_UnEmpA2 hs_UnEmpA2 mvoc_UnEmpA2 svoc_UnEmpA2,  style(tex)  keep(comprs wto) stats(r2 r2_a F N N_clust, fmt(3 3 3 0)) cells(b(star fmt(%9.3f)) se(par)) legend

capture log close

**********************************************************
**Figure 3: Trade-induced Unemployment and Workers' Education
**********************************************************

esttab  coll_UnEmpA2 voc_UnEmpA2 hs_UnEmpA2 mvoc_UnEmpA2 svoc_UnEmpA2 using Figure3Data.rtf, ///
replace compress label keep(comprs)  b(%9.3f) se(%9.3f)  title({\i Cumulative Unemployment Spells by Education }) ///
mtitles("College" "Vocational"  "HighSchool" "Manu-Spec Voc" "Service-related Voc") star(a 0.05 b 0.01 c 0.001) varwidth(11) modelwidth(9) 



****Online Appendix Table 10***


esttab coll_Emp2 coll_Emp_I2 coll_Emp_T2 coll_Emp_M2 coll_Emp_S2 coll_Emp_R2 using OnlineApp_Table10.rtf, ///
replace compress label keep(comprs) coeflabel(comprs COMP_C) b(%9.3f) se(%9.3f) nonote title( {\b Table 10} {\i Workers' Adjustment by Initial Education --- Cumulative Employment} \line {\b College Educated Workers } ) ///
mtitles("All" "Initial"  "otTC" "otMan" "Service" "Ot") star(a 0.05 b 0.01 c 0.001) varwidth(11) modelwidth(8) 

esttab voc_Emp2 voc_Emp_I2 voc_Emp_T2 voc_Emp_M2 voc_Emp_S2 voc_Emp_R2 using OnlineApp_Table10.rtf,  ///
append compress label keep(comprs) coeflabel(comprs COMP_C) b(%9.3f) se(%9.3f) nonote  title({\b Workers w/ Vocational Education } ) ///
mtitles("All" "Initial"  "otTC" "otMan" "Service" "Ot") star(a 0.05 b 0.01 c 0.001) varwidth(11) modelwidth(8)  


esttab hs_Emp2 hs_Emp_I2 hs_Emp_T2 hs_Emp_M2 hs_Emp_S2 hs_Emp_R2 using OnlineApp_Table10.rtf,  ///
append compress label keep(comprs) coeflabel(comprs COMP_C) b(%9.3f) se(%9.3f) nonote  title({\b Workers w/ High-School Education } ) ///
mtitles("All" "Initial"  "otTC" "otMan" "Service" "Ot") star(a 0.05 b 0.01 c 0.001) varwidth(11) modelwidth(8) 


esttab mvoc_Emp2 mvoc_Emp_I2 mvoc_Emp_T2 mvoc_Emp_M2 mvoc_Emp_S2 mvoc_Emp_R2 using OnlineApp_Table10.rtf,  ///
append compress label keep(comprs) coeflabel(comprs COMP_C) b(%9.3f) se(%9.3f) nonote  title({\b Workers w/ Manufacturing-Specific Vocational Education } ) ///
mtitles("All" "Initial"  "otTC" "otMan" "Service" "Ot") star(a 0.05 b 0.01 c 0.001) varwidth(11) modelwidth(8) 


esttab svoc_Emp2 svoc_Emp_I2 svoc_Emp_T2 svoc_Emp_M2 svoc_Emp_S2 svoc_Emp_R2 using OnlineApp_Table10.rtf,  ///
append compress label keep(comprs) coeflabel(comprs COMP_C) b(%9.3f) se(%9.3f) nonote  title({\b Workers w/ Service Specific Vocational Education } ) ///
mtitles("All" "Initial"  "otTC" "otMan" "Service" "Ot") star(a 0.05 b 0.01 c 0.001) varwidth(11) modelwidth(8)  addnote(`notes')





******************************************************************
***Online Appendix Table 11** Adj of Workers by Initial Education
*****************************************************************

esttab PYI1 PYI1_I PYI1_T PYI1_M PYI1_S PYI1_R using OnlineApp_Table11.rtf, ///
replace compress label keep(comprs) coeflabel(comprs COMP_C) b(%9.3f) se(%9.3f) nonote noobs title( {\b Table 11} {\i Workers' Adjustment by Initial Education --- Earnings per year of Employment} \line {\b College } ) ///
mtitles("All" "Initial"  "otTC" "otMan" "Service" "Ot") star(a 0.05 b 0.01 c 0.001) varwidth(11) modelwidth(8) 


esttab PYI2 PYI2_I PYI2_T PYI2_M PYI2_S PYI2_R using OnlineApp_Table11.rtf, ///
append compress label keep(comprs) coeflabel(comprs COMP_C) b(%9.3f) se(%9.3f) nonote noobs title({\b Vocational Education } ) ///
mtitles("All" "Initial"  "otTC" "otMan" "Service" "Ot") star(a 0.05 b 0.01 c 0.001) varwidth(11) modelwidth(8) 

esttab PYI3 PYI3_I PYI3_T PYI3_M PYI3_S PYI3_R using OnlineApp_Table11.rtf, ///
append compress label keep(comprs) coeflabel(comprs COMP_C) b(%9.3f) se(%9.3f) nonote noobs title({\b High School Education} ) ///
mtitles("All" "Initial"  "otTC" "otMan" "Service" "Ot") star(a 0.05 b 0.01 c 0.001) varwidth(11) modelwidth(8) 

esttab PYI4 PYI4_I PYI4_T PYI4_M PYI4_S PYI4_R using OnlineApp_Table11.rtf, ///
append compress label keep(comprs) coeflabel(comprs COMP_C) b(%9.3f) se(%9.3f) nonote noobs title({\b Manu-specific Vocational Education } ) ///
mtitles("All" "Initial"  "otTC" "otMan" "Service" "Ot") star(a 0.05 b 0.01 c 0.001) varwidth(11) modelwidth(8) 

esttab PYI5 PYI5_I PYI5_T PYI5_M PYI5_S PYI5_R using OnlineApp_Table11.rtf, ///
append compress label keep(comprs) coeflabel(comprs COMP_C) b(%9.3f) se(%9.3f) nonote noobs title({\b Service-related Vocational Education } ) ///
mtitles("All" "Initial"  "otTC" "otMan" "Service" "Ot") star(a 0.05 b 0.01 c 0.001) varwidth(11) modelwidth(8) addnote(`notes')



******************************************************************
***Online Appendix Table 12** Unemployment and Education
*****************************************************************


esttab  coll_UnEmpA2 UE1_lT UE1_lM UE1_lS using OnlineApp_Table12.rtf, ///
replace compress label keep(comprs) coeflabel(comprs COMP_C)  b(%9.3f) se(%9.3f)  title({\b Table 12} {\i Unemployment and Education } \line {\i Cumulative Unemployment spells depending on the sector of last employment} \line {\b College}) ///
mtitles("All UE Spells" "Textile"  "Manuf" "Service" ) star(a 0.05 b 0.01 c 0.001) varwidth(12) modelwidth(10) nonote

esttab  voc_UnEmpA2 UE2_lT UE2_lM UE2_lS using OnlineApp_Table12.rtf, ///
append compress label keep(comprs) coeflabel(comprs COMP_C)  b(%9.3f) se(%9.3f)  title({\b Vocational Education}) ///
mtitles("All UE Spells" "Textile"  "Manuf" "Service" ) star(a 0.05 b 0.01 c 0.001) varwidth(12) modelwidth(10) nonote


esttab  hs_UnEmpA2 UE3_lT UE3_lM UE3_lS using OnlineApp_Table12.rtf, ///
append compress label keep(comprs) coeflabel(comprs COMP_C)  b(%9.3f) se(%9.3f)  title({\b High School Education}) ///
mtitles("All UE Spells" "Textile"  "Manuf" "Service" ) star(a 0.05 b 0.01 c 0.001) varwidth(12) modelwidth(10) nonote


esttab  mvoc_UnEmpA2 UE4_lT UE4_lM UE4_lS using OnlineApp_Table12.rtf, ///
append compress label keep(comprs) coeflabel(comprs COMP_C)  b(%9.3f) se(%9.3f)  title({\b Manu-specific Vocational Education}) ///
mtitles("All UE Spells" "Textile"  "Manuf" "Service" ) star(a 0.05 b 0.01 c 0.001) varwidth(12) modelwidth(10) nonote

esttab  svoc_UnEmpA2 UE5_lT UE5_lM UE5_lS using OnlineApp_Table12.rtf, ///
append compress label keep(comprs) coeflabel(comprs COMP_C)  b(%9.3f) se(%9.3f)  title({\b Service-related Vocational Education}) ///
mtitles("All UE Spells" "Textile"  "Manuf" "Service" ) star(a 0.05 b 0.01 c 0.001) varwidth(12) modelwidth(10) nonote addnote(`notes')



estimates drop _all


*********************************
**********   Occupation ********


local ylist "Inc Emp  Hrs "
foreach y of local ylist {
forvalues i=1/6 {
qui xtreg C`y' comp wto if ocreg==`i', fe robust cl(pid)
est store occ`i'_`y'
qui xtreg C`y' comprs wto if ocreg==`i', fe robust cl(pid)
est store occ`i'_`y'2
}


local xlist " I T M S R"
foreach x of local xlist {
forvalues i=1/6 {
qui xtreg C`y'_`x' comp wto if ocreg==`i', fe robust cl(pid)
est store occ`i'_`y'_`x'
qui xtreg C`y'_`x' comprs wto if ocreg==`i', fe robust cl(pid)
est store occ`i'_`y'_`x'2
}
}
}




forvalues i=1/6 {
qui xtreg CUnEmpA comprs wto if ocreg==`i', fe robust cl(pid)
est store occ`i'_UnEmpA2
}









*****************************************************
**Figure 4 Workers' Occupation and Their Adjustment
*****************************************************

esttab  occ1_Inc2 occ2_Inc2 occ3_Inc2 occ4_Inc2 occ5_Inc2 occ6_Inc2 using Figure4Data.rtf, ///
title({\b Figure4a})  star(a 0.05 b 0.01 c 0.001) varwidth(11) modelwidth(9) ///
replace compress label keep(comprs)  b(%9.3f) se(%9.3f) nonote  mtitles("Managers" "Profs&Techs" "Clerks&SW" "CraftW" "Oper" "Labourer")

esttab  occ1_Inc_I2 occ2_Inc_I2 occ3_Inc_I2 occ4_Inc_I2 occ5_Inc_I2 occ6_Inc_I2 using Figure4Data.rtf, ///
append compress label keep(comprs)  b(%9.3f) se(%9.3f) nonote varwidth(11) modelwidth(9) star(a 0.05 b 0.01 c 0.001)


esttab  occ1_Emp_S2 occ2_Emp_S2 occ3_Emp_S2 occ4_Emp_S2 occ5_Emp_S2 occ6_Emp_S2 using Figure4Data.rtf, ///
title({\b Figure4b})  star(a 0.05 b 0.01 c 0.001) varwidth(11) modelwidth(9) ///
append compress label keep(comprs)  b(%9.3f) se(%9.3f) nonote  mtitles("Managers" "Profs&Techs" "Clerks&SW" "CraftW" "Oper" "Labourer")

esttab  occ1_Emp_I2 occ2_Emp_I2 occ3_Emp_I2 occ4_Emp_I2 occ5_Emp_I2 occ6_Emp_I2 using Figure4Data.rtf, ///
append compress label keep(comprs)  b(%9.3f) se(%9.3f) nonote star(a 0.05 b 0.01 c 0.001) varwidth(11) modelwidth(9)

esttab  occ1_Hrs2 occ2_Hrs2 occ3_Hrs2 occ4_Hrs2 occ5_Hrs2 occ6_Hrs2 using Figure4Data.rtf, ///
title({\b Figure4c})  star(a 0.05 b 0.01 c 0.001) varwidth(11) modelwidth(9) ///
append compress label keep(comprs)  b(%9.3f) se(%9.3f) nonote  mtitles("Managers" "Profs&Techs" "Clerks&SW" "CraftW" "Oper" "Labourer")

esttab  occ1_Hrs_I2 occ2_Hrs_I2 occ3_Hrs_I2 occ4_Hrs_I2 occ5_Hrs_I2 occ6_Hrs_I2 using Figure4Data.rtf, ///
append compress label keep(comprs)  b(%9.3f) se(%9.3f) nonote star(a 0.05 b 0.01 c 0.001) varwidth(11) modelwidth(9)

esttab  occ1_UnEmpA2 occ2_UnEmpA2 occ3_UnEmpA2 occ4_UnEmpA2 occ5_UnEmpA2 occ6_UnEmpA2 using Figure4Data.rtf, ///
title({\b Figure4d})  star(a 0.05 b 0.01 c 0.001) varwidth(11) modelwidth(9) ///
append compress label keep(comprs)  b(%9.3f) se(%9.3f)  mtitles("Managers" "Profs&Techs" "Clerks&SW" "CraftW" "Oper" "Labourer")




**********************************************************************************************
**online appendix Table 13 Adjustment of Workers by Initial Occupation--Cumulative Earnings
**********************************************************************************************

esttab  occ1_Inc2 occ1_Inc_I2 occ1_Inc_T2 occ1_Inc_M2 occ1_Inc_S2 occ1_Inc_R2 using OnlineApp_Table13.rtf, ///
replace compress label keep(comprs) coeflabel(comprs COMP_C)  b(%9.3f) se(%9.3f) nonote star(a 0.05 b 0.01 c 0.001) mtitles("All Emp" "InitialFirm" "otherTC" "otherManu" "Service" "Other") ///
title({\i Adjustment of Workers by Initial Occupation-Cumulative Earnings} \line {\b Managers}) varwidth(11) modelwidth(9)

esttab  occ2_Inc2 occ2_Inc_I2 occ2_Inc_T2 occ2_Inc_M2 occ2_Inc_S2 occ2_Inc_R2 using OnlineApp_Table13.rtf, append compress label keep(comprs) coeflabel(comprs COMP_C) ///
b(%9.3f) se(%9.3f) nonote  star(a 0.05 b 0.01 c 0.001) title({\b Professionals and Technicians}) mtitles("All Emp" "InitialFirm" "otherTC" "otherManu" "Service" "Other") varwidth(11) modelwidth(9)

esttab  occ3_Inc2 occ3_Inc_I2 occ3_Inc_T2 occ3_Inc_M2 occ3_Inc_S2 occ3_Inc_R2 using OnlineApp_Table13.rtf, append compress label keep(comprs) coeflabel(comprs COMP_C) ///
b(%9.3f) se(%9.3f) nonote  star(a 0.05 b 0.01 c 0.001) title({\b Clerks and Service Workers}) mtitles("All Emp" "InitialFirm" "otherTC" "otherManu" "Service" "Other") varwidth(11) modelwidth(9)

esttab  occ4_Inc2 occ4_Inc_I2 occ4_Inc_T2 occ4_Inc_M2 occ4_Inc_S2 occ4_Inc_R2 using OnlineApp_Table13.rtf, append compress label keep(comprs) coeflabel(comprs COMP_C) ///
b(%9.3f) se(%9.3f) nonote  star(a 0.05 b 0.01 c 0.001) title({\b Craft Workers}) mtitles("All Emp" "InitialFirm" "otherTC" "otherManu" "Service" "Other") varwidth(11) modelwidth(9)

esttab  occ5_Inc2 occ5_Inc_I2 occ5_Inc_T2 occ5_Inc_M2 occ5_Inc_S2 occ5_Inc_R2 using OnlineApp_Table13.rtf, append compress label keep(comprs) coeflabel(comprs COMP_C) ///
b(%9.3f) se(%9.3f) nonote  star(a 0.05 b 0.01 c 0.001) title({\b Machine Operators}) mtitles("All Emp" "InitialFirm" "otherTC" "otherManu" "Service" "Other") varwidth(11) modelwidth(9)

esttab  occ6_Inc2 occ6_Inc_I2 occ6_Inc_T2 occ6_Inc_M2 occ6_Inc_S2 occ6_Inc_R2 using OnlineApp_Table13.rtf, append compress label keep(comprs) coeflabel(comprs COMP_C) /// 
b(%9.3f) se(%9.3f)  star(a 0.05 b 0.01 c 0.001) title({\b Labourers}) mtitles("All Emp" "InitialFirm" "otherTC" "otherManu" "Service" "Other") varwidth(11) modelwidth(9)


*****************************************************************************************
**online appendix Table 14 Adjustment of Workers by Initial Occupation--Cumulative Employment
*****************************************************************************************



**Panel A. Cumulative Hours Worked
esttab  occ1_Hrs2 occ1_Hrs_I2 occ1_Hrs_T2 occ1_Hrs_M2 occ1_Hrs_S2 occ1_Hrs_R2 using OnlineApp_Table14.rtf, ///
replace compress label keep(comprs) coeflabel(comprs COMP_C) b(%9.3f) se(%9.3f) nonote star(a 0.05 b 0.01 c 0.001) mtitles("All Emp" "InitialFirm" "otherTC" "otherManu" "Service" "Other") ///
title({\i Adjustment of Workers by Initial Occupation} \line{\b Panel A. \i Cumulative Hours Worked} \line {\b Managers}) varwidth(11) modelwidth(8)


esttab  occ2_Hrs2 occ2_Hrs_I2 occ2_Hrs_T2 occ2_Hrs_M2 occ2_Hrs_S2 occ2_Hrs_R2 using OnlineApp_Table14.rtf, append compress label keep(comprs) coeflabel(comprs COMP_C) ///
b(%9.3f) se(%9.3f) nonote star(a 0.05 b 0.01 c 0.001) title({\b Professionals and Technicians}) mtitles("All Emp" "InitialFirm" "otherTC" "otherManu" "Service" "Other") varwidth(11) modelwidth(8)

esttab  occ3_Hrs2 occ3_Hrs_I2 occ3_Hrs_T2 occ3_Hrs_M2 occ3_Hrs_S2 occ3_Hrs_R2 using OnlineApp_Table14.rtf, append compress label keep(comprs) coeflabel(comprs COMP_C) ///
b(%9.3f) se(%9.3f) nonote star(a 0.05 b 0.01 c 0.001) title({\b Clerks and Service Workers}) mtitles("All Emp" "InitialFirm" "otherTC" "otherManu" "Service" "Other") varwidth(11) modelwidth(8)

esttab  occ4_Hrs2 occ4_Hrs_I2 occ4_Hrs_T2 occ4_Hrs_M2 occ4_Hrs_S2 occ4_Hrs_R2 using OnlineApp_Table14.rtf, append compress label keep(comprs) coeflabel(comprs COMP_C) ///
b(%9.3f) se(%9.3f) nonote  star(a 0.05 b 0.01 c 0.001) title({\b Craft Workers}) mtitles("All Emp" "InitialFirm" "otherTC" "otherManu" "Service" "Other") varwidth(11) modelwidth(8)

esttab  occ5_Hrs2 occ5_Hrs_I2 occ5_Hrs_T2 occ5_Hrs_M2 occ5_Hrs_S2 occ5_Hrs_R2 using OnlineApp_Table14.rtf, append compress label keep(comprs)  coeflabel(comprs COMP_C) ///
b(%9.3f) se(%9.3f) nonote star(a 0.05 b 0.01 c 0.001) title({\b Machine Operators}) mtitles("All Emp" "InitialFirm" "otherTC" "otherManu" "Service" "Other") varwidth(11) modelwidth(8)

esttab  occ6_Hrs2 occ6_Hrs_I2 occ6_Hrs_T2 occ6_Hrs_M2 occ6_Hrs_S2 occ6_Hrs_R2 using OnlineApp_Table14.rtf, append compress label keep(comprs)  coeflabel(comprs COMP_C) ///
b(%9.3f) se(%9.3f) nonote star(a 0.05 b 0.01 c 0.001) title({\b Labourers}) mtitles("All Emp" "InitialFirm" "otherTC" "otherManu" "Service" "Other") varwidth(11) modelwidth(8)

**Panel B. Cumulative Years with Employment
esttab  occ1_Emp2 occ1_Emp_I2 occ1_Emp_T2 occ1_Emp_M2 occ1_Emp_S2 occ1_Emp_R2 using OnlineApp_Table14.rtf, append compress label keep(comprs)  coeflabel(comprs COMP_C) ///
b(%9.3f) se(%9.3f) nonote  star(a 0.05 b 0.01 c 0.001) title({\b Panel B. \i Cumulative Employment (No of Years w/ primary job)} \line {\b Managers}) mtitles("All Emp" "InitialFirm" "otherTC" "otherManu" "Service" "Other") varwidth(11) modelwidth(8)

esttab  occ2_Emp2 occ2_Emp_I2 occ2_Emp_T2 occ2_Emp_M2 occ2_Emp_S2 occ2_Emp_R2 using OnlineApp_Table14.rtf, append compress label keep(comprs)  coeflabel(comprs COMP_C) ///
b(%9.3f) se(%9.3f) nonote star(a 0.05 b 0.01 c 0.001) title({\b Professionals and Technicians}) mtitles("All Emp" "InitialFirm" "otherTC" "otherManu" "Service" "Other") varwidth(11) modelwidth(8)

esttab  occ3_Emp2 occ3_Emp_I2 occ3_Emp_T2 occ3_Emp_M2 occ3_Emp_S2 occ3_Emp_R2 using OnlineApp_Table14.rtf, append compress label keep(comprs)  coeflabel(comprs COMP_C) ///
b(%9.3f) se(%9.3f) nonote  star(a 0.05 b 0.01 c 0.001) title({\b Clerks and Service Workers}) mtitles("All Emp" "InitialFirm" "otherTC" "otherManu" "Service" "Other") varwidth(11) modelwidth(8)

esttab  occ4_Emp2 occ4_Emp_I2 occ4_Emp_T2 occ4_Emp_M2 occ4_Emp_S2 occ4_Emp_R2 using OnlineApp_Table14.rtf, append compress label keep(comprs)  coeflabel(comprs COMP_C) ///
b(%9.3f) se(%9.3f) nonote star(a 0.05 b 0.01 c 0.001) title({\b Craft Workers}) mtitles("All Emp" "InitialFirm" "otherTC" "otherManu" "Service" "Other") varwidth(11) modelwidth(8)

esttab  occ5_Emp2 occ5_Emp_I2 occ5_Emp_T2 occ5_Emp_M2 occ5_Emp_S2 occ5_Emp_R2 using OnlineApp_Table14.rtf, append compress label keep(comprs)  coeflabel(comprs COMP_C) ///
b(%9.3f) se(%9.3f) nonote star(a 0.05 b 0.01 c 0.001) title({\b Machine Operators}) mtitles("All Emp" "InitialFirm" "otherTC" "otherManu" "Service" "Other") varwidth(11) modelwidth(8)

esttab  occ6_Emp2 occ6_Emp_I2 occ6_Emp_T2 occ6_Emp_M2 occ6_Emp_S2 occ6_Emp_R2 using OnlineApp_Table14.rtf, append compress label keep(comprs)  coeflabel(comprs COMP_C) ///
b(%9.3f) se(%9.3f) nonote title({\b Labourers}) ///
star(a 0.05 b 0.01 c 0.001) mtitles("All Emp" "InitialFirm" "otherTC" "otherManu" "Service" "Other") varwidth(11) modelwidth(8) addnote(`notes')



*********************************************************************************************
**online appendix Table 15 Adjustment of Workers by Initial Occupation--Cumulative Unemployment
**********************************************************************************************

local xlist " lT lM lS lR"
foreach x of local xlist {
forvalues i=1/6 {
qui xtreg CUnEmpA_`x' comprs wto if ocreg==`i', fe robust cl(pid)
est store occ`i'_`x'
}
}
**online appendix Table 15

esttab  occ1_UnEmpA2 occ1_lT occ1_lM occ1_lS occ1_lR using OnlineApp_Table15.rtf, ///
replace compress label title({\b Managers}) keep(comprs)  b(%9.3f) se(%9.3f) nonote ///
star(a 0.05 b 0.01 c 0.001) mtitles("All UE Spells" "last Sect Tex" "last sect Manu" "last sect Service" "Other")

esttab  occ2_UnEmpA2 occ2_lT occ2_lM occ2_lS occ2_lR using OnlineApp_Table15.rtf, ///
append compress label title({\b Professionals and Technicians}) keep(comprs)  b(%9.3f) ///
se(%9.3f) nonote star(a 0.05 b 0.01 c 0.001) mtitles("All UE Spells" "last Sect Tex" "last sect Manu" "last sect Service" "Other")

esttab  occ3_UnEmpA2 occ3_lT occ3_lM occ3_lS occ3_lR using OnlineApp_Table15.rtf, ///
append compress label title({\b Clerks and Service Workers}) keep(comprs)  b(%9.3f) ///
se(%9.3f) nonote star(a 0.05 b 0.01 c 0.001) mtitles("All UE Spells" "last Sect Tex" "last sect Manu" "last sect Service" "Other")

esttab  occ4_UnEmpA2 occ4_lT occ4_lM occ4_lS occ4_lR using OnlineApp_Table15.rtf, ///
append compress label title({\b Craft Workers}) keep(comprs)  b(%9.3f) se(%9.3f) ///
nonote star(a 0.05 b 0.01 c 0.001) mtitles("All UE Spells" "last Sect Tex" "last sect Manu" "last sect Service" "Other")

esttab  occ5_UnEmpA2 occ5_lT occ5_lM occ5_lS occ5_lR using OnlineApp_Table15.rtf, ///
append compress label title({\b Machine Operators}) keep(comprs)  b(%9.3f) se(%9.3f) nonote ///
star(a 0.05 b 0.01 c 0.001) mtitles("All UE Spells" "last Sect Tex" "last sect Manu" "last sect Service" "Other")

esttab  occ6_UnEmpA2 occ6_lT occ6_lM occ6_lS occ6_lR using OnlineApp_Table15.rtf, append ///
compress label title({\b Labourers}) keep(comprs)  b(%9.3f) se(%9.3f) nonote star(a 0.05 b 0.01 c 0.001) ///
mtitles("All UE Spells" "last Sect Tex" "last sect Manu" "last sect Service" "Other") addnote(`notes')




estimates drop _all



local ylist "PYHrs LHW"
foreach y of local ylist {
forvalues i=1/6 {
qui xtreg `y' comprs wto if ocreg==`i', fe robust cl(pid)
est store occ`i'_`y'2
}


local xlist " I T M S"
foreach x of local xlist {
forvalues i=1/6 {
qui xtreg `y'_`x' comprs wto if ocreg==`i', fe robust cl(pid)
est store occ`i'_`y'_`x'2
}
}
}


********************************************************************************************************
**Online appendix Table 16 Adjustment of Workers by Initial Occupation--per year of employment hours worked
********************************************************************************************************



esttab  occ1_PYHrs2 occ1_PYHrs_I2 occ1_PYHrs_T2 occ1_PYHrs_M2 occ1_PYHrs_S2  using OnlineApp_Table16.rtf, ///
replace compress label keep(comprs)  b(%9.3f) se(%9.3f) nonote star(a 0.05 b 0.01 c 0.001) mtitles("All Emp" "InitialFirm" "otherTC" "otherManu" "Service" "Other") ///
title({\i Adjustment of Workers by Initial Occupation-Per Year Hours Worked} \line {\b Managers})

esttab  occ2_PYHrs2 occ2_PYHrs_I2 occ2_PYHrs_T2 occ2_PYHrs_M2 occ2_PYHrs_S2  using OnlineApp_Table16.rtf, ///
append compress label title({\b Professionals & Technicians}) keep(comprs)  b(%9.3f) se(%9.3f) nonote ///
star(a 0.05 b 0.01 c 0.001)  mtitles("All Emp" "InitialFirm" "otherTC" "otherManu" "Service" )

esttab  occ3_PYHrs2 occ3_PYHrs_I2 occ3_PYHrs_T2 occ3_PYHrs_M2 occ3_PYHrs_S2  using OnlineApp_Table16.rtf, ///
append compress label title({\b Clerks & Service Workers}) keep(comprs)  b(%9.3f) se(%9.3f) nonote ///
star(a 0.05 b 0.01 c 0.001)  mtitles("All Emp" "InitialFirm" "otherTC" "otherManu" "Service" )

esttab  occ4_PYHrs2 occ4_PYHrs_I2 occ4_PYHrs_T2 occ4_PYHrs_M2 occ4_PYHrs_S2  using OnlineApp_Table16.rtf, ///
append compress label title({\b Craft Workers}) keep(comprs)  b(%9.3f) se(%9.3f) nonote  star(a 0.05 b 0.01 c 0.001)  ///
mtitles("All Emp" "InitialFirm" "otherTC" "otherManu" "Service" )

esttab  occ5_PYHrs2 occ5_PYHrs_I2 occ5_PYHrs_T2 occ5_PYHrs_M2 occ5_PYHrs_S2  using OnlineApp_Table16.rtf, ///
append compress label title({\b Machine Operators}) keep(comprs)  b(%9.3f) se(%9.3f) nonote star(a 0.05 b 0.01 c 0.001)  ///
mtitles("All Emp" "InitialFirm" "otherTC" "otherManu" "Service" )

esttab  occ6_PYHrs2 occ6_PYHrs_I2 occ6_PYHrs_T2 occ6_PYHrs_M2 occ6_PYHrs_S2  using OnlineApp_Table16.rtf, ///
append compress label title({\b Labourers}) keep(comprs)  b(%9.3f) se(%9.3f) nonote star(a 0.05 b 0.01 c 0.001)  ///
mtitles("All Emp" "InitialFirm" "otherTC" "otherManu" "Service" )


********************************************************************************************************
**Online appendix Table 17 Adjustment of Workers by Initial Occupation--Hourly Wage
********************************************************************************************************

esttab  occ1_LHW2 occ1_LHW_I2 occ1_LHW_T2 occ1_LHW_M2 occ1_LHW_S2  using OnlineApp_Table17.rtf, ///
replace compress label keep(comprs)  b(%9.3f) se(%9.3f) nonote star(a 0.05 b 0.01 c 0.001) mtitles("All Emp" "InitialFirm" "otherTC" "otherManu" "Service" "Other") ///
title({\i Adjustment of Workers by Initial Occupation- Hourly Wage} \line {\b Managers})

esttab  occ2_LHW2 occ2_LHW_I2 occ2_LHW_T2 occ2_LHW_M2 occ2_LHW_S2  using OnlineApp_Table17.rtf, ///
append compress label keep(comprs) title({\b Professionals & Technicians}) b(%9.3f) se(%9.3f) ///
nonote star(a 0.05 b 0.01 c 0.001)  mtitles("All Emp" "InitialFirm" "otherTC" "otherManu" "Service" )

esttab  occ3_LHW2 occ3_LHW_I2 occ3_LHW_T2 occ3_LHW_M2 occ3_LHW_S2  using OnlineApp_Table17.rtf, ///
append compress label keep(comprs) title({\b Clerks & Service Workers})  b(%9.3f) se(%9.3f) ///
nonote star(a 0.05 b 0.01 c 0.001)  mtitles("All Emp" "InitialFirm" "otherTC" "otherManu" "Service" )

esttab  occ4_LHW2 occ4_LHW_I2 occ4_LHW_T2 occ4_LHW_M2 occ4_LHW_S2  using OnlineApp_Table17.rtf, ///
append compress label keep(comprs) title({\b Craft Workers})  b(%9.3f) se(%9.3f) nonote  ///
star(a 0.05 b 0.01 c 0.001)  mtitles("All Emp" "InitialFirm" "otherTC" "otherManu" "Service" )

esttab  occ5_LHW2 occ5_LHW_I2 occ5_LHW_T2 occ5_LHW_M2 occ5_LHW_S2  using OnlineApp_Table17.rtf, ///
append compress label keep(comprs) title({\b Machine Operators}) b(%9.3f) se(%9.3f) nonote ///
star(a 0.05 b 0.01 c 0.001)  mtitles("All Emp" "InitialFirm" "otherTC" "otherManu" "Service" )

esttab  occ6_LHW2 occ6_LHW_I2 occ6_LHW_T2 occ6_LHW_M2 occ6_LHW_S2  using OnlineApp_Table17.rtf, ///
append compress label keep(comprs) title({\b Labourers}) b(%9.3f) se(%9.3f) nonote star(a 0.05 b 0.01 c 0.001)  ///
mtitles("All Emp" "InitialFirm" "otherTC" "otherManu" "Service" )



***********************************
***Table 6 : Specific Human Capital
***********************************

local ylist "Inc Emp Hrs"
foreach y of local ylist {
qui xtreg C`y' comprs wto comprs_mspec4 mspec4_wto, fe robust cl(pid)
est store cm`y'2
 
local xlist " I T M S R"
foreach x of local xlist {
qui xtreg C`y'_`x' comprs wto comprs_mspec4 mspec4_wto, fe robust cl(pid)
est store cm`y'2_`x'
}

}
local ylist "Inc Emp Hrs"
foreach y of local ylist {
qui xtreg C`y' comprs wto comprs_tspec4 tspec4_wto, fe robust cl(pid)
est store ct`y'2
 
local xlist " I T M S R"
foreach x of local xlist {
qui xtreg C`y'_`x' comprs wto comprs_tspec4 tspec4_wto, fe robust cl(pid)
est store ct`y'2_`x'
}

}


local ylist "Inc Emp Hrs"
foreach y of local ylist {
qui xtreg C`y' comprs wto comprs_rti rti_wto, fe robust cl(pid)
est store cr`y'2
 
local xlist " I T M S R"
foreach x of local xlist {
qui xtreg C`y'_`x' comprs wto comprs_rti rti_wto, fe robust cl(pid)
est store cr`y'2_`x'
}

}




*******************************************************
**Table 6: Trade Adjustment and Specific Human Capital
*****************************************************

esttab cmInc2 cmInc2_I  cmInc2_S using Table6.rtf, ///
replace compress label keep(comprs_mspec4 comprs wto mspec4_wto)  b(%9.3f) se(%9.3f) ///
nonote title({\b Table 6} {\i Trade Adjustment and Specific Human Capital} \line {\b Panel A. Manufacturing Specificity of 4-digit Occupation} ) ///
mtitles("All Employers" "InitialFirm"  "Service" ) ///
varwidth(19) modelwidth(11) coeflabel(comprs "COMP_C" wto "Post_Shock" comprs_mspec4  "COMPC*MSpec" mspec4_wto "MSPEC*PostShock") star(a 0.05 b 0.01 c 0.001) 

esttab ctInc2 ctInc2_I  ctInc2_S using Table6.rtf, append compress label keep(comprs wto comprs_tspec4 tspec4_wto)  ///
b(%9.3f) se(%9.3f) nonote title({\b Panel B. Textile & Clothing Specificity of 4-digit Occupation}) ///
mtitles("All Emplyers" "InitialFirm"  "Service" ) coeflabel(comprs "COMP_C" wto "Post_Shock" comprs_tspec4  "COMPC*TCSpec" tspec4_wto "TCSPEC*PostShock")  varwidth(19) modelwidth(11) star(a 0.05 b 0.01 c 0.001) addnote(`notes')

********************************************************************************
**Online Appendix Table 18 Manufacturing Specificity of Occupation and Adjustment Costs
********************************************************************************

esttab cmInc2 cmInc2_I cmInc2_T cmInc2_M cmInc2_S cmInc2_R using OnlineApp_Table18.rtf, ///
replace compress label keep(comprs_mspec4 comprs wto mspec4_wto)  b(%9.3f) se(%9.3f) nonote  mtitles("All" "Initial"  "otTC" "otMan" "Service" "Other") ///
title({\b Table 18} {\i Manufacturing Specificity of Occupation and Adjustment Costs } \line {\b Earnings}) ///
coeflabel(comprs "COMP_C" wto "Post_Shock" comprs_mspec4  "COMPC*MSpec" mspec4_wto "MSpec*PostShock") varwidth(15) modelwidth(7) star(a 0.05 b 0.01 c 0.001) 

esttab cmEmp2 cmEmp2_I cmEmp2_T cmEmp2_M cmEmp2_S cmEmp2_R using OnlineApp_Table18.rtf, ///
append compress label title({\b Employment}) keep(comprs_mspec4 comprs wto mspec4_wto)  b(%9.3f) se(%9.3f) nonote mtitles("All" "Initial"  "otTC" "otMan" "Service" "Other") ///
coeflabel(comprs "COMP_C" wto "Post_Shock" comprs_mspec4  "COMPC*MSpec" mspec4_wto "MSpec*PostShock") varwidth(15) modelwidth(7) star(a 0.05 b 0.01 c 0.001) 

esttab cmHrs2 cmHrs2_I cmHrs2_T cmHrs2_M cmHrs2_S cmHrs2_R using OnlineApp_Table18.rtf, ///
append compress label title({\b Hours Worked}) keep(comprs_mspec4 comprs wto mspec4_wto)  b(%9.3f) se(%9.3f) nonote mtitles("All" "Initial"  "otTC" "otMan" "Service" "Other") ///
coeflabel(comprs "COMP_C" wto "Post_Shock" comprs_mspec4  "COMPC*MSpec" mspec4_wto "MSpec*PostShock") varwidth(15) modelwidth(7) star(a 0.05 b 0.01 c 0.001) addnote(`notes')

********************************************************************************
**Online Appendix Table 19 Textile Specificity of Occupation and Adjustment Costs
********************************************************************************

esttab ctInc2 ctInc2_I ctInc2_T ctInc2_M ctInc2_S ctInc2_R using OnlineApp_Table19.rtf, ///
replace compress label keep(comprs wto comprs_tspec4 tspec4_wto)  b(%9.3f) se(%9.3f) nonote  mtitles("All" "Initial"  "otTC" "otMan" "Service" "Other") ///
title({\b Table 19} {\i Textile Specificity of Occupation and Adjustment Costs } \line {\b Earnings}) ///
coeflabel(comprs "COMP_C" wto "Post_Shock" comprs_tspec4  "COMPC*TCSpec" tspec4_wto "TCSpec*PostShock") varwidth(15) modelwidth(7) star(a 0.05 b 0.01 c 0.001) 

esttab ctEmp2 ctEmp2_I ctEmp2_T ctEmp2_M ctEmp2_S ctEmp2_R using OnlineApp_Table19.rtf, ///
append compress label title({\b Employment}) keep(comprs wto comprs_tspec4 tspec4_wto)  b(%9.3f) se(%9.3f) nonote mtitles("All" "Initial"  "otTC" "otMan" "Service" "Other") ///
coeflabel(comprs "COMP_C" wto "Post_Shock" comprs_tspec4  "COMPC*TCSpec" tspec4_wto "TCSpec*PostShock") varwidth(15) modelwidth(7) star(a 0.05 b 0.01 c 0.001) 

esttab ctHrs2 ctHrs2_I ctHrs2_T ctHrs2_M ctHrs2_S ctHrs2_R using OnlineApp_Table19.rtf, ///
append compress label title({\b Hours Worked}) keep(comprs wto comprs_tspec4 tspec4_wto)  b(%9.3f) se(%9.3f) nonote mtitles("All" "Initial"  "otTC" "otMan" "Service" "Other") ///
coeflabel(comprs "COMP_C" wto "Post_Shock" comprs_tspec4  "COMPC*TCSpec" tspec4_wto "TCSpec*PostShock") varwidth(15) modelwidth(7) star(a 0.05 b 0.01 c 0.001) addnote(`notes')

**************************************************************************************
**Online Appendix Table 20 Routine Task Intensity of Occupation and Adjustment Costs
**************************************************************************************

esttab crInc2 crInc2_I crInc2_T crInc2_M crInc2_S crInc2_R using OnlineApp_Table20.rtf, ///
title({\b Table 20} {\i Routine Task Intensity of Occupation} \line {\b Earnings}) ///
replace compress label keep(comprs wto comprs_rti rti_wto)  b(%9.3f) se(%9.3f) nonote  mtitles("All" "Initial"  "otTC" "otMan" "Service" "Ot") ///
coeflabel(comprs_rti  "COMPC*RTI" rti_wto "RTI*PostShock") varwidth(15) modelwidth(7) star(a 0.05 b 0.01 c 0.001)

esttab crEmp2 crEmp2_I crEmp2_T crEmp2_M crEmp2_S crEmp2_R using OnlineApp_Table20.rtf, ///
append compress label title({\b Employment}) keep(comprs wto comprs_rti rti_wto)  b(%9.3f) se(%9.3f) nonote  /// 
coeflabel(comprs_rti  "COMPC*RTI" rti_wto "RTI*PostShock") varwidth(15) modelwidth(7) mtitles("All" "Initial"  "otTC" "otMan" "Service" "Ot") star(a 0.05 b 0.01 c 0.001)

esttab crHrs2 crHrs2_I crHrs2_T crHrs2_M crHrs2_S crHrs2_R using OnlineApp_Table20.rtf, ///
append compress label title({\b Hours Worked}) keep(comprs wto comprs_rti rti_wto)  b(%9.3f) se(%9.3f) nonote  ///
coeflabel(comprs_rti  "COMPC*RTI" rti_wto "RTI*PostShock") varwidth(15) modelwidth(7) mtitles("All" "Initial"  "otTC" "otMan" "Service" "Ot") addnote(`notes') star(a 0.05 b 0.01 c 0.001)


************************************************************************************
***Online Appendix Table 21 Occupation and Industry Experience and Adjustment Costs
************************************************************************************



local ylist"ocexp mexp texp"
foreach y of local ylist{
qui xtreg CInc comprs wto comprs_`y' `y'_wto, fe robust cl(pid)
est store `y'2
 
local xlist " I T M S R"
foreach x of local xlist {
qui xtreg CInc_`x' comprs wto comprs_`y' `y'_wto, fe robust cl(pid)
est store `y'2_`x'
}
}



esttab ocexp2 ocexp2_I ocexp2_T ocexp2_M ocexp2_S ocexp2_R using OnlineApp_Table21.rtf, ///
title({\b Table 21} {\i Occupation and Industry Experience and Adjustment Costs} \line {\b Cumulative Earnings} \line {\b Panel A. Occupational Experience}) ///
replace compress label keep(comprs wto comprs_ocexp ocexp_wto)  b(%9.3f) se(%9.3f) nonote  mtitles("All" "Initial"  "otTC" "otMan" "Service" "Ot") ///
coeflabel(comprs "COMP_C" comprs_ocexp  "COMPC*OccExp" wto "PostShock" ocexp_wto "OccExp*PostShock") varwidth(15) modelwidth(7) star(a 0.05 b 0.01 c 0.001)

esttab mexp2 mexp2_I mexp2_T mexp2_M mexp2_S mexp2_R using OnlineApp_Table21.rtf, ///
title({\b Panel B. Manufacturing Experience}) ///
append compress label keep(comprs wto comprs_mexp mexp_wto)  b(%9.3f) se(%9.3f) nonote  mtitles("All" "Initial"  "otTC" "otMan" "Service" "Ot") ///
coeflabel(comprs "COMP_C" comprs_mexp  "COMPC*ManExp" wto "PostShock" mexp_wto "ManExp*PostShock") varwidth(15) modelwidth(7) star(a 0.05 b 0.01 c 0.001)

esttab texp2 texp2_I texp2_T texp2_M texp2_S texp2_R using OnlineApp_Table21.rtf, ///
title({\b Panel C. Textile Experience}) ///
append compress label keep(comprs wto comprs_texp texp_wto)  b(%9.3f) se(%9.3f) nonote  mtitles("All" "Initial"  "otTC" "otMan" "Service" "Ot") ///
coeflabel(comprs "COMP_C" comprs_texp  "COMPC*TexExp" wto "PostShock" texp_wto "TexExp*PostShock") varwidth(15) modelwidth(7) star(a 0.05 b 0.01 c 0.001) addnote(`notes')













**Fig 7 data in the paper

qui xtivreg2 CNEDU comprs wto , fe robust cl(pid)
est store CNEDU2
local xlist "lm_I lm_M lm_S lm_SL lm_U lm_O "
foreach x of local xlist {
qui xtivreg2 CNEDU_`x' comprs wto , fe robust cl(pid)
est store CNEDU2_`x'
}

local ylist "ET1 ET2 ET3 MVoc SVoc"
foreach y of local ylist {
qui xtivreg2 CNEDU comprs wto if `y'==1, fe robust cl(pid)
est store CNEDU2_`y'

}

cap log using "Figure5Data.log"

*Figure 5a data
estout CNEDU2 CNEDU2_lm_I CNEDU2_lm_M CNEDU2_lm_S CNEDU2_lm_SL CNEDU2_lm_U CNEDU2_lm_O,  style(tex)  keep(comprs ) stats(F N , fmt(0)) cells(b(star fmt(%9.3f)) se(par)) legend starlevel(* 0.05 ** 0.01 *** 0.001) 
*Figure 5b data
estout CNEDU2 CNEDU2_ET1 CNEDU2_ET2 CNEDU2_ET3 CNEDU2_MVoc CNEDU2_SVoc,  style(tex)  keep(comprs ) stats(F N , fmt(0)) cells(b(star fmt(%9.3f)) se(par)) legend starlevel(* 0.05 ** 0.01 *** 0.001) 

cap log close

********************************************************
**Figure 5: Impact of Trade Shock on School Enrollment
*******************************************************

esttab CNEDU2 CNEDU2_lm_I CNEDU2_lm_M CNEDU2_lm_S CNEDU2_lm_SL CNEDU2_lm_U CNEDU2_lm_O using Figure7Data.rtf, ///
title({\i Figure 5a data }) varwidth(11) modelwidth(6) ///
replace compress label keep(comprs)  b(%9.3f) se(%9.3f) nonote star(a 0.05 b 0.01 c 0.001)  mtitles("Any Pos" "InitialFirm" "otherManu" "Service" "SelfEmp" "Unemployed" "Outside")

esttab CNEDU2 CNEDU2_ET1 CNEDU2_ET2 CNEDU2_ET3 CNEDU2_MVoc CNEDU2_SVoc using Figure7Data.rtf, ///
title({\i Figure 5b data}) varwidth(11) modelwidth(8) ///
append compress label keep(comprs)  b(%9.3f) se(%9.3f) star(a 0.05 b 0.01 c 0.001)  mtitles("AllWorkers" "Coll" "Vocational" "HighSchool"  "Man-Spec Voc" "Serv-Spec Voc")


********************************************************
***Online Appendix Figure 1
********************************************************

gen AInd10="Outside Labor Market" if outlab10==1 
replace AInd10="Unemployed" if unemp_e10==1  
replace AInd10="Manufacturing" if pernace10>=100000 & pernace10<330000 
replace AInd10="Service" if pernace10>=460000 & pernace10<980000 
replace AInd10="Agr, Fishing, Mining" if pernace10>=100 & pernace10<100000 
replace AInd10="Others" if pernace10>=330000 & pernace10<460000 
replace AInd10="Construction" if pernace10>=410000 & pernace10<440000  
replace AInd10="Unknown" if pernace10==.  & outlab10==0 & unemp_e10==0 
replace AInd10="Unknown" if pernace10==990000  & outlab10==0 & unemp_e10==0 
replace AInd10="Unknown" if pernace10==999999  & outlab10==0 & unemp_e10==0 


graph pie, over(AInd10)   pie(5, color(gray)) plabel(3 percent  , format(%9.0f))   plabel(5 percent  , format(%9.0f)) plabel(6 percent  , format(%9.0f)) by(,title("Workers' Positions in 2010" ))  by(ImportCompetition, style(econ)) 

bysort ImportCompetition: tab AInd10



********************************************************************************
**Online Appendix Table 22: Trade-induced Skill Upgrading: Worker Level Evidence
********************************************************************************


local ylist "ET1 ET2 ET3 MVoc SVoc"
foreach y of local ylist {
local xlist "lm_I lm_M lm_S lm_SL lm_U lm_O "
foreach x of local xlist {
qui xtreg CNEDU_`x' comprs wto if `y'==1, fe robust cl(pid)
est store CNEDU2_`y'_`x'
}
}


esttab CNEDU2 CNEDU2_lm_I CNEDU2_lm_M CNEDU2_lm_S CNEDU2_lm_SL CNEDU2_lm_U CNEDU2_lm_O using OnlineApp_Table22.rtf, ///
title({\b Table 22} {\i Trade induced skill upgrading}) varwidth(11) modelwidth(6) ///
replace compress label keep(comprs) coeflabel(comprs COMP_C) b(%9.3f) se(%9.3f) nonote star(a 0.05 b 0.01 c 0.001)  mtitles("Any Pos" "InitialFirm" "otherManu" "Service" "SelfEmp" "Unemployed" "Outside")

esttab CNEDU2_ET1 CNEDU2_ET1_lm_I CNEDU2_ET1_lm_M CNEDU2_ET1_lm_S CNEDU2_ET1_lm_SL CNEDU2_ET1_lm_U CNEDU2_ET1_lm_O using OnlineApp_Table22.rtf, ///
varwidth(11) modelwidth(6) title({\b Workers w/ College Education}) ///
append compress label keep(comprs) coeflabel(comprs COMP_C) b(%9.3f) se(%9.3f) nonote star(a 0.05 b 0.01 c 0.001)  mtitles("Any Pos" "InitialFirm" "otherManu" "Service" "SelfEmp" "Unemployed" "Outside")

esttab CNEDU2_ET2 CNEDU2_ET2_lm_I CNEDU2_ET2_lm_M CNEDU2_ET2_lm_S CNEDU2_ET2_lm_SL CNEDU2_ET2_lm_U CNEDU2_ET2_lm_O using OnlineApp_Table22.rtf, ///
varwidth(11) modelwidth(6) title({\b Workers w/ any type of Vocational Education}) ///
append compress label keep(comprs) coeflabel(comprs COMP_C) b(%9.3f) se(%9.3f) nonote star(a 0.05 b 0.01 c 0.001)  mtitles("Any Pos" "InitialFirm" "otherManu" "Service" "SelfEmp" "Unemployed" "Outside")

esttab CNEDU2_MVoc CNEDU2_MVoc_lm_I CNEDU2_MVoc_lm_M CNEDU2_MVoc_lm_S CNEDU2_MVoc_lm_SL CNEDU2_MVoc_lm_U CNEDU2_MVoc_lm_O using OnlineApp_Table22.rtf, ///
varwidth(11) modelwidth(6) title({\b Workers w/ Manufacturing Specific Vocational Education}) ///
append compress label keep(comprs) coeflabel(comprs COMP_C) b(%9.3f) se(%9.3f) nonote star(a 0.05 b 0.01 c 0.001)  mtitles("Any Pos" "InitialFirm" "otherManu" "Service" "SelfEmp" "Unemployed" "Outside")

esttab CNEDU2_SVoc CNEDU2_SVoc_lm_I CNEDU2_SVoc_lm_M CNEDU2_SVoc_lm_S CNEDU2_SVoc_lm_SL CNEDU2_SVoc_lm_U CNEDU2_SVoc_lm_O using OnlineApp_Table22.rtf, ///
varwidth(11) modelwidth(6) title({\b Workers w/ Service Related Vocational Education}) ///
append compress label keep(comprs) coeflabel(comprs COMP_C) b(%9.3f) se(%9.3f) nonote star(a 0.05 b 0.01 c 0.001)  mtitles("Any Pos" "InitialFirm" "otherManu" "Service" "SelfEmp" "Unemployed" "Outside")

esttab CNEDU2_ET3 CNEDU2_ET3_lm_I CNEDU2_ET3_lm_M CNEDU2_ET3_lm_S CNEDU2_ET3_lm_SL CNEDU2_ET3_lm_U CNEDU2_ET3_lm_O using OnlineApp_Table22.rtf, ///
varwidth(11) modelwidth(6) title({\b Workers w/ High-School Education}) ///
append compress label keep(comprs) coeflabel(comprs COMP_C) b(%9.3f) se(%9.3f) nonote star(a 0.05 b 0.01 c 0.001)  mtitles("Any Pos" "InitialFirm" "otherManu" "Service" "SelfEmp" "Unemployed" "Outside") addnote(`notes')



estimates drop _all

*********************************
***Income recovery via Transfers
*********************************

local ylist "CPerInc CPenInc CSickBen CUI CUIBen CEduAll COtBen"
foreach y of local ylist {

qui xtreg `y' comprs wto  ,  fe robust cl(pid)
est store `y'2

local xlist " lm_I lm_M lm_S lm_SL lm_U lm_O lm_OED lm_OER lm_OP"
foreach x of local xlist {

qui xtreg `y'_`x' comprs wto , fe robust cl(pid)
est store `y'_`x'2
}

}

**************************************
**Online Appendix Table 23: Transfers
**************************************

esttab CPerInc2 CPerInc_lm_I2 CPerInc_lm_M2 CPerInc_lm_S2 CPerInc_lm_SL2 CPerInc_lm_U2 CPerInc_lm_O2 using OnlineApp_Table23.rtf,  replace ///
title({\b Table 22} {\i Import Competition and Government Transfers} \line {\b Cumulative personal income} ) ///
keep(comprs ) coeflabel(comprs COMP_C) b(%9.3f) se(%9.3f) nonote star(a 0.05 b 0.01 c 0.001) varwidth(11) modelwidth(6) ///
mtitles("Any Pos" "InitialFirm" "otherManu" "Service" "SelfEmp" "Unemployed" "Outside")

esttab CPenInc2 CPenInc_lm_I2 CPenInc_lm_M2 CPenInc_lm_S2 CPenInc_lm_SL2 CPenInc_lm_U2 CPenInc_lm_O2 using OnlineApp_Table23.rtf, append ///
title({\b Cumulative pension income}) keep(comprs ) coeflabel(comprs COMP_C) b(%9.3f) se(%9.3f) nonote star(a 0.05 b 0.01 c 0.001) ///
varwidth(11) modelwidth(6) mtitles("Any Pos" "InitialFirm" "otherManu" "Service" "SelfEmp" "Unemployed" "Outside")

esttab CSickBen2 CSickBen_lm_I2 CSickBen_lm_M2 CSickBen_lm_S2 CSickBen_lm_SL2 CSickBen_lm_U2 CSickBen_lm_O2 using OnlineApp_Table23.rtf, append ///
title({\b Cumulative sickness benefit}) keep(comprs ) coeflabel(comprs COMP_C) b(%9.3f) se(%9.3f) nonote star(a 0.05 b 0.01 c 0.001) ///
varwidth(11) modelwidth(6) mtitles("Any Pos" "InitialFirm" "otherManu" "Service" "SelfEmp" "Unemployed" "Outside")

esttab CUIBen2 CUIBen_lm_I2 CUIBen_lm_M2 CUIBen_lm_S2 CUIBen_lm_SL2 CUIBen_lm_U2 CUIBen_lm_O2 using OnlineApp_Table23.rtf, append ///
title({\b Cumulative unemployment benefit}) keep(comprs ) coeflabel(comprs COMP_C) b(%9.3f) se(%9.3f) nonote star(a 0.05 b 0.01 c 0.001) ///
varwidth(11) modelwidth(6) mtitles("Any Pos" "InitialFirm" "otherManu" "Service" "SelfEmp" "Unemployed" "Outside")

esttab CEduAll2 CEduAll_lm_I2 CEduAll_lm_M2 CEduAll_lm_S2 CEduAll_lm_SL2 CEduAll_lm_U2 CEduAll_lm_O2  using OnlineApp_Table23.rtf, append ///
title({\b Cumulative education allowance}) keep(comprs ) coeflabel(comprs COMP_C) b(%9.3f) se(%9.3f) nonote star(a 0.05 b 0.01 c 0.001) ///
varwidth(11) modelwidth(6) mtitles("Any Pos" "InitialFirm" "otherManu" "Service" "SelfEmp" "Unemployed" "Outside")

esttab COtBen2 COtBen_lm_I2 COtBen_lm_M2 COtBen_lm_S2 COtBen_lm_SL2 COtBen_lm_U2 COtBen_lm_O2  using OnlineApp_Table23.rtf, append ///
title({\b Cumulative other benefits}) keep(comprs ) coeflabel(comprs COMP_C) b(%9.3f) se(%9.3f) nonote star(a 0.05 b 0.01 c 0.001) ///
varwidth(11) modelwidth(6) mtitles("Any Pos" "InitialFirm" "otherManu" "Service" "SelfEmp" "Unemployed" "Outside") addnote(`notes')


**Online Appendix Table 4 Panel A

replace avgnrsal=avgnrsal/normsal9699
replace avgnrwag=avgnrwag/normtotwag9699
replace avgnrper=avgnrper/normpers9699

local i 0
local ylist"avgnrsal avgnrwag avgnrper"
foreach y of local ylist {
local ++i
qui xtivreg2 `y' comp wto , fe robust cl(pid)
est store avgd`i'
qui xtivreg2 `y' comprs wto , fe robust cl(pid)
est store avgc`i'
}

estout avgd1 avgc1 avgd2 avgc2 avgd3 avgc3,  style(tex)  keep(comp comprs ) stats(F N , fmt(0)) cells(b(star fmt(%9.3f)) se(par)) legend starlevel(* 0.05 ** 0.01 *** 0.001) 

esttab avgd1 avgc1 avgd2 avgc2 avgd3 avgc3 using OnlineApp_Table4.rtf, ///
title({\b Table 4 } {\i Average Impact of the Chinese Import Shock on Earnings and Income} \line {\b Panel A. 1999-2010}) varwidth(11) modelwidth(8) ///
replace compress label keep(comp comprs)  b(%9.3f) se(%9.3f) star(a 0.05 b 0.01 c 0.001)  mtitles("Annual Wage""Annual Wage""Total Annual Earnings""Total Annual Earnings""Personal Income""Personal Income")






*******************************************
***Online Appendix Table 6 and Table 7 
**Workers Reallocation within the Sectors
******************************************


 
local xlist " S WR HR TSC FI RRB PD ED HSW SPW AH"
foreach x of local xlist {
qui xtivreg2 CEmp_`x' comprs wto , fe robust cl(pid)
est store cEmp2_`x'
}

**primary employment
estout cEmp2_S cEmp2_WR cEmp2_HR cEmp2_TSC cEmp2_FI cEmp2_RRB  ,  style(tex)  keep(comprs wto) stats(r2 r2_a F N N_clust, fmt(3 3 3 0)) cells(b(star fmt(%9.3f)) se(par)) legend starlevel(+ 0.10 * 0.05 ** 0.01 *** 0.001) 

estout cEmp2_S cEmp2_PD cEmp2_ED cEmp2_HSW cEmp2_SPW cEmp2_AH,  style(tex)  keep(comprs wto) stats(r2 r2_a F N N_clust, fmt(3 3 3 0)) cells(b(star fmt(%9.3f)) se(par)) legend starlevel(+ 0.10 * 0.05 ** 0.01 *** 0.001) 




esttab cEmp2_S cEmp2_WR cEmp2_HR cEmp2_TSC cEmp2_FI cEmp2_RRB  using OnlineApp_Table6.rtf, ///
title( {\i Trade-induced workers movement across jobs} {\b within services}) varwidth(11) modelwidth(7) ///
replace compress label keep(comprs) coeflabel(comprs Trade) b(%9.3f) se(%9.3f) star(a 0.05 b 0.01 c 0.001)  mtitles("All Services""WHS/Retail""HotelsRest""TranspComm" "Finance" "RealEstateRentingBuss") nonote addnote("Robust standard errors, given in paranthesis, are clustered at worker level. Superscripts a, b, c indicate p < 0.05,  p < 0.01,  p < 0.001, respectively.")

esttab cEmp2_S cEmp2_PD cEmp2_ED cEmp2_HSW cEmp2_SPW cEmp2_AH  using OnlineApp_Table6.rtf, ///
varwidth(11) modelwidth(7) ///
append compress label keep(comprs) coeflabel(comprs Trade) b(%9.3f) se(%9.3f) star(a 0.05 b 0.01 c 0.001)  mtitles("All Services""Defense""Education" "Health&SocialW" "PersonalServices" "HouseholdActivities") nonote addnote("Robust standard errors, given in paranthesis, are clustered at worker level. Superscripts a, b, c indicate p < 0.05,  p < 0.01,  p < 0.001, respectively.")

local xlist "M MFood MLS MWoodPaper MPublish MPetChem MGlaMin MMetals MMachines MMeasuring MTransEq MMisc"
foreach x of local xlist {
qui xtivreg2 CEmp_`x' comprs wto , fe robust cl(pid)
est store cEmp2_`x'
}


**primary employment
estout cEmp2_M cEmp2_MFood  cEmp2_MLS cEmp2_MWoodPaper cEmp2_MPublish cEmp2_MPetChem ,  style(tex)  keep(comprs wto) stats(r2 r2_a F N N_clust, fmt(3 3 3 0)) cells(b(star fmt(%9.3f)) se(par)) legend starlevel(+ 0.10 * 0.05 ** 0.01 *** 0.001) 

estout cEmp2_M cEmp2_MGlaMin cEmp2_MMetals cEmp2_MMachines cEmp2_MMeasuring cEmp2_MTransEq  cEmp2_MMisc,  style(tex)  keep(comprs wto) stats(r2 r2_a F N N_clust, fmt(3 3 3 0)) cells(b(star fmt(%9.3f)) se(par)) legend starlevel(+ 0.10 * 0.05 ** 0.01 *** 0.001) 


esttab cEmp2_M cEmp2_MFood  cEmp2_MLS cEmp2_MWoodPaper cEmp2_MPublish cEmp2_MPetChem  using OnlineApp_Table7.rtf, ///
title( {\i Trade-induced workers movement across jobs} {\b within manufacturing}) varwidth(11) modelwidth(7) ///
replace compress label keep(comprs) coeflabel(comprs Trade) b(%9.3f) se(%9.3f) star(a 0.05 b 0.01 c 0.001)  mtitles("Manufacturing""Food""Leather&Shoes""Wood&Paper" "PublishingPrinting" "PetrolChemicals") nonote addnote("Robust standard errors, given in paranthesis, are clustered at worker level. Superscripts a, b, c indicate p < 0.05,  p < 0.01,  p < 0.001, respectively.")
esttab cEmp2_MGlaMin cEmp2_MMetals cEmp2_MMachines cEmp2_MMeasuring cEmp2_MTransEq  cEmp2_MMisc  using OnlineApp_Table7.rtf, ///
varwidth(11) modelwidth(7) ///
append compress label keep(comprs) coeflabel(comprs Trade) b(%9.3f) se(%9.3f) star(a 0.05 b 0.01 c 0.001)  mtitles("GlassMinerals""Metals""Machines""MeasuringEq" "TransEq" "MiscMan") nonote addnote("Robust standard errors, given in paranthesis, are clustered at worker level. Superscripts a, b, c indicate p < 0.05,  p < 0.01,  p < 0.001, respectively.")


*****************************************
***Workers' Adjustment by Age
*****************************************

**
gen age1=0
replace age1=1 if age99>=22 & age99<=35  /* young */

gen age2=0
replace age2=1 if age99>=36 & age99<=49  /* mid */

gen age3=0
replace age3=1 if age99>=50 & age99<=56   /* old */






local ylist "Inc Emp Hrs"
foreach y of local ylist {
forvalues i=1/3 {
qui xtreg C`y' comprs wto if age`i'==1, fe robust cl(pid)
est store age`i'_`y'2
}
local xlist " I T M S R"
foreach x of local xlist {
forvalues i=1/3 {
qui xtreg C`y'_`x' comprs wto if age`i'==1, fe robust cl(pid)
est store age`i'_`y'_`x'2
}
}
}

*age 22-35
estout age1_Inc2 age1_Inc_I2 age1_Inc_T2 age1_Inc_M2 age1_Inc_S2 age1_Inc_R2,  style(tex)  keep(comprs wto) stats(r2 r2_a F N N_clust, fmt(3 3 3 0)) cells(b(star fmt(%9.3f)) se(par)) legend starlevel(+ 0.10 * 0.05 ** 0.01 *** 0.001) 
estout age1_Emp2 age1_Emp_I2 age1_Emp_T2 age1_Emp_M2 age1_Emp_S2 age1_Emp_R2,  style(tex)  keep(comprs wto) stats(r2 r2_a F N N_clust, fmt(3 3 3 0)) cells(b(star fmt(%9.3f)) se(par)) legend starlevel(+ 0.10 * 0.05 ** 0.01 *** 0.001) 
estout age1_Hrs2 age1_Hrs_I2 age1_Hrs_T2 age1_Hrs_M2 age1_Hrs_S2 age1_Hrs_R2,  style(tex)  keep(comprs wto) stats(r2 r2_a F N N_clust, fmt(3 3 3 0)) cells(b(star fmt(%9.3f)) se(par)) legend starlevel(+ 0.10 * 0.05 ** 0.01 *** 0.001)

*age 36-49
estout age2_Inc2 age2_Inc_I2 age2_Inc_T2 age2_Inc_M2 age2_Inc_S2 age2_Inc_R2,  style(tex)  keep(comprs wto) stats(r2 r2_a F N N_clust, fmt(3 3 3 0)) cells(b(star fmt(%9.3f)) se(par)) legend starlevel(+ 0.10 * 0.05 ** 0.01 *** 0.001)
estout age2_Emp2 age2_Emp_I2 age2_Emp_T2 age2_Emp_M2 age2_Emp_S2 age2_Emp_R2,  style(tex)  keep(comprs wto) stats(r2 r2_a F N N_clust, fmt(3 3 3 0)) cells(b(star fmt(%9.3f)) se(par)) legend starlevel(+ 0.10 * 0.05 ** 0.01 *** 0.001)
estout age2_Hrs2 age2_Hrs_I2 age2_Hrs_T2 age2_Hrs_M2 age2_Hrs_S2 age2_Hrs_R2,  style(tex)  keep(comprs wto) stats(r2 r2_a F N N_clust, fmt(3 3 3 0)) cells(b(star fmt(%9.3f)) se(par)) legend starlevel(+ 0.10 * 0.05 ** 0.01 *** 0.001)


*age 50-56
estout age3_Inc2 age3_Inc_I2 age3_Inc_T2 age3_Inc_M2 age3_Inc_S2 age3_Inc_R2,  style(tex)  keep(comprs wto) stats(r2 r2_a F N N_clust, fmt(3 3 3 0)) cells(b(star fmt(%9.3f)) se(par)) legend starlevel(+ 0.10 * 0.05 ** 0.01 *** 0.001)
estout age3_Emp2 age3_Emp_I2 age3_Emp_T2 age3_Emp_M2 age3_Emp_S2 age3_Emp_R2,  style(tex)  keep(comprs wto) stats(r2 r2_a F N N_clust, fmt(3 3 3 0)) cells(b(star fmt(%9.3f)) se(par)) legend starlevel(+ 0.10 * 0.05 ** 0.01 *** 0.001)
estout age3_Hrs2 age3_Hrs_I2 age3_Hrs_T2 age3_Hrs_M2 age3_Hrs_S2 age3_Hrs_R2,  style(tex)  keep(comprs wto) stats(r2 r2_a F N N_clust, fmt(3 3 3 0)) cells(b(star fmt(%9.3f)) se(par)) legend starlevel(+ 0.10 * 0.05 ** 0.01 *** 0.001)


***************************************************************
**Online Appendix Table 8. Workers' Adjustment by Age: Earnings
***************************************************************

esttab  age1_Inc2 age1_Inc_I2 age1_Inc_T2 age1_Inc_M2 age1_Inc_S2 age1_Inc_R2 using OnlineApp_Table8.rtf, ///
replace compress label keep(comprs) coeflabel(comprs COMP_C) b(%9.3f) se(%9.3f) nonote star(a 0.05 b 0.01 c 0.001) /// 
mtitles("All Emp" "InitialFirm" "otherTC" "otherManu" "Service" "Other") ///
title({\i Workers Adjustment by Age: Earnings} \line {\b The Early Career Group, Age 22-35}) varwidth(11) modelwidth(8)

esttab  age2_Inc2 age2_Inc_I2 age2_Inc_T2 age2_Inc_M2 age2_Inc_S2 age2_Inc_R2 using OnlineApp_Table8.rtf, ///
append compress label keep(comprs) coeflabel(comprs COMP_C) b(%9.3f) se(%9.3f) nonote star(a 0.05 b 0.01 c 0.001) ///
mtitles("All Emp" "InitialFirm" "otherTC" "otherManu" "Service" "Other") ///
title({\b The Mid Career Group, Age 36-49}) varwidth(11) modelwidth(8)

esttab  age3_Inc2 age3_Inc_I2 age3_Inc_T2 age3_Inc_M2 age3_Inc_S2 age3_Inc_R2 using OnlineApp_Table8.rtf, ///
append compress label keep(comprs) coeflabel(comprs COMP_C) b(%9.3f) se(%9.3f) nonote star(a 0.05 b 0.01 c 0.001) ///
mtitles("All Emp" "InitialFirm" "otherTC" "otherManu" "Service" "Other") ///
title({\b The Late Career Group, Age 50-56}) varwidth(11) modelwidth(8) addnote(`notes')


******************************************************************************************
**Online Appendix Table 9 Workers' Adjustment by Age: Years of Employment and Hours Worked
*******************************************************************************************

esttab  age1_Emp2 age1_Emp_I2 age1_Emp_T2 age1_Emp_M2 age1_Emp_S2 age1_Emp_R2 using OnlineApp_Table9.rtf, ///
replace compress label keep(comprs) coeflabel(comprs COMP_C) b(%9.3f) se(%9.3f) nonote star(a 0.05 b 0.01 c 0.001) mtitles("All Emp" "InitialFirm" "otherTC" "otherManu" "Service" "Other") ///
title({\i Workers Adjustment by Age: Years of Employment and Hours Worked} \line {\b The Early Career Group, Age 22-35}) varwidth(11) modelwidth(8)

esttab  age1_Hrs2 age1_Hrs_I2 age1_Hrs_T2 age1_Hrs_M2 age1_Hrs_S2 age1_Hrs_R2 using OnlineApp_Table9.rtf, ///
append compress label keep(comprs) coeflabel(comprs COMP_C) b(%9.3f) se(%9.3f) nonote star(a 0.05 b 0.01 c 0.001) mtitles("All Emp" "InitialFirm" "otherTC" "otherManu" "Service" "Other") ///
varwidth(11) modelwidth(8)


esttab  age2_Emp2 age2_Emp_I2 age2_Emp_T2 age2_Emp_M2 age2_Emp_S2 age2_Emp_R2 using OnlineApp_Table9.rtf, ///
append compress label keep(comprs) coeflabel(comprs COMP_C) b(%9.3f) se(%9.3f) nonote star(a 0.05 b 0.01 c 0.001) mtitles("All Emp" "InitialFirm" "otherTC" "otherManu" "Service" "Other") ///
title({\b The Mid Career Group, Age 36-49}) varwidth(11) modelwidth(8)

esttab  age2_Hrs2 age2_Hrs_I2 age2_Hrs_T2 age2_Hrs_M2 age2_Hrs_S2 age2_Hrs_R2 using OnlineApp_Table9.rtf, ///
append compress label keep(comprs) coeflabel(comprs COMP_C) b(%9.3f) se(%9.3f) nonote star(a 0.05 b 0.01 c 0.001) mtitles("All Emp" "InitialFirm" "otherTC" "otherManu" "Service" "Other") ///
varwidth(11) modelwidth(8)


esttab  age3_Emp2 age3_Emp_I2 age3_Emp_T2 age3_Emp_M2 age3_Emp_S2 age3_Emp_R2 using OnlineApp_Table9.rtf, ///
append compress label keep(comprs) coeflabel(comprs COMP_C) b(%9.3f) se(%9.3f) nonote star(a 0.05 b 0.01 c 0.001) mtitles("All Emp" "InitialFirm" "otherTC" "otherManu" "Service" "Other") ///
title({\b The Late Career Group, Age 50-56}) varwidth(11) modelwidth(8)

esttab  age3_Hrs2 age3_Hrs_I2 age3_Hrs_T2 age3_Hrs_M2 age3_Hrs_S2 age3_Hrs_R2 using OnlineApp_Table9.rtf, ///
append compress label keep(comprs) coeflabel(comprs COMP_C) b(%9.3f) se(%9.3f) nonote star(a 0.05 b 0.01 c 0.001) mtitles("All Emp" "InitialFirm" "otherTC" "otherManu" "Service" "Other") ///
varwidth(11) modelwidth(8) addnote(`notes')





****AnnualData: 1999-2010 **



estimates drop _all

use "TCWorkers_1999_2010.dta", clear

/*
replace rsalary=0 if rtotwag~=. & rsalary==.
replace rsalary=0 if rpersonindk~=. & rsalary==.
replace rpersonindk=0 if rpersonindk<0 & rpersonindk~=.
*/


xtset pid year



local xlist "arledgr "
foreach x of local xlist {
gen ln1`x'=ln(`x'+1)
}

gen post=1 if year>=2002





*singletons
local j 0
local xlist "lnrsalary lnrtotwag  lnrpersonindk  lnhrs lnrhwage ln1arledgr ln1sumgrad"
foreach x of local xlist {
local ++ j
bysort pid: egen aux`j'=count(`x')
replace `x'=. if aux`j'==1
drop aux`j'
bysort pid: egen paux`j'=count(`x'*post)
replace `x'=. if paux`j'==0
drop paux`j'
}




reghdfe lnrsalary AffwdD02 if  lnrtotwag~=. & lnrpersonindk~=. , vce(cluster pid) absorb(pid year)
gen esample=1 if e(sample) 



local j 0
local xlist "lnrsalary lnrtotwag  lnrpersonindk  lnhrs lnrhwage  ln1arledgr "
foreach x of  local xlist {
local ++ j

qui reghdfe `x'  AffwdD02  if esample==1, vce(cluster pid) absorb(pid year)
est store fe_`j'
qui reghdfe `x'  AffwdrsD02  if esample==1, vce(cluster pid) absorb(pid year)
est store cfe_`j'


}

tabstat lnrsalary lnrtotwag  lnrpersonindk  lnhrs lnrhwage  ln1arledgr if esample==1, stats(mean sd N)
tabstat lnrsalary lnrtotwag  lnrpersonindk  lnhrs lnrhwage  ln1arledgr if esample==1, stats(mean sd N) format(%9.3f)



esttab fe_1 fe_2 fe_3 fe_4 fe_5 fe_6  using Table2A.rtf, ///
title({\b Table 2 } {\i Impact of the Chinese Import Shock on Earnings, Income, and Unemployment} \line {\b Panel A. Annual data 1999-2010}) varwidth(11) modelwidth(8) ///
replace compress label keep(AffwdD02) coeflabel(AffwdD02 COMP_D)  b(%9.3f) se(%9.3f) star(a 0.05 b 0.01 c 0.001)  mtitles("Annual Wage""Total Annual Earnings""Personal Income""Annual Hrs" "HourlyWage" "Unemp") nonote 
esttab cfe_1 cfe_2 cfe_3 cfe_4 cfe_5 cfe_6  using Table2A.rtf, ///
title({\b Panel A. Annual data 1999-2010}) varwidth(11) modelwidth(8) ///
append compress label keep(AffwdrsD02) coeflabel(AffwdrsD02 COMP_C)  b(%9.3f) se(%9.3f) star(a 0.05 b 0.01 c 0.001)  mtitles("Annual Wage""Total Annual Earnings""Personal Income""Annual Hrs" "HourlyWage" "Unemp") nonote addnote("Robust standard errors, given in parenthesis, are clustered at worker level. Superscripts a, b, c indicate p < 0.05,  p < 0.01,  p < 0.001, respectively.")


collapse (mean) norm* rsalary99 rsalary  rtotwag  rpersonindk hrs timprae rhwage rmnhw ///
		 (mean) length sumgrad arledgr affwd AffwdD02 AffwdrsD02 ET1 ET2 ET3  disc1_99 age99 (median) fid , by(pnr Dum02) 


destring pnr, gen(pid)		 
		 
gen wto=0
replace wto=1 if Dum02==1

gen post=1 if wto==1




local xlist "rsalary  rtotwag  rpersonindk hrs rhwage"
foreach x of local xlist {
gen ln`x'=ln(`x')
}
local xlist "rsalary rtotwag  rpersonindk arledgr "
foreach x of local xlist {
gen ln1`x'=ln(`x'+1)
}




local j 0
local xlist "lnrsalary  lnrtotwag  lnrpersonindk  lnhrs lnrhwage ln1arledgr "

foreach x of local xlist {
local ++ j

bysort pid: egen aux`j'=count(`x')
replace `x'=. if aux`j'==1

bysort pid: egen paux`j'=count(`x'*post)
replace `x'=. if paux`j'==0
drop paux`j'
}
capture drop aux*



xtset pid Dum02





xtreg lnrsalary  AffwdD02  Dum02 if lnrtotwag~=. & lnrpersonindk~=. , fe robust cl(pid) 
gen aesample=1  if e(sample) 



local j 0
local xlist "lnrsalary  lnrtotwag  lnrpersonindk  lnhrs  lnrhwage  ln1arledgr "
foreach x of  local xlist {
local ++ j


qui xtivreg2 `x'  AffwdD02  wto if aesample==1, fe robust cl(pid) 
est store afe_`j'

qui xtivreg2 `x'  AffwdrsD02  wto if aesample==1, fe robust cl(pid) 
est store cafe_`j'


}




esttab afe_1 afe_2 afe_3 afe_4 afe_5 afe_6  using Table2B.rtf, ///
title({\b Table 2 } {\i Impact of the Chinese Import Shock on Earnings, Income, and Unemployment} \line {\b Panel B. Aggregated Data 1999-2010}) varwidth(11) modelwidth(8) ///
replace compress label keep(AffwdD02) coeflabel(AffwdD02 COMP_D)  b(%9.3f) se(%9.3f) star(a 0.05 b 0.01 c 0.001)  mtitles("Annual Wage""Total Annual Earnings""Personal Income""Annual Hrs" "HourlyWage" "Unemp") nonote 
esttab cafe_1 cafe_2 cafe_3 cafe_4 cafe_5 cafe_6  using Table2B.rtf, ///
title({\b Panel B. Aggregated Data 1999-2010}) varwidth(11) modelwidth(8) ///
append compress label keep(AffwdrsD02) coeflabel(AffwdrsD02 COMP_C)  b(%9.3f) se(%9.3f) star(a 0.05 b 0.01 c 0.001)  mtitles("Annual Wage""Total Annual Earnings""Personal Income""Annual Hrs" "HourlyWage" "Unemp") nonote addnote("Robust standard errors, given in parenthesis, are clustered at worker level. Superscripts a, b, c indicate p < 0.05,  p < 0.01,  p < 0.001, respectively.")





// annual worker-level data 1985-1999

use "idapall8599tc.dta", clear 


set more off

keep if year>=1990




label var persbrc"personal branch code
destring persbrc, gen(pernace)

rename pstill pstill_i
label var pstill_i"the working position in the main occupation of the individual in November IDA
destring pstill_i, replace

rename still still_i
label var still_i"still from IDA
destring still_i, replace


gen nwemp=0 //non-wage earner employed
replace nwemp=1 if pstill_i==12 | pstill_i==13 | pstill_i==14 | pstill_i==19 | pstill_i==20
gen tg_tc99=0
replace tg_tc99=1 if pernace>=170000 & pernace<190000 & year==1999  & nwemp==0
bysort pnr: egen tc99=sum(tg_tc99)   // people employed in TC-man in 1999

keep if tc99==1

g byear=year(foed_dag)

gen age=year-byear

gen aux=age if year==1999
bys pnr: egen age99=max(aux)
drop aux

g sample_1767=0
replace sample_1767=1 if byear>=1943 & byear<=1982  
keep if sample_1767==1


rename slon totwag
label var totwag"the total annual sum of  net wage for the individual from CON

rename timelon hwage
label var hwage"timelon-hourly wage
rename tlonkval hwagequality

rename joblon salary 
label var salary"joblon-wages in the employment relationship-nov

rename atpar experience
label var experience"number of years from 1980 (of paid ATP) as an employee 

label var type"type of employment relationship

rename jobkat joblength
label var joblength"jobkat-jobtype in the employment

label var  tilknyt"attachment to the primary workplace



label var koen"1=man, 2=women
destring koen, gen(gender)

 //this makes sure workers in the data till 2010
sort pnr
merge n:1 pnr using "affectedtc.dta", using(affwd affwd_rs)
tab _merge
keep if _merge==3
drop _merge



gen cpi=.
replace cpi=66.733 if year==1985
replace cpi=69.217 if year==1986
replace cpi=71.975 if year==1987
replace cpi=75.250 if year==1988
replace cpi=78.850 if year==1989
replace cpi=80.942 if year==1990
replace cpi=82.858 if year==1991
replace cpi=84.600 if year==1992
replace cpi=85.658 if year==1993
replace cpi=87.367 if year==1994
replace cpi=89.200 if year==1995
replace cpi=91.083 if year==1996
replace cpi=93.083 if year==1997
replace cpi=94.808 if year==1998
replace cpi=97.158 if year==1999



*Deflate nominal variables

local xlist "personindk totwag hwage  salary "
foreach x of local xlist {
gen r`x'=100*`x'/cpi
}



replace rhwage=. if hwagequality>=100  // hwagequality 100 and above is unusable 

gen hrs=salary/hwage
replace hrs=. if hwagequality>=100

replace rsalary=0 if rsalary==. & rtotwag~=. 
replace rsalary=0 if rsalary==. & rpersonindk~=.
replace rsalary=. if age<15 & age~=.

replace rtotwag=0 if rtotwag==. & rpersonindk~=.
replace rtotwag=. if age<15 & age~=.

*Take logarithm 

local xlist "rpersonindk rtotwag rhwage  rsalary experience hrs"
foreach x of local xlist {
gen ln`x'=ln(`x')
}

local xlist " arledgr "
foreach x of local xlist {
gen ln1`x'=ln(`x'+1)
}

gen str ind2=substr(persbrc,1,2)
destring ind2, replace

**Time Dummies
gen Dum95=0
replace Dum95=1 if year>=1995

gen AffwdD95=affwd*Dum95

gen AffwdrsD95=affwd_rs*Dum95


destring pnr, gen(pid)
xtset pid year





reghdfe lnrsalary AffwdD95 if lnrtotwag~=. & lnrpersonindk~=. , vce(cluster pid) absorb(pid year)
gen dum=1 if e(sample)

local xlist "lnrsalary   lnrtotwag  lnrpersonindk  lnhrs lnrhwage ln1arledgr  "
foreach x of local xlist{
qui reghdfe `x' AffwdD95 if dum==1 , vce(cluster pid) absorb(pid year)
est store reg_`x'
qui  reghdfe `x' AffwdrsD95 if dum==1 , vce(cluster pid) absorb(pid year)
est store creg_`x'
}





drop dum


esttab reg_lnrsalary reg_lnrtotwag  reg_lnrpersonindk reg_lnhrs reg_lnrhwage  reg_ln1arledgr  using Table2C_ws.rtf, ///
title({\b Table 2 } {\i Impact of the Chinese Import Shock on Earnings, Income, and Unemployment} \line {\b Panel C. Annual data 1990-1999}) varwidth(11) modelwidth(8) ///
replace compress label keep(AffwdD95)  b(%9.3f) se(%9.3f) star(a 0.05 b 0.01 c 0.001)  mtitles("Annual Wage""Total Annual Earnings""Personal Income""Annual Hrs" "HourlyWage" "Unemp") nonote   
esttab creg_lnrsalary creg_lnrtotwag  creg_lnrpersonindk creg_lnhrs creg_lnrhwage  creg_ln1arledgr using Table2C_ws.rtf, ///
title({\b Panel C. Annual data 1990-1999}) varwidth(11) modelwidth(8) ///
append compress label keep(AffwdrsD95)   b(%9.3f) se(%9.3f) star(a 0.05 b 0.01 c 0.001)  mtitles("Annual Wage""Total Annual Earnings""Personal Income""Annual Hrs" "HourlyWage" "Unemp") nonote addnote("Robust standard errors, given in paranthesis, are clustered at worker level. Superscripts a, b, c indicate p < 0.05,  p < 0.01,  p < 0.001, respectively.")



bysort year: tabstat age lnrsal lnrtotwag, by(affwd) 


bysort year: tabstat  rsalary rtotsal rtotwag rloenmv rpersonindk hrs  rhwage arledgr , stats(mean min N)






collapse (mean)  rsalary rtotsal rtotwag  rpersonindk hrs  rhwage  sumgrad arledgr affwd AffwdD95 AffwdrsD95, by(pid pnr Dum95)



local xlist "rsalary rtotsal rtotwag rpersonindk hrs rhwage "
foreach x of local xlist {
gen ln`x'=ln(`x')
}

local xlist "arledgr "
foreach x of local xlist {
gen ln1`x'=ln(`x'+1)
}


gen time=Dum95

xtset pid time




xtreg lnrsalary  AffwdD95  Dum95 if lnrtotwag~=. & lnrpersonindk~=. & id2010==1, fe robust cl(pid)
keep if e(sample)

local xlist "lnrsalary lnrtotwag  lnrpersonindk  lnhrs lnrhwage ln1arledgr "
foreach x of local xlist{
qui xtreg `x' AffwdD95  Dum95  , fe robust cl(pid)
est store reg_`x'
qui xtreg `x' AffwdrsD95  Dum95  , fe robust cl(pid)
est store creg_`x'
}




esttab reg_lnrsalary reg_lnrtotwag  reg_lnrpersonindk reg_lnhrs reg_lnrhwage  reg_ln1arledgr  using Table2D_ws.rtf, ///
title({\b Table 2 } {\i Impact of the Chinese Import Shock on Earnings, Income, and Unemployment} \line {\b Panel D. Aggregated Data 1990-1999}) varwidth(11) modelwidth(8) ///
replace compress label keep(AffwdD95) coeflabel(AffwdD02 COMP_D)  b(%9.3f) se(%9.3f) star(a 0.05 b 0.01 c 0.001)  mtitles("Annual Wage""Total Annual Earnings""Personal Income""Annual Hrs" "HourlyWage" "Unemp") nonote  
esttab creg_lnrsalary creg_lnrtotwag  creg_lnrpersonindk creg_lnhrs creg_lnrhwage  creg_ln1arledgr using Table2D_ws.rtf, ///
title({\b Panel D. Aggregated Data 1990-1999}) varwidth(11) modelwidth(8) ///
append compress label keep(AffwdrsD95) coeflabel(AffwdrsD02 COMP_C)  b(%9.3f) se(%9.3f) star(a 0.05 b 0.01 c 0.001)  mtitles("Annual Wage""Total Annual Earnings""Personal Income""Annual Hrs" "HourlyWage" "Unemp") nonote addnote("Robust standard errors, given in paranthesis, are clustered at worker level. Superscripts a, b, c indicate p < 0.05,  p < 0.01,  p < 0.001, respectively.")




*******************************************
***Yearly Figures**
*******************************************



estimates drop _all

local yr 2001

local zlist "0202 0203 0204 0205 0206 0207 0208 0209 0210"
foreach z of local zlist {

local ++yr

use "CumVars9901.dta", clear

append using "CumVars`z'.dta"





xtset pid time

gen wto=0 if time==1
replace wto=1 if time==2

gen comp=affwd*wto
gen comprs=affwd_rs*wto




local ylist "Emp Hrs "
foreach y of local ylist {
qui xtivreg2 C`y' comprs wto , fe robust cl(pid)
est store c`y'2
 
local xlist " I T M S R"
foreach x of local xlist {
qui xtivreg2 C`y'_`x' comprs wto , fe robust cl(pid)
est store c`y'2_`x'
}

}

 
qui xtivreg2 CUnEmpA comprs wto , fe robust cl(pid)
est store cUnEmpA2
 
local xlist "T M S R"
foreach x of local xlist {
qui xtivreg2 CUnEmpA_l`x' comprs wto , fe robust cl(pid)
est store cUnEmpA2_l`x'

}

********************************************************************************************************
**Figure 2
********************************************************************************************************

esttab cEmp2 cEmp2_I cEmp2_T cEmp2_M cEmp2_S using Figure2aData.rtf, ///
append compress label keep(comprs)  cells(b( fmt(%9.3f)) ci_l ci_u ) nonote  nostar mtitles("All" "Initial"  "otTC" "otMan" "Service" ) ///
title({\b Year `yr' } ) varwidth(11) modelwidth(9) coeflabel( comprs "COMP_C")

esttab cHrs2 cHrs2_I cHrs2_T cHrs2_M cHrs2_S using Figure2bData.rtf, ///
append compress label keep(comprs)  cells(b( fmt(%9.3f)) ci_l ci_u ) nonote  nostar coeflabel( comprs "COMP_C") ///
mtitles("All" "Initial"  "otTC" "otMan" "Service" ) varwidth(11) modelwidth(9) title({\b Year `yr' })



********************************************************************************************************
*****Online appendix figure 2
********************************************************************************************************
estout cUnEmpA2 cUnEmpA2_lS ,  keep(comprs )  cells(b( fmt(%9.3f)) ci_l ci_u ) legend level(95)


esttab cUnEmpA2 cUnEmpA2_lS using OAFigure2data.rtf, append keep(comprs ) coeflabel( comprs "COMP_C") nostar nonote ///
cells(b( fmt(%9.3f)) ci_l ci_u ) mtitles("All UE spells" "following a service job" ) varwidth(11) modelwidth(15) title({\b Year `yr' }) 



}

