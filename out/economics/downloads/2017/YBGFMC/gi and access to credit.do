*************************************************************************************
*                                                                                   *
*                  government intervention and access to credit                     *
*                                    Tong Fu                                        *
*                                JXUFE/20-10-2017                                   *
*************************************************************************************
set mem 200m
set matsize 4000
set more off
destring  h31   j1   industry  j622   i1 i3,replace force
destring a1,gen(firmyear)                
gen lnage=ln(2004-firmyear)              
gen ceo_edu=8-i1                         
gen ceo_gov=(i3==1)                         
gen lnceo_tenure=ln(i2)                  
replace lnceo_tenure=. if i2==999
gen export=(a24>0 & a24 !=.)             
gen state_share=aa11/100                 
gen foreign_share=aa15/100               
gen private_share=aa14/100               
gen lnlabor2003=ln(ac21)                 //firm size, measured by the labor in 2003
gen gips=log(1+j622)                         // gen the iv variable for gi with public security
gen gi=j1                                 //governmental internvetion  
gen formalloan=h31
replace formalloan=0 if h31>1 & h31<.     //converting
gen collateral=h323/100
tab city, gen(chengshi)
tab industry, gen(changye)
encode(city), gen(cityv)
encode county, gen(countyv)

*/tables 1-2*/
sum  formalloan  collateral gi lnage lnlabor2003 export state_share foreign_share ceo_gov ceo_edu  lnceo_tenure  
corre  formalloan collateral gi lnage lnlabor2003 export state_share foreign_share ceo_gov ceo_edu  lnceo_tenure 
global xlist0 lnlabor2003 export state_share foreign_share ceo_gov ceo_edu lnage  lnceo_tenure 

*/table 3*/
mean(gi), over(cityv)
mean(formalloan), over(cityv)
mean(collateral), over(cityv)

*/-----Table 4: Basic results----------*/

quietly probit formalloan gi  $xlist0 i.industry i.cityv, vce(robust)
outreg using collumn1, varlabels replace starlevels(15 10 5 1) sigsymbols(+ * ** ***)  keep(gi lnage lnlabor2003 export state_share foreign_share ceo_gov ceo_edu  lnceo_tenure _cons)stats(b se)starloc(1) 
margins, dydx(gi) at(gi=0.0391506)  //obtain the me_a and S_ta in Equations 6-8 when formaloan is the mediation with robust standard errors
quietly probit formalloan gi  $xlist0 i.industry i.cityv, vce(cluster countyv)
outreg using columns12, varlabels replace starlevels(15 10 5 1) sigsymbols(+ * ** ***)  keep(gi lnage lnlabor2003 export state_share foreign_share ceo_gov ceo_edu  lnceo_tenure _cons)stats(b se)starloc(1) merge
margins, dydx(gi) at(gi=0.0391506)  //obtain the me_a and S_ta in Equations 6-8 when formaloan is the mediation with clustered standard errors

quietly tobit collateral gi  $xlist0 i.industry i.cityv, ll(0) vce(robust)
outreg using column3, varlabels replace starlevels(15 10 5 1) sigsymbols(+ * ** ***)  keep(gi lnage lnlabor2003 export state_share foreign_share ceo_gov ceo_edu  lnceo_tenure _cons)stats(b se)starloc(1) 
margins, dydx(gi) at(gi=0.0391506)  //obtain the me_a and S_ta in Equations 6-8 when collateral is the mediation with robust standard errors
quietly tobit collateral gi $xlist0 i.industry i.cityv, ll(0) vce(cluster countyv)
outreg using columns34, varlabels replace starlevels(15 10 5 1) sigsymbols(+ * ** ***)  keep(gi lnage lnlabor2003 export state_share foreign_share ceo_gov ceo_edu  lnceo_tenure _cons)stats(b se)starloc(1) merge
margins, dydx(gi) at(gi=0.0391506)  //obtain the me_a and S_ta in Equations 6-8 when collateral is the mediation with clustered standard errors

*/ iv estimations*/
*/Table 5*/
quietly ologit gi gips  $xlist0 i.industry i.cityv, vce(robust)
outreg using column1, varlabels replace starlevels(15 10 5 1) sigsymbols(+ * ** ***)  keep(gips lnage lnlabor2003 export state_share foreign_share ceo_gov ceo_edu  lnceo_tenure _cons)stats(b se)starloc(1) 
quietly ologit gi gips  $xlist0 i.industry i.cityv, vce(cluster countyv)
outreg using columns12, varlabels replace starlevels(15 10 5 1) sigsymbols(+ * ** ***)  keep(gips lnage lnlabor2003 export state_share foreign_share ceo_gov ceo_edu  lnceo_tenure _cons)stats(b se)starloc(1) merge

quietly probit formalloan gips $xlist0 i.cityv i.industry, vce(robust)
outreg using column3, varlabels replace starlevels(15 10 5 1) sigsymbols(+ * ** ***)  keep(gips lnage lnlabor2003 export state_share foreign_share ceo_gov ceo_edu  lnceo_tenure _cons)stats(b se)starloc(1) 
quietly probit formalloan gips $xlist0 i.cityv i.industry, vce(cluster countyv)
outreg using columns34, varlabels replace starlevels(15 10 5 1) sigsymbols(+ * ** ***)  keep(gips lnage lnlabor2003 export state_share foreign_share ceo_gov ceo_edu  lnceo_tenure _cons)stats(b se)starloc(1) merge
quietly tobit collateral gips $xlist0 i.cityv i.industry , ll(0)  vce(robust)
outreg using column5, varlabels replace starlevels(15 10 5 1) sigsymbols(+ * ** ***)  keep(gips lnage lnlabor2003 export state_share foreign_share ceo_gov ceo_edu  lnceo_tenure _cons)stats(b se)starloc(1) 
quietly tobit collateral gips $xlist0 i.cityv i.industry  , ll(0)  vce(cluster countyv)
outreg using columns56, varlabels replace starlevels(15 10 5 1) sigsymbols(+ * ** ***)  keep(gips lnage lnlabor2003 export state_share foreign_share ceo_gov ceo_edu  lnceo_tenure _cons)stats(b se)starloc(1) merge

*/Table 6*/
quietly ivprobit  formalloan (gi=gips)  $xlist0 i.industry i.cityv, vce(robust)
outreg using column1, varlabels replace starlevels(15 10 5 1) sigsymbols(+ * ** ***)  keep(gi lnage lnlabor2003 export state_share foreign_share ceo_gov ceo_edu  lnceo_tenure _cons)stats(b se)starloc(1) 
quietly ivprobit  formalloan (gi=gips)  $xlist0 i.industry i.cityv, vce(cluster countyv)
outreg using columns12, varlabels replace starlevels(15 10 5 1) sigsymbols(+ * ** ***)  keep(gi lnage lnlabor2003 export state_share foreign_share ceo_gov ceo_edu  lnceo_tenure _cons)stats(b se)starloc(1) merge

quietly ivtobit collateral (gi=gips) $xlist0 i.cityv i.industry , ll(0)  vce(robust)
outreg using column3, varlabels replace starlevels(15 10 5 1) sigsymbols(+ * ** ***)  keep(gi lnage lnlabor2003 export state_share foreign_share ceo_gov ceo_edu  lnceo_tenure _cons)stats(b se)starloc(1) 
quietly ivtobit collateral (gi=gips) $xlist0 i.cityv i.industry  , ll(0)  vce(cluster countyv)
outreg using columns34, varlabels replace starlevels(15 10 5 1) sigsymbols(+ * ** ***)  keep(gi lnage lnlabor2003 export state_share foreign_share ceo_gov ceo_edu  lnceo_tenure _cons)stats(b se)starloc(1) merge


*/ Table 7*/

gen profit=ab1114/ac11
sort city industry
by city industry: egen aprofit=mean(profit)
by city industry: egen mprofit=median(profit)
sort idstd
gen profitdummya1=profit>=aprofit
gen profitdummya2=profit>aprofit
gen profitdummym1=profit>=mprofit
gen profitdummym2=profit>mprofit

quietly ivprobit profitdummym1 (gi=gips)  $xlist0 changye* chengshi* , vce(robust)
outreg using column1, varlabels replace starlevels(15 10 5 1) sigsymbols(+ * ** ***)  keep(gi lnage lnlabor2003 export state_share foreign_share ceo_gov ceo_edu  lnceo_tenure _cons)stats(b se)starloc(1) 
quietly ivprobit profitdummym1 (gi=gips)  $xlist0 changye* chengshi* , vce(cluster countyv)
outreg using columns12, varlabels replace starlevels(15 10 5 1) sigsymbols(+ * ** ***)  keep(gi lnage lnlabor2003 export state_share foreign_share ceo_gov ceo_edu  lnceo_tenure _cons)stats(b se)starloc(1) merge
quietly ivprobit profitdummym2 (gi=gips)  $xlist0 changye* chengshi* , vce(robust)
outreg using column3, varlabels replace starlevels(15 10 5 1) sigsymbols(+ * ** ***)  keep(gi lnage lnlabor2003 export state_share foreign_share ceo_gov ceo_edu  lnceo_tenure _cons)stats(b se)starloc(1) merge
quietly ivprobit profitdummym2 (gi=gips)  $xlist0 changye* chengshi* , vce(cluster countyv)
outreg using columns34, varlabels replace starlevels(15 10 5 1) sigsymbols(+ * ** ***)  keep(gi lnage lnlabor2003 export state_share foreign_share ceo_gov ceo_edu  lnceo_tenure _cons)stats(b se)starloc(1) merge

*/ Table 8*/
quietly probit profitdummym1 formalloan gi  $xlist0 changye* chengshi* , vce(robust)
outreg using column1, varlabels replace starlevels(15 10 5 1) sigsymbols(+ * ** ***)  keep(formalloan gi lnage lnlabor2003 export state_share foreign_share ceo_gov ceo_edu  lnceo_tenure _cons)stats(b se)starloc(1) 
margins, dydx(formalloan) at(formalloan=0.5996365)  //obtain the me_delta and S_delta in Equations 6-8 when formalloan is used as the mediation for profitdummym1 with robust standard errors
quietly probit profitdummym1 formalloan gi  $xlist0 changye* chengshi* , vce(cluster countyv)
outreg using columns12, varlabels replace starlevels(15 10 5 1) sigsymbols(+ * ** ***)  keep(formalloan gi lnage lnlabor2003 export state_share foreign_share ceo_gov ceo_edu  lnceo_tenure _cons)stats(b se)starloc(1) merge
margins, dydx(formalloan) at(formalloan=0.5996365)   // obtain the me_delta and S_delta in Equations 6-8 when formalloan is used as the mediation for profitdummym1 with clustered standard errors
quietly probit profitdummym2 formalloan gi  $xlist0 changye* chengshi* , vce(robust)
outreg using column5, varlabels replace starlevels(15 10 5 1) sigsymbols(+ * ** ***)  keep(formalloan gi lnage lnlabor2003 export state_share foreign_share ceo_gov ceo_edu  lnceo_tenure _cons)stats(b se)starloc(1) merge
margins, dydx(formalloan) at(formalloan=0.5996365)  //obtain the me_delta and S_delta in Equations 6-8 when formalloan is used as the mediation for profitdummym2 with robust standard errors
quietly probit profitdummym2 formalloan gi  $xlist0 changye* chengshi* , vce(cluster countyv)
outreg using columns56, varlabels replace starlevels(15 10 5 1) sigsymbols(+ * ** ***)  keep(formalloan gi lnage lnlabor2003 export state_share foreign_share ceo_gov ceo_edu  lnceo_tenure _cons)stats(b se)starloc(1) merge
margins, dydx(formalloan) at(formalloan=0.5996365)   // obtain the me_delta and S_delta in Equations 6-8 when formalloan is used as the mediation for profitdummym2 with clustered standard errors

quietly probit profitdummym1 collateral gi  $xlist0 changye* chengshi* , vce(robust)
outreg using column3, varlabels replace starlevels(15 10 5 1) sigsymbols(+ * ** ***)  keep(collateral gi lnage lnlabor2003 export state_share foreign_share ceo_gov ceo_edu  lnceo_tenure _cons)stats(b se)starloc(1) 
margins, dydx(collateral) at(collateral=5.493917) //obtain the me_delta and S_delta in Equations 6-8 when collateral is used as the mediation for profitdummym1 with robust standard errors
quietly probit profitdummym1 collateral gi  $xlist0 changye* chengshi* , vce(cluster countyv)
outreg using columns34, varlabels replace starlevels(15 10 5 1) sigsymbols(+ * ** ***)  keep(collateral gi lnage lnlabor2003 export state_share foreign_share ceo_gov ceo_edu  lnceo_tenure _cons)stats(b se)starloc(1) merge
margins, dydx(collateral) at(collateral=5.493917)  //obtain the me_delta and S_delta in Equations 6-8 when collateral is used as the mediation for profitdummym1 with clustered standard errors
quietly probit profitdummym2 collateral gi  $xlist0 changye* chengshi* , vce(robust)
outreg using column7, varlabels replace starlevels(15 10 5 1) sigsymbols(+ * ** ***)  keep(collateral gi lnage lnlabor2003 export state_share foreign_share ceo_gov ceo_edu  lnceo_tenure _cons)stats(b se)starloc(1) merge
margins, dydx(collateral) at(collateral=5.493917)  //obtain the me_delta and S_delta in Equations 6-8 when collateral is used as the mediation for profitdummym2 with robust standard errors
quietly probit profitdummym2 collateral gi  $xlist0 changye* chengshi* , vce(cluster countyv)
outreg using columns78, varlabels replace starlevels(15 10 5 1) sigsymbols(+ * ** ***)  keep(collateral gi lnage lnlabor2003 export state_share foreign_share ceo_gov ceo_edu  lnceo_tenure _cons)stats(b se)starloc(1) merge
margins, dydx(collateral) at(collateral=5.493917)  //obtain the me_delta and S_delta in Equations 6-8 when collateral is used as the mediation for profitdummym2 with clustered standard errors

*/provided if required*/

quietly ivprobit profitdummym1 formalloan (gi=gips)  $xlist0 changye* chengshi* , vce(robust)
outreg using interv9, varlabels replace starlevels(15 10 5 1) sigsymbols(+ * ** ***)  keep(formalloan gi lnage lnlabor2003 export state_share foreign_share ceo_gov ceo_edu  lnceo_tenure _cons)stats(b se)starloc(1) 
quietly ivprobit profitdummym1 formalloan (gi=gips)  $xlist0 changye* chengshi* , vce(cluster countyv)
outreg using interv9, varlabels replace starlevels(15 10 5 1) sigsymbols(+ * ** ***)  keep(formalloan gi lnage lnlabor2003 export state_share foreign_share ceo_gov ceo_edu  lnceo_tenure _cons)stats(b se)starloc(1) merge
quietly ivprobit profitdummym2 formalloan (gi=gips)  $xlist0 changye* chengshi* , vce(robust)
outreg using interv9, varlabels replace starlevels(15 10 5 1) sigsymbols(+ * ** ***)  keep(formalloan gi lnage lnlabor2003 export state_share foreign_share ceo_gov ceo_edu  lnceo_tenure _cons)stats(b se)starloc(1) merge
quietly ivprobit profitdummym2 formalloan (gi=gips)  $xlist0 changye* chengshi* , vce(cluster countyv)
outreg using interv9, varlabels replace starlevels(15 10 5 1) sigsymbols(+ * ** ***)  keep(formalloan gi lnage lnlabor2003 export state_share foreign_share ceo_gov ceo_edu  lnceo_tenure _cons)stats(b se)starloc(1) merge

quietly ivprobit profitdummym1 collateral (gi=gips)  $xlist0 changye* chengshi* , vce(robust)
outreg using interv9, varlabels replace starlevels(15 10 5 1) sigsymbols(+ * ** ***)  keep(formalloan gi lnage lnlabor2003 export state_share foreign_share ceo_gov ceo_edu  lnceo_tenure _cons)stats(b se)starloc(1) 
quietly ivprobit profitdummym1 collateral (gi=gips)  $xlist0 changye* chengshi* , vce(cluster countyv)
outreg using interv9, varlabels replace starlevels(15 10 5 1) sigsymbols(+ * ** ***)  keep(formalloan gi lnage lnlabor2003 export state_share foreign_share ceo_gov ceo_edu  lnceo_tenure _cons)stats(b se)starloc(1) merge
quietly ivprobit profitdummym2 collateral (gi=gips)  $xlist0 changye* chengshi* , vce(robust)
outreg using interv9, varlabels replace starlevels(15 10 5 1) sigsymbols(+ * ** ***)  keep(formalloan gi lnage lnlabor2003 export state_share foreign_share ceo_gov ceo_edu  lnceo_tenure _cons)stats(b se)starloc(1) merge
quietly ivprobit profitdummym2 collateral (gi=gips)  $xlist0 changye* chengshi* , vce(cluster countyv)
outreg using interv9, varlabels replace starlevels(15 10 5 1) sigsymbols(+ * ** ***)  keep(formalloan gi lnage lnlabor2003 export state_share foreign_share ceo_gov ceo_edu  lnceo_tenure _cons)stats(b se)starloc(1) merge


*/for Table 9*/
*/see the estimates of marginal effects and the corresponding standard deviation obtained in Tables 4 and 8, which I remarked above. Those values should be used to calcuate z-test results in Table 9 according to Equations 6-8/  



