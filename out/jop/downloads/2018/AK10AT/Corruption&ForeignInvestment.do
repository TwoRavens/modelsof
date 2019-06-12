********************************************************************************
*Replication File for "Greasing the Wheels of Commerce? Corruption and Foreign Investment"
********************************************************************************

*set working directory
use Corruption&ForeignInvestment.dta, clear

********************************************************************************
************************ Heckman Probit Model in Table 1 ***********************
********************************************************************************
heckprob MajOwn g1 g2 g3 if oinvest==1 , select(entry=g1 g2 g3 trade hc ) robust 

**simulate coefficients
matrix V_h=e(V)
matrix M_h=e(b)

set seed 12365
drawnorm x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11, n(1000) cov(V_h) means(M_h) clear
save sim_heck.dta,replace

********************************************************************************
*************************** Appendix *******************************************
use Corruption&ForeignInvestment.dta, clear
* Table A: Distributions of Firms in the 2014 CODIS
sum agriculture mining manufacturing wholesale otherservice
sum SOE COE foreign private
tab region

* Table B: Distribution of Manufacturing Firms in the 2014 CODIS
tab indcode2 if indcode2>=13&indcode2<=43

* Table C: Descriptive Statistics
sum oinvest SOE private foreign lemp logsales13 atfp primary manufacturing service

* Table D: Respondents' Positions
sum position1 position2 position3 position4
sum position1 position2 position3 position4 if oinvest==1

************* Table E: Attractiveness of Business Environments *****************
*** unweighted
* Model 1: full sample  
reg q146 g1 g2 g3  

* Model 2: Overseas Investors
reg q146 g1 g2 g3 if oinvest==1 

* Model 3: Domestic-Oriented Firms
reg q146 g1 g2 g3 if oinvest==0 

*** weighted
* model 4: full sample
reg q146 g1 g2 g3 [pw=weights]

* model 5: Overseas Investors
reg q146 g1 g2 g3 if oinvest==1 [pw=weights] 

* model 6: Domestic-Oriented Firms
reg q146 g1 g2 g3 if oinvest==0 [pw=weights]

*************** Table F: Firm Heterogeneity (Productivity) *********************
*** unweighted
* Model 1: sales>median
reg q146 g1 g2 g3 if oinvest==1&highsales==1

* Model 2: sales<=median
reg q146 g1 g2 g3 if oinvest==1&highsales==0

* Model 3: atfp>median
reg q146 g1 g2 g3 if oinvest==1&atfp2==1

* Model 4: atfp<=median
reg q146 g1 g2 g3 if oinvest==1&atfp2==0

*** weighted
* Model 5: sales>median
reg q146 g1 g2 g3 if oinvest==1&highsales==1 [pw=weights]

* Model 6: sales<=median
reg q146 g1 g2 g3 if oinvest==1&highsales==0 [pw=weights]

* Model 7: atfp<=median
reg q146 g1 g2 g3 if oinvest==1&atfp2==1 [pw=weights]

* Model 8: atfp<=median
reg q146 g1 g2 g3 if oinvest==1&atfp2==0 [pw=weights]


************ Table F: Firm Heterogeneity (Fixed Asset Intensity) ***************
*** Unweighted
* Model 1: Fixed Assets>median
reg q146 g1 g2 g3 if oinvest==1&capint==1

* Model 2: Fixed Assets<=median 
reg q146 g1 g2 g3 if oinvest==1&capint==0 

*** Weighted
* Model 3: Fixed Assets>median
reg q146 g1 g2 g3 if oinvest==1&capint==1 [pw=weights]

* Model 3: Fixed Assets<=median
reg q146 g1 g2 g3 if oinvest==1&capint==0 [pw=weights]

*************Table H: Market Entry and Majority Ownership (Heckman) ************
* Model 1: unweighted
heckman MajOwn g1 g2 g3 if oinvest==1, select(entry=g1 g2 g3 trade hc ) robust 

* Model 2: weighted
heckman MajOwn g1 g2 g3 if oinvest==1 [pw=weights], select(entry=g1 g2 g3 trade hc) robust 


**************************** Sample Balance Checks *****************************

global vars="logsales13 lemp atfp SOE private foreign primary manufacturing service" 

****** Table I: Full Sample
* Means: group 1
 local counter=1
foreach var in $vars {
 sum `var' if exprandom1==1
 matrix ttest1= ( r(mean), r(N))
 matrix ttest2= ( r(sd)/sqrt(r(N)))
 matrix rownames ttest1= `var'
 matrix rownames ttest2= SE
 matrix colnames ttest1= Mean N
 matrix colnames ttest2= SE
 if `counter'==1{
 mat2txt, matrix(ttest1) sav("summary1.xls") replace
 }
 else{
 mat2txt, matrix(ttest1) sav("summary1.xls") append
 }
 local counter=0
 mat2txt, matrix(ttest2) sav("summary1.xls") append
 }
 *

 * Means: group 2
 local counter=1
foreach var in $vars {
 sum `var' if exprandom1==2
 matrix ttest1= ( r(mean), r(N))
 matrix ttest2= ( r(sd)/sqrt(r(N)))
 matrix rownames ttest1= `var'
 matrix rownames ttest2= SE
 matrix colnames ttest1= Mean N
 matrix colnames ttest2= SE
 if `counter'==1{
 mat2txt, matrix(ttest1) sav("summary2.xls") replace
 }
 else{
 mat2txt, matrix(ttest1) sav("summary2.xls") append
 }
 local counter=0
 mat2txt, matrix(ttest2) sav("summary2.xls") append
 }
 *
 * Means: group 3
 local counter=1
foreach var in $vars {
 sum `var' if exprandom1==3
 matrix ttest1= ( r(mean), r(N))
 matrix ttest2= ( r(sd)/sqrt(r(N)))
 matrix rownames ttest1= `var'
 matrix rownames ttest2= SE
 matrix colnames ttest1= Mean N
 matrix colnames ttest2= SE
 if `counter'==1{
 mat2txt, matrix(ttest1) sav("summary3.xls") replace
 }
 else{
 mat2txt, matrix(ttest1) sav("summary3.xls") append
 }
 local counter=0
 mat2txt, matrix(ttest2) sav("summary3.xls") append
 }
 *
  * Means: group 4
 local counter=1
foreach var in $vars {
 sum `var' if exprandom1==4
 matrix ttest1= ( r(mean), r(N))
 matrix ttest2= ( r(sd)/sqrt(r(N)))
 matrix rownames ttest1= `var'
 matrix rownames ttest2= SE
 matrix colnames ttest1= Mean N
 matrix colnames ttest2= SE
 if `counter'==1{
 mat2txt, matrix(ttest1) sav("summary4.xls") replace
 }
 else{
 mat2txt, matrix(ttest1) sav("summary4.xls") append
 }
 local counter=0
 mat2txt, matrix(ttest2) sav("summary4.xls") append
 }
 *
* Sample Balance Check
local counter=1
foreach var in $vars {
 oneway `var' exprandom1
 matrix ttest= (r(N), r(F), Ftail(r(df_m), r(df_r), r(F)))
 matrix rownames ttest= `var'
 matrix colnames ttest= N Fstat pvalue
  if `counter'==1{
 mat2txt, matrix(ttest) sav("BalanceCheck.xls") replace
 }
 else{
 mat2txt, matrix(ttest) sav("BalanceCheck.xls") append
 }
 local counter=0
 }
 *

************************ Table J: Overseas Investors ***************************
 * Means: group 1
 
 local counter=1
foreach var in $vars {
 sum `var' if exprandom1==1&oinvest==1
 matrix ttest1= ( r(mean), r(N))
 matrix ttest2= ( r(sd)/sqrt(r(N)))
 matrix rownames ttest1= `var'
 matrix rownames ttest2= SE
 matrix colnames ttest1= Mean N
 matrix colnames ttest2= SE
 if `counter'==1{
 mat2txt, matrix(ttest1) sav("summary1a.xls") replace
 }
 else{
 mat2txt, matrix(ttest1) sav("summary1a.xls") append
 }
 local counter=0
 mat2txt, matrix(ttest2) sav("summary1a.xls") append
 }
 *

 * Means: group 2
 local counter=1
foreach var in $vars {
 sum `var' if exprandom1==2&oinvest==1
 matrix ttest1= ( r(mean), r(N))
 matrix ttest2= ( r(sd)/sqrt(r(N)))
 matrix rownames ttest1= `var'
 matrix rownames ttest2= SE
 matrix colnames ttest1= Mean N
 matrix colnames ttest2= SE
 if `counter'==1{
 mat2txt, matrix(ttest1) sav("summary2a.xls") replace
 }
 else{
 mat2txt, matrix(ttest1) sav("summary2a.xls") append
 }
 local counter=0
 mat2txt, matrix(ttest2) sav("summary2a.xls") append
 }
 *
 * Means: group 3
local counter=1
foreach var in $vars {
 sum `var' if exprandom1==3&oinvest==1
 matrix ttest1= ( r(mean), r(N))
 matrix ttest2= ( r(sd)/sqrt(r(N)))
 matrix rownames ttest1= `var'
 matrix rownames ttest2= SE
 matrix colnames ttest1= Mean N
 matrix colnames ttest2= SE
 if `counter'==1{
 mat2txt, matrix(ttest1) sav("summary3a.xls") replace
 }
 else{
 mat2txt, matrix(ttest1) sav("summary3a.xls") append
 }
 local counter=0
 mat2txt, matrix(ttest2) sav("summary3a.xls") append
 }
 *
  * Means: group 4
local counter=1
foreach var in $vars {
 sum `var' if exprandom1==4&oinvest==1
 matrix ttest1= ( r(mean), r(N))
 matrix ttest2= ( r(sd)/sqrt(r(N)))
 matrix rownames ttest1= `var'
 matrix rownames ttest2= SE
 matrix colnames ttest1= Mean N
 matrix colnames ttest2= SE
 if `counter'==1{
 mat2txt, matrix(ttest1) sav("summary4a.xls") replace
 }
 else{
 mat2txt, matrix(ttest1) sav("summary4a.xls") append
 }
 local counter=0
 mat2txt, matrix(ttest2) sav("summary4a.xls") append
 }
 *
* Sample Balance Check
local counter=1
foreach var in $vars {
 oneway `var' exprandom1 if oinvest==1
 matrix ttest= (r(N), r(F), Ftail(r(df_m), r(df_r), r(F)))
 matrix rownames ttest= `var'
 matrix colnames ttest= N Fstat pvalue
  if `counter'==1{
 mat2txt, matrix(ttest) sav("BalanceCheck2.xls") replace
 }
 else{
 mat2txt, matrix(ttest) sav("BalanceCheck2.xls") append
 }
 local counter=0
 }
 *


