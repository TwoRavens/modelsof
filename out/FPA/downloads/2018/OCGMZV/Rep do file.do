***DO FILE:
* To sign or not to sign. Hegemony, Global Internet Governance, and the International Telecommunication Regulations 
* submitted to fpa 
clear
use "Replication data set.dta" 



**PREPARE DATA: LAGS - AVERAGES - LOGS
*Averaged and lagged log GDP per capita
sort COW year 
by COW: gen gdp_cma=(gdp_c[_n-1]+gdp_c[_n-2]+gdp_c[_n-3])/3
gen lngdp=ln(gdp_cma+1)

*Averaged and lagged trade 
by COW: gen expCHsharema=(expCHshare[_n-1]+expCHshare[_n-2]+expCHshare[_n-3])/3
by COW: gen tradeCHsharema=(tradeCHshare[_n-1]+tradeCHshare[_n-2]+tradeCHshare[_n-3])/3
by COW: gen expUSsharema=(expUSshare[_n-1]+expUSshare[_n-2]+expUSshare[_n-3])/3
by COW: gen tradeUSsharema=(tradeUSshare[_n-1]+tradeUSshare[_n-2]+tradeUSshare[_n-3])/3
label var expUSsharema "Exports to US, %"
label var expCHsharema "Exports to China, %"
label var tradeUSsharema "US trade, %"
label var tradeCHsharema "China trade, %"

*Averaged and lagged log population
by COW: gen popma=(population[_n-1]+population[_n-2]+population[_n-3])/3
gen lnpop=ln(popma+1)

*lagged autocracy dummy POLITY
sort COW year 
by COW: gen polity2lag1=polity2[_n-1] /*takes values from 2011*/
gen autodummy=1 if polity2lag1<=6 & polity2lag1!=. 
replace autodummy=0 if polity2lag1>6 & polity2lag1!=.


*FREEDOM HOuse: Free (1.0 to 2.5), Partly Free (3.0 to 5.0), or Not Free (5.5 to 7.0)
gen fh_mean=(fh_pr+fh_cl)/2
sort COW year 
by COW: gen fh_meanlag1=fh_mean[_n-1] /*takes values from 2011*/
gen fh_dummy=0 if fh_meanlag1<3 & fh_meanlag1!=. 
replace fh_dummy=1 if fh_meanlag1>2.5 & fh_meanlag1<=7
***

*Most recent usdefense 
sort COW year  
by COW: gen usdefense_2008=usdefense[_n-3] if year==2011 /*note that the dataset from which K&S are taking this var, is from 2003, but it seems to be updated*/
label var usdefense_2008 "US defense"

*ln aid
gen lnaid=ln(aidUS2011m+1)
keep if year==2011

*esttab logistic regression table
global F3 = "esttab , se star(+ .10 * .05 ** .01 *** .001) label scalars(ll chi2 df_m aic bic) nodepvars nomtitles compress"

**Label variables 
label var polity2lag1 "Polity"
label var lngdp "GDP/c (ln)"
label var fh_meanlag "Freedom house" 
label var troops "US troops"
label var internetusersper100people "Internet users"
label var lnpop "Population (ln)"
label var lnaid "US aid/c (ln)"
label var teleliberalization "Liberalization"
label var fh_meanlag1 "Freedom house"
label var g77 "G77"
label var autodummy "Autocracy"

***************************************************************************************************************************************
**ANALYSIS

*Likelihood ratio and fistat 
logit itr i.autodummy  lnpop i.usdefense_2008  c.lnaid c.internetusers   c.tradeUSsharema c.tradeCHsharema c.tradeCHsharema#i.autodummy c.tradeUSsharema#i.autodummy c.lnaid#i.autodummy 
fitstat, saving(m2) 
logit itr i.autodummy  lnpop i.usdefense_2008  c.lnaid c.lngdp c.internetusers   c.tradeUSsharema c.tradeCHsharema c.tradeCHsharema#i.autodummy c.tradeUSsharema#i.autodummy c.lnaid#i.autodummy 
fitstat,  using(m2) force
corr lngdp internetusers if e(sample)==1


*TABLE 1, MODEL 1
eststo clear
logit itr i.autodummy  lnpop i.usdefense_2008 c.tradeUSsharema  c.lnaid c.internetusersper100people c.tradeCHsharema
est store m1
gen sample=1 if e(sample)==1

*FIGURE 1
margins autodummy, at( internetusers= (1 (5) 90)) 
marginsplot, scheme(s1mono)  recastci(rarea) recast(line) ci1opts(fintensity(30))   xmtick(##2)

*SUMMARY STATISTICS Appendix B
sum itr autodummy  lnpop i.usdefense_2008 c.tradeUSsharema  c.lnaid aidUS2011 c.internetusersper100people c.tradeCHsharema expUSsharema expCHsharema fh_dum troops if e(sample)==1


*TABLE 1, MODEL 2
 logit itr teleliberalization i.autodummy  lnpop i.usdefense_2008 c.tradeUSsharema c.tradeCHsharema c.lnaid c.internetusersper100people 
est store lib

*GDP 
logit itr i.autodummy  lnpop i.usdefense_2008  c.lnaid c.lngdp   c.tradeUSsharema c.tradeCHsharema 
est store gdp
 
* TABLE 1, MODEL 3
 logit itr i.autodummy  lnpop i.usdefense_2008 c.tradeUSsharema c.tradeCHsharema c.lnaid c.internetusersper100people if eu==0
est sto eu

*TABLE 1, MODEL 4 
 logit itr g77 i.autodummy  lnpop i.usdefense_2008 c.tradeUSsharema c.tradeCHsharema  c.lnaid c.internetusersper100people  
 est store g77 

*TABLE 1, MODEL 5
 logit itr i.autodummy  lnpop i.usdefense_2008 c.tradeUSsharema c.tradeCHsharema c.lnaid#i.autodummy c.lnaid c.internetusersper100people c.tradeUSsharema#i.autodummy c.tradeCHsharema#i.autodummy
est store base

 *FIGURE 2 based on model 5
logit itr i.autodummy  lnpop i.usdefense_2008 c.tradeUSsharema c.tradeCHsharema c.lnaid#i.autodummy c.lnaid c.internetusersper100people c.tradeUSsharema#i.autodummy c.tradeCHsharema#i.autodummy
margins autodummy, at(lnaid = (-1.5 (0.5) 4))
marginsplot, scheme(s1mono)  recastci(rarea) recast(line) ci1opts(fintensity(30))   xmtick(##2)
*  summmary stat:    lnaid |        122    1.073092    1.266748  -1.791759   4.328318
 
 
*TABLE 1
outreg2 [m1 lib eu g77  base]  using tab2, word lab replace dec(3)  alpha(0.001, 0.01, 0.05) e(ll chi2 r2_p) nodepvar ///
  sortvar(autodummy internetusersper100people lnpop g77 usdefense_2008 lnaid tradeUSsharema tradeCHsharema   )
 
**ROBUSTNESS
*MODEL 1, TABLE 2
local baseline = "i.autodummy  lnpop i.troops c.tradeUSsharema  c.tradeCHsharema c.lnaid c.internetusersper100people  " 
 logit itr `baseline'   if sample==1
est store troops 

**ROBUSTNESS 
*MODEL 2, TABLE 2
local baseline = "i.autodummy  lnpop i.usdefense_2008   c.lnaid c.internetusersper100people" 
logit itr  c.tradeUSsharema c.tradeCHsharema c.tradeCHsharema#i.autodummy c.tradeUSsharema#i.autodummy c.lnaid#i.autodummy `baseline' if  country!="Kyrgyz Republic" & country!="Panama" & country!="Togo" 
est store out

*MODEL 3,TABLE 2
local baseline = "i.autodummy  lnpop i.usdefense_2008   c.lnaid c.internetusersper100people" 
logit itr  expUSsharema expCHsharema c.expCHsharema#i.autodummy c.expUSsharema#i.autodummy  c.lnaid#i.autodummy `baseline'   if sample==1
est store exp

*MODEL 4, TABLE 2
local baseline = "i.fh_dummy  lnpop i.usdefense_2008 c.tradeUSsharema  c.lnaid c.internetusersper100people c.tradeCHsharema" 
logit itr `baseline' c.lnaid#i.fh_dummy   if sample==1
est sto aid2 

*MODEL 5, TABLE 3
local baseline = "i.autodummy  lnpop i.usdefense_2008 c.tradeUSsharema  c.aidUS2011 c.internetusersper100people  c.tradeCHsharema" 
logit itr `baseline' c.aidUS2011#i.autodummy  
est store aid3
  
*TABLE 2
outreg2 [troops out exp aid2 aid3] using tab_robust, word lab replace dec(3)  alpha(0.001, 0.01, 0.05) e(ll chi2 r2_p) nodepvar ///
  sortvar(autodummy internetusersper100people  lnpop  usdefense_2008 lnaid tradeUSsharema tradeCHsharema  )



