use "LAPOP replication data .dta", clear


replace rs_pension = -1*rs_pension
replace  rs_healthcare = -1* rs_healthcare
replace  rs_wellbeing  = -1* rs_wellbeing 
replace rs_ownindustry = -1*rs_ownindustry
replace   rs_jobs  = -1*  rs_jobs 
replace  rs_inequality = -1* rs_inequality

gen SM_INDEX = (rs_wellbeing +  rs_ownindustry + rs_pension + rs_inequality + rs_healthcare)/5


sort cowcode year
##table 2##

{
est clear
gen sample = 1 if d_real_returns != . & country != "Panama"
xtreg SM_INDEX contributor                            income i.work_type rural  single years_educ male age  if sample ==1,   r
est store a
xtreg SM_INDEX contributor                            income i.work_type rural  single years_educ male age  deflator  unemp gdppcgrowth lngdppc if sample ==1,   r
est store b
xtreg SM_INDEX contributor                            income i.work_type rural  single years_educ male age   govdebt foreigninvestment contribover15 if sample ==1,   r
est store c
xtreg SM_INDEX contributor   						  income i.work_type rural  single years_educ male age  if sample ==1,   fe r
est store d
xtreg SM_INDEX c.contributor##c.corpsec               income i.work_type rural  single years_educ male age  if sample ==1,   cl(cowcode)
est store e
xtreg SM_INDEX c.contributor##c.corpsec               income i.work_type rural  single years_educ male age   deflator unemp  gdppcgrowth lngdppc if sample ==1,   r
est store f
xtreg SM_INDEX c.contributor##c.corpsec               income i.work_type rural  single years_educ male age   govdebt foreigninvestment contribover15  if sample ==1,   r
est store g
xtreg SM_INDEX c.contributor##c.corpsec               income i.work_type rural  single years_educ male age  if sample ==1,   fe r
est store h
xtreg SM_INDEX  contributor  corpsec                   income i.work_type rural  single years_educ male age  if sample ==1,    r
est store i
drop sample
}

esttab * using "Table2.csv", replace cells(b(star fmt(%9.3f) label(coef.)) se( fmt(%9.2f)label(SE))) stats(r2 r2_o N) label legend posthead("") prefoot("") postfoot("")  varlabels(_cons Constant) starlevels(* 0.10 ** 0.05 *** 0.01 ) number ("" "") 



##table 3##

est clear
{
gen sample = 1 if country != "Panama"
xtreg SM_INDEX c.contributor##c.d_real_returns    income i.work_type rural  single years_educ male age  if sample ==1 ,  r
est store a
xtreg SM_INDEX c.contributor##c.d_real_returns    income i.work_type rural  single years_educ male age  unemp    deflator   gdppcgrowth lngdppc  if sample ==1 ,  r
est store b
xtreg SM_INDEX c.contributor##c.d_real_returns    income i.work_type rural  single years_educ male age  govdebt foreigninvestment contribover15   if sample ==1 ,  r
est store c
xtreg SM_INDEX c.contributor##c.d_real_returns    income i.work_type rural  single years_educ male age   if sample ==1  ,   fe  r
est store d
drop sample
}
esttab * using "Table3.csv", replace cells(b(star fmt(%9.3f) label(coef.)) se( fmt(%9.2f)label(SE))) stats(r2 N) label legend posthead("") prefoot("") postfoot("")  varlabels(_cons Constant) starlevels(* 0.10 ** 0.05 *** 0.01 ) number ("" "") 


##figure 1###


est restore c
qui{
cap drop MVZ conbx consx ax upperx lowerx
matrix b=e(b)
matrix V=e(V)
scalar beta1=b[1,1]
scalar beta3=b[1,3]
scalar varb1=V[1,1]
scalar varb3=V[3,3]
scalar covb1b3=V[1,3]
scalar list beta1 beta3 varb1 varb3 covb1b3
su  d_real_returns if e(sample), detail
generate MVZ=r(p5) + (_n-1)*((r(p95) - r(p1))/10)
replace  MVZ=. if _n>11
gen conbx=beta1 + beta3*MVZ if MVZ !=.
gen consx=sqrt(varb1+varb3*(MVZ^2)+2*covb1b3*MVZ) if MVZ!=.
gen ax=1.96*consx
gen upperx=conbx+ax
gen lowerx=conbx-ax
}
twoway (hist d_real_returns if e(sample), sort yaxis(2) yscale(alt axis(2))col(gs14))(line conbx   MVZ, clpattern(solid) clwidth(medium) clcolor(black)  yscale(alt axis(1)))(line upperx  MVZ, clpattern(dash) clwidth(thin) clcolor(black))(line lowerx  MVZ, clpattern(dash) clwidth(thin) clcolor(black)), title( Figure 1: Conditional Effect of Pension Participation on Attitude Towards Neoliberalism, size(medsmall)) ytitle("Conditional Effect" " ", col(black)) xtitle(Real Pension Returns)  yline(0)name(`DV', replace) scheme(s1mono) legend(off)

###Table 4 -- note: the columns created will be in alphabetical order, rather than by pension returns###

est clear
qui reg SM_INDEX c.contributor##c.d_real_returns   if country != "Panama"
levelsof(onenamecountry) if e(sample), local(levels)
foreach i of local levels{
reg SM_INDEX contributor  income i.work_type rural  single years_educ male age   if onenamecountry =="`i'"   
est store `i'
}
esttab * using "Table4.csv", replace cells(b(star fmt(%9.3f) label(coef.)) se( fmt(%9.2f)label(SE))) stats(r2 N) label legend posthead("") prefoot("") postfoot("")  varlabels(_cons Constant) starlevels(* 0.10 ** 0.05 *** 0.01 ) number ("" "") 




###Table 5###

{
est clear
gen sample = 1 if country != "Panama"  
xtreg SM_INDEX c.contributor##c.unemp           c.contributor##c.d_real_returns   income i.work_type rural  single years_educ male age   govdebt foreigninvestment contribover15    if sample ==1,r
est store a
xtreg SM_INDEX c.contributor##c.deflator        c.contributor##c.d_real_returns   income i.work_type rural  single years_educ male age   govdebt foreigninvestment contribover15    if sample ==1,r
est store b 
xtreg  SM_INDEX c.contributor##c.gdppcgrowth    c.contributor##c.d_real_returns   income i.work_type rural  single years_educ male age   govdebt foreigninvestment contribover15    if sample ==1,r
est store c  
xtreg SM_INDEX c.contributor##c.mandatory       c.contributor##c.d_real_returns   income i.work_type rural  single years_educ male age   govdebt foreigninvestment contribover15    if sample ==1,r
est store d
xtreg SM_INDEX c.contributor##c.twoyear_d                                         income i.work_type rural  single years_educ male age   govdebt foreigninvestment contribover15    if sample ==1,r
est store e
xtreg SM_INDEX c.contributor##c.threeyear_d                                       income i.work_type rural  single years_educ male age   govdebt foreigninvestment contribover15    if sample ==1,r
est store f
drop sample
}

esttab * using "Table5.csv", replace cells(b(star fmt(%9.3f) label(coef.)) se( fmt(%9.2f)label(SE))) stats(r2 N) label legend posthead("") prefoot("") postfoot("")  varlabels(_cons Constant) starlevels(* 0.10 ** 0.05 *** 0.01 ) number ("" "") 

##Table 6##


{
est clear
local DV  rs_pension rs_healthcare rs_wellbeing rs_ownindustry  rs_jobs  rs_inequality 
foreach DV in `DV'{
xtreg `DV' c.contributor##c.d_real_returns income i.work_type rural  single years_educ male age govdebt foreigninvestment contribover15   if country != "Panama", r
est store `DV'
cap drop MVZ conbx consx ax upperx lowerx
matrix b=e(b)
matrix V=e(V)
scalar beta1=b[1,1]
scalar beta3=b[1,3]
scalar varb1=V[1,1]
scalar varb3=V[3,3]
scalar covb1b3=V[1,3]
scalar list beta1 beta3 varb1 varb3 covb1b3
su  d_real_returns if e(sample), detail
generate MVZ=r(p5) + (_n-1)*((r(p95) - r(p1))/10)
replace  MVZ=. if _n>11
gen conbx=beta1 + beta3*MVZ if MVZ !=.
gen consx=sqrt(varb1+varb3*(MVZ^2)+2*covb1b3*MVZ) if MVZ!=.
gen ax=1.96*consx
gen upperx=conbx+ax
gen lowerx=conbx-ax
twoway (hist d_real_returns if e(sample), sort yaxis(2) yscale(alt axis(2))col(gs14))(line conbx   MVZ, clpattern(solid) clwidth(medium) clcolor(black)  yscale(alt axis(1)))(line upperx  MVZ, clpattern(dash) clwidth(thin) clcolor(black))(line lowerx  MVZ, clpattern(dash) clwidth(thin) clcolor(black)), title( `DV', size(medsmall)) ytitle("Conditional Effect" " ", col(black)) xtitle(Real Pension Returns)  yline(0)name(`DV', replace) scheme(s1mono) legend(off)
local graphnames `graphnames' `DV'
}
}
esttab * using "Table6.csv", replace cells(b(star fmt(%9.3f) label(coef.)) se( fmt(%9.2f)label(SE))) stats(r2 N) label legend posthead("") prefoot("") postfoot("")  varlabels(_cons Constant) starlevels(* 0.10 ** 0.05 *** 0.01 ) number ("" "") 
grc1leg `graphnames', title (Figure 2: Conditional Effect of Pension Participation on Attitude Towards Governments Role in..., size(med)) scheme(s1mono)


use "LB replication data.dta", clear 
tsset cowcode year

replace mkt_econ_best2 = mkt_econ_best2*-1
{
est clear
xtreg   mkt_econ_best2  c.contribover15   year if d_real_returns != .   ,  cl(cowcode)
est store a
xtreg  mkt_econ_best2   c.contribover15   gdppcgrowth  unemp  deflator lngdppc   year if d_real_returns != .  ,  cl(cowcode) 
est store b
xtreg  mkt_econ_best2   c.contribover15       foreign   govdebt mandatory year  if d_real_returns != .  ,  cl(cowcode)  
est store c
xtreg  mkt_econ_best2   c.contribover15      year  if d_real_returns != . ,  cl(cowcode)   fe
est store d

xtreg   mkt_econ_best2  c.contribover15##c.corpsec   year if d_real_returns != .   ,  cl(cowcode)
est store e
xtreg  mkt_econ_best2   c.contribover15##c.corpsec  gdppcgrowth  unemp  deflator lngdppc   year if d_real_returns != .  ,  cl(cowcode) 
est store f
xtreg  mkt_econ_best2   c.contribover15##c.corpsec      foreign   govdebt mandatory year  if d_real_returns != .  ,  cl(cowcode)  
est store g
xtreg  mkt_econ_best2   c.contribover15##c.corpsec      year  if d_real_returns != .  ,  cl(cowcode)   fe
est store h

xtreg   mkt_econ_best2   c.contribover15##c.d_real_returns   year   ,  cl(cowcode)
est store i
xtreg  mkt_econ_best2   c.contribover15##c.d_real_returns  gdppcgrowth  unemp  deflator lngdppc   year   ,  cl(cowcode) 
est store j
xtreg  mkt_econ_best2   c.contribover15##c.d_real_returns      foreign   govdebt mandatory year    ,  cl(cowcode)  
est store k
xtreg  mkt_econ_best2   c.contribover15##c.d_real_returns      year    ,  cl(cowcode)   fe
est store l
}
esttab * using "Table6.csv", replace cells(b(star fmt(%9.3f) label(coef.)) se( fmt(%9.2f)label(SE))) stats(r2 N) label legend posthead("") prefoot("") postfoot("")  varlabels(_cons Constant) starlevels(* 0.10 ** 0.05 *** 0.01 ) number ("" "") 


local DV  i j k l
foreach DV in `DV'{
est restore `DV'
qui {
cap drop MVZ conbx consx  upperx lowerx
matrix b=e(b)
matrix V=e(V)
scalar b1=b[1,1]
scalar b3=b[1,3]
scalar varb1=V[1,1]
scalar varb3=V[3,3]
scalar covb1b3=V[1,3]
scalar list b1 b3 varb1 varb3 covb1b3
su d_real_returns if e(sample), detail
generate MVZ=r(min) + (_n-1)*((r(max) - r(min))/10)
replace  MVZ=. if _n>12
gen conbx=b1+b3*MVZ if _n<12
gen consx=sqrt(varb1+varb3*(MVZ^2)+2*covb1b3*MVZ) if _n<12
gen upperx= conbx + invttail(e(df_m), .05)*consx
gen lowerx=conbx + invttail(e(df_m), .95)*consx
}
twoway (hist d_real_returns if e(sample), yaxis(2) col(gs14))(line conbx   MVZ, clpattern(solid) clwidth(medium) clcolor(black) yaxis(1))(line upperx  MVZ, clpattern(dash) clwidth(thin) clcolor(black))(line lowerx  MVZ, clpattern(dash) clwidth(thin) clcolor(black)), title(`DV', col(black)) ytitle( Marginal Effect) xtitle(% contributors)  yline(0)name(`DV', replace) scheme(s1mono)
}
local graphnames `graphnames' `DV'
grc1leg i j k l , title(Fig 3: Conditional Effects of Pension Particpation Rates on Belief That Markets are Best For Country, size(small)) subtitle(Model numbers refer to Table 7, size(small)) r(1) scheme(s1mono)

  

est clear
{
xtreg   mkt_econ_best2    c.contribover15##c.unemp c.contribover15##c.d_real_returns foreign   govdebt mandatory  year  ,  cl(cowcode)
est store e
xtreg  mkt_econ_best2    c.contribover15##c.deflator   c.contribover15##c.d_real_returns foreign   govdebt mandatory   year  ,  cl(cowcode) 
est store f
xtreg  mkt_econ_best2    c.contribover15##c.gdppcgrowth c.contribover15##c.d_real_returns   foreign   govdebt mandatory    year    ,  cl(cowcode)  
est store g
xtreg  mkt_econ_best2    c.contribover15##c.mandatory   c.contribover15##c.d_real_returns foreign   govdebt mandatory    year    ,  cl(cowcode)   
est store h
xtreg  mkt_econ_best2    c.contribover15##c.twoyear_d    foreign   govdebt mandatory    year    ,  cl(cowcode)   
est store i
xtreg  mkt_econ_best2    c.contribover15##c.threeyear_d   foreign   govdebt mandatory     year    ,  cl(cowcode)   
est store j
}

esttab * using "Table8.csv", replace cells(b(star fmt(%9.3f) label(coef.)) se( fmt(%9.2f)label(SE))) stats(r2 N) label legend posthead("") prefoot("") postfoot("")  varlabels(_cons Constant) starlevels(* 0.10 ** 0.05 *** 0.01 ) number ("" "")



