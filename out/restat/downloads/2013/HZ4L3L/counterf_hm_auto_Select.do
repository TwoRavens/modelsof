version 9.2

clear
set mem 1000m
set matsize 11000
set maxvar 10000
set more off

scalar theta=1             /* IHS parameter */

* Path
* global foldp "C:/work/Integration/"
do "c:/foldp/foldp.do"
global foldp "${foldp}/Wealth Counterfactuals/Verification/"
global foldp1 ${foldp}


foreach cntr of numlist 1(1)12 {


*use "${foldp}Data/HRS_final_DG.dta", clear
*append using "${foldp}Data/SHARE_final_DG.dta"
*append using "${foldp}Data/ELSA_final_DG.dta"
use "${foldp1}Data/HRS/HRS_DG.dta", clear
append using "${foldp1}Data/SHARE/SHARE_DG.dta"
append using "${foldp1}Data/ELSA/ELSA_DG.dta"

keep if head==1

keep if country==0 | country==`cntr'

ge byte ind = (country==`cntr')


*** Regressors *** 

*Age squared
qui gen long agesq=age^2

*Age group
qui recode age (min/59=1) (60/69=2) (70/79=3) (80/max=4),g(agegroup)
qui ta agegroup,g(dage)

*Female dummy
qui gen byte fem=(gender==2) if gender~=.

*Education dummies
qui gen byte nohigh=(edu==1) if edu~=.
qui gen byte highs=(edu==2) if edu~=.
qui gen byte college=(edu==3) if edu~=.

*Health status
qui gen byte badhs=(srhealtha==4 | srhealtha==5) if srhealtha~=.

*Marital Status
qui gen byte couple=(mstat==1) if mstat~=.
qui gen byte divorced=(mstat==2) if mstat~=.
qui gen byte widow=(mstat==3) if mstat~=.
qui gen byte nevmar=(mstat==4) if mstat~=.

*Number of rooms (range)
*qui ta ordhrooms,g(dnroom)


*Both spouses retired

*Non working and retirement dummy (combined)
qui gen byte dnw=(retire==1 | nonwork==1)
qui egen byte sdnw=sum(dnw),by(implicat hhid)
*Actual hhd size in the sample
qui gen byte d1=1
qui egen byte sd1=sum(d1),by(implicat hhid)
*Dummy for households where the single head or the head and the spouse are not employed
qui gen byte dnonempl=(sdnw==sd1)
drop d1 sd1


*Wealth regressors. 

*Wealth covariate for the regression of risky financial assets. Equal to net worth minus risky financial assets
qui gen double inrw=hnetwv-hrfinv
*IHS of wealth
qui replace inrw=log(theta*(inrw)+sqrt((theta*(inrw))^2+1))/theta


*Wealth covariate for the regression of risky real assets. Equal to net worth minus risky real assets
qui gen double ibow=hnetwv-horlav
*IHS of wealth
qui replace ibow=log(theta*(ibow)+sqrt((theta*(ibow))^2+1))/theta

*Wealth covariate for the regression of own business. Equal to net worth minus own business
qui gen double ienw=hnetwv-hownbv
*IHS of wealth
qui replace ienw=log(theta*(ienw)+sqrt((theta*(ienw))^2+1))/theta

*Wealth covariate for the regression of other real estate. Equal to net worth minus other real estate
qui gen double istw=hnetwv-horesv
*IHS of wealth 
qui replace istw=log(theta*(istw)+sqrt((theta*(istw))^2+1))/theta

*Wealth covariate for the regression of home. Equal to net worth minus home value
qui gen double imhw=hnetwv-(hhomev-hmortv)
*IHS of wealth
qui replace imhw=log(theta*(imhw)+sqrt((theta*(imhw))^2+1))/theta

*Income. Equal to total minus capital
*ATTENTION. Look at disaggregation of capital income
qui gen double iinc=hgtincv-hcpincv
*IHS of non-capital income
qui replace iinc=log(theta*(iinc)+sqrt((theta*(iinc))^2+1))/theta


*IHS of total income
qui gen double igtinc=log(theta*(hgtinc)+sqrt((theta*(hgtinc))^2+1))/theta


*IHS of dependent variables.

*IHS of gross total wealth
qui gen double itgw=log(theta*hgtwv+sqrt((theta*hgtwv)^2+1))/theta

*IHS of net total wealth
qui gen double itnw=log(theta*hnetwv+sqrt((theta*hnetwv)^2+1))/theta

* IHS of risky financial assets *
qui gen double irf=log(theta*hrfinv+sqrt((theta*hrfinv)^2+1))/theta

*IHS of risky real assets
qui gen double irr=log(theta*horlav+sqrt((theta*horlav)^2+1))/theta

*IHS of own business
qui gen double ibus=log(theta*hownbv+sqrt((theta*hownbv)^2+1))/theta

*IHS of other real estate
qui gen double iest=log(theta*horesv+sqrt((theta*horesv)^2+1))/theta

*IHS of the value of the home equity
qui gen double ihm=log(theta*hhomev+sqrt((theta*hhomev)^2+1))/theta



*exit

drop if wgtach==0

*************

su imhw [aw=wgtach] if ind==0, d

scalar pw25 = r(p25)
scalar pw50 = r(p50)
scalar pw75 = r(p75)

ge byte qw2_0 = (pw25<imhw & imhw<=pw50) 
ge byte qw3_0 = (pw50<imhw & imhw<=pw75) 
ge byte qw4_0 = (pw75<imhw) if imhw!=. 


*************

su iinc [aw=wgtach] if ind==0, d

scalar pi25 = r(p25)
scalar pi50 = r(p50)
scalar pi75 = r(p75)

ge byte qi2_0 = (pi25<iinc & iinc<=pi50) 
ge byte qi3_0 = (pi50<iinc & iinc<=pi75) 
ge byte qi4_0 = (pi75<iinc) if iinc!=. 

**************  **************  **************

su imhw [aw=wgtach] if ind==1, d

scalar pw25 = r(p25)
scalar pw50 = r(p50)
scalar pw75 = r(p75)

ge byte qw2_1 = (pw25<imhw & imhw<=pw50) if ind==1
ge byte qw3_1 = (pw50<imhw & imhw<=pw75)  if ind==1
ge byte qw4_1 = (pw75<imhw) if imhw!=. & ind==1


*************

su iinc [aw=wgtach] if ind==1, d

scalar pi25 = r(p25)
scalar pi50 = r(p50)
scalar pi75 = r(p75)

ge byte qi2_1 = (pi25<iinc & iinc<=pi50) if ind==1
ge byte qi3_1 = (pi50<iinc & iinc<=pi75) if ind==1
ge byte qi4_1 = (pi75<iinc) if iinc!=. & ind==1

**********************************************************************

ge double loghm = log(hhomev)

/*
preserve

keep if hhomeo==1



*exit

noisily ta ind
noisily ta country


**** Commands / Graphs ****

* Specify titles for the graphs
global depvar loghm
global indepvars age agesq hsize highs college recall badhs retire working couple widow nevmar beqex00 provhelp voluntary adlno  qi2_0 qi3_0 qi4_0 qw2_0 qw3_0 qw4_0
global ytitl Difference in log Housing Wealth


 *** A. NO Orig option is specified ***

* A1. Without SE

* Commands

noisily mmdeco ${depvar} ${indepvars}, p(20)  w(wgtach)  by(ind)

keep if p!=.
 
sort p

matrix  Q_`cntr'= diff[25] , cvef[25], ref[25], . \ diff[50] , cvef[50], ref[50], . \ diff[75] , cvef[75], ref[75], . 

restore
*/

*************************************************************************************************************************************************************
*************************************************************************************************************************************************************
 
 **** Mean Decompositions Oaxaca and Heckman ****

*Two step (specify:two) or ML model (leave blank)
global twostp = "two"

*Dependent variable for Selection Probit
global ysel "hhomeo"
*Dependent variable for Second Stage Probit
global ytwo "loghm"

replace qi2_0 = qi2_1 if ind==1
replace qi3_0 = qi3_1 if ind==1
replace qi4_0 = qi4_1 if ind==1

replace qw2_0 = qw2_1 if ind==1
replace qw3_0 = qw3_1 if ind==1
replace qw4_0 = qw4_1 if ind==1


*Covariate list for Selection Probit 
global regvarsel age agesq hsize highs college recall badhs retire working couple ///
widow nevmar beqex00 provhelp voluntary adlno qi2_0 qi3_0 qi4_0 qw2_0 qw3_0 qw4_0

*Covariate list for Second-stage eqn 
global regvartwo age agesq hsize highs college recall badhs retire working couple ///
widow nevmar beqex00 provhelp voluntary adlno qi2_0 qi3_0 qi4_0 qw2_0 qw3_0 qw4_0



*Define variable that contains weights
global wgt = wgtach


* need to define variable ind (0/1) which distinguishes the 2 groups that are compared; then the counterfactual
* combines b's from group 0 and X's from group 1. All the variable names with "A" / "B" are generated from 
* groups 0 and 1, respectively.

***************************************************************************************
* Oaxaca - OLS
regress ${ytwo} ${regvartwo} if ${ysel}==1 & ind==0

matrix coefA_ox = (e(b))'


regress ${ytwo} ${regvartwo} if ${ysel}==1 & ind==1

matrix coefB_ox = (e(b))'


preserve

collapse ${ytwo} ${regvartwo} [aw=${wgt}] if ${ysel}==1 & ind==0
ge cons=1
matrix YA = ${ytwo}[1]
mkmat ${regvartwo} cons, matrix (XA)

restore

preserve

collapse ${ytwo} ${regvartwo} [aw=${wgt}] if ${ysel}==1 & ind==1
ge cons=1
matrix YB = ${ytwo}[1]
mkmat ${regvartwo} cons, matrix (XB)

restore

matrix Diff = YA-YB

matrix Covar = (XA*coefA_ox) - (XB*coefA_ox)
matrix Coeff = (XB*coefA_ox) - (XB*coefB_ox)


***************************************************************************************
*Heckman - ML

heckman ${ytwo} ${regvartwo} if ind==0, select(${ysel} = ${regvarsel}) m(millsA)  ${twostp}

matrix hcoefA = e(b)
matselrc hcoefA coefA_hk, c("${ytwo}:")
matrix coefA_hk = coefA_hk'
scalar lambda_A = e(lambda)
scalar selambda_A = e(selambda)

matselrc hcoefA coefprobA, c("${ysel}:")
matrix coefprobA = coefprobA'


heckman ${ytwo} ${regvartwo} if ind==1, select(${ysel} = ${regvarsel}) m(millsB)  ${twostp}

matrix hcoefB = e(b)
matselrc hcoefB coefB_hk, c("${ytwo}:")
matrix coefB_hk = coefB_hk'
scalar lambda_B = e(lambda)
scalar selambda_B = e(selambda)

ge cons=1
mkmat ${regvartwo} cons if ind==1, matrix (B)
matrix BpA = B * coefprobA

preserve
collapse millsA [aw=${wgt}] if  ind==0 & ${ysel}==1
scalar mA = millsA[1]
restore


preserve
keep if  ind==1

svmat BpA
ge double mills_AB = normden(BpA1)/norm(BpA1) 

collapse millsB mills_AB [aw=${wgt}] if  ind==1 & ${ysel}==1
scalar mB = millsB[1]
scalar mAB = mills_AB[1]
restore


*******************************************************************************
**** Heck 1 (based on Eqn. 8)

matrix Diff = Diff\YA-YB

matrix Covar = Covar\(XA*coefA_hk) - (XB*coefA_hk)
matrix Coeff = Coeff\(XB*coefA_hk) - (XB*coefB_hk)

matrix dL = .
matrix dL = dL\lambda_A*mA - lambda_B*mB

*******************************************************************************
**** Heck 2 (based on Eqn. 10)

matrix Diff = Diff\YA-YB

matrix Covar = Covar\(XA*coefA_hk) - (XB*coefA_hk) + lambda_A*(mA-mAB) + (lambda_A - lambda_B)*mB
matrix Coeff = Coeff\(XB*coefA_hk) - (XB*coefB_hk) + lambda_A*(mAB-mB)

matrix dL = dL\ .

*******************************************************************************
**** Heck 3 (based on Eqn. 11)

matrix Diff = Diff\YA-YB

matrix Covar = Covar\(XA*coefA_hk) - (XB*coefA_hk) + lambda_A*(mA-mAB) 
matrix Coeff = Coeff\(XB*coefA_hk) - (XB*coefB_hk) + lambda_A*(mAB-mB) + (lambda_A - lambda_B)*mB


matrix dL = dL\ .

*******************************************************************************
**** Heck 3 (based on Eqn. 12)

matrix Diff = Diff\YA-YB

matrix Covar = Covar\(XA*coefA_hk) - (XB*coefA_hk) + lambda_A*(mA-mAB)
matrix Coeff = Coeff\(XB*coefA_hk) - (XB*coefB_hk) + lambda_A*(mAB-mB)

matrix dL = dL\ (lambda_A - lambda_B)*mB

*******************************************************************************
**Collect Results:

matrix Tot_`cntr' = Diff, Covar, Coeff, dL \.,.,.,.\lambda_A, selambda_A, lambda_B, selambda_B 

matrix rown Tot_`cntr' = Oaxaca Heck1 Heck2 Heck3 Heck4 Lambda lA(se)lB(se)
matrix coln Tot_`cntr' = Diff(0-`cntr') Covar Coeff dlambda 

noisily matrix list Tot_`cntr'

global cn = `cntr'

mat2txt, matrix(Tot_${cn}) saving("${foldp1}/Results/DG/House/Selection/Table_${ytwo}_0_${cn}${twostp}") title(${ytwo}: 0-${cn}) format(%9.4f) replace

}


exit






